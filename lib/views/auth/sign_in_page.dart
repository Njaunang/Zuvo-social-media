import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:zuvo/l10n/app_localizations.dart';
import 'package:zuvo/services/auth_service.dart';
import 'package:zuvo/util/toast_notification.dart';
import 'package:zuvo/views/dashboard_page.dart';
import 'package:zuvo/views/auth/sign_up_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoadingEmail = false;
  bool _isLoadingFacebook = false;
  bool _obscurePassword = true;

  Future<void> signInWithEmail() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoadingEmail = true);

      try {
        String email = emailController.text.trim();
        String password = passwordController.text.trim();

        await _authService.signInWithEmail(email: email, password: password);

        if (mounted) {
          ToastNotification.showSuccess(
            context,
            title: AppLocalizations.of(context)!.success_title,
            description: AppLocalizations.of(
              context,
            )!.sign_in_with_email_successfully,
          );

          // Navigate to home or next screen
          await Future.delayed(const Duration(seconds: 1));
          if (mounted) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const DashboardPage()),
              (route) => false,
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ToastNotification.showError(
            context,
            title: AppLocalizations.of(context)!.failed_signin_title,
            description: e.toString().replaceFirst('Exception: ', ''),
            // description: "",
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoadingEmail = false);
        }
      }
    }
  }

  Future<void> signInWithFacebook() async {
    setState(() => _isLoadingFacebook = true);

    try {
      await _authService.signInWithFacebook();

      if (mounted) {
        ToastNotification.showSuccess(
          context,
          title: AppLocalizations.of(context)!.success_title,
          description: AppLocalizations.of(
            context,
          )!.signin_with_facebook_successfully,
        );

        // Navigate to home or next screen
        await Future.delayed(const Duration(seconds: 1));
        if (mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const DashboardPage()),
            (route) => false,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ToastNotification.showError(
          context,
          title: AppLocalizations.of(context)!.facebook_signin_failed,
          // description: e.toString().replaceFirst('Exception: ', ''),
          description: e.toString().replaceFirst('Exception: ', ''),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoadingFacebook = false);
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              const SizedBox(height: 60),
              // Logo at the top center
              Center(
                child: Text(
                  AppLocalizations.of(context)!.app_name,
                  style: Theme.of(context).textTheme.displayLarge,
                ),
              ),
              const SizedBox(height: 40),
              Text(
                AppLocalizations.of(context)!.welcome_back,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Email TextField
                    TextFormField(
                      controller: emailController,
                      enabled: !_isLoadingEmail && !_isLoadingFacebook,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.email_hintext,
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(left: 16.0),
                          child: HugeIcon(
                            icon: HugeIcons.strokeRoundedMail02,
                            size: 20,
                          ),
                        ),
                      ),
                      validator: ValidationBuilder().required().email().build(),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20),
                    // Password TextField
                    TextFormField(
                      controller: passwordController,
                      enabled: !_isLoadingEmail && !_isLoadingFacebook,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(
                          context,
                        )!.password_hintext,
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(left: 16.0),
                          child: HugeIcon(
                            icon: HugeIcons.strokeRoundedCircleLock01,
                            size: 20,
                          ),
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(
                              () => _obscurePassword = !_obscurePassword,
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 14.0),
                            child: HugeIcon(
                              icon: _obscurePassword
                                  ? HugeIcons.strokeRoundedViewOff
                                  : HugeIcons.strokeRoundedView,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                      validator: ValidationBuilder()
                          .required()
                          .minLength(6)
                          .build(),
                    ),
                    const SizedBox(height: 24),

                    // Sign in with email button
                    ElevatedButton(
                      onPressed: _isLoadingFacebook ? null : signInWithEmail,
                      child: _isLoadingEmail
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation(
                                  Theme.of(context).scaffoldBackgroundColor,
                                ),
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                HugeIcon(
                                  icon: HugeIcons.strokeRoundedMail02,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  AppLocalizations.of(
                                    context,
                                  )!.signin_with_email,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ],
                            ),
                    ),
                    const SizedBox(height: 24),

                    // Divider with "or"
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: Theme.of(context).dividerColor,
                            thickness: 1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Text(
                            AppLocalizations.of(context)!.or_text,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: Theme.of(context).dividerColor,
                            thickness: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Sign in with Facebook button
                    OutlinedButton(
                      onPressed: _isLoadingEmail ? null : signInWithFacebook,
                      child: _isLoadingFacebook
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation(
                                  Theme.of(context).primaryColor,
                                ),
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                HugeIcon(
                                  icon: HugeIcons.strokeRoundedFacebook02,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  AppLocalizations.of(
                                    context,
                                  )!.signin_with_facebook,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              // Don't have an account section
              Text(
                AppLocalizations.of(context)!.not_having_an_account,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: (_isLoadingEmail || _isLoadingFacebook)
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => SignUpPage()),
                        );
                      },
                child: Text(
                  AppLocalizations.of(context)!.signup_link,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
