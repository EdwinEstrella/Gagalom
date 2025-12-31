import express from 'express';
import {
  getAllProducts,
  getProductById,
  createProduct,
  updateProduct,
  deleteProduct,
  getCategories,
  getMyProducts,
} from '../controllers/productController.js';
import { authenticateToken } from '../middleware/auth.js';

const router = express.Router();

// Rutas públicas
router.get('/', getAllProducts);
router.get('/categories', getCategories);
router.get('/:id', getProductById);

// Rutas protegidas (requieren autenticación)
router.post('/', authenticateToken, createProduct);
router.put('/:id', authenticateToken, updateProduct);
router.delete('/:id', authenticateToken, deleteProduct);
router.get('/my/products', authenticateToken, getMyProducts);

export default router;
