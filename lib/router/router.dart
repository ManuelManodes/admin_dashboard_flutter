import 'package:admin_dashboard/router/admin_handlers.dart';
import 'package:admin_dashboard/router/no_page_found_handlers.dart'; // Agregar esta importación
import 'package:fluro/fluro.dart';

class Flurorouter {
  static final FluroRouter router = new FluroRouter();

  static String rootRoute = '/';

  // Auth Router
  static String loginRoute = '/auth/login';
  static String registerRoute = '/auth/register';

  // Dashboard Router
  static String dashboardRoute = '/dashboard';
  static String iconsRoute = '/dashboard/icons';
  static String blankRoute = '/dashboard/blank'; // Añadir esta línea

  static void configureRoutes() {
    // Auth Routes
    router.define(
      rootRoute,
      handler: AdminHandlers.login,
      transitionType: TransitionType.none,
    );
    router.define(
      loginRoute,
      handler: AdminHandlers.login,
      transitionType: TransitionType.none,
    );
    router.define(
      registerRoute,
      handler: AdminHandlers.register,
      transitionType: TransitionType.none,
    );

    // Dashboard Route
    router.define(
      dashboardRoute,
      handler: AdminHandlers.dashboard,
      transitionType: TransitionType.fadeIn,
    );

    // Icons Route - Agregar esta sección
    router.define(
      iconsRoute,
      handler: AdminHandlers.icons,
      transitionType: TransitionType.none,
    );

    // Blank Route - Añadir esta sección
    router.define(
      blankRoute,
      handler: AdminHandlers.blank,
      transitionType: TransitionType.none,
    );

    // Agregar handler para páginas no encontradas
    router.notFoundHandler = NoPageFoundHandlers.noPageFound;
  }
}

// This class will handle routing
