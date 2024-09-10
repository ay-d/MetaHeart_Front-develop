import 'package:cardio_sim/auth/model/state/member_state.dart';
import 'package:cardio_sim/auth/provider/auth_provider.dart';
import 'package:cardio_sim/auth/view/login_view.dart';
import 'package:cardio_sim/common/view/splash_screen.dart';
import 'package:cardio_sim/credit/view/credit_view.dart';
import 'package:cardio_sim/home/view/home_view.dart';
import 'package:cardio_sim/logcat/view/logcat_chart_view.dart';
import 'package:cardio_sim/logcat/view/logcat_view.dart';
import 'package:cardio_sim/menu/provider/menu_stack_provider.dart';
import 'package:cardio_sim/simulation/view/simulation_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final redirectProvider = ChangeNotifierProvider((ref) => RedirectData(ref));

class RedirectData extends ChangeNotifier {
  Ref ref;

  RedirectData(this.ref) {
    MemberState().addListener(notifyListeners);
    ref.listen(menuStackProvider, (_, __) {
      notifyListeners();
    });
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final AuthProvider auth = ref.read(authProvider);
  final MenuStack menu = ref.read(menuStackProvider);
  final redirectData = ref.read(redirectProvider);

  return GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/',
        redirect: menu.redirectLogic,
        routes: [
          GoRoute(
            path: 'home',
            name: HomeView.routeName,
            builder: (context, state) => const HomeView(),
          ),
          GoRoute(
            path: 'simulation',
            name: SimulationView.name,
            builder: (context, state) => const SimulationView(),
          ),
        ],
      ),
      GoRoute(
        path: '/logcat',
        name: LogcatView.name,
        builder: (context, state) => const LogcatView(),
        routes: [
          GoRoute(
            path: 'chart',
            name: LogcatChartView.name,
            builder: (context, state) => const LogcatChartView(),
          )
        ],
      ),
      GoRoute(
        path: '/splash',
        name: SplashScreen.routeName,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/auth',
        redirect: (context, state) {
          if (state.location.contains('credit')) return null;
          if (state.location.contains('signup')) return null;
          return '/auth/login';
        },
        routes: [
          GoRoute(
            path: 'login',
            name: LoginView.routeName,
            builder: (context, state) => const LoginView(),
          ),
          GoRoute(
            path: 'credit',
            name: CreditView.routeName,
            builder: (context, state) => const CreditView(),
          ),
        ],
      ),
    ],
    refreshListenable: redirectData,
    redirect: auth.redirectLogic,
  );
});
