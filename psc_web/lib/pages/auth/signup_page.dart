import 'package:flutter/material.dart';
import '../../widgets/auth/signup_form.dart';

/// 独立注册页面（如果需要的话）
/// 注意：主登录页面已经包含了注册功能，这个页面是可选的，
/// 仅当需要单独的注册入口时使用
class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('注册新账号'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.primary,
              Color.lerp(colorScheme.primary, colorScheme.secondary, 0.7)!,
            ],
          ),
        ),
        child: Center(
          child: Card(
            margin: const EdgeInsets.all(16),
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: SignupForm(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
} 