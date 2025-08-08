# Admin Dashboard - Flutter Web

Una aplicación de administración construida con Flutter Web que incluye autenticación, navegación protegida con guards, layouts responsivos y gestión avanzada de estado.

## 🚀 Características

- **Autenticación completa**: Login, registro y gestión de sesiones con persistencia
- **Sistema de Guards**: Protección automática de rutas con `requireAuth` y `requireGuest`
- **Navegación sin retorno**: Limpieza automática del historial para mejor UX
- **Layouts adaptativos**: AuthLayout, DashboardLayout y SplashLayout
- **Gestión de estado**: Provider con AuthProvider para manejo de sesiones
- **Almacenamiento persistente**: Tokens guardados en localStorage
- **Splash screens**: Pantallas de carga durante verificaciones y transiciones
- **Routing avanzado**: Sistema de rutas con Fluro Router y guards integrados

## 🏗️ Arquitectura del Proyecto

```
lib/
├── main.dart                     # Punto de entrada con builder condicional
├── providers/
│   └── auth_provider.dart        # Estados: checking, authenticated, unauthenticated
├── router/
│   ├── router.dart              # Configuración de rutas con Fluro
│   ├── admin_handlers.dart      # Handlers con RouteGuards integrados
│   └── route_guard.dart         # requireAuth() y requireGuest()
├── services/
│   ├── navigation_service.dart  # navigateToAndClear(), replaceTo(), etc.
│   └── local_storage.dart       # SharedPreferences para tokens
└── ui/
    ├── layouts/
    │   ├── auth/auth_layout.dart        # Layout para login/register
    │   ├── dashboard/dashboard_layout.dart # Layout para áreas autenticadas
    │   └── splash/splash_layout.dart    # Pantalla de carga
    └── views/
        ├── login_view.dart             # Vista de inicio de sesión
        ├── register_view.dart          # Vista de registro
        └── dashboard_view.dart         # Vista principal del dashboard
```

## 🔐 Sistema de Autenticación y Guards

### Estados de Autenticación (AuthProvider)
```dart
enum AuthStatus { 
  checking,        // Verificando token almacenado
  authenticated,   // Usuario autenticado con token válido
  unauthenticated  // Sin token o token inválido
}
```

### Sistema de Guards (RouteGuard)
```dart
// Protege rutas que requieren autenticación
RouteGuard.requireAuth(DashboardView())

// Protege rutas solo para usuarios no autenticados  
RouteGuard.requireGuest(LoginView())
```

### Flujo de Autenticación
1. **Inicio de app**: `AuthProvider` verifica token en localStorage
2. **Token válido**: Estado `authenticated` → Redirige a `/dashboard`
3. **Sin token**: Estado `unauthenticated` → Redirige a `/auth/login`
4. **Login exitoso**: Guarda token → `navigateToAndClear('/dashboard')`
5. **Logout**: Elimina token → `navigateToAndClear('/auth/login')`

### Características del Sistema de Navegación
- **Sin retorno al login**: `navigateToAndClear()` limpia todo el historial
- **Redirecciones automáticas**: Guards manejan accesos no autorizados
- **Prevención de loops**: Lógica robusta para evitar redirecciones infinitas

## 🛠️ Configuración y Uso

### Prerrequisitos
- Flutter SDK (>=3.0.0)
- Dart SDK (>=2.17.0)
- Navegador web moderno

### Instalación

1. **Clona el repositorio**
```bash
git clone <url-del-repositorio>
cd admin_dashboard
```

2. **Instala las dependencias**
```bash
flutter pub get
```

3. **Ejecuta en modo desarrollo**
```bash
flutter run -d chrome
```

4. **Build para producción**
```bash
flutter build web
```

### Dependencias Principales

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.0.0           # Gestión de estado reactivo
  fluro: ^2.0.0             # Routing declarativo
  shared_preferences: ^2.0.0 # Persistencia local
```

## 🔧 Servicios y Utilidades

### NavigationService
```dart
// Navegación básica
NavigationService.navigateTo('/dashboard')
NavigationService.replaceTo('/login')

// Navegación con limpieza de historial (recomendado para auth)
NavigationService.navigateToAndClear('/dashboard')

// Navegación hacia atrás
NavigationService.goBack()
```

### AuthProvider - Métodos Principales
```dart
// Iniciar sesión
await authProvider.login(email, password)

// Verificar autenticación
bool isAuth = await authProvider.isAuthenticated()

// Cerrar sesión
authProvider.logout()

// Obtener token actual
String? token = authProvider.token
```

## 📱 Layouts y Builder Condicional

### Main.dart - Builder Inteligente
```dart
builder: (_, child) {
  final authProvider = Provider.of<AuthProvider>(context);
  
  if (authProvider.authStatus == AuthStatus.checking) {
    return SplashLayout(); // Pantalla de carga
  }
  
  return _buildLayoutWrapper(authProvider, child!);
}
```

### Layouts Disponibles

**AuthLayout**
- Diseño centrado para formularios
- Fondo y estilos para páginas de autenticación
- Utilizado por: login, register

**DashboardLayout** 
- Estructura preparada para sidebar y navbar
- Área de contenido principal expandible
- Utilizado por: dashboard y futuras páginas autenticadas

**SplashLayout**
- Pantalla de carga con indicador circular
- Mostrado durante verificaciones y transiciones
- Previene pantallas vacías durante redirecciones

## 🚦 Rutas y Guards

| Ruta | Vista | Guard | Descripción |
|------|-------|-------|-------------|
| `/` | LoginView | requireGuest | Página principal → login |
| `/auth/login` | LoginView | requireGuest | Inicio de sesión |
| `/auth/register` | RegisterView | requireGuest | Registro de usuario |
| `/dashboard` | DashboardView | requireAuth | Panel principal |

### Comportamiento de Guards

**requireGuest** (para usuarios NO autenticados):
- Si está autenticado → Redirige a `/dashboard`
- Si no está autenticado → Muestra la vista solicitada

**requireAuth** (para usuarios autenticados):
- Si está autenticado → Muestra la vista solicitada  
- Si no está autenticado → Redirige a `/auth/login`

## 🔄 Flujo de Estados

```mermaid
graph TD
    A[App Start] --> B[AuthStatus.checking]
    B --> C{Token en localStorage?}
    C -->|Sí| D[AuthStatus.authenticated]
    C -->|No| E[AuthStatus.unauthenticated]
    
    D --> F[DashboardLayout + Dashboard]
    E --> G[AuthLayout + Login]
    
    G --> H[Login Success]
    H --> I[Guardar Token]
    I --> J[navigateToAndClear('/dashboard')]
    J --> D
    
    D --> K[Logout Button]
    K --> L[Eliminar Token]
    L --> M[navigateToAndClear('/auth/login')]
    M --> E
    
    style B fill:#fff2cc
    style D fill:#d5e8d4
    style E fill:#f8cecc
```

## 🎨 Personalización y Extensión

### Agregar nueva ruta protegida:

1. **Definir en router.dart**:
```dart
static String newRoute = '/new-page';
router.define(newRoute, handler: AdminHandlers.newPage);
```

2. **Crear handler con guard**:
```dart
static Handler newPage = Handler(
  handlerFunc: (context, params) {
    return RouteGuard.requireAuth(NewPageView());
  },
);
```

3. **Crear la vista**:
```dart
class NewPageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(/* tu contenido */);
  }
}
```

### Personalizar layouts:

**Para modificar DashboardLayout**:
- Descomenta las secciones de Sidebar y Navbar
- Agrega tus componentes personalizados
- El `child` se renderizará en el área principal

**Para modificar AuthLayout**:
- Cambia colores, fondos o disposición
- Mantén la estructura que envuelve al `child`

## 🐛 Solución de Problemas Comunes

### ❌ Error: "Pantalla roja en transiciones"
**Causa**: Provider no configurado correctamente o falta de guards
```dart
// ✅ Solución: Verificar en main.dart
ChangeNotifierProvider(lazy: false, create: (_) => AuthProvider())
```

### ❌ Error: "Usuario puede volver al login después de autenticarse"
**Causa**: Uso de `replaceTo` en lugar de `navigateToAndClear`
```dart
// ❌ Incorrecto
NavigationService.replaceTo('/dashboard')

// ✅ Correcto  
NavigationService.navigateToAndClear('/dashboard')
```

### ❌ Error: "Loop infinito de redirecciones"
**Causa**: Guards mal configurados o verificación de rutas incorrecta
```dart
// ✅ Solución: Verificar que los guards estén en admin_handlers.dart
return RouteGuard.requireAuth(DashboardView()); // Para rutas protegidas
return RouteGuard.requireGuest(LoginView());    // Para rutas públicas
```

### ❌ Error: "Token persiste pero redirige a login"
**Causa**: Validación de token en `isAuthenticated()` muy estricta
```dart
// ✅ Verificar en auth_provider.dart que el token se asigne correctamente
authStatus = AuthStatus.authenticated;
this._token = token; // ← Importante asignar el token recuperado
```

## 📈 Mejores Prácticas Implementadas

- ✅ **Single Source of Truth**: AuthProvider maneja todo el estado de autenticación
- ✅ **Guards Declarativos**: Protección de rutas a nivel de handler
- ✅ **Navegación sin retorno**: `navigateToAndClear` para mejor UX
- ✅ **Estados de carga**: SplashLayout durante transiciones
- ✅ **Separación de responsabilidades**: Services, Providers, Views separados
- ✅ **Persistencia automática**: Tokens guardados sin intervención manual

## 🚀 Próximos Pasos

- [ ] Implementar sidebar con navegación en DashboardLayout
- [ ] Agregar navbar con perfil de usuario y logout
- [ ] Crear más vistas del dashboard (usuarios, reportes, etc.)
- [ ] Implementar validación real de JWT con backend
- [ ] Agregar manejo de roles y permisos
- [ ] Implementar refresh tokens

## 📄 Licencia

Este proyecto está bajo la licencia MIT. Ver `LICENSE` para más detalles.

## 🤝 Contribuciones

Las contribuciones son bienvenidas:

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 👨‍💻 Autor

**Manuel Manodes**
- GitHub: [@ManuelManodes](https://github.com/ManuelManodes)
- LinkedIn: [Manuel Manodes](https://linkedin.com/in/manuelmanodes)

## ⭐ Agradecimientos

- Flutter Team por el framework
- Comunidad de Flutter por los recursos y ejemplos
- Material Design por las guías de diseño

---

*Hecho con ❤️ con Flutter*
