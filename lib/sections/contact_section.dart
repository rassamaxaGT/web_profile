import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/neomorphic_theme.dart';
import '../widgets/neomorphic_badge.dart';
import '../widgets/neomorphic_button.dart';
import '../widgets/neomorphic_card.dart';
import '../widgets/neomorphic_input.dart';

class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  final List<String> _topics = [
    'Flutter разработка',
    'Веб-приложение',
    'Дизайн-система',
    'Аудит кода',
  ];
  final Set<int> _selectedTopics = {0};
  bool _isSubmitting = false;
  bool _jupiterConsent = true;
  double _submitOffset = 0.0;
  int _chaseCount = 0;

  void _fleeSubmit() {
    setState(() {
      _chaseCount++;
      if (_chaseCount < 4) {
        _submitOffset = Random().nextBool() ? 60.0 : -60.0;
      } else {
        _submitOffset = 0.0; // Сдался
      }
    });
  }

  void _submitForm() async {
    if (!_jupiterConsent) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: NeoColors.surface,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          content: const Text(
            'Без согласия на расчёт орбиты Юпитера отправка невозможна.',
            style: TextStyle(color: NeoColors.roseDark, fontWeight: FontWeight.w600),
          ),
        ),
      );
      return;
    }

    if (_nameController.text.trim().isEmpty || _emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: NeoColors.surface,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          content: const Text(
            'Пожалуйста, укажите имя и контактный email.',
            style: TextStyle(color: NeoColors.roseDark, fontWeight: FontWeight.w600),
          ),
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(milliseconds: 1000));
    if (!mounted) return;
    setState(() => _isSubmitting = false);

    _nameController.clear();
    _emailController.clear();
    _messageController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: NeoColors.surface,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        content: const Text(
          'Сообщение отправлено. Ответ поступит на указанный адрес.',
          style: TextStyle(color: NeoColors.sageDark, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 900;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 64.0 : 20.0,
        vertical: 40.0,
      ),
      child: Column(
        children: [
          const NeomorphicBadge(
            text: 'Контакты',
            pastelColor: NeoColors.sage,
            textColor: NeoColors.sageDark,
          ),
          const SizedBox(height: NeoSpacing.md),
          Text(
            'Связаться для сотрудничества',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isDesktop ? 34 : 24,
              fontWeight: FontWeight.w800,
              color: NeoColors.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: NeoSpacing.xs),
          const Text(
            'Отвечаю на вопросы по архитектуре, разработке приложений и дизайн-систем',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: NeoColors.textSecondary,
            ),
          ),
          const SizedBox(height: NeoSpacing.xl),

          NeomorphicCard(
            width: double.infinity,
            padding: EdgeInsets.all(isDesktop ? 36 : 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Направление задачи',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: NeoColors.textPrimary,
                  ),
                ),
                const SizedBox(height: NeoSpacing.sm),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: List.generate(_topics.length, (i) {
                    final isSel = _selectedTopics.contains(i);
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSel) {
                            if (_selectedTopics.length > 1) _selectedTopics.remove(i);
                          } else {
                            _selectedTopics.add(i);
                          }
                        });
                      },
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 140),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                          decoration: BoxDecoration(
                            color: isSel
                                ? NeoColors.sage.withValues(alpha: 0.6)
                                : NeoColors.surface,
                            borderRadius: BorderRadius.circular(NeoRadius.full),
                            boxShadow: isSel
                                ? [
                                    BoxShadow(
                                      color: NeoColors.shadowDark.withValues(alpha: 0.35),
                                      offset: const Offset(1, 1),
                                      blurRadius: 2,
                                    ),
                                  ]
                                : NeoShadows.raisedSm(),
                          ),
                          child: Text(
                            _topics[i],
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                              color: isSel ? NeoColors.sageDark : NeoColors.textPrimary,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: NeoSpacing.xl),

                // Поля формы
                LayoutBuilder(
                  builder: (context, constraints) {
                    if (isDesktop) {
                      return Row(
                        children: [
                          Expanded(
                            child: NeomorphicInput(
                              controller: _nameController,
                              labelText: 'Имя',
                              hintText: 'Richard',
                            ),
                          ),
                          const SizedBox(width: NeoSpacing.lg),
                          Expanded(
                            child: NeomorphicInput(
                              controller: _emailController,
                              labelText: 'Email для ответа',
                              hintText: 'richard@brook.dev',
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Column(
                        children: [
                          NeomorphicInput(
                            controller: _nameController,
                            labelText: 'Имя',
                            hintText: 'Richard',
                          ),
                          const SizedBox(height: NeoSpacing.md),
                          NeomorphicInput(
                            controller: _emailController,
                            labelText: 'Email для ответа',
                            hintText: 'richard@brook.dev',
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ],
                      );
                    }
                  },
                ),
                const SizedBox(height: NeoSpacing.lg),

                NeomorphicInput(
                  controller: _messageController,
                  labelText: 'Описание проекта или вопроса',
                  hintText: 'Кратко опишите стек, цели или приложите ссылку на репозиторий...',
                  maxLines: 4,
                ),
                const SizedBox(height: NeoSpacing.md),

                // Абсурдный чекбокс Юпитера
                Row(
                  children: [
                    Checkbox(
                      value: _jupiterConsent,
                      activeColor: NeoColors.sageDark,
                      onChanged: (val) {
                        setState(() {
                          _jupiterConsent = val ?? false;
                          if (!_jupiterConsent) {
                            _nameController.clear();
                            _emailController.clear();
                            _messageController.clear();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: NeoColors.surface,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                content: const Text(
                                  'Вы отозвали согласие на расчёт орбиты Юпитера. Поля формы сброшены.',
                                  style: TextStyle(color: NeoColors.roseDark, fontWeight: FontWeight.w600),
                                ),
                              ),
                            );
                          }
                        });
                      },
                    ),
                    const Expanded(
                      child: Text(
                        'Согласен на обработку персональных данных и выделение 10% ресурсов CPU на расчёт траектории Юпитера',
                        style: TextStyle(fontSize: 11, color: NeoColors.textSecondary),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: NeoSpacing.lg),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Конфиденциально • Ответ в течение рабочего дня',
                      style: TextStyle(
                        fontSize: 12,
                        color: NeoColors.textTertiary,
                      ),
                    ),

                    // Убегающая кнопка отправки
                    MouseRegion(
                      onEnter: (_) => _fleeSubmit(),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 140),
                        curve: Curves.easeOutBack,
                        transform: Matrix4.translationValues(_submitOffset, 0.0, 0.0),
                        child: NeomorphicButton(
                          text: _chaseCount < 4 && _chaseCount > 0 ? 'Не поймал!' : 'Отправить',
                          accentColor: NeoColors.sage,
                          textColor: NeoColors.sageDark,
                          isLoading: _isSubmitting,
                          onPressed: _submitForm,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
