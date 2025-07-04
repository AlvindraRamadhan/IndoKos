import 'package:go_router/go_router.dart';
import 'package:indokos/payment_screen.dart';

import 'auth_provider.dart';
import 'login_screen.dart';
import 'register_screen.dart';
import 'main_layout.dart';
import 'mobile_home_screen.dart';
import 'chat_list_screen.dart';
import 'booking_history_screen.dart';
import 'profile_screen.dart';
import 'search_screen.dart';
import 'kos_detail_screen.dart';
import 'booking_screen.dart';
import 'payment_success_screen.dart';
import 'notifications_screen.dart';
import 'submit_kos_screen.dart';
import 'wishlist_screen.dart';
import 'about_us_screen.dart';
import 'settings_screen.dart';

class AppRouter {
  final AuthProvider authProvider;
  AppRouter(this.authProvider);

  late final GoRouter router = GoRouter(
    refreshListenable: authProvider,
    initialLocation: '/',
    routes: <RouteBase>[
      ShellRoute(
        builder: (context, state, child) {
          return MainLayout(child: child);
        },
        routes: [
          GoRoute(
              path: '/', builder: (context, state) => const MobileHomeScreen()),
          GoRoute(
              path: '/chat',
              builder: (context, state) => const ChatListScreen()),
          GoRoute(
              path: '/booking-history',
              builder: (context, state) => const BookingHistoryScreen()),
          GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen()),
        ],
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterScreen()),
      GoRoute(
          path: '/search', builder: (context, state) => const SearchScreen()),
      GoRoute(
        path: '/kos/:id',
        builder: (context, state) =>
            KosDetailScreen(kosId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/booking/:id',
        builder: (context, state) =>
            BookingScreen(kosId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/payment/:id',
        builder: (context, state) => PaymentScreen(
            bookingDetails: state.extra as Map<String, dynamic>? ?? {}),
      ),
      GoRoute(
        path: '/payment-success',
        builder: (context, state) => PaymentSuccessScreen(
            paymentDetails: state.extra as Map<String, dynamic>? ?? {}),
      ),
      GoRoute(
          path: '/notifications',
          builder: (context, state) => const NotificationsScreen()),
      GoRoute(
          path: '/submit-kos',
          builder: (context, state) => const SubmitKosScreen()),
      GoRoute(
          path: '/wishlist',
          builder: (context, state) => const WishlistScreen()),
      GoRoute(
          path: '/about-us',
          builder: (context, state) => const AboutUsScreen()),
      GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsScreen()),
    ],
    redirect: (context, state) {
      final bool loggedIn = authProvider.user != null;
      final bool isAuthRoute = state.matchedLocation == '/login' ||
          state.matchedLocation == '/register';

      if (!loggedIn && !isAuthRoute) return '/login';
      if (loggedIn && isAuthRoute) return '/';

      return null;
    },
  );
}
