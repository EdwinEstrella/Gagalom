import express from 'express';
import {
  createSellerRequest,
  getAllSellerRequests,
  getMySellerRequest,
  approveSellerRequest,
  rejectSellerRequest,
  getSellerStats,
} from '../controllers/sellerController.js';
import { authenticateToken } from '../middleware/auth.js';

const router = express.Router();

// Crear solicitud para ser vendedor
router.post('/request', authenticateToken, createSellerRequest);

// Ver mi solicitud
router.get('/my-request', authenticateToken, getMySellerRequest);

// Ver estadísticas de vendedor
router.get('/stats', authenticateToken, getSellerStats);

// Rutas de admin - Ver todas las solicitudes
router.get('/requests', authenticateToken, getAllSellerRequests);

// Rutas de admin - Aprobar/Rechazar solicitudes
router.put('/requests/:id/approve', authenticateToken, approveSellerRequest);
router.put('/requests/:id/reject', authenticateToken, rejectSellerRequest);

export default router;
