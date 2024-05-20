import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/user_service.dart';

class LoginPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final PageController pageController;

  LoginPage({required this.pageController, super.key});

  void setUsername(String username) {
    _usernameController.text = username;
  }

  void setPassword(String password) {
    _passwordController.text = password;
  }

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<UserService>(context, listen: false);

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  UserFormWidget(
                    formKey: _formKey,
                    usernameController: _usernameController,
                    passwordController: _passwordController,
                    buttonText: '登录',
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          await userService.loginUser(
                            _usernameController.text,
                            _passwordController.text,
                          );
                          // TODO: Handle successful login
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("登录失败: ${e.toString()}")),
                          );
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut);
                    },
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all<Size>(
                          const Size(double.infinity, 36)),
                    ),
                    child: const Text('注册'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RegisterPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final PageController pageController;

  RegisterPage({super.key, required this.pageController});

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<UserService>(context, listen: false);
    final loginPage = Provider.of<LoginPage>(context, listen: false);

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  UserFormWidget(
                    formKey: _formKey,
                    usernameController: _usernameController,
                    passwordController: _passwordController,
                    buttonText: '注册',
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          await userService.registerUser(
                            _usernameController.text,
                            _passwordController.text,
                            _usernameController.text,
                          );
                          loginPage.setUsername(_usernameController.text);
                          loginPage.setPassword(_passwordController.text);
                          pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("注册失败: ${e.toString()}")),
                          );
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        await userService.registerUserTemp();
                        loginPage.setUsername('temp');
                        loginPage.setPassword('temp');
                        pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("临时注册失败: ${e.toString()}")),
                        );
                      }
                    },
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all<Size>(
                          const Size(double.infinity, 36)),
                    ),
                    child: const Text('临时注册'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// 登录/注册页面
class LoginPageAndRegisterPage extends StatelessWidget {
  const LoginPageAndRegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final pageController = PageController();
    return PageView(
      controller: pageController,
      children: <Widget>[
        LoginPage(pageController: pageController),
        RegisterPage(pageController: pageController,),
      ],
    );
  }
}

// 用户登录/注册表单
class UserFormWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final String buttonText;
  final VoidCallback onPressed;

  const UserFormWidget({
    super.key,
    required this.formKey,
    required this.usernameController,
    required this.passwordController,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextFormField(
            controller: usernameController,
            decoration: const InputDecoration(
              labelText: '用户名',
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return '请输入用户名';
              }
              return null;
            },
          ),
          TextFormField(
            controller: passwordController,
            decoration: const InputDecoration(
              labelText: '密码',
            ),
            obscureText: true,
            validator: (value) {
              if (value!.isEmpty) {
                return '请输入密码';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: onPressed,
            style: ButtonStyle(
              minimumSize: MaterialStateProperty.all<Size>(
                  const Size(double.infinity, 36)),
            ),
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }
}
