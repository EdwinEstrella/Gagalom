import prisma from '../config/prisma.js';

/**
 * Crear solicitud para ser vendedor
 * POST /api/seller/request
 */
export const createSellerRequest = async (req, res) => {
  try {
    const {
      businessName,
      businessDescription,
      businessType,
      taxId,
      phone,
      address,
      city,
      country = 'España',
    } = req.body;

    // Validaciones
    if (!businessName || !phone || !address || !city) {
      return res.status(400).json({
        error: 'Faltan campos requeridos',
        required: ['businessName', 'phone', 'address', 'city'],
      });
    }

    // Verificar que el usuario no tenga ya una solicitud pendiente
    const existingRequest = await prisma.sellerRequest.findFirst({
      where: {
        userId: req.user.userId,
        status: 'pending',
      },
    });

    if (existingRequest) {
      return res.status(400).json({
        error: 'Ya tienes una solicitud pendiente',
      });
    }

    // Verificar si el usuario ya es vendedor
    const user = await prisma.user.findUnique({
      where: { id: req.user.userId },
    });

    if (user.role === 'seller') {
      return res.status(400).json({
        error: 'Ya eres vendedor',
      });
    }

    const request = await prisma.sellerRequest.create({
      data: {
        userId: req.user.userId,
        businessName,
        businessDescription,
        businessType,
        taxId,
        phone,
        address,
        city,
        country,
        status: 'pending',
      },
    });

    res.status(201).json({
      id: request.id,
      businessName: request.businessName,
      status: request.status,
      createdAt: request.createdAt,
      message: 'Solicitud creada exitosamente. Te contactaremos pronto.',
    });
  } catch (error) {
    console.error('Error al crear solicitud de vendedor:', error);
    res.status(500).json({
      error: 'Error al crear solicitud',
      message: error.message,
    });
  }
};

/**
 * Obtener todas las solicitudes de vendedor (admin)
 * GET /api/seller/requests
 */
export const getAllSellerRequests = async (req, res) => {
  try {
    // Solo admin puede ver todas las solicitudes
    if (req.user.role !== 'admin') {
      return res.status(403).json({
        error: 'Solo administradores pueden ver solicitudes',
      });
    }

    const { status, page = 1, limit = 20 } = req.query;

    const where = status ? { status } : {};

    const skip = (parseInt(page) - 1) * parseInt(limit);

    const [requests, total] = await Promise.all([
      prisma.sellerRequest.findMany({
        where,
        skip,
        take: parseInt(limit),
        orderBy: { createdAt: 'desc' },
        include: {
          user: {
            select: {
              id: true,
              email: true,
              firstName: true,
              lastName: true,
            },
          },
        },
      }),
      prisma.sellerRequest.count({ where }),
    ]);

    res.json({
      requests: requests.map(r => ({
        id: r.id,
        userId: r.userId,
        user: r.user,
        businessName: r.businessName,
        businessDescription: r.businessDescription,
        businessType: r.businessType,
        taxId: r.taxId,
        phone: r.phone,
        address: r.address,
        city: r.city,
        country: r.country,
        status: r.status,
        rejectionReason: r.rejectionReason,
        createdAt: r.createdAt,
      })),
      pagination: {
        page: parseInt(page),
        limit: parseInt(limit),
        total,
        pages: Math.ceil(total / parseInt(limit)),
      },
    });
  } catch (error) {
    console.error('Error al obtener solicitudes:', error);
    res.status(500).json({
      error: 'Error al obtener solicitudes',
      message: error.message,
    });
  }
};

/**
 * Obtener mi solicitud de vendedor
 * GET /api/seller/my-request
 */
export const getMySellerRequest = async (req, res) => {
  try {
    const request = await prisma.sellerRequest.findFirst({
      where: { userId: req.user.userId },
      orderBy: { createdAt: 'desc' },
    });

    if (!request) {
      return res.status(404).json({
        error: 'No tienes solicitudes de vendedor',
      });
    }

    res.json({
      id: request.id,
      businessName: request.businessName,
      businessDescription: request.businessDescription,
      businessType: request.businessType,
      taxId: request.taxId,
      phone: request.phone,
      address: request.address,
      city: request.city,
      country: request.country,
      status: request.status,
      rejectionReason: request.rejectionReason,
      createdAt: request.createdAt,
      updatedAt: request.updatedAt,
    });
  } catch (error) {
    console.error('Error al obtener solicitud:', error);
    res.status(500).json({
      error: 'Error al obtener solicitud',
      message: error.message,
    });
  }
};

/**
 * Aprobar solicitud de vendedor (admin)
 * PUT /api/seller/requests/:id/approve
 */
export const approveSellerRequest = async (req, res) => {
  try {
    const { id } = req.params;

    // Solo admin puede aprobar
    if (req.user.role !== 'admin') {
      return res.status(403).json({
        error: 'Solo administradores pueden aprobar solicitudes',
      });
    }

    const request = await prisma.sellerRequest.findUnique({
      where: { id: parseInt(id) },
    });

    if (!request) {
      return res.status(404).json({ error: 'Solicitud no encontrada' });
    }

    if (request.status !== 'pending') {
      return res.status(400).json({
        error: 'Esta solicitud ya fue procesada',
      });
    }

    // Actualizar solicitud y rol de usuario en una transacción
    await prisma.$transaction([
      prisma.sellerRequest.update({
        where: { id: parseInt(id) },
        data: {
          status: 'approved',
          reviewedBy: req.user.userId,
          reviewedAt: new Date(),
        },
      }),
      prisma.user.update({
        where: { id: request.userId },
        data: { role: 'seller' },
      }),
    ]);

    res.json({
      message: 'Solicitud aprobada exitosamente',
      requestId: request.id,
      userId: request.userId,
    });
  } catch (error) {
    console.error('Error al aprobar solicitud:', error);
    res.status(500).json({
      error: 'Error al aprobar solicitud',
      message: error.message,
    });
  }
};

/**
 * Rechazar solicitud de vendedor (admin)
 * PUT /api/seller/requests/:id/reject
 */
export const rejectSellerRequest = async (req, res) => {
  try {
    const { id } = req.params;
    const { rejectionReason } = req.body;

    // Solo admin puede rechazar
    if (req.user.role !== 'admin') {
      return res.status(403).json({
        error: 'Solo administradores pueden rechazar solicitudes',
      });
    }

    if (!rejectionReason) {
      return res.status(400).json({
        error: 'Debes proporcionar una razón para el rechazo',
      });
    }

    const request = await prisma.sellerRequest.findUnique({
      where: { id: parseInt(id) },
    });

    if (!request) {
      return res.status(404).json({ error: 'Solicitud no encontrada' });
    }

    if (request.status !== 'pending') {
      return res.status(400).json({
        error: 'Esta solicitud ya fue procesada',
      });
    }

    await prisma.sellerRequest.update({
      where: { id: parseInt(id) },
      data: {
        status: 'rejected',
        rejectionReason,
        reviewedBy: req.user.userId,
        reviewedAt: new Date(),
      },
    });

    res.json({
      message: 'Solicitud rechazada',
      requestId: request.id,
    });
  } catch (error) {
    console.error('Error al rechazar solicitud:', error);
    res.status(500).json({
      error: 'Error al rechazar solicitud',
      message: error.message,
    });
  }
};

/**
 * Obtener estadísticas de vendedor
 * GET /api/seller/stats
 */
export const getSellerStats = async (req, res) => {
  try {
    // Solo vendedores pueden ver sus estadísticas
    if (req.user.role !== 'seller') {
      return res.status(403).json({
        error: 'Solo vendedores pueden ver estadísticas',
      });
    }

    const [
      totalProducts,
      activeProducts,
      totalSales,
      totalViews,
    ] = await Promise.all([
      prisma.product.count({
        where: { sellerId: req.user.userId },
      }),
      prisma.product.count({
        where: {
          sellerId: req.user.userId,
          isActive: true,
        },
      }),
      prisma.product.aggregate({
        where: { sellerId: req.user.userId },
        _sum: { salesCount: true },
      }),
      prisma.product.aggregate({
        where: { sellerId: req.user.userId },
        _sum: { views: true },
      }),
    ]);

    res.json({
      totalProducts,
      activeProducts,
      totalSales: totalSales._sum.salesCount || 0,
      totalViews: totalViews._sum.views || 0,
    });
  } catch (error) {
    console.error('Error al obtener estadísticas:', error);
    res.status(500).json({
      error: 'Error al obtener estadísticas',
      message: error.message,
    });
  }
};
