import 'package:flutter/material.dart';
import '../theme/neomorphic_theme.dart';
import 'neomorphic_button.dart';
import 'neomorphic_card.dart';

class VitaliyChatBot extends StatefulWidget {
  final Widget? underButton;

  const VitaliyChatBot({
    super.key,
    this.underButton,
  });

  @override
  State<VitaliyChatBot> createState() => _VitaliyChatBotState();
}

class _VitaliyChatBotState extends State<VitaliyChatBot> {
  bool _isOpen = false;
  bool _isButtonLifted = false;
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [
    {'from': 'vitaliy', 'text': 'Здравствуйте. Готов ответить на технические вопросы по коду.'},
  ];
  bool _isTyping = false;

  void _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({'from': 'user', 'text': text});
      _isTyping = true;
    });
    _controller.clear();

    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    setState(() {
      _isTyping = false;
      _messages.add({'from': 'vitaliy', 'text': 'Понятно.'});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 24,
      right: 24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (_isOpen)
            Container(
              width: 310,
              height: 360,
              margin: const EdgeInsets.only(bottom: 12),
              child: NeomorphicCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: NeoColors.sageDark,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Ассистент разработчика',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: NeoColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () => setState(() => _isOpen = false),
                          child: const Icon(Icons.close_rounded, size: 16, color: NeoColors.textSecondary),
                        ),
                      ],
                    ),
                    const Divider(color: NeoColors.surfaceAlt, height: 16),

                    // Сообщения
                    Expanded(
                      child: ListView.builder(
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          final msg = _messages[index];
                          final isUser = msg['from'] == 'user';
                          return Align(
                            alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: isUser ? NeoColors.lavender.withValues(alpha: 0.5) : NeoColors.surfaceAlt,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                msg['text']!,
                                style: const TextStyle(fontSize: 12, color: NeoColors.textPrimary),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    if (_isTyping)
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                            'Ассистент печатает ответ...',
                            style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: NeoColors.textTertiary),
                          ),
                        ),
                      ),

                    // Поле ввода
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            style: const TextStyle(fontSize: 12),
                            decoration: const InputDecoration(
                              hintText: 'Задайте вопрос по проекту...',
                              isDense: true,
                              border: InputBorder.none,
                            ),
                            onSubmitted: (_) => _sendMessage(),
                          ),
                        ),
                        GestureDetector(
                          onTap: _sendMessage,
                          child: const Icon(Icons.send_rounded, size: 16, color: NeoColors.lavenderDark),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

          // Кнопка поддержки, под которой прячется строительный уровень
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomRight,
            children: [
              // Спрятанный под кнопкой уровень
              if (widget.underButton != null)
                Positioned(
                  bottom: 2,
                  right: 4,
                  child: widget.underButton!,
                ),

              // Сама кнопка, которая приподнимается при наведении
              MouseRegion(
                onEnter: (_) => setState(() => _isButtonLifted = true),
                onExit: (_) => setState(() => _isButtonLifted = false),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOutBack,
                  transform: Matrix4.translationValues(0, _isButtonLifted ? -36.0 : 0.0, 0),
                  child: NeomorphicButton(
                    text: _isOpen ? 'Свернуть' : 'Связаться онлайн',
                    height: 38,
                    onPressed: () => setState(() => _isOpen = !_isOpen),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
