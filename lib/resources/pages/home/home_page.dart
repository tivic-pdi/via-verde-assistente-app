import 'package:flutter/material.dart';
import 'package:guia_digital/resources/pages/auth/auth_page.dart';
import 'package:guia_digital/resources/pages/home/widgets/camera.widget.dart';
import 'package:nylo_framework/nylo_framework.dart';

import '/app/controllers/home_controller.dart';

class HomePage extends NyPage<HomeController> {
  static String path = '/home';

  HomePage() : super(path);

  @override
  init() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox.expand(
        child: Stack(
          fit: StackFit.expand,
          children: [
            const CameraPreviewWidget(),
            Positioned(
              top: 0,
              right: 0,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: _LogoutButton(onConfirmed: () => _handleLogout(context)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleLogout(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text('Sair da conta'),
        content: const Text('Deseja realmente encerrar a sessão?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF16A34A),
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Sair'),
          ),
        ],
      ),
    );

    if (shouldLogout != true) return;

    await Auth.logout();
    if (!context.mounted) return;
    routeTo(AuthPage.path);
  }

  bool get isThemeDark =>
      ThemeProvider.controllerOf(context).currentThemeId ==
      getEnv('DARK_THEME_ID');
}

class _LogoutButton extends StatelessWidget {
  final VoidCallback onConfirmed;

  const _LogoutButton({required this.onConfirmed});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Sair da conta',
      button: true,
      child: Material(
        color: Colors.black.withValues(alpha: 0.45),
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onConfirmed,
          customBorder: const CircleBorder(),
          child: Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.25),
                width: 1,
              ),
            ),
            child: const Icon(
              Icons.logout_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
        ),
      ),
    );
  }
}
