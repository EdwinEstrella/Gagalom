# Guía de Uso de Stripe - Gagalom E-commerce

## 🎯 Concepto Clave

**Stripe NO es para crear productos**, es solo una pasarela de pago para procesar el total del carrito.

- ✅ **Productos**: Se almacenan en PostgreSQL (`products` table)
- ✅ **Carrito**: Se maneja en el frontend (Flutter)
- ✅ **Stripe**: Solo procesa el pago del total del carrito

## 📦 Flujo de Compra Completo

### 1. Usuario navega productos (PostgreSQL)
```
Frontend → GET /api/products → Backend → PostgreSQL → Return products
```

### 2. Usuario agrega al carrito (Flutter)
```
Carrito mantenido en estado local (Riverpod)
```

### 3. Usuario procede al checkout
```
Frontend → Calcula total del carrito → Llama backend
```

### 4. Backend crea PaymentIntent en Stripe
```javascript
// Backend crea PaymentIntent con el TOTAL del carrito
const paymentIntent = await stripe.paymentIntents.create({
  amount: Math.round(cartTotal * 100), // Total en centavos
  currency: 'usd',
  customer: customerId,
  metadata: {
    userId: user.id,
    items: JSON.stringify(cartItems) // Guardamos items como metadata
  }
});
```

### 5. Frontend procesa el pago con Stripe
```dart
// Flutter usa flutter_stripe para procesar el pago
final paymentIntent = await Stripe.instance.initPaymentSheet(
  paymentIntentClientSecret: clientSecret,
);
```

### 6. Usuario completa el pago
```
Stripe muestra tarjeta → Usuario ingresa datos → Stripe procesa
```

### 7. Webhook notifica al backend
```javascript
// Stripe envía evento al webhook
POST /api/webhook/stripe
{
  type: "payment_intent.succeeded",
  data: { paymentIntent: { ... } }
}
```

### 8. Backend crea la orden en PostgreSQL
```javascript
// Webhook handler crea la orden
await pool.query(
  'INSERT INTO orders (user_id, total_amount, status, ...) VALUES (...)'
);
```

## 🔧 Implementación

### Backend (Node.js)

#### 1. Crear PaymentIntent para el carrito
```javascript
// POST /api/payments/create-intent
export const createPaymentIntent = async (req, res) => {
  const { amount, items } = req.body; // amount es el TOTAL del carrito

  const paymentIntent = await stripe.paymentIntents.create({
    amount: Math.round(amount * 100), // Convertir a centavos
    currency: 'usd',
    customer: customerId,
    metadata: {
      userId: req.user.userId,
      items: JSON.stringify(items), // Items solo como referencia
    },
  });

  res.json({
    clientSecret: paymentIntent.client_secret,
    paymentIntentId: paymentIntent.id,
  });
};
```

#### 2. Webhook para confirmar pago
```javascript
// POST /api/webhook/stripe
export const stripeWebhook = async (req, res) => {
  const sig = req.headers['stripe-signature'];
  const event = stripe.webhooks.constructEvent(
    req.body,
    sig,
    process.env.STRIPE_WEBHOOK_SECRET
  );

  if (event.type === 'payment_intent.succeeded') {
    const paymentIntent = event.data.object;

    // Crear orden en PostgreSQL con los items del metadata
    const items = JSON.parse(paymentIntent.metadata.items);

    await pool.query(
      'INSERT INTO orders (user_id, total_amount, stripe_payment_intent_id, status) VALUES ($1, $2, $3, $4)',
      [paymentIntent.metadata.userId, paymentIntent.amount / 100, paymentIntent.id, 'completed']
    );

    // Crear items de la orden
    for (const item of items) {
      await pool.query(
        'INSERT INTO order_items (order_id, product_id, quantity, price_at_time) VALUES ($1, $2, $3, $4)',
        [orderId, item.productId, item.quantity, item.price]
      );
    }
  }

  res.json({ received: true });
};
```

### Frontend (Flutter)

#### 1. Preparar el pago
```dart
// Calcular total del carrito
double cartTotal = cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));

// Crear PaymentIntent
final result = await stripeService.createPaymentIntent(
  amount: cartTotal,
  items: cartItems.map((item) => {
    'productId': item.id,
    'quantity': item.quantity,
    'price': item.price,
  }).toList(),
);
```

#### 2. Procesar el pago
```dart
// Inicializar Payment Sheet de Stripe
await Stripe.instance.initPaymentSheet(
  paymentIntentClientSecret: result['clientSecret'],
);

// Mostrar Payment Sheet y procesar pago
await Stripe.instance.presentPaymentSheet();

// Pago completado exitosamente
```

## 📊 Estructura de Datos

### Products Table (PostgreSQL)
```sql
CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  price DECIMAL(10, 2) NOT NULL,  -- Precio unitario
  category VARCHAR(100),
  image_url TEXT,
  stock INTEGER DEFAULT 0
  -- NOTA: No hay stripe_price_id porque NO creamos productos en Stripe
);
```

### Orders Table (PostgreSQL)
```sql
CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  user_id INTEGER REFERENCES users(id),
  stripe_payment_intent_id VARCHAR(255) UNIQUE,  -- Referencia al pago en Stripe
  total_amount DECIMAL(10, 2) NOT NULL,  -- Total pagado
  status VARCHAR(50) DEFAULT 'pending',
  shipping_address TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### Order Items Table (PostgreSQL)
```sql
CREATE TABLE order_items (
  id SERIAL PRIMARY KEY,
  order_id INTEGER REFERENCES orders(id),
  product_id INTEGER REFERENCES products(id),
  quantity INTEGER NOT NULL,
  price_at_time DECIMAL(10, 2) NOT NULL  -- Precio al momento de comprar
);
```

## 🚀 Comandos para Setup

### 1. Inicializar base de datos
```bash
npm run init-db
```

### 2. Insertar productos de ejemplo
```bash
npm run seed-products
```

Esto insertará 11 productos de ejemplo en PostgreSQL (NO en Stripe):
- 3 Hoodies
- 2 Shorts
- 2 Shoes
- 2 Bags
- 2 Accessories

### 3. Iniciar servidor
```bash
npm run dev
```

## 🧪 Probar el Sistema

### 1. Ver productos
```bash
curl http://localhost:3000/api/products
```

### 2. Crear PaymentIntent (simulación)
```bash
# Este endpoint recibe el total del carrito y crea el PaymentIntent
curl -X POST http://localhost:3000/api/payments/create-intent \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "amount": 149.97,
    "items": [
      {"productId": 1, "quantity": 2, "price": 49.99},
      {"productId": 2, "quantity": 1, "price": 49.99}
    ]
  }'
```

### 3. Webhook endpoint (Stripe notifica aquí)
```
POST http://your-server.com/api/webhook/stripe
```

## ⚠️ Importante

### ❌ NO hacer esto:
```javascript
// NO crear productos individuales en Stripe
await stripe.products.create({ name: "Hoodie" }); // ❌
await stripe.prices.create({ product: "prod_xxx" }); // ❌
```

### ✅ Hacer esto:
```javascript
// Crear UN solo PaymentIntent con el TOTAL del carrito
await stripe.paymentIntents.create({
  amount: cartTotal * 100,  // Total de todos los productos
  currency: 'usd',
}); // ✅
```

## 📱 Flutter Stripe Integration

### Configurar claves

**Android** (`android/app/build.gradle`):
```gradle
defaultConfig {
  resValue "string", "stripe_publishable_key", "pk_live_tu_clave"
}
```

**iOS** (`ios/Runner/Info.plist`):
```xml
<key>StripePublishableKey</key>
<string>pk_live_tu_clave</string>
```

### Flujo en Flutter
```dart
// 1. Calcular total del carrito (desde PostgreSQL)
double total = cartItems.fold(0, (sum, item) => sum + item.price);

// 2. Crear PaymentIntent (llamar backend)
final intent = await apiService.createPaymentIntent(total, cartItems);

// 3. Procesar pago con Stripe
await Stripe.instance.initPaymentSheet(
  paymentIntentClientSecret: intent['clientSecret'],
);
await Stripe.instance.presentPaymentSheet();

// 4. Confirmar orden (llamar backend)
await apiService.confirmOrder(intent['paymentIntentId'], cartItems);
```

## 🔐 Seguridad

### Webhook Signing
```javascript
// Siempre verificar que el evento viene de Stripe
const event = stripe.webhooks.constructEvent(
  req.body,
  req.headers['stripe-signature'],
  process.env.STRIPE_WEBHOOK_SECRET
);
```

### IP Whitelist
Stripe envía webhooks desde IPs específicas. Verifica:
https://stripe.com/docs/webhooks#build-a-handler

## 📚 Resumen

| Concepto | Dónde se almacena |
|----------|------------------|
| **Productos** | PostgreSQL (products table) |
| **Carrito** | Flutter (estado local) |
| **Órdenes** | PostgreSQL (orders, order_items tables) |
| **Pagos** | Stripe (solo PaymentIntents) |

Stripe es SOLO para procesar el pago del total, NO para gestionar productos o inventario.
