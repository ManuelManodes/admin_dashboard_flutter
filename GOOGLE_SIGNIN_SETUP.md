# Configuración de Google Sign-In

Este documento explica cómo configurar Google Sign-In en tu aplicación Flutter.

## Pasos para configurar Google Sign-In

### 1. Crear un proyecto en Google Cloud Console

1. Ve a [Google Cloud Console](https://console.cloud.google.com/)
2. Crea un nuevo proyecto o selecciona uno existente
3. Habilita la API de Google Sign-In

### 2. Configurar OAuth 2.0

1. Ve a "APIs & Services" > "Credentials"
2. Haz clic en "Create Credentials" > "OAuth 2.0 Client IDs"
3. Selecciona "Web application"
4. Agrega tus dominios autorizados:
   - Para desarrollo local: `http://localhost:3000`
   - Para producción: tu dominio real

### 3. Configurar para Web

En el archivo `lib/services/google_sign_in_service.dart`, descomenta y actualiza la línea:

```dart
clientId: 'tu-client-id-web.googleusercontent.com',
```

### 4. Configurar para Android (Opcional)

1. Obtén el SHA-1 de tu keystore:
   ```bash
   keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
   ```

2. En Google Cloud Console, crea un OAuth client ID para Android
3. Agrega el SHA-1 y el package name

### 5. Configurar para iOS (Opcional)

1. Agrega el archivo `GoogleService-Info.plist` a tu proyecto iOS
2. Configura el URL scheme en `ios/Runner/Info.plist`

## Funcionalidades Implementadas

- ✅ Botón de Google Sign-In en la vista de login
- ✅ Integración con el sistema de autenticación existente
- ✅ Almacenamiento de información del usuario
- ✅ Logout que incluye Google Sign-Out
- ✅ Manejo de errores
- ✅ Navegación automática después del login

## Uso

Una vez configurado, los usuarios podrán:

1. Hacer clic en "Continuar con Google"
2. Ser redirigidos a la página de login de Google
3. Autorizar la aplicación
4. Ser redirigidos automáticamente al dashboard

## Notas Importantes

- Para que funcione en web, necesitas configurar el `clientId` en el servicio
- El token de Google se almacena localmente para mantener la sesión
- La información del usuario (email, nombre) se guarda en SharedPreferences
- El logout cierra tanto la sesión local como la de Google

## Solución de Problemas

### Error: "Not a valid origin"
- Asegúrate de que tu dominio esté agregado en Google Cloud Console
- Para desarrollo local, agrega `http://localhost:PORT`

### Error: "Invalid client ID"
- Verifica que el clientId esté correctamente configurado
- Asegúrate de usar el clientId correcto para web

### El botón no aparece
- Verifica que el SDK de Google esté cargado en `web/index.html`
- Revisa la consola del navegador por errores de JavaScript
