import prisma from '../config/prisma.js';

/**
 * Obtener todos los productos con filtros opcionales
 * GET /api/products
 */
export const getAllProducts = async (req, res) => {
  try {
    const {
      category,
      sellerId,
      search,
      isActive = true,
      sortBy = 'createdAt',
      sortOrder = 'desc',
      page = 1,
      limit = 50
    } = req.query;

    // Construir filtros
    const where = {
      isActive: isActive === 'true' || isActive === true,
    };

    if (category) {
      where.category = category;
    }

    if (sellerId) {
      where.sellerId = parseInt(sellerId);
    }

    if (search) {
      where.OR = [
        { name: { contains: search, mode: 'insensitive' } },
        { description: { contains: search, mode: 'insensitive' } },
      ];
    }

    // Calcular paginación
    const skip = (parseInt(page) - 1) * parseInt(limit);

    // Obtener productos
    const [products, total] = await Promise.all([
      prisma.product.findMany({
        where,
        skip,
        take: parseInt(limit),
        orderBy: { [sortBy]: sortOrder.toLowerCase() },
        include: {
          seller: {
            select: {
              id: true,
              firstName: true,
              lastName: true,
              email: true,
            },
          },
        },
      }),
      prisma.product.count({ where }),
    ]);

    res.json({
      products: products.map(p => ({
        id: p.id,
        sellerId: p.sellerId,
        seller: p.seller,
        name: p.name,
        description: p.description,
        price: parseFloat(p.price),
        category: p.category,
        imageUrl: p.imageUrl,
        localAssetPath: p.localAssetPath,
        stock: p.stock,
        isActive: p.isActive,
        views: p.views,
        salesCount: p.salesCount,
        rating: parseFloat(p.rating),
        createdAt: p.createdAt,
      })),
      pagination: {
        page: parseInt(page),
        limit: parseInt(limit),
        total,
        pages: Math.ceil(total / parseInt(limit)),
      },
    });
  } catch (error) {
    console.error('Error al obtener productos:', error);
    res.status(500).json({
      error: 'Error al obtener productos',
      message: error.message,
    });
  }
};

/**
 * Obtener un producto por ID
 * GET /api/products/:id
 */
export const getProductById = async (req, res) => {
  try {
    const { id } = req.params;

    const product = await prisma.product.findUnique({
      where: { id: parseInt(id) },
      include: {
        seller: {
          select: {
            id: true,
            firstName: true,
            lastName: true,
            email: true,
          },
        },
      },
    });

    if (!product) {
      return res.status(404).json({ error: 'Producto no encontrado' });
    }

    // Incrementar vistas
    await prisma.product.update({
      where: { id: parseInt(id) },
      data: { views: { increment: 1 } },
    });

    res.json({
      id: product.id,
      sellerId: product.sellerId,
      seller: product.seller,
      name: product.name,
      description: product.description,
      price: parseFloat(product.price),
      category: product.category,
      imageUrl: product.imageUrl,
      localAssetPath: product.localAssetPath,
      stock: product.stock,
      isActive: product.isActive,
      views: product.views + 1,
      salesCount: product.salesCount,
      rating: parseFloat(product.rating),
      createdAt: product.createdAt,
    });
  } catch (error) {
    console.error('Error al obtener producto:', error);
    res.status(500).json({
      error: 'Error al obtener producto',
      message: error.message,
    });
  }
};

/**
 * Crear un nuevo producto (requiere ser vendedor)
 * POST /api/products
 */
export const createProduct = async (req, res) => {
  try {
    const {
      name,
      description,
      price,
      category,
      imageUrl,
      localAssetPath,
      stock = 0,
    } = req.body;

    // Validar campos requeridos
    if (!name || !price || !category) {
      return res.status(400).json({
        error: 'Faltan campos requeridos',
        required: ['name', 'price', 'category'],
      });
    }

    // Verificar que el usuario sea vendedor
    if (req.user.role !== 'seller' && req.user.role !== 'admin') {
      return res.status(403).json({
        error: 'Solo vendedores pueden crear productos',
      });
    }

    const product = await prisma.product.create({
      data: {
        sellerId: req.user.userId,
        name,
        description,
        price: parseFloat(price),
        category,
        imageUrl,
        localAssetPath,
        stock: parseInt(stock),
      },
    });

    res.status(201).json({
      id: product.id,
      sellerId: product.sellerId,
      name: product.name,
      description: product.description,
      price: parseFloat(product.price),
      category: product.category,
      imageUrl: product.imageUrl,
      localAssetPath: product.localAssetPath,
      stock: product.stock,
      isActive: product.isActive,
      createdAt: product.createdAt,
    });
  } catch (error) {
    console.error('Error al crear producto:', error);
    res.status(500).json({
      error: 'Error al crear producto',
      message: error.message,
    });
  }
};

/**
 * Actualizar un producto
 * PUT /api/products/:id
 */
export const updateProduct = async (req, res) => {
  try {
    const { id } = req.params;
    const {
      name,
      description,
      price,
      category,
      imageUrl,
      localAssetPath,
      stock,
      isActive,
    } = req.body;

    // Verificar que el producto existe
    const existingProduct = await prisma.product.findUnique({
      where: { id: parseInt(id) },
    });

    if (!existingProduct) {
      return res.status(404).json({ error: 'Producto no encontrado' });
    }

    // Verificar permisos: solo el vendedor dueño o admin
    if (
      existingProduct.sellerId !== req.user.userId &&
      req.user.role !== 'admin'
    ) {
      return res.status(403).json({
        error: 'No tienes permiso para editar este producto',
      });
    }

    const product = await prisma.product.update({
      where: { id: parseInt(id) },
      data: {
        ...(name && { name }),
        ...(description !== undefined && { description }),
        ...(price && { price: parseFloat(price) }),
        ...(category && { category }),
        ...(imageUrl !== undefined && { imageUrl }),
        ...(localAssetPath !== undefined && { localAssetPath }),
        ...(stock !== undefined && { stock: parseInt(stock) }),
        ...(isActive !== undefined && { isActive }),
      },
    });

    res.json({
      id: product.id,
      sellerId: product.sellerId,
      name: product.name,
      description: product.description,
      price: parseFloat(product.price),
      category: product.category,
      imageUrl: product.imageUrl,
      localAssetPath: product.localAssetPath,
      stock: product.stock,
      isActive: product.isActive,
      updatedAt: product.updatedAt,
    });
  } catch (error) {
    console.error('Error al actualizar producto:', error);
    res.status(500).json({
      error: 'Error al actualizar producto',
      message: error.message,
    });
  }
};

/**
 * Eliminar un producto (soft delete: isActive = false)
 * DELETE /api/products/:id
 */
export const deleteProduct = async (req, res) => {
  try {
    const { id } = req.params;

    // Verificar que el producto existe
    const existingProduct = await prisma.product.findUnique({
      where: { id: parseInt(id) },
    });

    if (!existingProduct) {
      return res.status(404).json({ error: 'Producto no encontrado' });
    }

    // Verificar permisos
    if (
      existingProduct.sellerId !== req.user.userId &&
      req.user.role !== 'admin'
    ) {
      return res.status(403).json({
        error: 'No tienes permiso para eliminar este producto',
      });
    }

    // Soft delete
    await prisma.product.update({
      where: { id: parseInt(id) },
      data: { isActive: false },
    });

    res.json({ message: 'Producto eliminado exitosamente' });
  } catch (error) {
    console.error('Error al eliminar producto:', error);
    res.status(500).json({
      error: 'Error al eliminar producto',
      message: error.message,
    });
  }
};

/**
 * Obtener categorías disponibles
 * GET /api/products/categories
 */
export const getCategories = async (req, res) => {
  try {
    const categories = await prisma.product.findMany({
      select: { category: true },
      distinct: ['category'],
      where: { isActive: true },
      orderBy: { category: 'asc' },
    });

    res.json({
      categories: categories.map(c => c.category),
    });
  } catch (error) {
    console.error('Error al obtener categorías:', error);
    res.status(500).json({
      error: 'Error al obtener categorías',
      message: error.message,
    });
  }
};

/**
 * Obtener productos del vendedor autenticado
 * GET /api/products/my-products
 */
export const getMyProducts = async (req, res) => {
  try {
    const { page = 1, limit = 20 } = req.query;

    if (req.user.role !== 'seller' && req.user.role !== 'admin') {
      return res.status(403).json({
        error: 'Solo vendedores pueden ver sus productos',
      });
    }

    const skip = (parseInt(page) - 1) * parseInt(limit);

    const [products, total] = await Promise.all([
      prisma.product.findMany({
        where: { sellerId: req.user.userId },
        skip,
        take: parseInt(limit),
        orderBy: { createdAt: 'desc' },
      }),
      prisma.product.count({ where: { sellerId: req.user.userId } }),
    ]);

    res.json({
      products: products.map(p => ({
        id: p.id,
        name: p.name,
        description: p.description,
        price: parseFloat(p.price),
        category: p.category,
        imageUrl: p.imageUrl,
        stock: p.stock,
        isActive: p.isActive,
        views: p.views,
        salesCount: p.salesCount,
        rating: parseFloat(p.rating),
        createdAt: p.createdAt,
      })),
      pagination: {
        page: parseInt(page),
        limit: parseInt(limit),
        total,
        pages: Math.ceil(total / parseInt(limit)),
      },
    });
  } catch (error) {
    console.error('Error al obtener productos del vendedor:', error);
    res.status(500).json({
      error: 'Error al obtener productos',
      message: error.message,
    });
  }
};
