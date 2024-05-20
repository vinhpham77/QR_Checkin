import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_checkin/utils/theme_ext.dart';

import '../../config/router.dart';
import '../../config/theme.dart';
import '../../features/auth/bloc/auth_bloc.dart';
import '../../widgets/single_child_scroll_view_with_column.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameKey = GlobalKey<FormFieldState>();
  final _emailKey = GlobalKey<FormFieldState>();
  final _passwordKey = GlobalKey<FormFieldState>();
  final _repeatPasswordKey = GlobalKey<FormFieldState>();
  final _usernameController = TextEditingController(text: '');
  final _passwordController = TextEditingController(text: '');
  final _repeatPasswordController = TextEditingController(text: '');
  final _emailController = TextEditingController(text: '');
  final _idCardController = TextEditingController(text: '');
  final _idCardFocusNode = FocusNode();
  final _idCardKey = GlobalKey<FormFieldState>();
  bool _passwordVisible = false;
  bool _repeatPasswordVisible = false;
  final _usernameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _repeatPasswordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _passwordController.clear();
    _repeatPasswordController.clear();
    _emailController.clear();
    _idCardController.clear();

    _usernameFocusNode.addListener(() {
      if (!_usernameFocusNode.hasFocus) {
        _usernameKey.currentState!.validate();
      }
    });

    _emailFocusNode.addListener(() {
      if (!_emailFocusNode.hasFocus) {
        _emailKey.currentState!.validate();
      }
    });

    _passwordFocusNode.addListener(() {
      if (!_passwordFocusNode.hasFocus) {
        _passwordKey.currentState!.validate();
      }
    });

    _repeatPasswordFocusNode.addListener(() {
      if (!_repeatPasswordFocusNode.hasFocus) {
        _repeatPasswordKey.currentState!.validate();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;

    var registerWidget = (switch (authState) {
      AuthRegisterInitial() => _buildInitialRegisterWidget(),
      AuthAuthenticateUnauthenticated() => _buildInitialRegisterWidget(),
      AuthRegisterInProgress() => _buildInProgressRegisterWidget(),
      AuthRegisterFailure(message: final msg) =>
        _buildFailureRegisterWidget(msg),
      _ => _buildInitialRegisterWidget(),
    });

    registerWidget = BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthRegisterSuccess) {
          context.go(RouteName.login);
          context.read<AuthBloc>().add(AuthLoginPrefilled(
                username: _usernameController.text,
                password: '',
              ));
        }
      },
      child: registerWidget,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollViewWithColumn(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Đăng ký',
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
                child: registerWidget,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSubmit(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            AuthRegisterStarted(
                username: _usernameController.text,
                password: _passwordController.text,
                email: _emailController.text,
                idNo: _idCardController.text),
          );
    }
  }

  void _handleRetry(BuildContext context) {
    context.read<AuthBloc>().add(AuthStarted());
  }

  Widget _buildInitialRegisterWidget() {
    return AutofillGroup(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _usernameController,
              key: _usernameKey,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
              ],
              focusNode: _usernameFocusNode,
              maxLength: 50,
              buildCounter: (context,
                      {required currentLength,
                      required isFocused,
                      maxLength}) =>
                  null,
              onEditingComplete: () {
                if (_usernameKey.currentState!.validate()) {
                  _emailFocusNode.requestFocus();
                }
              },
              autofillHints: const [AutofillHints.username],
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
              key: _passwordKey,
              focusNode: _passwordFocusNode,
              controller: _passwordController,
              keyboardType: TextInputType.visiblePassword,
              buildCounter: (context,
                      {required currentLength,
                      required isFocused,
                      maxLength}) =>
                  null,
              onEditingComplete: () {
                if (_passwordKey.currentState!.validate()) {
                  _repeatPasswordFocusNode.requestFocus();
                }
              },
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
              maxLength: 50,
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
            TextFormField(
              controller: _repeatPasswordController,
              focusNode: _repeatPasswordFocusNode,
              key: _repeatPasswordKey,
              maxLength: 50,
              buildCounter: (context,
                      {required currentLength,
                      required isFocused,
                      maxLength}) =>
                  null,
              onEditingComplete: () {
                if (_repeatPasswordKey.currentState!.validate()) {
                  _emailFocusNode.requestFocus();
                }
              },
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                labelText: 'Nhập lại mật khẩu',
                filled: true,
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                    icon: _repeatPasswordVisible
                        ? const Icon(Icons.visibility)
                        : const Icon(Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _repeatPasswordVisible = !_repeatPasswordVisible;
                      });
                    }),
              ),
              obscureText: !_repeatPasswordVisible,
              autocorrect: false,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập lại mật khẩu';
                }

                if (value != _passwordController.text) {
                  return 'Mật khẩu nhập lại không khớp với mật khẩu trên';
                }

                return null;
              },
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _emailController,
              key: _emailKey,
              focusNode: _emailFocusNode,
              keyboardType: TextInputType.emailAddress,
              maxLength: 50,
              buildCounter: (context,
                  {required currentLength,
                    required isFocused,
                    maxLength}) =>
              null,
              autofillHints: const [AutofillHints.email],
              onEditingComplete: () {
                if (_emailKey.currentState!.validate()) {
                  _idCardFocusNode.requestFocus();
                }
              },
              decoration: const InputDecoration(
                labelText: 'Email',
                filled: true,
                prefixIcon: Icon(Icons.email),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập email';
                }

                var emailPattern = RegExp(
                  r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                );

                if (!emailPattern.hasMatch(value)) {
                  return 'Email không hợp lệ';
                }

                return null;
              },
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _idCardController,
              focusNode: _idCardFocusNode,
              key: _idCardKey,
              keyboardType: TextInputType.number,
              maxLength: 12,
              buildCounter: (context,
                  {required currentLength,
                    required isFocused,
                    maxLength}) =>
              null,
              onEditingComplete: () {
                if (_idCardKey.currentState!.validate()) {
                  _handleSubmit(context);
                }
              },
              decoration: const InputDecoration(
                labelText: 'CMND/CCCD',
                filled: true,
                prefixIcon: Icon(Icons.email),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập CMND/CCCD';
                }

                if (value.length != 9 && value.length != 12) {
                  return 'CMND/CCCD không hợp lệ';
                }

                if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                  return 'CMND/CCCD không hợp lệ';
                }

                return null;
              },
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () {
                _handleSubmit(context);
              },
              label: const Text('Xác nhận'),
              icon: const Icon(Icons.arrow_forward),
            ),
            TextButton(
              // padding 0
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
              ),
              onPressed: () {
                context.read<AuthBloc>().add(AuthLoginPrefilled(
                      username: '',
                      password: '',
                    ));
                context.go(RouteName.login);
              },
              child: Text('Đã có tài khoản? Quay lại đăng nhập',
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

  Widget _buildInProgressRegisterWidget() {
    return const Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildFailureRegisterWidget(String message) {
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

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _repeatPasswordController.dispose();
    _emailController.dispose();
    _idCardController.dispose();
    _idCardFocusNode.dispose();
    _usernameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _repeatPasswordFocusNode.dispose();
    super.dispose();
  }
}
