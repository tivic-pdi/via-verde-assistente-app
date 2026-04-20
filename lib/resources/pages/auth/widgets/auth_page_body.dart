import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:guia_digital/app/models/usuario.dart';
import 'package:guia_digital/resources/pages/home/home_page.dart';
import 'package:nylo_framework/nylo_framework.dart';

class AuthPageBody extends StatefulWidget {
  const AuthPageBody({super.key});

  @override
  State<AuthPageBody> createState() => _AuthPageBodyState();
}

class _AuthPageBodyState extends State<AuthPageBody> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _emailFocus = FocusNode();
  final _passFocus = FocusNode();

  bool _obscure = true;
  bool _remember = true;
  bool _loading = false;

  // Paleta "Via Verde" – acessibilidade / mobilidade urbana.
  static const _primary = Color(0xFF16A34A);
  static const _primaryDark = Color(0xFF065F46);

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _emailFocus.dispose();
    _passFocus.dispose();
    super.dispose();
  }

  Future<void> _handleSignIn() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    // Simula latência de rede para dar feedback visual ao usuário.
    await Future.delayed(const Duration(milliseconds: 450));

    final usuario = Usuario(
      nmEmail: _emailCtrl.text.trim(),
      nmSenha: _passCtrl.text,
    );
    await Auth.set(usuario);

    if (!mounted) return;
    setState(() => _loading = false);
    routeTo(HomePage.path);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final bottomSafe = MediaQuery.paddingOf(context).bottom;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [_primaryDark, _primary],
          ),
        ),
        child: Column(
          children: [
            Expanded(child: _buildHero()),
            Flexible(
              fit: FlexFit.loose,
              child: SingleChildScrollView(
                padding: EdgeInsets.only(bottom: bottomInset),
                child: _buildCard(isDark, bottomSafe),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHero() {
    return SafeArea(
      bottom: false,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight - 52,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Semantics(
                    label: 'Logo Guia Digital',
                    child: Container(
                      width: 68,
                      height: 68,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.25),
                          width: 1,
                        ),
                      ),
                      child: const Icon(
                        Icons.accessible_rounded,
                        color: Colors.white,
                        size: 36,
                      ),
                    ),
                  ),
                  const SizedBox(height: 26),
                  const Text(
                    'Bem-vindo ao\nGuia Digital',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Acessibilidade na mobilidade urbana',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.88),
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCard(bool isDark, double bottomSafe) {
    final cardColor = isDark ? const Color(0xFF1F2937) : Colors.white;
    final titleColor = isDark ? Colors.white : const Color(0xFF111827);
    final subtitleColor = isDark ? Colors.white70 : const Color(0xFF6B7280);

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.08),
            blurRadius: 24,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(22, 28, 22, 22 + bottomSafe),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Entrar',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: titleColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Acesse sua conta para continuar',
              style: TextStyle(fontSize: 13.5, color: subtitleColor),
            ),
            const SizedBox(height: 24),
            _ModernField(
              controller: _emailCtrl,
              focusNode: _emailFocus,
              label: 'E-mail',
              hint: 'seu@email.com',
              icon: Icons.mail_outline_rounded,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.email, AutofillHints.username],
              isDark: isDark,
              onSubmitted: (_) => _passFocus.requestFocus(),
              validator: (v) {
                final value = v?.trim() ?? '';
                if (value.isEmpty) return 'Informe seu e-mail';
                final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
                if (!emailRegex.hasMatch(value)) return 'E-mail inválido';
                return null;
              },
            ),
            const SizedBox(height: 14),
            _ModernField(
              controller: _passCtrl,
              focusNode: _passFocus,
              label: 'Senha',
              hint: '••••••••',
              icon: Icons.lock_outline_rounded,
              obscure: _obscure,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.password],
              isDark: isDark,
              onSubmitted: (_) => _handleSignIn(),
              suffix: IconButton(
                tooltip: _obscure ? 'Mostrar senha' : 'Ocultar senha',
                splashRadius: 22,
                icon: Icon(
                  _obscure
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: isDark ? Colors.white70 : const Color(0xFF6B7280),
                ),
                onPressed: () => setState(() => _obscure = !_obscure),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Informe sua senha';
                if (v.length < 4) return 'Mínimo de 4 caracteres';
                return null;
              },
            ),
            const SizedBox(height: 6),
            _buildRememberRow(isDark),
            const SizedBox(height: 14),
            _buildPrimaryButton(),
            const SizedBox(height: 22),
            _buildSignupRow(subtitleColor),
          ],
        ),
      ),
    );
  }

  Widget _buildRememberRow(bool isDark) {
    return Row(
      children: [
        SizedBox(
          height: 24,
          width: 24,
          child: Checkbox(
            value: _remember,
            onChanged: (v) => setState(() => _remember = v ?? false),
            activeColor: _primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            visualDensity: VisualDensity.compact,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          'Lembrar-me',
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF374151),
            fontSize: 13.5,
          ),
        ),
        const Spacer(),
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            foregroundColor: _primary,
            padding: const EdgeInsets.symmetric(horizontal: 6),
            minimumSize: const Size(0, 36),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text(
            'Esqueci minha senha',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _buildPrimaryButton() {
    return SizedBox(
      height: 54,
      child: ElevatedButton(
        onPressed: _loading ? null : _handleSignIn,
        style: ElevatedButton.styleFrom(
          backgroundColor: _primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: _primary.withValues(alpha: 0.6),
          disabledForegroundColor: Colors.white,
          elevation: 0,
          shadowColor: _primary.withValues(alpha: 0.4),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: _loading
              ? const SizedBox(
                  key: ValueKey('loading'),
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.4,
                    color: Colors.white,
                  ),
                )
              : const Row(
                  key: ValueKey('label'),
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Acessar',
                      style: TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward_rounded, size: 20),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildSignupRow(Color subtitleColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Novo por aqui? ',
          style: TextStyle(color: subtitleColor, fontSize: 13.5),
        ),
        InkWell(
          borderRadius: BorderRadius.circular(6),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            child: Text(
              'Criar conta',
              style: TextStyle(
                color: _primary,
                fontWeight: FontWeight.w700,
                fontSize: 13.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ModernField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final String label;
  final String? hint;
  final IconData icon;
  final Widget? suffix;
  final bool obscure;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onSubmitted;
  final Iterable<String>? autofillHints;
  final bool isDark;

  const _ModernField({
    required this.controller,
    required this.label,
    required this.icon,
    required this.isDark,
    this.focusNode,
    this.hint,
    this.suffix,
    this.obscure = false,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.onSubmitted,
    this.autofillHints,
  });

  static const _primary = Color(0xFF16A34A);

  @override
  Widget build(BuildContext context) {
    final fillColor = isDark ? const Color(0xFF111827) : const Color(0xFFF3F4F6);
    final textColor = isDark ? Colors.white : const Color(0xFF111827);
    final hintColor = isDark ? Colors.white54 : const Color(0xFF9CA3AF);
    final iconColor = isDark ? Colors.white70 : const Color(0xFF6B7280);

    OutlineInputBorder border(Color color, {double width = 1}) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: color, width: width),
        );

    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      obscureText: obscure,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onFieldSubmitted: onSubmitted,
      validator: validator,
      autofillHints: autofillHints,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      cursorColor: _primary,
      style: TextStyle(fontSize: 15, color: textColor),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: TextStyle(color: hintColor, fontSize: 14),
        labelStyle: TextStyle(color: iconColor, fontSize: 14),
        floatingLabelStyle: const TextStyle(
          color: _primary,
          fontWeight: FontWeight.w600,
        ),
        filled: true,
        fillColor: fillColor,
        prefixIcon: Icon(icon, color: iconColor, size: 22),
        suffixIcon: suffix,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: border(Colors.transparent),
        enabledBorder: border(Colors.transparent),
        focusedBorder: border(_primary, width: 1.6),
        errorBorder: border(const Color(0xFFEF4444), width: 1.2),
        focusedErrorBorder: border(const Color(0xFFEF4444), width: 1.6),
        errorStyle: const TextStyle(fontSize: 12, height: 1.1),
      ),
    );
  }
}
