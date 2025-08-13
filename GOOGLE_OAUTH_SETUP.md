# Configuración de Google OAuth Client ID

## ⚠️ IMPORTANTE: Configuración requerida para producción

Actualmente tu aplicación usa autenticación simulada. Para habilitar Google Sign-In real, sigue estos pasos:

## 1. Configurar Google Cloud Console

### Paso 1: Acceder al proyecto
1. Ve a [Google Cloud Console](https://console.cloud.google.com/)
2. Selecciona tu proyecto: `dashboardflutter-78999`
3. Asegúrate de tener permisos de editor/propietario

### Paso 2: Habilitar APIs necesarias
1. Ve a **APIs & Services** > **Library**
2. Busca y habilita estas APIs:
   - **Google Sign-In API**
   - **Identity Toolkit API**
   - **Firebase Authentication API**

### Paso 3: Configurar pantalla de consentimiento OAuth
1. Ve a **APIs & Services** > **OAuth consent screen**
2. Selecciona **External** (para uso público) o **Internal** (solo tu organización)
3. Completa la información básica:
   - **App name**: Admin Dashboard
   - **User support email**: tu email
   - **Developer contact information**: tu email
4. Guarda y continúa

### Paso 4: Crear credenciales OAuth 2.0
1. Ve a **APIs & Services** > **Credentials**
2. Haz clic en **+ CREATE CREDENTIALS**
3. Selecciona **OAuth 2.0 Client IDs**
4. Selecciona **Web application**
5. Configurar:
   - **Name**: Admin Dashboard Web Client
   - **Authorized JavaScript origins**:
     - `http://localhost:3000`
     - `http://localhost:8080`
     - `http://127.0.0.1:3000`
     - `http://127.0.0.1:8080`
     - Tu dominio de producción (ej: `https://tu-dominio.com`)
   - **Authorized redirect URIs**:
     - `http://localhost:3000`
     - `http://localhost:8080`
     - Tu dominio de producción

6. Haz clic en **CREATE**
7. **¡IMPORTANTE!** Copia el **Client ID** que aparece (formato: `xxxxxxxxx-xxxxxxxxxxxxxxxx.apps.googleusercontent.com`)

## 2. Actualizar el código de Flutter

### Paso 1: Actualizar FirebaseAuthService
En el archivo `lib/services/firebase_auth_service.dart`, reemplaza:

```dart
static final GoogleSignIn _googleSignIn = GoogleSignIn(
  // Para desarrollo, usar sin clientId específico
  scopes: ['email', 'profile'],
);
```

Por:

```dart
static final GoogleSignIn _googleSignIn = GoogleSignIn(
  clientId: 'TU_CLIENT_ID_AQUI.apps.googleusercontent.com', // Pegar tu Client ID real
  scopes: ['email', 'profile'],
);
```

### Paso 2: Reactivar el código real en AuthProvider
En el archivo `lib/providers/auth_provider.dart`, en el método `signInWithGoogle()`:

1. Comenta o elimina el código simulado (líneas marcadas como TEMPORAL)
2. Descomenta el código real (el bloque TODO)

## 3. Probar la configuración

1. Ejecuta `flutter run -d chrome`
2. Intenta hacer login con Google
3. Deberías ser redirigido a la página de Google para autorizar la app

## 4. Solución de problemas comunes

### Error "The OAuth client was not found"
- Verifica que el Client ID esté correctamente copiado
- Asegúrate de usar el Client ID de tipo "Web application"

### Error "This app isn't verified"
- Normal en desarrollo
- Haz clic en "Advanced" > "Go to [App Name] (unsafe)"
- Para producción, solicita verificación de Google

### Error "Redirect URI mismatch"
- Agrega la URL actual a "Authorized redirect URIs"
- Para desarrollo local: `http://localhost:PUERTO`

### Error "Access blocked"
- Verifica que tengas configurada la pantalla de consentimiento OAuth
- Asegúrate de que tu email esté en la lista de usuarios de prueba

## 5. Archivos a actualizar

- ✅ `lib/services/firebase_auth_service.dart` - Client ID
- ✅ `lib/providers/auth_provider.dart` - Reactivar código real
- ✅ `web/index.html` - Ya configurado con Firebase

## 6. Para producción

1. Agrega tu dominio real a las URLs autorizadas
2. Configura la verificación de la app en Google
3. Considera usar variables de entorno para el Client ID
4. Implementa manejo de errores más robusto

## Estado actual

🟡 **Modo Demo**: La aplicación funciona con autenticación simulada
🔴 **Pendiente**: Configurar Client ID real de Google OAuth

Una vez completada la configuración, tendrás autenticación completa con Google y Firebase.
