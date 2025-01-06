import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:repore_chat/auth/application/auth_notifier.dart';
import 'package:repore_chat/auth/application/auth_state.dart';
import 'package:repore_chat/auth/presentation/sign_up_screen.dart';
import 'package:repore_chat/utils/widgets/custom_button.dart';
import 'package:repore_chat/utils/widgets/custom_textfield.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    ref.listen(authProvider, (previous, next) {
      next.maybeWhen(
        error: (message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: Colors.red,
            ),
          );
        },
        authenticated: (user) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Logged in as ${user.email}'),
              backgroundColor: Colors.green,
            ),
          );
        },
        orElse: () {},
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextField(
                controller: _emailController,
                label: 'Email',
                prefixIcon: const Icon(Icons.email),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const Gap(16),
              CustomTextField(
                controller: _passwordController,
                isPasswordField: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const Gap(16),
              CustomButton(
                text: 'Login',
                loading: authState == const AuthState.loading(),
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    ref.read(authProvider.notifier).signInWithEmailAndPassword(
                          _emailController.text.trim(),
                          _passwordController.text,
                        );
                  }
                },
              ),
              const Gap(16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Don\'t have an account?'),
                  TextButton(
                    onPressed: authState == const AuthState.loading()
                        ? null
                        : () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const SignUpScreen(),
                              ),
                            );
                          },
                    child: const Text('Sign Up'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
