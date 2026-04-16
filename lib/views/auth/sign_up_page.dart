import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:zuvo/l10n/app_localizations.dart';
import 'package:zuvo/services/auth_service.dart';
import 'package:zuvo/util/toast_notification.dart';
import 'package:zuvo/views/dashboard_page.dart';
import 'package:zuvo/views/auth/sign_in_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoadingEmail = false;
  bool _isLoadingFacebook = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  Future<void> signUpWithEmail() async {
    if (_formKey.currentState!.validate()) {
      if (passwordController.text != confirmPasswordController.text) {
        ToastNotification.showError(
          context,
          title: 'Error',
          description: 'Passwords do not match',
        );
        return;
      }

      setState(() => _isLoadingEmail = true);

      try {
        String username = usernameController.text.trim();
        String email = emailController.text.trim();
        String password = passwordController.text.trim();

        await _authService.signUpWithEmail(
          email: email,
          password: password,
          username: username,
        );

        if (mounted) {
          ToastNotification.showSuccess(
            context,
            title: 'Success',
            description: 'Account created successfully!',
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
            title: 'Sign Up Failed',
            description: e.toString().replaceFirst('Exception: ', ''),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoadingEmail = false);
        }
      }
    }
  }

  Future<void> signUpWithFacebook() async {
    setState(() => _isLoadingFacebook = true);

    try {
      await _authService.signUpWithFacebook();

      if (mounted) {
        ToastNotification.showSuccess(
          context,
          title: 'Success',
          description: 'Signed up with Facebook successfully!',
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
          title: 'Facebook Sign Up Failed',
          description: e.toString().replaceFirst('Exception: ', ''),
        );
        print(e.toString().replaceFirst('Exception: ', ''));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoadingFacebook = false);
      }
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 25),
              // Logo at the top center
              Center(
                child: Text(
                  AppLocalizations.of(context)!.app_name,
                  style: Theme.of(context).textTheme.displayLarge,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                AppLocalizations.of(context)!.welcome_text,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Username TextField
                    TextFormField(
                      controller: usernameController,
                      enabled: !_isLoadingEmail && !_isLoadingFacebook,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(
                          context,
                        )!.username_hintext,
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(left: 16.0),
                          child: HugeIcon(
                            icon: HugeIcons.strokeRoundedUser02,
                            size: 20,
                          ),
                        ),
                      ),
                      validator: ValidationBuilder()
                          .required()
                          .minLength(3)
                          .maxLength(20)
                          .build(),
                    ),
                    const SizedBox(height: 10),

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
                      validator: ValidationBuilder()
                          .required()
                          .email()
                          .maxLength(50)
                          .build(),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 10),

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
                          .maxLength(100)
                          .build(),
                    ),
                    const SizedBox(height: 10),

                    // Confirm Password TextField
                    TextFormField(
                      controller: confirmPasswordController,
                      enabled: !_isLoadingEmail && !_isLoadingFacebook,
                      obscureText: _obscureConfirmPassword,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(
                          context,
                        )!.confirm_password_hintext,
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
                              () => _obscureConfirmPassword =
                                  !_obscureConfirmPassword,
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 14.0),
                            child: HugeIcon(
                              icon: _obscureConfirmPassword
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
                          .maxLength(100)
                          .build(),
                    ),
                    const SizedBox(height: 24),

                    // Sign up with email button
                    ElevatedButton(
                      onPressed: _isLoadingFacebook ? null : signUpWithEmail,
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
                                  )!.signup_with_email,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ],
                            ),
                    ),
                    const SizedBox(height: 20),

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
                          padding: const EdgeInsets.symmetric(horizontal: 12),
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
                    const SizedBox(height: 20),

                    // Sign up with Facebook button
                    OutlinedButton(
                      onPressed: _isLoadingEmail ? null : signUpWithFacebook,
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
                                  )!.signup_with_facebook,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Already have account section
              Text(
                AppLocalizations.of(context)!.already_have_an_account,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: (_isLoadingEmail || _isLoadingFacebook)
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => SignInPage()),
                        );
                      },
                child: Text(
                  AppLocalizations.of(context)!.signin_link,
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
