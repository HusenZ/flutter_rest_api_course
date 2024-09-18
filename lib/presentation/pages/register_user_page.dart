import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rest_api_test/presentation/view_model/register_user_viewmodel.dart';
import 'package:rest_api_test/presentation/widgets/custom_snackbar.dart';

class RegisterUserPage extends StatelessWidget {
  RegisterUserPage({super.key});

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<RegisterUserViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Register User"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(label: Text("Enter Your Name")),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _usernameController,
              decoration:
                  const InputDecoration(label: Text("Enter Unique Username")),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(label: Text("Enter Email Id")),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(label: Text("Enter Password")),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                viewModel
                    .registerUser(
                  _nameController.text,
                  _usernameController.text,
                  _emailController.text,
                  _passwordController.text,
                )
                    .then(
                  (value) {
                    if (context.mounted) {
                      CustomSnackBar.show(context, value);
                    }
                  },
                );
              },
              child: const Text("Register User"),
            ),
          ],
        ),
      ),
    );
  }
}
