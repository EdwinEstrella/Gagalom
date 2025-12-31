# Gagalom 🛍️

Una aplicación de comercio electrónico moderna y elegante para la venta de ropa y accesorios.

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Riverpod](https://img.shields.io/badge/Riverpod-4B4B4B?style=for-the-badge&logo=flutter&logoColor=white)

</div>

## 📖 Sobre la App

Gagalom es una aplicación móvil de e-commerce diseñada para ofrecer una experiencia de compra intuitiva y atractiva. Permite a los usuarios explorar catálogos de ropa, filtrar productos por categorías, gestionar un carrito de compras y completar el proceso de checkout. Además, incluye un sistema completo de vendedores donde los usuarios pueden convertirse en tiendas y vender sus propios productos.

### Características Principales

- ✅ **Home Screen**: Explora productos destacados y nuevos arrivals
- ✅ **Búsqueda Avanzada**: Filtra por categorías, género, precio y más
- ✅ **Carrito de Compras**: Gestiona tus productos con control de cantidades
- ✅ **Checkout Completo**: Integración con Stripe para pagos seguros
- ✅ **Autenticación Completa**: Registro, login, recuperación de contraseña
- ✅ **Perfil de Usuario**: Gestión de cuenta, direcciones y métodos de pago
- ✅ **Modo Oscuro/Claro**: Interfaz adaptable con Material Design 3
- ✅ **Historial de Órdenes**: Consulta todas tus compras pasadas
- ✅ **Sistema de Vendedores**: Solicita ser vendedor y vende tus productos
- ✅ **Multi-Vendedor**: Productos de múltiples vendedores en una plataforma
- ✅ **Roles de Usuario**: Customer, Seller, Admin con permisos específicos
- ✅ **CRUD de Productos**: Gestión completa de inventario para vendedores
- ✅ **Solicitudes de Vendedor**: Flujo completo con aprobación de administradores
- ⏳ **Sistema de Reviews**: Valora y lee opiniones de productos (próximamente)
- ⏳ **Lista de Deseos**: Guarda tus productos favoritos (próximamente)
- ⏳ **Notificaciones Push**: Alertas de pedidos y ofertas (próximamente)
- ⏳ **Sistema de Cupones**: Descuentos y promociones (próximamente)
- ⏳ **Chat de Soporte**: Atención al cliente en tiempo real (próximamente)

## 👨‍💻 Creador

**Desarrollado por:** Wallfa

Una aplicación moderna construida con las mejores prácticas de desarrollo móvil y diseño UI/UX.

## 🛠️ Stack Tecnológico

### Frontend (Mobile)
- **Flutter** 3.10+ - Framework de desarrollo móvil multiplataforma
- **Dart** - Lenguaje de programación principal

### State Management
- **Riverpod** 2.6+ - Gestión de estado reactiva y eficiente
- **Providers** - Inyección de dependencias y estado global

### UI Components
- **Material Design 3** - Sistema de diseño moderno de Google
- **flutter_svg** - Soporte para gráficos vectoriales escalables
- **cached_network_image** - Caching inteligente de imágenes

### Navigation
- **go_router** 14.6+ - Enrutamiento declarativo y gestión de navegación

### Backend (Node.js + Express)
- **Express** 4.18+ - Framework web minimalista
- **Prisma ORM** 5.22+ - ORM type-safe para bases de datos
- **PostgreSQL** - Base de datos relacional
- **JWT** - Autenticación con JSON Web Tokens
- **Bcrypt** - Encriptación de contraseñas
- **Stripe** 14.7+ - Pasarela de pagos

### Security & Utilities
- **Helmet** - Headers HTTP seguros
- **CORS** - Compartimiento de recursos entre orígenes
- **express-rate-limit** - Limitación de rate limiting
- **Dio** - Cliente HTTP para Flutter
- **flutter_secure_storage** - Almacenamiento seguro de tokens

## 🎨 Arquitectura

La aplicación sigue una arquitectura limpia y escalable:

### Frontend (Flutter)
```
lib/
├── core/
│   ├── theme/               # Temas, colores y estilos centralizados
│   ├── config/              # Configuración de API y constantes
│   ├── services/            # Servicios API (auth, products, seller, stripe)
│   ├── models/              # Modelos de datos
│   └── utils/               # Utilidades y helpers
├── features/
│   ├── auth/                # Autenticación y onboarding
│   │   ├── providers/        # Riverpod providers de auth
│   │   └── screens/         # Login, Register, Splash, Onboarding
│   ├── home/                # Pantalla principal
│   ├── product/             # Detalles de productos
│   ├── cart/                # Carrito de compras
│   ├── checkout/            # Proceso de pago con Stripe
│   ├── search/              # Búsqueda y filtros
│   ├── seller/              # Sistema de vendedores
│   │   ├── providers/        # Riverpod providers de seller
│   │   └── screens/         # Solicitud de vendedor
│   └── orders/              # Historial de órdenes
└── shared/
    ├── widgets/             # Widgets reutilizables
    └── models/              # Modelos compartidos
```

### Backend (Node.js + Express)
```
backend/
├── src/
│   ├── config/              # Configuración (Prisma, etc.)
│   ├── controllers/         # Controladores de lógica de negocio
│   │   ├── authController.js
│   │   ├── productController.js
│   │   ├── sellerController.js
│   │   └── stripeController.js
│   ├── middleware/          # Middlewares (auth, rate limiting, validator)
│   ├── routes/              # Rutas de la API
│   │   ├── productRoutes.js
│   │   └── sellerRoutes.js
│   └── database/            # Configuración de BD
├── prisma/
│   ├── schema.prisma        # Schema de Prisma
│   ├── migrations/          # Migraciones de BD
│   └── seed.js              # Datos de prueba
└── .env                     # Variables de entorno
```

## 🎯 Características del Diseño

- ✅ **Colores Centralizados**: Todos los colores definidos en `app_colors.dart`
- ✅ **Temas Claro/Oscuro**: Implementado con Material Design 3
- ✅ **Componentes Reutilizables**: Tarjetas de productos, botones, inputs
- ✅ **Responsive Design**: Adaptable a diferentes tamaños de pantalla
- ✅ **Iconos SVG**: Gráficos vectoriales nítidos en cualquier resolución
- ✅ **Textos en Español**: Interfaz completamente traducida
- ✅ **Validaciones de Formularios**: Feedback en tiempo real
- ✅ **Animaciones Suaves**: Transiciones y efectos de carga
- ✅ **Manejo de Errores**: Mensajes claros y accionables

## 🔐 Seguridad

- ✅ **JWT Authentication**: Tokens con expiración de 7 días
- ✅ **Bcrypt Hashing**: Contraseñas encriptadas con 12 rounds
- ✅ **Rate Limiting**: Protección contra ataques de fuerza bruta
- ✅ **Helmet**: Headers HTTP seguros
- ✅ **CORS**: Compartimiento controlado de recursos
- ✅ **Input Validation**: Validación de datos con express-validator
- ✅ **Role-Based Access**: Permisos por roles (customer, seller, admin)
- ✅ **Flutter Secure Storage**: Tokens almacenados de forma segura

## 💾 Base de Datos

- **PostgreSQL**: Base de datos relacional robusta
- **Prisma ORM**: ORM type-safe con migraciones
- **Modelos**: User, Product, SellerRequest, Order, OrderItem, RefreshToken
- **Índices Optimizados**: Consultas rápidas y eficientes
- **Relaciones**: Foreign keys y cascadas configuradas

## 💳 Pagos

- **Stripe**: Pasarela de pagos líder en la industria
- **Payment Intents**: Manejo robusto de pagos
- **Webhooks**: Sincronización de estados de órdenes
- **Multi-Vendedor**: Soporte para múltiples vendedores

## 🚀 Próximas Features

### Frontend
- [ ] Lista de Deseos (Wishlist) - Guarda productos favoritos
- [ ] Sistema de Reviews y Calificaciones - Valora productos
- [ ] Notificaciones Push - Alertas de pedidos y ofertas
- [ ] Chat de Soporte al Cliente - Atención en tiempo real
- [ ] Modo Offline - Acceso sin conexión a internet
- [ ] Filtrado Avanzado de Productos - Más filtros y ordenamiento
- [ ] Comparador de Productos - Compara características
- [ ] Compartir Productos - Redes sociales y mensajería

### Backend
- [ ] Sistema de Cupones y Descuentos - Promociones
- [ ] Gestión de Inventario - Stock y alertas
- [ ] Dashboard de Admin - Panel de administración completo
- [ ] Reportes y Analíticas - Estadísticas de ventas
- [ ] Sistema de Refundaciones - Devoluciones y reembolsos
- [ ] Integración con Email - Notificaciones por correo
- [ ] Exportación de Órdenes - CSV, PDF, Excel
- [ ] Webhooks de Stripe - Eventos en tiempo real

### Infraestructura
- [ ] CI/CD Pipeline - Despliegue automático
- [ ] Testing Automatizado - Tests unitarios y de integración
- [ ] Docker Compose - Desarrollo local fácil
- [ ] Documentación de API - Swagger/OpenAPI
- [ ] Monitoring y Logging - Seguimiento de errores
- [ ] Cache Redis - Optimización de rendimiento
- [ ] CDN para Imágenes - Entrega rápida de media

## 🌐 Soporte de Plataformas

- ✅ **Android** 5.0+ (API 21+)
- ✅ **iOS** 12.0+
- 🔄 **Web** (En desarrollo)

## 📱 Pantallas Principales

| Pantalla | Descripción | Estado |
|----------|-------------|---------|
| **Splash** | Pantalla de carga con logo | ✅ |
| **Onboarding** | Introducción a la app | ✅ |
| **Login** | Inicio de sesión con email | ✅ |
| **Registro** | Creación de cuenta nueva | ✅ |
| **Home** | Catálogo principal con productos destacados | ✅ |
| **Categorías** | Navegación por categorías de productos | ✅ |
| **Búsqueda** | Búsqueda avanzada con filtros | ✅ |
| **Detalle Producto** | Vista completa del producto con opciones | ✅ |
| **Carrito** | Carrito de compras con gestión de cantidades | ✅ |
| **Checkout** | Proceso completo de pago con Stripe | ✅ |
| **Órdenes** | Historial de compras del usuario | ✅ |
| **Solicitud Vendedor** | Formulario para ser vendedor | ✅ |
| **Ajustes** | Configuración de la app y tema | ✅ |
| **Notificaciones** | Alertas y actualizaciones | ⏳ |
| **Wishlist** | Lista de productos favoritos | ⏳ |

## 🎨 Personalización

La app está diseñada para ser fácilmente personalizable. Todos los colores están centralizados en:

```
lib/core/theme/app_colors.dart
```

Cambia los colores en un solo lugar y toda la app se actualiza automáticamente.

## 📄 Licencia

Este proyecto es propiedad de Wallfa. Todos los derechos reservados.

---

**Hecho con ❤️ usando Flutter**