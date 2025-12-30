# Guía de Colores de la App

## 🎨 Estructura Centralizada

Todos los colores de la aplicación están centralizados en un solo archivo:
- **Archivo**: `lib/core/theme/app_colors.dart`

## 🌗 Temas Disponibles

### Tema Claro (Light Theme)
- **Background**: `0xFFFFFFFF` (Blanco)
- **Surface**: `0xFFF5F5F5` (Gris claro)
- **Primary**: `0xFF000000` (Negro)
- **Secondary**: `0xFF757575` (Gris medio)
- **OnPrimary**: `0xFFFFFFFF` (Blanco - texto sobre primary)
- **OnSurface**: `0xFF272727` (Gris oscuro - texto sobre surface)

### Tema Oscuro (Dark Theme)
- **Background**: `0xFF121212` (Negro muy oscuro)
- **Surface**: `0xFF1E1E1E` (Gris muy oscuro)
- **Primary**: `0xFFFFFFFF` (Blanco)
- **Secondary**: `0xFFB0B0B0` (Gris claro)
- **OnPrimary**: `0xFF000000` (Negro - texto sobre primary)
- **OnSurface**: `0xFFE0E0E0` (Gris muy claro - texto sobre surface)

## 🔧 Cómo Cambiar los Colores

### 1. Cambiar color del tema principal
Solo necesitas editar el archivo `app_colors.dart`:

```dart
// Ejemplo: Cambiar el color primario a azul
static const Color lightPrimary = Color(0xFF2196F3); // Azul
static const Color darkPrimary = Color(0xFF90CAF9);  // Azul claro
```

### 2. Cambiar el color de fondo
```dart
static const Color lightBackground = Color(0xFFFFF0E5); // Crema
static const Color darkBackground = Color(0xFF1A1A1A);  // Gris más claro
```

### 3. Los cambios se aplican automáticamente
Todos los widgets usan `theme.colorScheme.primary`, `theme.colorScheme.surface`, etc.
**NO necesitas cambiar nada más**, solo los valores en `app_colors.dart`

## 🎯 Ejemplos de Cambios Rápidos

### Hacer la app con colores morados
```dart
// Light theme
static const Color lightPrimary = Color(0xFF9C27B0);     // Púrpura
static const Color lightSecondary = Color(0xFFBA68C8);   // Lavanda

// Dark theme
static const Color darkPrimary = Color(0xFFE1BEE7);      // Púrpura claro
static const Color darkSecondary = Color(0xFFCE93D8);    // Lavanda claro
```

### Hacer la app con colores rojos
```dart
// Light theme
static const Color lightPrimary = Color(0xFFFA3636);     // Rojo coral
static const Color lightSecondary = Color(0xFFEF5350);   // Rojo claro

// Dark theme
static const Color darkPrimary = Color(0xFFFF8A80);      // Rojo claro
static const Color darkSecondary = Coloro(0xFFFF5252);   // Rojo medio
```

## 📱 Implementar el Switch de Tema

El switch ya está creado en `settings_screen.dart`. Para activarlo:

1. Ve a `lib/core/theme/theme_provider.dart`
2. Sigue las instrucciones comentadas ahí
3. Solo necesitas descomentar 3 bloques de código

## ⚠️ Importante

- **NO uses colores hardcoded** como `Colors.white` o `Color(0xFF...)` en los widgets
- **SIEMPRE usa** `theme.colorScheme.primary`, `theme.colorScheme.onSurface`, etc.
- Esto asegura que funcione tanto en tema claro como oscuro
- Todos los cambios se hacen en **un solo lugar**: `app_colors.dart`
