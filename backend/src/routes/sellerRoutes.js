import express from 'express';
import {
  createSellerRequest,
  getAllSellerRequests,
  getMySellerRequest,
  approveSellerRequest,
  rejectSellerRequest,
  getSellerStats,
} from '../controllers/sellerController.js';
import { authenticate } from '../middleware/auth.js';

const router = express.Router();

// Crear solicitud para ser vendedor
router.post('/request', authenticate, createSellerRequest);

// Ver mi solicitud
router.get('/my-request', authenticate, getMySellerRequest);

// Ver estadísticas de vendedor
router.get('/stats', authenticate, getSellerStats);

// Rutas de admin - Ver todas las solicitudes
router.get('/requests', authenticate, getAllSellerRequests);

// Rutas de admin - Aprobar/Rechazar solicitudes
router.put('/requests/:id/approve', authenticate, approveSellerRequest);
router.put('/requests/:id/reject', authenticate, rejectSellerRequest);

export default router;
