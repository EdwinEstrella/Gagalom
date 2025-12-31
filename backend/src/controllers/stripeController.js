import Stripe from 'stripe';
import pool from '../database/db.js';

const stripe = new Stripe(process.env.STRIPE_SECRET_KEY);

// Crear Payment Intent para un pago
export const createPaymentIntent = async (req, res) => {
  const { amount, currency = 'usd', items } = req.body;

  // Validar monto mínimo (50 centavos en centavos)
  if (amount < 50) {
    return res.status(400).json({ error: 'El monto mínimo es 0.50 USD' });
  }

  const client = await pool.connect();

  try {
    // Obtener información del usuario
    const userResult = await client.query(
      'SELECT stripe_customer_id FROM users WHERE id = $1',
      [req.user.userId]
    );

    if (userResult.rows.length === 0) {
      return res.status(404).json({ error: 'Usuario no encontrado' });
    }

    let customerId = userResult.rows[0].stripe_customer_id;

    // Crear cliente en Stripe si no existe
    if (!customerId) {
      const customer = await stripe.customers.create({
        email: req.user.email,
        metadata: { userId: req.user.userId }
      });

      customerId = customer.id;

      await client.query(
        'UPDATE users SET stripe_customer_id = $1 WHERE id = $2',
        [customerId, req.user.userId]
      );
    }

    // Crear Payment Intent
    const paymentIntent = await stripe.paymentIntents.create({
      amount: Math.round(amount), // Stripe requiere centavos
      currency,
      customer: customerId,
      metadata: {
        userId: req.user.userId,
        items: JSON.stringify(items || []),
      },
      automatic_payment_methods: {
        enabled: true,
      },
    });

    res.json({
      clientSecret: paymentIntent.client_secret,
      paymentIntentId: paymentIntent.id,
      amount: paymentIntent.amount,
      currency: paymentIntent.currency,
    });

  } catch (error) {
    console.error('Error al crear Payment Intent:', error);
    res.status(500).json({
      error: 'Error al crear el intento de pago',
      message: error.message
    });
  } finally {
    client.release();
  }
};

// Confirmar pago y crear orden
export const confirmPayment = async (req, res) => {
  const { paymentIntentId, items, shippingAddress } = req.body;
  const client = await pool.connect();

  try {
    // Verificar el Payment Intent en Stripe
    const paymentIntent = await stripe.paymentIntents.retrieve(paymentIntentId);

    if (paymentIntent.status !== 'succeeded') {
      return res.status(400).json({ error: 'El pago no ha sido completado' });
    }

    // Verificar que el pago pertenezca al usuario
    if (paymentIntent.metadata.userId !== String(req.user.userId)) {
      return res.status(403).json({ error: 'Pago no autorizado' });
    }

    // Verificar si la orden ya existe
    const existingOrder = await client.query(
      'SELECT id FROM orders WHERE stripe_payment_intent_id = $1',
      [paymentIntentId]
    );

    if (existingOrder.rows.length > 0) {
      return res.status(400).json({ error: 'La orden ya fue procesada' });
    }

    // Calcular total
    const totalAmount = paymentIntent.amount / 100; // Convertir de centavos a dólares

    // Crear orden
    const orderResult = await client.query(
      `INSERT INTO orders (user_id, stripe_payment_intent_id, total_amount, status, shipping_address)
       VALUES ($1, $2, $3, $4, $5)
       RETURNING id`,
      [req.user.userId, paymentIntentId, totalAmount, 'completed', JSON.stringify(shippingAddress)]
    );

    const orderId = orderResult.rows[0].id;

    // Agregar items a la orden
    if (items && items.length > 0) {
      for (const item of items) {
        await client.query(
          `INSERT INTO order_items (order_id, product_id, quantity, price_at_time)
           VALUES ($1, $2, $3, $4)`,
          [orderId, item.productId, item.quantity, item.price]
        );
      }
    }

    res.json({
      message: 'Pago confirmado exitosamente',
      orderId,
      status: 'completed',
      totalAmount,
    });

  } catch (error) {
    console.error('Error al confirmar pago:', error);
    res.status(500).json({ error: 'Error al confirmar el pago' });
  } finally {
    client.release();
  }
};

// Obtener historial de órdenes
export const getOrders = async (req, res) => {
  const client = await pool.connect();

  try {
    const result = await client.query(
      `SELECT id, total_amount, status, shipping_address, created_at
       FROM orders
       WHERE user_id = $1
       ORDER BY created_at DESC`,
      [req.user.userId]
    );

    res.json({
      orders: result.rows.map(order => ({
        id: order.id,
        totalAmount: parseFloat(order.total_amount),
        status: order.status,
        shippingAddress: order.shipping_address ? JSON.parse(order.shipping_address) : null,
        createdAt: order.created_at,
      }))
    });

  } catch (error) {
    console.error('Error al obtener órdenes:', error);
    res.status(500).json({ error: 'Error al obtener órdenes' });
  } finally {
    client.release();
  }
};

// Obtener detalles de una orden
export const getOrderDetails = async (req, res) => {
  const { orderId } = req.params;
  const client = await pool.connect();

  try {
    // Verificar que la orden pertenezca al usuario
    const orderResult = await client.query(
      `SELECT id, total_amount, status, shipping_address, created_at
       FROM orders
       WHERE id = $1 AND user_id = $2`,
      [orderId, req.user.userId]
    );

    if (orderResult.rows.length === 0) {
      return res.status(404).json({ error: 'Orden no encontrada' });
    }

    const order = orderResult.rows[0];

    // Obtener items de la orden
    const itemsResult = await client.query(
      `SELECT product_id, quantity, price_at_time
       FROM order_items
       WHERE order_id = $1`,
      [orderId]
    );

    res.json({
      order: {
        id: order.id,
        totalAmount: parseFloat(order.total_amount),
        status: order.status,
        shippingAddress: order.shipping_address ? JSON.parse(order.shipping_address) : null,
        createdAt: order.created_at,
        items: itemsResult.rows.map(item => ({
          productId: item.product_id,
          quantity: item.quantity,
          priceAtTime: parseFloat(item.price_at_time),
        })),
      },
    });

  } catch (error) {
    console.error('Error al obtener detalles de orden:', error);
    res.status(500).json({ error: 'Error al obtener detalles de orden' });
  } finally {
    client.release();
  }
};

// Webhook de Stripe
export const stripeWebhook = async (req, res) => {
  const sig = req.headers['stripe-signature'];
  let event;

  try {
    event = stripe.webhooks.constructEvent(
      req.body,
      sig,
      process.env.STRIPE_WEBHOOK_SECRET
    );
  } catch (err) {
    console.error('Error en webhook de Stripe:', err);
    return res.status(400).json({ error: `Webhook Error: ${err.message}` });
  }

  const client = await pool.connect();

  try {
    // Manejar diferentes eventos
    switch (event.type) {
      case 'payment_intent.succeeded':
        const paymentIntent = event.data.object;
        console.log('Pago exitoso:', paymentIntent.id);

        // Actualizar estado de la orden si existe
        await client.query(
          `UPDATE orders
           SET status = 'completed'
           WHERE stripe_payment_intent_id = $1`,
          [paymentIntent.id]
        );
        break;

      case 'payment_intent.payment_failed':
        const failedPayment = event.data.object;
        console.log('Pago fallido:', failedPayment.id);

        // Actualizar estado de la orden
        await client.query(
          `UPDATE orders
           SET status = 'failed'
           WHERE stripe_payment_intent_id = $1`,
          [failedPayment.id]
        );
        break;

      default:
        console.log(`Evento no manejado: ${event.type}`);
    }

    res.json({ received: true });

  } catch (error) {
    console.error('Error al procesar webhook:', error);
    res.status(500).json({ error: 'Error al procesar webhook' });
  } finally {
    client.release();
  }
};

// Crear producto en Stripe
export const createProduct = async (req, res) => {
  const { name, description, price, imageUrl } = req.body;

  try {
    // Crear producto en Stripe
    const product = await stripe.products.create({
      name,
      description,
      images: imageUrl ? [imageUrl] : [],
    });

    // Crear precio
    const priceObj = await stripe.prices.create({
      product: product.id,
      unit_amount: Math.round(price * 100), // Convertir a centavos
      currency: 'usd',
    });

    res.json({
      productId: product.id,
      priceId: priceObj.id,
      name: product.name,
      price: priceObj.unit_amount / 100,
    });

  } catch (error) {
    console.error('Error al crear producto:', error);
    res.status(500).json({
      error: 'Error al crear producto en Stripe',
      message: error.message
    });
  }
};
