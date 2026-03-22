import 'package:crudops_application/features/request/active_job_screen.dart';
import 'package:crudops_application/features/request/home_screen.dart';
import 'package:go_router/go_router.dart';


final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => HomeScreen(),
    ),
    GoRoute(
      path: '/active-job/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return ActiveJobScreen(id: id);
      },
    ),
  ],
);