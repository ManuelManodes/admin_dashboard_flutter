# 📊 Admin Dashboard Flutter

Un dashboard administrativo moderno desarrollado con Flutter, diseñado para ser multiplataforma y responsivo. Este proyecto utiliza un sistema de routing robusto con Fluro y está optimizado para web, móvil y desktop.

## 🚀 Características

- ✅ **Multiplataforma**: Compatible con Web, Android, iOS, Windows, macOS y Linux
- ✅ **Routing Avanzado**: Sistema de navegación basado en Fluro router
- ✅ **Diseño Responsivo**: Layout adaptativo para desktop y móvil
- ✅ **Arquitectura Modular**: Código organizado por funcionalidades
- ✅ **Autenticación**: Sistema de login integrado
- ✅ **UI Moderna**: Diseño limpio y profesional

## 🛠️ Tecnologías Utilizadas

- **Flutter** - Framework principal
- **Dart** - Lenguaje de programación
- **Fluro** - Router y navegación
- **Google Fonts** - Tipografías personalizadas
- **Material Design** - Sistema de diseño

## 📱 Capturas de Pantalla

*Próximamente se agregarán capturas del dashboard en funcionamiento*

## 🏗️ Estructura del Proyecto

```
lib/
├── main.dart                 # Punto de entrada de la aplicación
├── router/                   # Sistema de routing
│   ├── router.dart          # Configuración principal de rutas
│   ├── admin_handlers.dart  # Manejadores de rutas del admin
│   └── no_page_found_handlers.dart # Manejo de páginas 404
├── ui/
│   ├── layouts/             # Layouts principales
│   │   └── auth/           # Layout de autenticación
│   │       └── auth_layout.dart
│   ├── views/              # Vistas/Páginas
│   │   ├── login_view.dart # Vista de login
│   │   └── no_page_found_view.dart # Página 404
│   └── buttons/            # Componentes de botones
└── assets/                 # Recursos estáticos
    ├── twitter-bg.png     # Imagen de fondo
    └── twitter-white-logo.png # Logo
```

## 🎯 Rutas Disponibles

| Ruta | Descripción | Handler |
|------|-------------|---------|
| `/` | Página principal (redirige a login) | AdminHandlers.login |
| `/auth/login` | Página de inicio de sesión | AdminHandlers.login |
| `/dashboard` | Dashboard principal | *En desarrollo* |
| `*` | Página 404 - No encontrada | NoPageFoundHandlers.noPageFound |

## 🚀 Instalación y Configuración

### Prerrequisitos

- Flutter SDK (>=3.8.1)
- Dart SDK
- IDE compatible (VS Code, Android Studio, IntelliJ)

### Pasos de Instalación

1. **Clonar el repositorio**
   ```bash
   git clone https://github.com/ManuelManodes/admin_dashboard_flutter.git
   cd admin_dashboard_flutter
   ```

2. **Instalar dependencias**
   ```bash
   flutter pub get
   ```

3. **Ejecutar la aplicación**
   
   **Para Web:**
   ```bash
   flutter run -d web-server
   ```
   
   **Para Desktop:**
   ```bash
   flutter run -d windows  # En Windows
   flutter run -d macos    # En macOS
   flutter run -d linux    # En Linux
   ```
   
   **Para Móvil:**
   ```bash
   flutter run -d android  # Android
   flutter run -d ios      # iOS
   ```

## 🔧 Comandos Útiles

```bash
# Verificar configuración de Flutter
flutter doctor

# Ejecutar tests
flutter test

# Construir para producción (Web)
flutter build web

# Construir para producción (Android)
flutter build apk

# Limpiar proyecto
flutter clean
flutter pub get
```

## 📦 Dependencias Principales

```yaml
dependencies:
  flutter: sdk
  fluro: ^2.0.5              # Router avanzado
  google_fonts: ^6.2.1      # Fuentes de Google
  cupertino_icons: ^1.0.8   # Iconos iOS

dev_dependencies:
  flutter_test: sdk
  flutter_lints: ^5.0.0     # Análisis de código
```

## 🎨 Sistema de Diseño

El proyecto utiliza un diseño responsivo con:

- **Desktop Layout**: Vista de dos columnas con sidebar y contenido principal
- **Mobile Layout**: Vista adaptativa para pantallas pequeñas *(en desarrollo)*
- **Colores**: Esquema de colores profesional basado en Material Design
- **Tipografía**: Google Fonts para una apariencia moderna

## 🔮 Roadmap

- [ ] **Dashboard Principal**: Vista del dashboard con métricas
- [ ] **Gestión de Usuarios**: CRUD de usuarios
- [ ] **Reportes**: Sistema de reportes y analytics
- [ ] **Configuraciones**: Panel de configuración del sistema
- [ ] **Modo Oscuro**: Implementar tema oscuro
- [ ] **Internacionalización**: Soporte multi-idioma
- [ ] **API Integration**: Conexión con backend
- [ ] **Tests**: Cobertura completa de tests

## 🤝 Contribución

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para más detalles.

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
