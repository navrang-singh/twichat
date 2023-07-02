import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twichat/consts/theme/theme.dart';
import 'package:twichat/services/auth/controller/auth_controller.dart';
import 'package:twichat/services/auth/view/screens/login_page.dart';
import 'package:twichat/services/home/view/home_page.dart';
import 'package:twichat/widgets/error_page.dart';
import 'package:twichat/widgets/loading.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.theme,
      debugShowCheckedModeBanner: false,
      home: ref.watch(currAccountUserProvider).when(
            data: (user) {
              if (user != null) {
                return const HomePage();
              }
              return const LoginPage();
            },
            error: (error, st) {
              return ErrorPage(
                error: error.toString(),
              );
            },
            loading: () => const LoadingPage(),
          ),
    );
  }
}
