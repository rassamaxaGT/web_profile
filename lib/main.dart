import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'sections/contact_section.dart';
import 'sections/footer_section.dart';
import 'sections/header_section.dart';
import 'sections/hero_section.dart';
import 'sections/playground_section.dart';
import 'sections/projects_section.dart';
import 'sections/skills_section.dart';
import 'theme/neomorphic_theme.dart';
import 'widgets/neomorphic_button.dart';
import 'widgets/passive_telemetry_hud.dart';
import 'widgets/vitaliy_chat_bot.dart';

void main() {
  runApp(const DevPortfolioApp());
}

class DevPortfolioApp extends StatelessWidget {
  const DevPortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alexandr R. • Flutter & Frontend Portfolio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: NeoColors.surface,
        colorScheme: ColorScheme.fromSeed(
          seedColor: NeoColors.lavenderDark,
          surface: NeoColors.surface,
          primary: NeoColors.lavenderDark,
          secondary: NeoColors.sageDark,
          error: NeoColors.roseDark,
        ),
        fontFamily: 'sans-serif',
      ),
      home: const PortfolioHomePage(),
    );
  }
}

class PortfolioHomePage extends StatefulWidget {
  const PortfolioHomePage({super.key});

  @override
  State<PortfolioHomePage> createState() => _PortfolioHomePageState();
}

class _PortfolioHomePageState extends State<PortfolioHomePage> {
  final ScrollController _scrollController = ScrollController();

  final GlobalKey _heroKey = GlobalKey();
  final GlobalKey _skillsKey = GlobalKey();
  final GlobalKey _projectsKey = GlobalKey();
  final GlobalKey _labKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  double _pageTurns = 0.0;
  bool _isFlashlight = false;
  Offset _cursorPos = const Offset(200, 200);
  Timer? _errorDialogTimer;

  // Пассивные интерактивные переменные
  bool _isHeroFallen = false;
  DateTime _lastMouseMove = DateTime.now();
  Offset _lastPos = Offset.zero;
  double _mouseSpeed = 0.0;
  bool _isOverspeed = false;
  bool _isSleeping = false;
  Timer? _inactivityTimer;

  @override
  void initState() {
    super.initState();
    // Запуск таймера ошибки через 12 секунд после захода на страницу
    _scheduleErrorDialog(seconds: 12);
    _scrollController.addListener(_handleScroll);
    _resetInactivityTimer();
  }

  void _handleScroll() {
    final fallen = _scrollController.hasClients && _scrollController.offset > 25;
    if (fallen != _isHeroFallen) {
      setState(() => _isHeroFallen = fallen);
    }
  }

  void _onMouseHover(PointerHoverEvent event) {
    final now = DateTime.now();
    final dt = now.difference(_lastMouseMove).inMilliseconds;
    if (dt > 15) {
      final dist = (event.position - _lastPos).distance;
      final speed = (dist / dt) * 1000.0;
      _mouseSpeed = speed;
      _lastMouseMove = now;
      _lastPos = event.position;
      final overspeed = speed > 1350.0;

      if (overspeed != _isOverspeed || _isSleeping || _isFlashlight) {
        setState(() {
          _cursorPos = event.position;
          _isOverspeed = overspeed;
          _isSleeping = false;
        });
      } else {
        _cursorPos = event.position;
      }
      _resetInactivityTimer();
    }
  }

  void _resetInactivityTimer() {
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(const Duration(seconds: 9), () {
      if (mounted) setState(() => _isSleeping = true);
    });
  }

  void _scheduleErrorDialog({int seconds = 25}) {
    _errorDialogTimer?.cancel();
    _errorDialogTimer = Timer(Duration(seconds: seconds), () {
      if (mounted) _showErrorReloadDialog();
    });
  }

  void _showErrorReloadDialog() {
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: true, // Позволяет закрыть кликом по фону
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 440),
            padding: const EdgeInsets.all(26),
            decoration: BoxDecoration(
              color: NeoColors.surface,
              borderRadius: BorderRadius.circular(NeoRadius.xl),
              boxShadow: NeoShadows.raisedLg(),
            ),
            child: Stack(
              children: [
                // Крестик закрытия в углу
                Positioned(
                  top: 0,
                  right: 0,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(dialogContext).pop();
                        _scheduleErrorDialog(seconds: 40);
                      },
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: NeoColors.surface,
                          shape: BoxShape.circle,
                          boxShadow: NeoShadows.raisedSm(),
                        ),
                        child: const Icon(
                          Icons.close_rounded,
                          size: 16,
                          color: NeoColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ),

                // Основное содержимое
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: NeoColors.surface,
                        shape: BoxShape.circle,
                        boxShadow: NeoShadows.raisedSm(),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.error_outline_rounded,
                          size: 24,
                          color: NeoColors.roseDark,
                        ),
                      ),
                    ),
                    const SizedBox(height: NeoSpacing.md),
                    const Text(
                      'Сбой графического конвейера',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: NeoColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: NeoSpacing.sm),
                    const Text(
                      'На странице зафиксирована ошибка рассинхронизации неоморфных теней. Для восстановления калибровки рекомендуется перезагрузка.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.45,
                        color: NeoColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: NeoSpacing.md),

                    // Приписка о возможности закрыть
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: NeoColors.surfaceAlt,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'Примечание: Вы можете просто закрыть это окно и продолжить просмотр на свой страх и риск. Однако стабильность геометрии и ортогональность экрана не гарантируются.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11,
                          height: 1.4,
                          color: NeoColors.textSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(height: NeoSpacing.lg),

                    // Кнопки действий
                    Wrap(
                      spacing: 12,
                      runSpacing: 10,
                      alignment: WrapAlignment.center,
                      children: [
                        NeomorphicButton(
                          text: 'Игнорировать и закрыть',
                          height: 42,
                          onPressed: () {
                            Navigator.of(dialogContext).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: NeoColors.surface,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                content: const Text(
                                  'Сбой проигнорирован. Режим работы «на свой страх и риск» активен.',
                                  style: TextStyle(color: NeoColors.textPrimary, fontWeight: FontWeight.w600),
                                ),
                              ),
                            );
                            _scheduleErrorDialog(seconds: 45);
                          },
                        ),
                        NeomorphicButton(
                          text: 'Перезагрузить страницу',
                          icon: Icons.refresh_rounded,
                          accentColor: NeoColors.lavender,
                          textColor: NeoColors.lavenderDark,
                          height: 42,
                          onPressed: () {
                            Navigator.of(dialogContext).pop();
                            _rotatePage(); // Вращение страницы на 90 градусов!
                            _scheduleErrorDialog(seconds: 35);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _rotatePage() {
    setState(() {
      _pageTurns += 0.25; // +90 градусов по часовой стрелке!
    });

    final int quarterRotations = (_pageTurns / 0.25).round();
    final int degrees = (quarterRotations * 90) % 360;

    String msg = 'Синхронизация сессии ($degrees°).';
    if (degrees == 0) {
      msg = 'Сессия калибрована на 360°. Очистка кэша завершена.';
    }

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: NeoColors.surface,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        content: Text(
          msg,
          style: const TextStyle(color: NeoColors.textPrimary, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  void _toggleFlashlight() {
    setState(() {
      _isFlashlight = !_isFlashlight;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: NeoColors.surface,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        content: Text(
          _isFlashlight
              ? 'Тёмная тема активирована.'
              : 'Светлая тема активирована.',
          style: const TextStyle(color: NeoColors.textPrimary, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  void _scrollToKey(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 650),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _handleNavClick(String section) {
    switch (section) {
      case 'hero':
      case 'about':
        _scrollToKey(_heroKey);
        break;
      case 'skills':
        _scrollToKey(_skillsKey);
        break;
      case 'projects':
        _scrollToKey(_projectsKey);
        break;
      case 'lab':
        _scrollToKey(_labKey);
        break;
      case 'contact':
        _scrollToKey(_contactKey);
        break;
    }
  }

  @override
  void dispose() {
    _errorDialogTimer?.cancel();
    _inactivityTimer?.cancel();
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent = Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1280),
        child: Column(
          children: [
            // Шапка с кнопкой поворота на 90 градусов, фонариком и глазами-радарами
            HeaderSection(
              cursorPos: _cursorPos,
              onNavClick: _handleNavClick,
              onRotatePage: _rotatePage,
              onFlashlightToggle: _toggleFlashlight,
            ),

            // Скроллируемая часть
            Expanded(
              child: SelectionArea(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      Container(
                        key: _heroKey,
                        child: HeroSection(
                          isScrolled: _isHeroFallen,
                          onProjectsClick: () => _scrollToKey(_projectsKey),
                          onContactClick: () => _scrollToKey(_contactKey),
                        ),
                      ),
                      const SizedBox(height: NeoSpacing.lg),
                      Container(key: _skillsKey, child: const SkillsSection()),
                      const SizedBox(height: NeoSpacing.lg),
                      Container(key: _projectsKey, child: const ProjectsSection()),
                      const SizedBox(height: NeoSpacing.lg),
                      Container(key: _labKey, child: const PlaygroundSection()),
                      const SizedBox(height: NeoSpacing.lg),
                      Container(key: _contactKey, child: const ContactSection()),
                      const SizedBox(height: NeoSpacing.lg),
                      const FooterSection(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    return Scaffold(
      backgroundColor: NeoColors.surface,
      body: MouseRegion(
        onHover: _onMouseHover,
        child: Stack(
          children: [
            // Поворот страницы на 90 градусов при каждом клике
            AnimatedRotation(
              turns: _pageTurns,
              duration: const Duration(milliseconds: 700),
              curve: Curves.easeInOutBack,
              child: mainContent,
            ),

            // Оверлей фонарика (Тёмная тема в пещере)
            if (_isFlashlight)
              Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(
                    painter: _FlashlightPainter(center: _cursorPos),
                  ),
                ),
              ),

            // Оверлей спящего режима при отсутствии активности курсора
            if (_isSleeping)
              Positioned.fill(
                child: IgnorePointer(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 600),
                    color: NeoColors.surface.withValues(alpha: 0.72),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                        decoration: BoxDecoration(
                          color: NeoColors.surface,
                          borderRadius: BorderRadius.circular(NeoRadius.full),
                          boxShadow: NeoShadows.raisedMd(),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.bedtime_rounded, color: NeoColors.lavenderDark, size: 20),
                            SizedBox(width: 10),
                            Text(
                              '💤 Режим сна: сенсоры отдыхают. Пошевелите курсором!',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: NeoColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

            // Пассивная телеметрия мыши в левом нижнем углу (спидометр и индикатор покоя)
            Positioned(
              left: 20,
              bottom: 20,
              child: PassiveTelemetryHud(
                cursorPos: _cursorPos,
                isSleeping: _isSleeping,
                mouseSpeed: _mouseSpeed,
                isOverspeed: _isOverspeed,
              ),
            ),

            // Фейковый чат-бот Виталий в правом нижнем углу
            const VitaliyChatBot(),
          ],
        ),
      ),
    );
  }
}

class _FlashlightPainter extends CustomPainter {
  final Offset center;

  _FlashlightPainter({required this.center});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()
      ..shader = RadialGradient(
        center: Alignment(
          (center.dx / size.width) * 2 - 1,
          (center.dy / size.height) * 2 - 1,
        ),
        radius: 0.18,
        colors: [
          Colors.transparent,
          Colors.black.withValues(alpha: 0.6),
          Colors.black.withValues(alpha: 0.96),
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(rect);

    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant _FlashlightPainter oldDelegate) {
    return oldDelegate.center != center;
  }
}
