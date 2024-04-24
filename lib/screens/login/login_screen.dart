import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_checkin/config/theme.dart';
import 'package:qr_checkin/utils/theme_ext.dart';

import '../../config/http_client.dart';
import '../../config/router.dart';
import '../../features/auth/bloc/auth_bloc.dart';
import '../../features/auth/data/auth_repository.dart';
import '../../widgets/single_child_scroll_view_with_column.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameKey = GlobalKey<FormFieldState>();
  final _usernameFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _passwordKey = GlobalKey<FormFieldState>();
  late bool _passwordVisible = false;
  late final _authState = context.read<AuthBloc>().state;
  late final _usernameController = TextEditingController(
    text: (switch (_authState) {
      AuthLoginInitial(username: final username) => username,
      _ => '',
    }),
  );
  late final _passwordController = TextEditingController(
    text: (switch (_authState) {
      AuthLoginInitial(password: final password) => password,
      _ => '',
    }),
  );

  @override
  void initState() {
    super.initState();

    _usernameFocusNode.addListener(() {
      if (!_usernameFocusNode.hasFocus) {
        _usernameKey.currentState!.validate();
      }
    });

    _passwordFocusNode.addListener(() {
      if (!_passwordFocusNode.hasFocus) {
        _passwordKey.currentState!.validate();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;

    var loginWidget = (switch (authState) {
      AuthLoginInitial() => _buildInitialLoginWidget(),
      AuthAuthenticateUnauthenticated() => _buildInitialLoginWidget(),
      AuthLoginInProgress() => _buildInProgressLoginWidget(),
      AuthLoginFailure(message: final msg) => _buildFailureLoginWidget(msg),
      _ => _buildInitialLoginWidget(),
    });

    loginWidget = BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          switch (state) {
            case AuthLoginSuccess():
              context.read<AuthBloc>().add(AuthAuthenticateStarted());
              break;
            case AuthAuthenticateSuccess():
              context.go(RouteName.home);
              break;
            default:
          }
        },
        child: loginWidget);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollViewWithColumn(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Đăng nhập',
              style: context.text.headlineLarge!,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FractionallySizedBox(
              widthFactor: 0.8,
              child: Container(
                padding: const EdgeInsets.fromLTRB(32, 40, 32, 20),
                decoration: BoxDecoration(
                  color: context.color.surface,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: loginWidget,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleGo(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            AuthLoginStarted(
              username: _usernameController.text,
              password: _passwordController.text,
            ),
          );
    }
  }

  void _handleRetry(BuildContext context) {
    context.read<AuthBloc>().add(AuthStarted());
  }

  Widget _buildInitialLoginWidget() {
    return AutofillGroup(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _usernameController,
              key: _usernameKey,
              focusNode: _usernameFocusNode,
              autofocus: true,
              onEditingComplete: () {
                if (_usernameKey.currentState!.validate()) {
                  _passwordFocusNode.requestFocus();
                }
              },
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
              ],
              autofillHints: const [AutofillHints.username],
              maxLength: 50,
              buildCounter: (context,
                      {required currentLength,
                      required isFocused,
                      maxLength}) =>
                  null,
              decoration: const InputDecoration(
                labelText: 'Tên đăng nhập',
                prefixIcon: Icon(Icons.person),
                filled: true,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập tên đăng nhập';
                } else if (value.length < 6) {
                  return 'Tên đăng nhập phải có ít nhất 6 ký tự';
                }

                return null;
              },
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _passwordController,
              key: _passwordKey,
              focusNode: _passwordFocusNode,
              keyboardType: TextInputType.visiblePassword,
              onFieldSubmitted: (_) {
                _handleGo(context);
              },
              maxLength: 50,
              buildCounter: (context,
                      {required currentLength,
                      required isFocused,
                      maxLength}) =>
                  null,
              autofillHints: const [AutofillHints.newPassword],
              decoration: InputDecoration(
                labelText: 'Mật khẩu',
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                    icon: _passwordVisible
                        ? const Icon(Icons.visibility)
                        : const Icon(Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    }),
                filled: true,
              ),
              obscureText: !_passwordVisible,
              enableSuggestions: false,
              autocorrect: false,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập mật khẩu';
                } else if (value.length < 8) {
                  return 'Mật khẩu phải có ít nhất 8 ký tự';
                } else if (!RegExp(r'[a-zA-Z]').hasMatch(value) ||
                    !RegExp(r'[0-9]').hasMatch(value)) {
                  return 'Mật khẩu ít nhất 1 chữ cái và 1 chữ số';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () {
                _handleGo(context);
              },
              label: const Text('Tiếp tục'),
              icon: const Icon(Icons.arrow_forward),
            ),
            TextButton(
              onPressed: () {
                context.read<AuthBloc>().add(AuthRegisterInitiated());
                context.go(RouteName.register);
              },
              child: Text('Chưa có tài khoản? Đăng ký ngay!',
                  textAlign: TextAlign.center, style: context.text.bodyMedium!.copyWith(
                    color: context.color.primary,
                    fontWeight: FontWeight.w400,
                  )),
            ),
          ]
              .animate(
                interval: 50.ms,
              )
              .slideX(
                begin: -0.1,
                end: 0,
                curve: Curves.easeInOutCubic,
                duration: 400.ms,
              )
              .fadeIn(
                curve: Curves.easeInOutCubic,
                duration: 400.ms,
              ),
        ),
      ),
    );
  }

  Widget _buildInProgressLoginWidget() {
    return const Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildFailureLoginWidget(String message) {
    return Column(
      children: [
        Text(
          message,
          style: context.text.bodyLarge!.copyWith(
            color: context.color.error,
          ),
        ),
        const SizedBox(height: 24),
        FilledButton.icon(
          onPressed: () {
            _handleRetry(context);
          },
          label: const Text('Thử lại'),
          icon: const Icon(Icons.refresh),
        ),
      ],
    );
  }
}
