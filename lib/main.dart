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
import 'widgets/absurd_bubble_level.dart';
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
      title: 'Richard Brook • Flutter & Frontend Portfolio',
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

  // Абсурдные стрелки и уровень горизонта
  double _interfaceShiftX = 0.0;
  int _leftShiftClicks = 0;
  bool _rightArrowFled = false;
  double _levelTiltTurns = 0.0;

  // Сценарий первого скролла: плавный сдвиг по другой оси и стрелка рядом с контентом
  bool _hasCompletedHorizontalScroll = false;
  double _scrollShiftX = 0.0;
  bool _showScrollRestoreArrow = false;
  bool _restoreArrowVisible = false;
  bool _restoreArrowFled = false;

  // Однократный показ ошибки графического конвейера
  bool _hasShownErrorDialog = false;

  void _onLeftArrowPressed() {
    setState(() {
      _leftShiftClicks++;
      if (_leftShiftClicks >= 4) {
        _leftShiftClicks = 0;
        _interfaceShiftX = 0.0;
        _scrollShiftX = 0.0;
        _hasCompletedHorizontalScroll = false;
        _showScrollRestoreArrow = false;
        _restoreArrowVisible = false;
        _restoreArrowFled = false;
      } else {
        _interfaceShiftX -= 170.0;
      }
    });
  }

  void _onRightArrowPressed() {
    setState(() {
      _rightArrowFled = true;
    });
    // Через 3.5 секунды стрелка робко возвращается обратно из-за границы экрана
    Timer(const Duration(milliseconds: 3500), () {
      if (mounted) {
        setState(() {
          _rightArrowFled = false;
        });
      }
    });
  }

  void _onRestoreArrowPressed() {
    if (_restoreArrowFled) return;

    setState(() {
      _restoreArrowFled = true;
    });

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: NeoColors.surface,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        elevation: 6,
        duration: const Duration(seconds: 4),
        content: const Text(
          '💨 Стрелка попыталась вернуть сайт, но не справилась с массой вёрстки и улетела за экран.',
          style: TextStyle(color: NeoColors.textPrimary, fontWeight: FontWeight.w600),
        ),
      ),
    );
    // Стрелка улетает насовсем без автоматического возврата по таймеру
  }

  @override
  void initState() {
    super.initState();
    // Запуск таймера ошибки графического конвейера позже (через 55 секунд) и однократно
    _scheduleErrorDialog(seconds: 55);
    _scrollController.addListener(_handleScroll);
    _resetInactivityTimer();
  }

  void _handleScroll() {
    if (!_scrollController.hasClients) return;
    final offset = _scrollController.offset;
    final fallen = offset > 25;
    if (fallen != _isHeroFallen) {
      setState(() => _isHeroFallen = fallen);
    }
  }

  void _onPointerSignal(PointerSignalEvent event) {
    if (event is PointerScrollEvent) {
      if (!_hasCompletedHorizontalScroll) {
        final dy = event.scrollDelta.dy;
        if (dy.abs() > 0.1) {
          final maxShift = (MediaQuery.of(context).size.width < 700) ? -90.0 : -170.0;
          setState(() {
            _scrollShiftX = (_scrollShiftX - dy).clamp(maxShift, 0.0);
            if (_scrollShiftX <= maxShift) {
              _hasCompletedHorizontalScroll = true;
              _scrollShiftX = maxShift;
            }
            if (_scrollShiftX < -15.0) {
              _showScrollRestoreArrow = true;
              _restoreArrowVisible = true;
            } else if (_scrollShiftX >= 0.0) {
              _showScrollRestoreArrow = false;
              _restoreArrowVisible = false;
            }
          });
        }
      }
    }
  }

  void _onPointerMove(PointerMoveEvent event) {
    if (!_hasCompletedHorizontalScroll &&
        (event.buttons == kPrimaryMouseButton || event.kind == PointerDeviceKind.touch)) {
      final dy = event.delta.dy;
      if (dy.abs() > 0.5) {
        final maxShift = (MediaQuery.of(context).size.width < 700) ? -90.0 : -170.0;
        setState(() {
          _scrollShiftX = (_scrollShiftX + dy).clamp(maxShift, 0.0);
          if (_scrollShiftX <= maxShift) {
            _hasCompletedHorizontalScroll = true;
            _scrollShiftX = maxShift;
          }
          if (_scrollShiftX < -15.0) {
            _showScrollRestoreArrow = true;
            _restoreArrowVisible = true;
          }
        });
      }
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

  void _scheduleErrorDialog({int seconds = 55}) {
    if (_hasShownErrorDialog) return;
    _errorDialogTimer?.cancel();
    _errorDialogTimer = Timer(Duration(seconds: seconds), () {
      if (mounted && !_hasShownErrorDialog) _showErrorReloadDialog();
    });
  }

  void _showErrorReloadDialog() {
    if (!mounted || _hasShownErrorDialog) return;
    _hasShownErrorDialog = true;
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
    if (!_hasCompletedHorizontalScroll) {
      final maxShift = (MediaQuery.of(context).size.width < 700) ? -90.0 : -170.0;
      setState(() {
        _hasCompletedHorizontalScroll = true;
        _scrollShiftX = maxShift;
        _showScrollRestoreArrow = true;
        _restoreArrowVisible = true;
      });
    }
    final targetContext = key.currentContext;
    if (targetContext != null) {
      Scrollable.ensureVisible(
        targetContext,
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
    final screenWidth = MediaQuery.of(context).size.width;
    final totalShiftX = _interfaceShiftX + _scrollShiftX;
    final contentWidth = screenWidth > 1280 ? 1280.0 : screenWidth;
    final contentRight = (screenWidth + contentWidth) / 2.0;
    final shiftedContentRight = contentRight + totalShiftX;
    final arrowLeft = (shiftedContentRight + (screenWidth < 700 ? 10.0 : 18.0))
        .clamp(10.0, screenWidth - 62.0);
    final fleeDistance = screenWidth - arrowLeft + 160.0;

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
                  physics: _hasCompletedHorizontalScroll
                      ? const BouncingScrollPhysics()
                      : const NeverScrollableScrollPhysics(),
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
        child: Listener(
          onPointerSignal: _onPointerSignal,
          onPointerMove: _onPointerMove,
          child: Stack(
            children: [
              // Сдвиг всего интерфейса влево (левая стрелка / первый скролл) + поворот (рефреш / уровень)
              AnimatedContainer(
                duration: Duration(
                  milliseconds: !_hasCompletedHorizontalScroll
                      ? 140
                      : (_leftShiftClicks == 0 ? 700 : 380),
                ),
                curve: !_hasCompletedHorizontalScroll
                    ? Curves.easeOutCubic
                    : (_leftShiftClicks == 0 ? Curves.elasticOut : Curves.easeOutCubic),
                transform: Matrix4.translationValues(totalShiftX, 0, 0),
                child: AnimatedRotation(
                  turns: _pageTurns + _levelTiltTurns,
                  duration: const Duration(milliseconds: 700),
                  curve: Curves.easeInOutBack,
                  child: mainContent,
                ),
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

            // Стрелки навигации вместе внизу слева
            Positioned(
              left: 20,
              bottom: 64,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Левая стрелка: сдвигает весь интерфейс влево несколько шагов, а потом центрирует
                  Tooltip(
                    message: _leftShiftClicks == 0
                        ? 'Сдвинуть весь сайт влево (Шаг 1/3)'
                        : _leftShiftClicks == 3
                            ? 'Центрировать интерфейс'
                            : 'Сдвинуть сайт ещё левее (Шаг ${_leftShiftClicks + 1}/3)',
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: _onLeftArrowPressed,
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: NeoColors.surface,
                            shape: BoxShape.circle,
                            boxShadow: NeoShadows.raisedSm(),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              const Icon(
                                Icons.arrow_back_ios_new_rounded,
                                size: 16,
                                color: NeoColors.sageDark,
                              ),
                              if (_leftShiftClicks > 0)
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1.5),
                                    decoration: BoxDecoration(
                                      color: NeoColors.roseDark,
                                      borderRadius: BorderRadius.circular(NeoRadius.full),
                                    ),
                                    child: Text(
                                      '$_leftShiftClicks/3',
                                      style: const TextStyle(
                                        fontSize: 7.5,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Правая стрелка: при нажатии со свистом улетает через весь экран за правую границу!
                  AnimatedContainer(
                    duration: Duration(milliseconds: _rightArrowFled ? 600 : 700),
                    curve: _rightArrowFled ? Curves.easeInQuad : Curves.easeOutBack,
                    transform: Matrix4.translationValues(
                      _rightArrowFled ? (MediaQuery.of(context).size.width + 120.0) : 0.0,
                      0,
                      0,
                    ),
                    child: Tooltip(
                      message: _rightArrowFled
                          ? 'Улетела направо...'
                          : 'Стрелка вправо (Нажмите, чтобы отправить)',
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: _onRightArrowPressed,
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: NeoColors.surface,
                              shape: BoxShape.circle,
                              boxShadow: NeoShadows.raisedSm(),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 16,
                                color: NeoColors.lavenderDark,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
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

            // Фейковый чат-бот Виталий в правом нижнем углу, под кнопкой которого прячется строительный уровень
            VitaliyChatBot(
              underButton: AbsurdBubbleLevel(
                cursorPos: _cursorPos,
                onTiltChanged: (tilt) {
                  setState(() => _levelTiltTurns = tilt);
                },
              ),
            ),

            // Стрелка в освободившемся справа пространстве рядом с контентом
            if (_showScrollRestoreArrow)
              Positioned(
                left: arrowLeft,
                top: MediaQuery.of(context).size.height * 0.44,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: _restoreArrowFled ? 600 : 250),
                  curve: _restoreArrowFled ? Curves.easeInQuad : Curves.easeOutBack,
                  transform: Matrix4.translationValues(
                    _restoreArrowFled ? fleeDistance : 0.0,
                    0,
                    0,
                  ),
                  child: AnimatedScale(
                    scale: _restoreArrowVisible ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeOutBack,
                    child: AnimatedOpacity(
                      opacity: _restoreArrowVisible ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 250),
                      child: Tooltip(
                        message: _restoreArrowFled
                            ? 'Стрелка улетела вправо...'
                            : 'Вернуть интерфейс на место',
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: _onRestoreArrowPressed,
                            child: Column(
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
                                      Icons.arrow_forward_ios_rounded,
                                      size: 18,
                                      color: NeoColors.lavenderDark,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: NeoColors.surface,
                                    borderRadius: BorderRadius.circular(NeoRadius.sm),
                                    boxShadow: NeoShadows.raisedSm(),
                                  ),
                                  child: const Text(
                                    'Вернуть',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: NeoColors.textSecondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
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
