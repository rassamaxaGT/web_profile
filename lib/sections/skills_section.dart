import 'package:flutter/material.dart';
import '../theme/neomorphic_theme.dart';
import '../widgets/neomorphic_badge.dart';
import '../widgets/neomorphic_card.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const NeomorphicBadge(
            text: 'Стек технологий',
            pastelColor: NeoColors.lavender,
            textColor: NeoColors.lavenderDark,
          ),
          const SizedBox(height: NeoSpacing.md),
          Text(
            'Специализация и ключевые навыки',
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
            'Проверенный стек инструментов для создания надежных клиентских систем',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: NeoColors.textSecondary,
            ),
          ),
          const SizedBox(height: NeoSpacing.xl),

          // Карточки доменов
          LayoutBuilder(
            builder: (context, constraints) {
              final cardWidth = isDesktop ? (constraints.maxWidth - 24) / 2 : constraints.maxWidth;

              return Wrap(
                spacing: 24,
                runSpacing: 24,
                children: [
                  _SkillDomainCard(
                    width: cardWidth,
                    index: '01',
                    title: 'Flutter Web & Mobile',
                    description: 'Разработка мультиплатформенных приложений с нативной частотой кадров, оптимизацией дерева виджетов и рендерингом на CanvasKit.',
                    tags: const ['Flutter', 'Dart', 'CanvasKit', 'Custom Painters', 'Web Performance'],
                    progress: 0.95,
                    pastelAccent: NeoColors.lavender,
                    accentColor: NeoColors.lavenderDark,
                  ),
                  _SkillDomainCard(
                    width: cardWidth,
                    index: '02',
                    title: 'Архитектура & State-management',
                    description: 'Проектирование расширяемых систем на базе Clean Architecture, BLoC, Repository Pattern и строгой типизации данных.',
                    tags: const ['BLoC', 'Clean Architecture', 'Repository', 'DI', 'Offline-first'],
                    progress: 0.92,
                    pastelAccent: NeoColors.sage,
                    accentColor: NeoColors.sageDark,
                  ),
                  _SkillDomainCard(
                    width: cardWidth,
                    index: '03',
                    title: 'Дизайн-системы & UI/UX',
                    description: 'Разработка библиотек компонентов, семантических дизайн-токенов, микроанимаций и адаптивных макетов по спецификациям.',
                    tags: const ['Design Tokens', 'Neomorphism', 'ThemeData', 'WCAG AA', 'Micro-interactions'],
                    progress: 0.90,
                    pastelAccent: NeoColors.peach,
                    accentColor: NeoColors.peachDark,
                  ),
                  _SkillDomainCard(
                    width: cardWidth,
                    index: '04',
                    title: 'Инфраструктура & Качество',
                    description: 'Написание Unit- и Widget-тестов, настройка автоматизированных пайплайнов CI/CD в GitHub Actions и профилирование памяти.',
                    tags: const ['Unit & Widget Tests', 'GitHub Actions', 'Fastlane', 'Memory Profiling'],
                    progress: 0.88,
                    pastelAccent: NeoColors.rose,
                    accentColor: NeoColors.roseDark,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SkillDomainCard extends StatelessWidget {
  final double width;
  final String index;
  final String title;
  final String description;
  final List<String> tags;
  final double progress;
  final Color pastelAccent;
  final Color accentColor;

  const _SkillDomainCard({
    required this.width,
    required this.index,
    required this.title,
    required this.description,
    required this.tags,
    required this.progress,
    required this.pastelAccent,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return NeomorphicCard(
      width: width,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: NeoColors.surface,
                  shape: BoxShape.circle,
                  boxShadow: NeoShadows.raisedSm(),
                ),
                child: Center(
                  child: Text(
                    index,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: accentColor,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: NeoSpacing.md),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: NeoColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: NeoSpacing.md),
          Text(
            description,
            style: const TextStyle(
              fontSize: 13,
              height: 1.5,
              color: NeoColors.textSecondary,
            ),
          ),
          const SizedBox(height: NeoSpacing.md),

          // Вдавленный неоморфный индикатор
          Container(
            height: 6,
            decoration: BoxDecoration(
              color: NeoColors.surface,
              borderRadius: BorderRadius.circular(NeoRadius.full),
              boxShadow: [
                BoxShadow(
                  color: NeoColors.shadowDark.withValues(alpha: 0.35),
                  offset: const Offset(1, 1),
                  blurRadius: 2,
                ),
                const BoxShadow(
                  color: Colors.white,
                  offset: Offset(-1, -1),
                  blurRadius: 2,
                ),
              ],
            ),
            child: FractionallySizedBox(
              widthFactor: progress,
              alignment: Alignment.centerLeft,
              child: Container(
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.circular(NeoRadius.full),
                ),
              ),
            ),
          ),
          const SizedBox(height: NeoSpacing.md),

          // Теги стека с пассивным "таянием" (провисанием) при наведении курсора
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: tags.map((t) {
              return _MeltingSkillTag(
                tag: t,
                pastelAccent: pastelAccent,
                accentColor: accentColor,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

/// Тег навыка, который пассивно провисает/подтаивает под весом курсора мыши
class _MeltingSkillTag extends StatefulWidget {
  final String tag;
  final Color pastelAccent;
  final Color accentColor;

  const _MeltingSkillTag({
    required this.tag,
    required this.pastelAccent,
    required this.accentColor,
  });

  @override
  State<_MeltingSkillTag> createState() => _MeltingSkillTagState();
}

class _MeltingSkillTagState extends State<_MeltingSkillTag> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutBack,
        transform: Matrix4.translationValues(0, _isHovered ? 7.0 : 0.0, 0),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: widget.pastelAccent.withValues(alpha: _isHovered ? 0.6 : 0.35),
          borderRadius: BorderRadius.circular(NeoRadius.full),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: widget.accentColor.withValues(alpha: 0.2),
                    offset: const Offset(0, 4),
                    blurRadius: 4,
                  ),
                ]
              : null,
        ),
        child: Text(
          _isHovered ? '${widget.tag} 💧' : widget.tag,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: widget.accentColor,
          ),
        ),
      ),
    );
  }
}

