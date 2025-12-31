# Guía de Configuración - Gagalom App (Android/iOS)

Esta guía es específica para la app móvil nativa de Gagalom con autenticación y pagos Stripe.

## 📱 Configuración para Android/iOS

### 1. Instalar dependencias de Flutter

```bash
cd gagalom
flutter pub get
```

### 2. Configurar Stripe para Móviles

#### Android

Edita `android/app/build.gradle` y agrega dentro de `android {`:

```gradle
defaultConfig {
    applicationId "com.example.gagalom"
    minSdkVersion 21  // Stripe requiere mínimo 21
    targetSdkVersion 33

    // Agrega tu clave publicable de Stripe
    resValue "string", "stripe_publishable_key", "pk_test_tu_clave_aqui"
}
```

En `android/app/src/main/AndroidManifest.xml`, agrega:

```xml
<application
    ...>
    <meta-data
        android:name="com.google.android.gms.wallet.api.enabled"
        android:value="true" />

    <intent-filter>
        <action android:name="android.intent.action.VIEW" />
        <category android:name="android.intent.category.DEFAULT" />
        <category android:name="android.intent.category.BROWSABLE" />
        <data android:scheme="com.example.gagalom" />
    </intent-filter>
</application>
```

#### iOS

Edita `ios/Runner/Info.plist`:

```xml
<key>StripePublishableKey</key>
<string>pk_test_tu_clave_aqui</string>

<key>CFBundleURLSchemes</key>
<array>
    <string>com.example.gagalom</string>
</array>
```

### 3. Configurar URL del Backend

Edita `lib/core/config/api_config.dart`:

#### Para Android Emulator:
```dart
static const String baseUrl = 'http://10.0.2.2:3000';
```

#### Para iOS Simulator:
```dart
static const String baseUrl = 'http://localhost:3000';
```

#### Para dispositivo físico:
Usa la IP de tu computador en la red local:
```dart
static const String baseUrl = 'http://192.168.1.100:3000'; // Reemplaza con tu IP
```

### 4. Permisos Requeridos

#### Android - `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
```

#### iOS - `ios/Runner/Info.plist`:

```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

## 🔧 Configuración del Backend

### 1. Instalar dependencias

```bash
cd backend
npm install
```

### 2. Configurar `.env`

El archivo ya tiene las credenciales de PostgreSQL. Solo agrega tus claves de Stripe:

```env
# Obtén tus claves en https://dashboard.stripe.com/test/apikeys
STRIPE_SECRET_KEY=sk_test_tu_clave_aqui
STRIPE_PUBLISHABLE_KEY=pk_test_tu_clave_aqui
```

### 3. Inicializar base de datos

```bash
npm run init-db
```

### 4. Iniciar servidor backend

```bash
npm run dev
```

El backend estará en: `http://localhost:3000`

## 🚀 Ejecutar la App

### Opción 1: Con dispositivo conectado

```bash
# En una terminal, inicia el backend
cd backend && npm run dev

# En otra terminal, ejecuta la app
flutter run
```

### Opción 2: Con emulador

```bash
# Iniciar emulador Android
flutter emulators --launch <emulator_id>

# O iniciar simulador iOS
open -a Simulator

# Ejecutar la app
flutter run
```

## 🧪 Probar el Sistema Completo

### 1. Registro
- Abre la app
- Tap en "Create One"
- Completa: Nombre, Apellido, Email, Contraseña
- Selecciona: Género (Men/Women) y Rango de edad
- Tap en "Continue"

### 2. Login
- Ingresa tu email
- Ingresa tu contraseña
- Seleccionar el ícono de ojo para ver/ocultar contraseña

### 3. Procesar un Pago (con Stripe Test)

Usa estas tarjetas de prueba de Stripe:

#### ✅ Pago Exitoso:
- **Número**: `4242 4242 4242 4242`
- **Fecha**: Cualquier fecha futura (ej: 12/25)
- **CVC**: Cualquier número de 3 dígitos (ej: 123)
- **ZIP**: Cualquier código postal (ej: 12345)

#### ❌ Pago Fallido:
- **Número**: `4000 0000 0000 0002`
- Resto igual que arriba

#### ⏳ Pago Requiere Autenticación 3D:
- **Número**: `4000 0025 0000 3155`
- Resto igual que arriba

## 📱 Pantallas Implementadas

### Autenticación
- ✅ Splash Screen
- ✅ Login (Email)
- ✅ Login Password
- ✅ Registro con información completa
- ✅ Validación de formularios
- ✅ Mensajes de error

### Pagos (Proveedores creados)
- ✅ Servicio de Stripe
- ✅ Crear Payment Intent
- ✅ Confirmar pago
- ✅ Obtener historial de órdenes
- ✅ Providers de Riverpod

## 🔒 Seguridad Implementada

### Backend
- ✅ Contraseñas hasheadas con bcrypt (12 rounds)
- ✅ Tokens JWT con expiración
- ✅ Rate limiting (5 intentos de login cada 15 min)
- ✅ Validación de email y contraseña fuerte
- ✅ Helmet para headers seguros

### Frontend
- ✅ Almacenamiento seguro con flutter_secure_storage
- ✅ Verificación de expiración de tokens
- ✅ Interceptors para agregar tokens automáticamente
- ✅ Manejo de errores de 401 (logout automático)

## 🎨 Características de la UI

- ✅ Diseño basado en Figma
- ✅ Soporte para tema claro/oscuro
- ✅ Animaciones de carga
- ✅ Mensajes de error descriptivos
- ✅ Validación en tiempo real
- ✅ Iconos de visibilidad de contraseña
- ✅ Navegación fluida

## 🐛 Solución de Problemas Comunes

### Error: "Connection refused"
**Solución**: Verifica que el backend esté corriendo en el puerto 3000

### Error: "Host unreachable" (Android Emulator)
**Solución**: Usa `10.0.2.2` en lugar de `localhost` en `api_config.dart`

### Error: "SSL Error" (Android)
**Solución**: Agrega `android:usesCleartextTraffic="true"` en `<application>` del AndroidManifest

### Error: "Stripe initialization failed"
**Solución**: Verifica que la clave publicable esté correcta en `build.gradle` (Android) o `Info.plist` (iOS)

### Error: "Token expired"
**Solución**: Haz logout y login nuevamente

## 📦 Estructura de Archivos Creados

### Backend
```
backend/
├── src/
│   ├── controllers/
│   │   ├── authController.js      # Registro, login, perfil
│   │   └── stripeController.js    # Pagos Stripe
│   ├── middleware/
│   │   ├── auth.js                # Verificación JWT
│   │   ├── validator.js           # Validación de inputs
│   │   └── rateLimiter.js         # Rate limiting
│   ├── database/
│   │   ├── db.js                  # Config PostgreSQL
│   │   └── init.js                # Script de inicialización
│   └── server.js                  # Servidor Express
├── package.json
├── .env                           # Credenciales
└── .env.example
```

### Flutter
```
lib/
├── core/
│   ├── config/
│   │   └── api_config.dart        # URLs de API
│   ├── models/
│   │   └── user.dart              # Modelo User
│   └── services/
│       ├── auth_api_service.dart  # API Auth
│       ├── storage_service.dart   # Secure Storage
│       └── stripe_service.dart    # Stripe Service
├── features/
│   ├── auth/
│   │   ├── providers/
│   │   │   ├── auth_provider.dart # State management
│   │   │   └── auth_state.dart
│   │   └── screens/
│   │       ├── login_screen.dart
│   │       ├── login_password_screen.dart
│   │       └── register_screen.dart
│   └── checkout/
│       └── providers/
│           └── stripe_provider.dart
└── main.dart
```

## 🎯 Próximos Pasos

1. **Agregar productos** en la base de datos
2. **Implementar carrito** con los providers creados
3. **Conectar Stripe** en la pantalla de checkout
4. **Agregar webhook** de Stripe para confirmación de pagos
5. **Personalizar** el diseño según tus necesidades

## 📞 Credenciales de Prueba

### PostgreSQL (Ya configurado)
- Host: 190.166.109.120
- Port: 5432
- Database: postgres
- User: postgres
- Password: zghqcwwhp37wcjeo

### Stripe (Necesitas configurar)
1. Ve a https://dashboard.stripe.com/register
2. Regístrate en modo test
3. Copia tus claves API
4. Agrégalas al `.env` del backend

## 💡 Tips de Desarrollo

- **Hot Reload**: Usa `flutter run` para hot reload
- **Logs**: Usa `print()` o `debugPrint()` para logs
- **Debug**: VS Code tiene excelente debug para Flutter
- **Postman**: Úsalo para probar los endpoints del backend
- **Stripe CLI**: Usa `stripe listen` para probar webhooks

## ✅ Checklist Antes de Deploy

- [ ] Cambiar URLs de localhost a producción
- [ ] Usar claves de Stripe en modo live
- [ ] Configurar webhook de Stripe en producción
- [ ] Probar flujo completo de compra
- [ ] Verificar permisos de Android/iOS
- [ ] Probar en dispositivo físico
- [ ] Revisar rendimiento y memoria
- [ ] Agregar analytics y crash reporting
