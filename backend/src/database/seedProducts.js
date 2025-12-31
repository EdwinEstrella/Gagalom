import pool from '../database/db.js';
import bcrypt from 'bcrypt';

// Productos de ejemplo para Gagalom
const sampleProducts = [
  {
    name: 'Gagalom Classic Hoodie',
    description: 'Premium quality cotton hoodie, perfect for any occasion. Comfortable and stylish.',
    price: 49.99,
    category: 'hoodies',
    image_url: 'https://images.unsplash.com/photo-1556821840-3a63f95609a7?w=500',
    stock: 50,
  },
  {
    name: 'Urban Street Hoodie',
    description: 'Modern street-style hoodie with unique design. Ultra-soft fabric blend.',
    price: 59.99,
    category: 'hoodies',
    image_url: 'https://images.unsplash.com/photo-1578768079052-aa76e52ff62e?w=500',
    stock: 35,
  },
  {
    name: 'Cozy Winter Hoodie',
    description: 'Warm fleece-lined hoodie for cold weather. Essential for winter.',
    price: 69.99,
    category: 'hoodies',
    image_url: 'https://images.unsplash.com/photo-1620799140408-edc6dcb6d633?w=500',
    stock: 40,
  },
  {
    name: 'Gagalom Denim Shorts',
    description: 'Comfortable denim shorts for casual wear. High quality fabric and modern fit.',
    price: 39.99,
    category: 'shorts',
    image_url: 'https://images.unsplash.com/photo-1591195853828-11db59a44f6b?w=500',
    stock: 60,
  },
  {
    name: 'Summer Breeze Shorts',
    description: 'Lightweight and breathable shorts perfect for summer days.',
    price: 34.99,
    category: 'shorts',
    image_url: 'https://images.unsplash.com/photo-1503944583220-79ed89e0436c?w=500',
    stock: 45,
  },
  {
    name: 'Gagalom Urban Sneakers',
    description: 'Trendy sneakers with premium comfort. Perfect for everyday wear.',
    price: 89.99,
    category: 'shoes',
    image_url: 'https://images.unsplash.com/photo-1549298916-b41d501d3772?w=500',
    stock: 30,
  },
  {
    name: 'Classic White Sneakers',
    description: 'Clean and minimalist white sneakers. Versatile for any outfit.',
    price: 79.99,
    category: 'shoes',
    image_url: 'https://images.unsplash.com/photo-1525966222134-fcfa99b8ae77?w=500',
    stock: 25,
  },
  {
    name: 'Gagalom Everyday Bag',
    description: 'Elegant and functional bag for daily use. Spacious and durable design.',
    price: 59.99,
    category: 'bags',
    image_url: 'https://images.unsplash.com/photo-1590874103328-eac38a683ce7?w=500',
    stock: 40,
  },
  {
    name: 'Leather Crossbody Bag',
    description: 'Premium leather crossbody bag. Perfect for any occasion.',
    price: 89.99,
    category: 'bags',
    image_url: 'https://images.unsplash.com/photo-1584917865442-de89df76afd3?w=500',
    stock: 20,
  },
  {
    name: 'Gagalom Premium Watch',
    description: 'Elegant wristwatch with premium materials. Water-resistant design.',
    price: 149.99,
    category: 'accessories',
    image_url: 'https://images.unsplash.com/photo-1524592094714-0f0654e20314?w=500',
    stock: 15,
  },
  {
    name: 'Designer Sunglasses',
    description: 'Stylish sunglasses with UV protection. Premium quality lenses.',
    price: 79.99,
    category: 'accessories',
    image_url: 'https://images.unsplash.com/photo-1511499767150-a48a237f0083?w=500',
    stock: 50,
  },
];

async function seedProducts() {
  const client = await pool.connect();

  try {
    console.log('🌱 Insertando productos de ejemplo...');

    for (const product of sampleProducts) {
      const result = await client.query(
        `INSERT INTO products (name, description, price, category, image_url, stock)
         VALUES ($1, $2, $3, $4, $5, $6)
         ON CONFLICT DO NOTHING
         RETURNING id, name`,
        [
          product.name,
          product.description,
          product.price,
          product.category,
          product.image_url,
          product.stock,
        ]
      );

      if (result.rows.length > 0) {
        console.log(`✅ Producto creado: ${result.rows[0].name} (ID: ${result.rows[0].id})`);
      }
    }

    console.log('\n✅ Productos insertados exitosamente');

    // Mostrar resumen
    const countResult = await client.query('SELECT COUNT(*) as total FROM products');
    console.log(`📦 Total de productos en la base de datos: ${countResult.rows[0].total}`);

  } catch (error) {
    console.error('❌ Error al insertar productos:', error);
    throw error;
  } finally {
    client.release();
    await pool.end();
  }
}

seedProducts()
  .then(() => {
    console.log('✅ Proceso completado');
    process.exit(0);
  })
  .catch((error) => {
    console.error('❌ Error:', error);
    process.exit(1);
  });
