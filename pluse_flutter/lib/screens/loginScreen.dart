import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:the_responsive_builder/the_responsive_builder.dart';

enum AuthMode { signup, login }

class LoginPayload {
  final String email;
  final String password;
  final bool rememberMe;

  const LoginPayload({
    required this.email,
    required this.password,
    required this.rememberMe,
  });
}

class SignupPayload {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final bool agreeTerms;

  const SignupPayload({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.agreeTerms,
  });
}

class AuthContent extends StatefulWidget {
  const AuthContent({
    super.key,
    required this.mode,
    required this.onModeChanged,
    required this.onBack,
    required this.onGoogleTap,
    required this.onLogin,
    required this.onSignup,
  });

  final AuthMode mode;
  final ValueChanged<AuthMode> onModeChanged;
  final VoidCallback onBack;
  final Future<void> Function() onGoogleTap;
  final Future<void> Function(LoginPayload payload) onLogin;
  final Future<void> Function(SignupPayload payload) onSignup;

  @override
  State<AuthContent> createState() => _AuthContentState();
}

class _AuthContentState extends State<AuthContent> {
  final _loginFormKey = GlobalKey<FormState>();
  final _signupFormKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _signupEmailController = TextEditingController();
  final _signupPasswordController = TextEditingController();

  final _loginEmailController = TextEditingController();
  final _loginPasswordController = TextEditingController();

  bool _rememberMe = false;
  bool _agreeTerms = false;
  bool _signupObscure = true;
  bool _loginObscure = true;
  bool _busy = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _signupEmailController.dispose();
    _signupPasswordController.dispose();
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submitLogin() async {
    if (!_loginFormKey.currentState!.validate()) return;

    setState(() => _busy = true);
    try {
      await widget.onLogin(
        LoginPayload(
          email: _loginEmailController.text.trim(),
          password: _loginPasswordController.text.trim(),
          rememberMe: _rememberMe,
        ),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _submitSignup() async {
    if (!_signupFormKey.currentState!.validate()) return;
    if (!_agreeTerms) return;

    setState(() => _busy = true);
    try {
      await widget.onSignup(
        SignupPayload(
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          email: _signupEmailController.text.trim(),
          password: _signupPasswordController.text.trim(),
          agreeTerms: _agreeTerms,
        ),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: widget.onBack,
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  color: Colors.black87,
                ),
              ).animate().fadeIn(duration: 250.ms).slideX(begin: -0.2),

              SizedBox(height: 1.h),

              Container(
                width: 88.w,
                constraints: const BoxConstraints(maxWidth: 420),
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.92),
                  borderRadius: BorderRadius.circular(26),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.10),
                      blurRadius: 26,
                      offset: const Offset(0, 14),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const _BrandHeader(),
                    SizedBox(height: 2.4.h),
                    Text(
                      'Get started now',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: Colors.black,
                          ),
                    ),
                    SizedBox(height: 0.8.h),
                    Text(
                      'Create an account or log in to explore the app',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11.5.sp,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    _ModeSwitcher(
                      mode: widget.mode,
                      onModeChanged: widget.onModeChanged,
                    ),
                    SizedBox(height: 2.h),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 420),
                      transitionBuilder: (child, animation) {
                        final slide = Tween<Offset>(
                          begin: const Offset(0.08, 0),
                          end: Offset.zero,
                        ).animate(animation);

                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: slide,
                            child: child,
                          ),
                        );
                      },
                      child: widget.mode == AuthMode.signup
                          ? _SignupForm(
                              key: const ValueKey('signup_form'),
                              formKey: _signupFormKey,
                              firstNameController: _firstNameController,
                              lastNameController: _lastNameController,
                              emailController: _signupEmailController,
                              passwordController: _signupPasswordController,
                              obscure: _signupObscure,
                              agreeTerms: _agreeTerms,
                              busy: _busy,
                              onToggleObscure: () {
                                setState(() => _signupObscure = !_signupObscure);
                              },
                              onAgreeChanged: (value) {
                                setState(() => _agreeTerms = value ?? false);
                              },
                              onSubmit: _submitSignup,
                              onGoogleTap: widget.onGoogleTap,
                            )
                          : _LoginForm(
                              key: const ValueKey('login_form'),
                              formKey: _loginFormKey,
                              emailController: _loginEmailController,
                              passwordController: _loginPasswordController,
                              obscure: _loginObscure,
                              rememberMe: _rememberMe,
                              busy: _busy,
                              onToggleObscure: () {
                                setState(() => _loginObscure = !_loginObscure);
                              },
                              onRememberChanged: (value) {
                                setState(() => _rememberMe = value ?? false);
                              },
                              onSubmit: _submitLogin,
                              onGoogleTap: widget.onGoogleTap,
                            ),
                    ),
                  ],
                ),
              )
                  .animate()
                  .fadeIn(duration: 350.ms)
                  .slideY(begin: 0.08, duration: 450.ms, curve: Curves.easeOutCubic),
            ],
          ),
        ),
      ),
    );
  }
}

class _BrandHeader extends StatelessWidget {
  const _BrandHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Icon(
          Icons.play_circle_outline_rounded,
          color: Color(0xFFD88A2B),
          size: 28,
        ),
        SizedBox(height: 0.4.h),
        Text(
          'Saddle',
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w800,
            color: const Color(0xFFD88A2B),
          ),
        ),
      ],
    );
  }
}

class _ModeSwitcher extends StatelessWidget {
  const _ModeSwitcher({
    required this.mode,
    required this.onModeChanged,
  });

  final AuthMode mode;
  final ValueChanged<AuthMode> onModeChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F0DE),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: _ModeTab(
              title: 'Sign up',
              active: mode == AuthMode.signup,
              onTap: () => onModeChanged(AuthMode.signup),
            ),
          ),
          Expanded(
            child: _ModeTab(
              title: 'Login',
              active: mode == AuthMode.login,
              onTap: () => onModeChanged(AuthMode.login),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModeTab extends StatelessWidget {
  const _ModeTab({
    required this.title,
    required this.active,
    required this.onTap,
  });

  final String title;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOut,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: active
              ? Border.all(color: const Color(0xFFF1D19A))
              : Border.all(color: Colors.transparent),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: active ? const Color(0xFFD88A2B) : Colors.black87,
          ),
        ),
      ),
    );
  }
}

class _SignupForm extends StatelessWidget {
  const _SignupForm({
    super.key,
    required this.formKey,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.passwordController,
    required this.obscure,
    required this.agreeTerms,
    required this.busy,
    required this.onToggleObscure,
    required this.onAgreeChanged,
    required this.onSubmit,
    required this.onGoogleTap,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscure;
  final bool agreeTerms;
  final bool busy;
  final VoidCallback onToggleObscure;
  final ValueChanged<bool?> onAgreeChanged;
  final VoidCallback onSubmit;
  final Future<void> Function() onGoogleTap;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _AppTextField(
                  label: 'First Name',
                  hint: 'First name',
                  controller: firstNameController,
                  validator: _requiredValidator,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _AppTextField(
                  label: 'Last Name',
                  hint: 'Last name',
                  controller: lastNameController,
                  validator: _requiredValidator,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.6.h),
          _AppTextField(
            label: 'Email Address',
            hint: 'Please enter your email',
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            suffixIcon: Icons.mail_outline_rounded,
            validator: _emailValidator,
          ),
          SizedBox(height: 1.6.h),
          _AppTextField(
            label: 'Password',
            hint: 'Password',
            controller: passwordController,
            obscureText: obscure,
            suffixIcon: obscure
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            onSuffixTap: onToggleObscure,
            validator: _passwordValidator,
          ),
          SizedBox(height: 0.8.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: agreeTerms,
                onChanged: onAgreeChanged,
                activeColor: const Color(0xFFD88A2B),
                side: const BorderSide(color: Colors.black26),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 11),
                  child: Text(
                    'By continuing you accept our Privacy Policy and Terms & Conditions',
                    style: TextStyle(
                      fontSize: 10.7.sp,
                      color: Colors.black54,
                      height: 1.4,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.2.h),
          _GradientActionButton(
            title: busy ? 'Please wait...' : 'Sign Up',
            onTap: busy ? null : onSubmit,
          ),
          SizedBox(height: 1.8.h),
          const _OrDivider(),
          SizedBox(height: 1.8.h),
          _SocialButton(
            icon: Icons.g_mobiledata_rounded,
            title: 'Continue with Google',
            onTap: busy ? null : () => onGoogleTap(),
          ),
        ],
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.obscure,
    required this.rememberMe,
    required this.busy,
    required this.onToggleObscure,
    required this.onRememberChanged,
    required this.onSubmit,
    required this.onGoogleTap,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscure;
  final bool rememberMe;
  final bool busy;
  final VoidCallback onToggleObscure;
  final ValueChanged<bool?> onRememberChanged;
  final VoidCallback onSubmit;
  final Future<void> Function() onGoogleTap;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          _AppTextField(
            label: 'Email Address',
            hint: 'Please enter your email',
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            suffixIcon: Icons.mail_outline_rounded,
            validator: _emailValidator,
          ),
          SizedBox(height: 1.6.h),
          _AppTextField(
            label: 'Password',
            hint: 'Password',
            controller: passwordController,
            obscureText: obscure,
            suffixIcon: obscure
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            onSuffixTap: onToggleObscure,
            validator: _passwordValidator,
          ),
          SizedBox(height: 0.7.h),
          Row(
            children: [
              Row(
                children: [
                  Checkbox(
                    value: rememberMe,
                    onChanged: onRememberChanged,
                    activeColor: const Color(0xFFD88A2B),
                    side: const BorderSide(color: Colors.black26),
                  ),
                  Text(
                    'Remember me',
                    style: TextStyle(
                      fontSize: 11.4.sp,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                'Forgot Password ?',
                style: TextStyle(
                  fontSize: 11.4.sp,
                  color: const Color(0xFFD88A2B),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.2.h),
          _GradientActionButton(
            title: busy ? 'Please wait...' : 'Login',
            onTap: busy ? null : onSubmit,
          ),
          SizedBox(height: 1.8.h),
          const _OrDivider(),
          SizedBox(height: 1.8.h),
          _SocialButton(
            icon: Icons.g_mobiledata_rounded,
            title: 'Continue with Google',
            onTap: busy ? null : () => onGoogleTap(),
          ),
        ],
      ),
    );
  }
}

class _AppTextField extends StatelessWidget {
  const _AppTextField({
    required this.label,
    required this.hint,
    required this.controller,
    this.validator,
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
    this.onSuffixTap,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool obscureText;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11.8.sp,
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 0.7.h),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          obscureText: obscureText,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.black38,
              fontSize: 12.5.sp,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 15,
            ),
            suffixIcon: suffixIcon == null
                ? null
                : GestureDetector(
                    onTap: onSuffixTap,
                    child: Icon(
                      suffixIcon,
                      size: 18,
                      color: Colors.black38,
                    ),
                  ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.black.withOpacity(0.08)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color(0xFFD88A2B),
                width: 1.2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.redAccent),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.redAccent),
            ),
          ),
        ),
      ],
    );
  }
}

class _GradientActionButton extends StatelessWidget {
  const _GradientActionButton({
    required this.title,
    required this.onTap,
  });

  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: onTap == null ? 0.6 : 1,
        child: Container(
          height: 54,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: const LinearGradient(
              colors: [
                Color(0xFFFFA726),
                Color(0xFFFF7043),
                Color(0xFFFF5E8A),
              ],
            ),
          ),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black.withOpacity(0.08)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.red),
            SizedBox(width: 2.5.w),
            Text(
              title,
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.black.withOpacity(0.10))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text(
            'Or',
            style: TextStyle(
              color: Colors.black45,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(child: Divider(color: Colors.black.withOpacity(0.10))),
      ],
    );
  }
}

String? _requiredValidator(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Required';
  }
  return null;
}

String? _emailValidator(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Email is required';
  }
  final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  if (!emailRegex.hasMatch(value.trim())) {
    return 'Enter a valid email';
  }
  return null;
}

String? _passwordValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Password is required';
  }
  if (value.length < 6) {
    return 'Minimum 6 characters';
  }
  return null;
}