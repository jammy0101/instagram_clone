import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:horizon/features/authh/presentation/pages/signup_page.dart';
import 'package:horizon/features/home/presentation/pages/home.dart';
import 'package:horizon/features/profile/presentation/pages/profile.dart';
import '../../../../core/common/widgets/loader.dart';
import '../../../../core/theme/app_pallete.dart';
import '../../../../core/utils/show_snackbar.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/auth_field.dart';
import '../widgets/auth_gradient_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _selectedRole;
  final List<String> _roles = ["English", "Urdu"];
  bool _isVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthFailure) {
              showSnackBar(context, state.message);
            } else if (state is AuthSuccess) {
              Navigator.pushAndRemoveUntil(context, Home.route(), (route) => false);
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => Home()),
              // );
            }
          },
          builder: (context, state) {
            if (state is AuthLoading) {
              return Loader();
            }
            return Form(
              key: formKey,
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 50),
                  DropdownButtonFormField<String>(
                    value: _selectedRole,
                    hint: const Text("English"),
                    items: _roles.map((role) {
                      return DropdownMenuItem(value: role, child: Text(role));
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedRole = value;
                      });
                    },
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 150,
                      ), // optional, tightens space
                    ),
                    icon: const Icon(Icons.arrow_drop_down, size: 20),
                  ),
                  SizedBox(height: 185),
                  Center(
                    child: Image(
                      color: AppPallete.whiteColor,
                      image: ExactAssetImage(
                        'assets/images/logos_instagram.png',
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  AuthField(hintText: 'Email', controller: _emailController),
                  SizedBox(height: 15),
                  AuthField(
                    controller: _passwordController,
                    hintText: 'Password',
                    obSecure: !_isVisible,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isVisible ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isVisible = !_isVisible;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 25),
                  SizedBox(height: 15),
                  AuthGradientButton(
                    buttonText: 'Sign In',
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        context.read<AuthBloc>().add(
                          AuthLogin(
                            email: _emailController.text,
                            password: _passwordController.text,
                          ),
                        );
                      }
                    },
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignupPage()),
                      );
                    },
                    child: RichText(
                      text: TextSpan(
                        text: "Don't have an Account? ",
                        style: Theme.of(context).textTheme.titleMedium,
                        children: [
                          TextSpan(
                            text: "Sign Up",
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: AppPallete.gradient2,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
