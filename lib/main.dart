import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rest_api_test/presentation/pages/register_user_page.dart';
import 'package:rest_api_test/presentation/view_model/register_user_viewmodel.dart';
import 'package:rest_api_test/injection_container.dart' as di;

void main() {
  di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<RegisterUserViewModel>(
          create: (_) => di.sl<RegisterUserViewModel>(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter REST API',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        home: RegisterUserPage(),
      ),
    );
  }
}
