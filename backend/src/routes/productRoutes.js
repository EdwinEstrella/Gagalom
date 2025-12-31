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
import { authenticate } from '../middleware/auth.js';

const router = express.Router();

// Rutas públicas
router.get('/', getAllProducts);
router.get('/categories', getCategories);
router.get('/:id', getProductById);

// Rutas protegidas (requieren autenticación)
router.post('/', authenticate, createProduct);
router.put('/:id', authenticate, updateProduct);
router.delete('/:id', authenticate, deleteProduct);
router.get('/my/products', authenticate, getMyProducts);

export default router;
