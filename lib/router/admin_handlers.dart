import 'package:admin_dashboard/providers/sidemenu_provider.dart';
import 'package:admin_dashboard/ui/views/login_view.dart';
import 'package:admin_dashboard/ui/views/register_view.dart';
import 'package:admin_dashboard/ui/views/dashboard_view.dart';
import 'package:admin_dashboard/ui/views/icons_view.dart';
import 'package:admin_dashboard/ui/views/blank_view.dart'; // Añadir esta línea
import 'package:admin_dashboard/ui/views/scheduling_view.dart';
import 'package:admin_dashboard/router/route_guard.dart';
import 'package:admin_dashboard/router/router.dart'; // Asegúrate de importar el router
import 'package:fluro/fluro.dart';
import 'package:provider/provider.dart';

class AdminHandlers {
  static Handler login = Handler(
    handlerFunc: (context, params) {
      return RouteGuard.requireGuest(LoginView());
    },
  );

  static Handler register = Handler(
    handlerFunc: (context, params) {
      if (context != null) {
        Provider.of<SideMenuProvider>(
          context,
          listen: false,
        ).setCurrentPageUrl(Flurorouter.registerRoute);
      }
      return RouteGuard.requireGuest(RegisterView());
    },
  );

  static Handler dashboard = Handler(
    handlerFunc: (context, params) {
      if (context != null) {
        Provider.of<SideMenuProvider>(
          context,
          listen: false,
        ).setCurrentPageUrl(Flurorouter.dashboardRoute);
      }
      return RouteGuard.requireAuth(DashboardView());
    },
  );

  static Handler icons = Handler(
    handlerFunc: (context, params) {
      if (context != null) {
        Provider.of<SideMenuProvider>(
          context,
          listen: false,
        ).setCurrentPageUrl(Flurorouter.iconsRoute);
      }
      return RouteGuard.requireAuth(IconsView());
    },
  );

  // Añadir este handler
  static Handler blank = Handler(
    handlerFunc: (context, params) {
      if (context != null) {
        Provider.of<SideMenuProvider>(
          context,
          listen: false,
        ).setCurrentPageUrl(Flurorouter.blankRoute);
      }
      return RouteGuard.requireAuth(BlankView());
    },
  );

  static Handler scheduling = Handler(
    handlerFunc: (context, params) {
      if (context != null) {
        Provider.of<SideMenuProvider>(
          context,
          listen: false,
        ).setCurrentPageUrl(Flurorouter.schedulingRoute);
      }
      return RouteGuard.requireAuth(SchedulingView());
    },
  );
}
