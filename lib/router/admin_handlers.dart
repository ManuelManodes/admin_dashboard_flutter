import 'package:admin_dashboard/ui/views/login_view.dart';
import 'package:admin_dashboard/ui/views/register_view.dart';
import 'package:admin_dashboard/ui/views/dashboard_view.dart';
import 'package:admin_dashboard/router/route_guard.dart';
import 'package:fluro/fluro.dart';

class AdminHandlers {
  static Handler login = Handler(
    handlerFunc: (context, params) {
      return RouteGuard.requireGuest(LoginView());
    },
  );

  static Handler register = Handler(
    handlerFunc: (context, params) {
      return RouteGuard.requireGuest(RegisterView());
    },
  );

  static Handler dashboard = Handler(
    handlerFunc: (context, params) {
      return RouteGuard.requireAuth(DashboardView());
    },
  );
}
