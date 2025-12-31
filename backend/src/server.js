import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import dotenv from 'dotenv';

// Importar middlewares
import { authenticateToken, optionalAuth } from './middleware/auth.js';
import { validate, validateRegister, validateLogin } from './middleware/validator.js';
import { apiLimiter, loginLimiter, registerLimiter } from './middleware/rateLimiter.js';

// Importar controladores
import * as authController from './controllers/authController.js';
import * as stripeController from './controllers/stripeController.js';

// Importar rutas
import productRoutes from './routes/productRoutes.js';
import sellerRoutes from './routes/sellerRoutes.js';

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;

// Middlewares de seguridad
app.use(helmet({
  contentSecurityPolicy: false, // Desactivado para APIs
  crossOriginEmbedderPolicy: false,
}));

app.use(cors({
  origin: process.env.FRONTEND_URL || '*',
  credentials: true,
}));

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Rate limiting general
app.use('/api/', apiLimiter);

// Health check
app.get('/health', (req, res) => {
  res.json({ status: 'OK', message: 'Gagalom API is running' });
});

// Rutas de autenticación
app.post('/api/auth/register', registerLimiter, validateRegister, validate, authController.register);
app.post('/api/auth/login', loginLimiter, validateLogin, validate, authController.login);
app.post('/api/auth/logout', authenticateToken, authController.logout);
app.get('/api/auth/me', authenticateToken, authController.getProfile);
app.put('/api/auth/profile', authenticateToken, authController.updateProfile);
app.put('/api/auth/change-password', authenticateToken, authController.changePassword);

// Rutas de pagos con Stripe
app.post('/api/payments/create-intent', authenticateToken, stripeController.createPaymentIntent);
app.post('/api/payments/confirm', authenticateToken, stripeController.confirmPayment);
app.get('/api/orders', authenticateToken, stripeController.getOrders);
app.get('/api/orders/:orderId', authenticateToken, stripeController.getOrderDetails);
app.post('/api/webhook/stripe', express.raw({ type: 'application/json' }), stripeController.stripeWebhook);

// Rutas de productos (opcional, para admin)
app.post('/api/products/create', authenticateToken, stripeController.createProduct);

// Nuevas rutas de productos con Prisma
app.use('/api/products', productRoutes);

// Nuevas rutas de vendedores
app.use('/api/seller', sellerRoutes);

// Manejo de errores 404
app.use((req, res) => {
  res.status(404).json({ error: 'Ruta no encontrada' });
});

// Manejo de errores globales
app.use((err, req, res, next) => {
  console.error('Error:', err);
  res.status(err.status || 500).json({
    error: err.message || 'Error interno del servidor',
    ...(process.env.NODE_ENV === 'development' && { stack: err.stack })
  });
});

// Iniciar servidor
app.listen(PORT, '0.0.0.0', () => {
  console.log(`
Servidor Gagalom Backend corriendo
Port: ${PORT}
Environment: ${process.env.NODE_ENV || 'development'}
API URL: http://0.0.0.0:${PORT}
  `);
});

export default app;
