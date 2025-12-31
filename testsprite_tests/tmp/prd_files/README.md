# Gagalom 🛍️

Una aplicación de comercio electrónico moderna y elegante para la venta de ropa y accesorios.

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Riverpod](https://img.shields.io/badge/Riverpod-4B4B4B?style=for-the-badge&logo=flutter&logoColor=white)

</div>

## 📖 Sobre la App

Gagalom es una aplicación móvil de e-commerce diseñada para ofrecer una experiencia de compra intuitiva y atractiva. La app permite a los usuarios explorar catálogos de ropa, filtrar productos por categorías, gestionar un carrito de compras y completar el proceso de checkout de manera sencilla.

### Características Principales

- 🏠 **Home Screen**: Explora productos destacados y nuevos arrivals
- 🔍 **Búsqueda Avanzada**: Filtra por categorías, género, precio y más
- 🛒 **Carrito de Compras**: Gestiona tus productos con control de cantidades
- 💳 **Checkout Completo**: Direcciones de envío, métodos de pago y resumen de órdenes
- 👤 **Perfil de Usuario**: Gestión de cuenta, direcciones y métodos de pago
- 🌙 **Modo Oscuro**: Interfaz adaptable a preferencias del usuario (próximamente)
- ⭐ **Sistema de Reviews**: Valora y lee opiniones de productos

## 👨‍💻 Creador

**Desarrollado por:** Wallfa

Una aplicación moderna construida con las mejores prácticas de desarrollo móvil y diseño UI/UX.

## 🛠️ Stack Tecnológico

### Core
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

### Utilities
- **intl** - Formateo de fechas, números y monedas
- **equatable** - Comparación de objetos por valor
- **shimmer** - Efectos de carga skeleton

## 🎨 Arquitectura

La aplicación sigue una arquitectura limpia y escalable:

```
lib/
├── core/
│   ├── theme/          # Temas, colores y estilos centralizados
│   └── screens/        # Pantallas principales
├── features/
│   ├── auth/           # Autenticación y onboarding
│   ├── home/           # Pantalla principal
│   ├── product/        # Detalles de productos
│   ├── cart/           # Carrito de compras
│   ├── checkout/       # Proceso de pago
│   ├── search/         # Búsqueda y filtros
│   └── profile/        # Perfil y ajustes
└── shared/
    ├── widgets/        # Widgets reutilizables
    └── models/         # Modelos de datos
```

## 🎯 Características del Diseño

- ✅ **Colores Centralizados**: Todos los colores definidos en un solo archivo
- ✅ **Temas Claro/Oscuro**: Preparado para cambio dinámico de temas
- ✅ **Componentes Reutilizables**: Tarjetas de productos, botones, inputs
- ✅ **Responsive Design**: Adaptable a diferentes tamaños de pantalla
- ✅ **Iconos SVG**: Gráficos vectoriales nítidos en cualquier resolución

## 🚀 Próximas Features

- [ ] Sistema de autenticación completo
- [ ] Persistencia de carrito de compras
- [ ] Historial de órdenes
- [ ] Lista de deseos (Wishlist)
- [ ] Notificaciones de pedidos
- [ ] Integración con pasarelas de pago reales
- [ ] Sistema de cupones y descuentos
- [ ] Reviews y calificaciones de productos
- [ ] Chat de soporte al cliente
- [ ] Modo offline

## 🌐 Soporte de Plataformas

- ✅ **Android** 5.0+ (API 21+)
- ✅ **iOS** 12.0+
- 🔄 **Web** (En desarrollo)

## 📱 Pantallas Principales

| Pantalla | Descripción |
|----------|-------------|
| **Onboarding** | Selección de preferencias de usuario |
| **Home** | Catálogo principal con productos destacados |
| **Search** | Búsqueda avanzada con filtros |
| **Product Detail** | Vista completa del producto con opciones |
| **Cart** | Carrito de compras con gestión de cantidades |
| **Checkout** | Proceso completo de pago |
| **Profile** | Gestión de cuenta y ajustes |
| **Settings** | Configuración de la app |

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