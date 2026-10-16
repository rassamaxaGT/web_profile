import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/neomorphic_theme.dart';
import 'neomorphic_button.dart';

class AbsurdCaptchaDialog extends StatefulWidget {
  final String projectTitle;

  const AbsurdCaptchaDialog({super.key, required this.projectTitle});

  @override
  State<AbsurdCaptchaDialog> createState() => _AbsurdCaptchaDialogState();
}

class _AbsurdCaptchaDialogState extends State<AbsurdCaptchaDialog> {
  int _currentAge = 25;
  bool _isSpinning = true;
  String _message = 'Нажмите «Зафиксировать», чтобы подтвердить диапазон:';
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startSpin();
  }

  void _startSpin() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (_isSpinning) {
        setState(() {
          _currentAge = Random().nextInt(99) + 1;
        });
      }
    });
  }

  void _stopSpin() {
    setState(() {
      _isSpinning = false;
      if (_currentAge < 18) {
        _message = 'Значение $_currentAge: стаж ниже допустимого порога безопасности.';
      } else if (_currentAge > 75) {
        _message = 'Значение $_currentAge: превышен лимит устаревания сессии.';
      } else {
        _message = 'Хеш сессии $_currentAge принят. Документация «${widget.projectTitle}» доступна.';
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(26),
        decoration: BoxDecoration(
          color: NeoColors.surface,
          borderRadius: BorderRadius.circular(NeoRadius.xl),
          boxShadow: NeoShadows.raisedLg(),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Верификация сессии инженера',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: NeoColors.textPrimary,
              ),
            ),
            const SizedBox(height: NeoSpacing.xs),
            Text(
              'Для загрузки архитектурной спецификации «${widget.projectTitle}» подтвердите энтропийный ключ:',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: NeoColors.textSecondary),
            ),
            const SizedBox(height: NeoSpacing.lg),

            // Барабан с числом
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: NeoColors.surface,
                shape: BoxShape.circle,
                boxShadow: NeoShadows.raisedMd(),
              ),
              child: Center(
                child: Text(
                  '$_currentAge',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: _isSpinning ? NeoColors.lavenderDark : NeoColors.sageDark,
                  ),
                ),
              ),
            ),
            const SizedBox(height: NeoSpacing.md),

            Text(
              _message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: NeoColors.textPrimary,
              ),
            ),
            const SizedBox(height: NeoSpacing.lg),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_isSpinning)
                  NeomorphicButton(
                    text: 'Зафиксировать',
                    accentColor: NeoColors.lavender,
                    textColor: NeoColors.lavenderDark,
                    height: 40,
                    onPressed: _stopSpin,
                  )
                else ...[
                  NeomorphicButton(
                    text: 'Сбросить',
                    height: 40,
                    onPressed: () {
                      setState(() {
                        _isSpinning = true;
                        _message = 'Нажмите «Зафиксировать», чтобы подтвердить диапазон:';
                      });
                      _startSpin();
                    },
                  ),
                  const SizedBox(width: 12),
                  NeomorphicButton(
                    text: 'Закрыть',
                    accentColor: NeoColors.sage,
                    textColor: NeoColors.sageDark,
                    height: 40,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
