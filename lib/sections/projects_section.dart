import 'package:flutter/material.dart';
import '../theme/neomorphic_theme.dart';
import '../widgets/absurd_captcha_dialog.dart';
import '../widgets/neomorphic_badge.dart';
import '../widgets/neomorphic_button.dart';
import '../widgets/neomorphic_card.dart';

class ProjectsSection extends StatefulWidget {
  const ProjectsSection({super.key});

  @override
  State<ProjectsSection> createState() => _ProjectsSectionState();
}

class _ProjectsSectionState extends State<ProjectsSection> {
  int _selectedFilter = 1; // По умолчанию открыт Flutter Apps, так как "Все" скрывает всё!
  final List<String> _filters = ['Все (Скрыть всё)', 'Flutter Apps', 'Web Platforms', 'Design Systems'];

  final List<Map<String, dynamic>> _projects = [
    {
      'title': 'MemeWeb Platform',
      'category': 'Flutter Apps',
      'type': 'Web & Canvas',
      'description': 'Платформа для работы с интерактивным графическим контентом. Кастомный холст на CanvasKit, BLoC-состояние и оптимизированный экспорт графики.',
      'tags': ['Flutter Web', 'Dart 3', 'CanvasKit', 'BLoC', 'WebSockets'],
      'pastel': NeoColors.sage,
      'accent': NeoColors.sageDark,
      'codeSnippet': 'CanvasRenderer.paint(layerTree)',
    },
    {
      'title': 'Neomorphic Design System Kit',
      'category': 'Design Systems',
      'type': 'Open Source',
      'description': 'Комплект виджетов и токенов для Flutter и веба с двойными тенями, отсутствием внешних рамок и физикой тактильных состояний.',
      'tags': ['Design Tokens', 'Flutter Package', 'WCAG AA', 'Zero Borders'],
      'pastel': NeoColors.lavender,
      'accent': NeoColors.lavenderDark,
      'codeSnippet': 'NeoShadows.raisedMd(elevation: 16)',
    },
    {
      'title': 'FinTrack Portfolio Core',
      'category': 'Flutter Apps',
      'type': 'Client App',
      'description': 'Кроссплатформенный клиент аналитики портфеля с гладкими графиками временных рядов, локальным шифрованием и оффлайн-синхронизацией.',
      'tags': ['Flutter', 'Clean Architecture', 'Custom Charts', 'Isar DB'],
      'pastel': NeoColors.peach,
      'accent': NeoColors.peachDark,
      'codeSnippet': 'PortfolioBloc.loadHistoricalData()',
    },
    {
      'title': 'Zen Task Engine',
      'category': 'Web Platforms',
      'type': 'Web Platform',
      'description': 'Минималистичный менеджер задач и фокуса без перегруженного интерфейса. Высокая скорость загрузки, нулевой оверхед и строгий дизайн-код.',
      'tags': ['PWA', 'Offline First', 'Responsive Grid', 'Key Bindings'],
      'pastel': NeoColors.rose,
      'accent': NeoColors.roseDark,
      'codeSnippet': 'TaskQueue.syncWithLocalStorage()',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 900;

    final filteredProjects = _selectedFilter == 0
        ? <Map<String, dynamic>>[]
        : _projects.where((p) => p['category'] == _filters[_selectedFilter]).toList();

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 64.0 : 20.0,
        vertical: 40.0,
      ),
      child: Column(
        children: [
          const NeomorphicBadge(
            text: 'Проекты',
            pastelColor: NeoColors.peach,
            textColor: NeoColors.peachDark,
          ),
          const SizedBox(height: NeoSpacing.md),
          Text(
            'Избранные реализации',
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
            'Архитектурные кейсы, веб-сервисы и компонентные решения',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: NeoColors.textSecondary,
            ),
          ),
          const SizedBox(height: NeoSpacing.lg),

          // Переключатель фильтров
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: NeoColors.surface,
                borderRadius: BorderRadius.circular(NeoRadius.full),
                boxShadow: [
                  BoxShadow(
                    color: NeoColors.shadowDark.withValues(alpha: 0.35),
                    offset: const Offset(1.5, 1.5),
                    blurRadius: 3,
                  ),
                  const BoxShadow(
                    color: Colors.white,
                    offset: Offset(-1.5, -1.5),
                    blurRadius: 3,
                  ),
                ],
              ),
              child: Row(
                children: List.generate(_filters.length, (index) {
                  final isSelected = _selectedFilter == index;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedFilter = index),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 160),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                        decoration: BoxDecoration(
                          color: isSelected ? NeoColors.surface : Colors.transparent,
                          borderRadius: BorderRadius.circular(NeoRadius.full),
                          boxShadow: isSelected ? NeoShadows.raisedSm() : [],
                        ),
                        child: Text(
                          _filters[index],
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            color: isSelected ? NeoColors.textPrimary : NeoColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
          const SizedBox(height: NeoSpacing.xl),

          // Если выбран фильтр "Все" -> скрывает всё!
          if (_selectedFilter == 0) ...[
            NeomorphicCard(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              child: Column(
                children: const [
                  Text(
                    'Вы выбрали категорию «Все (Скрыть всё)»',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: NeoColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Поздравляем! Страница успешно очищена от всех проектов для достижения максимального минимализма. Выберите категорию Flutter Apps или Design Systems, чтобы вернуть контент.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, color: NeoColors.textSecondary),
                  ),
                ],
              ),
            ),
          ] else ...[
            // Список карточек проектов
            LayoutBuilder(
              builder: (context, constraints) {
                final cardWidth = isDesktop ? (constraints.maxWidth - 24) / 2 : constraints.maxWidth;

                return Wrap(
                  spacing: 24,
                  runSpacing: 24,
                  children: filteredProjects.map((project) {
                    return _ShyProjectCard(
                      cardWidth: cardWidth,
                      project: project,
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}

/// Карточка проекта с пассивной реакцией смущения при наведении курсора
class _ShyProjectCard extends StatefulWidget {
  final double cardWidth;
  final Map<String, dynamic> project;

  const _ShyProjectCard({
    required this.cardWidth,
    required this.project,
  });

  @override
  State<_ShyProjectCard> createState() => _ShyProjectCardState();
}

class _ShyProjectCardState extends State<_ShyProjectCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final project = widget.project;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        transform: Matrix4.diagonal3Values(
          _isHovered ? 0.98 : 1.0,
          _isHovered ? 0.98 : 1.0,
          1.0,
        )..setTranslationRaw(0.0, _isHovered ? 8.0 : 0.0, 0.0),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          decoration: BoxDecoration(
            color: _isHovered ? NeoColors.rose.withValues(alpha: 0.12) : Colors.transparent,
            borderRadius: BorderRadius.circular(NeoRadius.lg),
          ),
          child: NeomorphicCard(
            width: widget.cardWidth,
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Схематичное превью
                Container(
                  height: 110,
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: (project['pastel'] as Color).withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(NeoRadius.md),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: project['accent'] as Color,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                project['category'] as String,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                  color: project['accent'] as Color,
                                ),
                              ),
                            ],
                          ),
                          if (_isHovered)
                            const Text(
                              '🫣 смущается от взгляда',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: NeoColors.roseDark,
                              ),
                            ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: NeoColors.surface.withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _isHovered ? '// Не подглядывайте в чужой код!' : project['codeSnippet'] as String,
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 11,
                            color: _isHovered ? NeoColors.roseDark : NeoColors.textPrimary.withValues(alpha: 0.85),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: NeoSpacing.md),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      project['title'] as String,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: NeoColors.textPrimary,
                      ),
                    ),
                    Text(
                      project['type'] as String,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: NeoColors.textTertiary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: NeoSpacing.xs),

                Text(
                  project['description'] as String,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.45,
                    color: NeoColors.textSecondary,
                  ),
                ),
                const SizedBox(height: NeoSpacing.md),

                // Tags
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: (project['tags'] as List<String>).map((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                      decoration: BoxDecoration(
                        color: NeoColors.surface,
                        borderRadius: BorderRadius.circular(NeoRadius.full),
                        boxShadow: [
                          BoxShadow(
                            color: NeoColors.shadowDark.withValues(alpha: 0.25),
                            offset: const Offset(1, 1),
                            blurRadius: 1.5,
                          ),
                          const BoxShadow(
                            color: Colors.white,
                            offset: Offset(-1, -1),
                            blurRadius: 1.5,
                          ),
                        ],
                      ),
                      child: Text(
                        tag,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: NeoColors.textPrimary,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: NeoSpacing.lg),

                // Кнопка перехода с вызовом капчи-рулетки
                NeomorphicButton(
                  text: 'Смотреть спецификацию',
                  accentColor: project['pastel'] as Color,
                  textColor: project['accent'] as Color,
                  height: 44,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => AbsurdCaptchaDialog(
                        projectTitle: project['title'] as String,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

