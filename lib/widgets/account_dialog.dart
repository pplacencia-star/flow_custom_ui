import 'package:flutter/material.dart';

import '../core/app_theme.dart';

class AccountDialog extends StatelessWidget {
  const AccountDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.phoneBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: const BorderSide(color: Color(0x5C6B4B88)),
      ),
      child: Container(
        padding: const EdgeInsets.all(22),
        constraints: const BoxConstraints(maxWidth: 490),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Workspace Account',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF241831),
                minimumSize: const Size(double.infinity, 45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(11),
                  side: const BorderSide(color: Color(0x12FFFFFF)),
                ),
              ),
              onPressed: () {},
              child: const Text(
                'Continuar con Google',
                style: TextStyle(color: Color(0xFFAD98E2)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
