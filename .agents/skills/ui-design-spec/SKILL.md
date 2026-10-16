---
name: ui-design-spec
description: Design system elaboration, UI/UX specification, and detailed component breakdown for developers (especially Flutter/Dart, Web, and Mobile). Use whenever the user asks to design a screen, create or maintain a design system/design code, describe UI elements, specify component states (default, hover, active, disabled, error, loading), define spacing, typography, colors, or create a comprehensive developer-ready handoff specification to guarantee visual consistency and uniformity.
---

# UI Design Specification & Design Code Skill

Этот скилл предназначен для глубокой проработки пользовательского интерфейса, создания дизайн-кода и формирования исчерпывающих спецификаций элементов для программиста. 

Главная цель — **абсолютное единообразие (Design Consistency)**: отсутствие случайных отступов, "магических чисел" и несогласованных цветов в кодовой базе. Разработчик должен получить точную инструкцию: какие токены, виджеты, размеры и состояния использовать.

---

## 1. Фундаментальный принцип: Единый дизайн-код

Любой элемент интерфейса обязан опираться на три кита:
1. **Семантические токены**: Никаких жестко закодированных HEX-цветов (например, `Color(0xFF3B82F6)`). Используются только семантические роли (`Theme.of(context).colorScheme.primary`).
2. **Сетка 4pt / 8pt**: Все отступы (`padding`, `margin`, `gap`), высоты и радиусы кратны 4 или 8 (`4`, `8`, `12`, `16`, `24`, `32`, `48`).
3. **Строгая матрица состояний**: Ни один интерактивный элемент не описывается только в статике. Разработчик должен знать, как элемент выглядит при нажатии, наведении, блокировке, ошибке и загрузке.

> Подробная таблица базовых токенов доступна в файле:
> [references/design-tokens-template.md](file:///Users/rassma/memeweb/.agents/skills/ui-design-spec/references/design-tokens-template.md)

---

## 2. Пошаговый процесс работы над задачей

При поступлении запроса на дизайн экрана, фичи или отдельного компонента следуй этому алгоритму:

```
[1. Контекст и требования] 
       │
       ▼
[2. Проверка / назначение дизайн-токенов]
       │
       ▼
[3. Анатомия и геометрия компонента/экрана]
       │
       ▼
[4. Матрица состояний (State Matrix)]
       │
       ▼
[5. Адаптивность и поведение (Edge cases)]
       │
       ▼
[6. Формирование спецификации для разработчика]
```

---

## 3. Структура спецификации элемента (Developer Handoff)

При описании любого компонента формируй ответ строго по следующему шаблону:

### 3.1. Назначение и контекст
- Какую задачу решает компонент.
- Где используется (экраны, модальные окна, списки).
- Иерархический уровень (Primary CTA, Secondary action, Display widget).

### 3.2. Анатомия и Схема (ASCII-диаграмма)
Приведи наглядную схему расположения вложенных элементов с указанием отступов:
```
┌─────────────────────────────────────────────────────────────┐
│ [Prefix Icon]  [Text Label]                 [Badge / Arrow] │
└─────────────────────────────────────────────────────────────┘
  │<- 16dp ->│   │<- 8dp ->│                  │<- 16dp ->│
```

### 3.3. Геометрия и отступы
- **Высота / Ширина**: фиксированная (например, `48dp` для кнопок/инпутов) или адаптивная (`wrap_content` / `double.infinity`).
- **Скругление (`BorderRadius`)**: токен (`radius.sm = 8dp`, `radius.md = 12dp`, `radius.lg = 16dp`, `radius.full`).
- **Внутренние отступы (`Padding`)**: horizontal и vertical (например, `horizontal: 16dp`, `vertical: 12dp`).
- **Расстояние между дочерними элементами (`Gap`)**: между иконкой и текстом (`8dp`), между полями формы (`16dp` или `24dp`).
- **Минимальная область нажатия (`Touch Target`)**: не менее `48x48dp` для мобильных устройств (согласно Material & Apple HIG).

### 3.4. Токены стилей
- **Цвета**:
  - Фон контейнера: токен `colorScheme.surface` / `colorScheme.primary`
  - Границы (`Border`): токен `colorScheme.outline`, толщина `1dp`
  - Иконки: токен `colorScheme.onSurfaceVariant`, размер `20x20dp` или `24x24dp`
- **Типографика**:
  - Ссылка на стиль `TextTheme` (например, `Theme.of(context).textTheme.labelLarge`).
  - Font-size, Font-weight, Line-height.

### 3.5. Матрица состояний (Обязательный раздел)
Сведи состояния в таблицу:

| Состояние | Фон | Граница | Текст / Иконка | Эффект / Анимация |
| :--- | :--- | :--- | :--- | :--- |
| **Default** | Токен фона | Токен границы | Токен текста | Базовое состояние покоя |
| **Hover** (Web/Desktop) | Смещение яркости (+4..8%) | Подсветка границы | Без изменений | Курсор `SystemMouseCursors.click` |
| **Pressed / Active** | Смещение затемнения (+12%) | — | — | Splash / InkWell эффект |
| **Focused** | — | `colorScheme.primary` (2dp) | — | Индикатор фокуса с клавиатуры |
| **Disabled** | Opacity 38% | Opacity 12% | Opacity 38% | `onTap: null`, серые тона |
| **Loading** | Блокировка кликов | — | Спиннер вместо текста | `SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))` |
| **Error** | — | `colorScheme.error` | `colorScheme.error` | Сообщение об ошибке под элементом |

### 3.6. Реализация во Flutter (Кодовый мост для разработчика)
- Рекомендуемый базовый виджет (`ElevatedButton`, `OutlinedButton`, `TextField`, `Card`, `ListTile`).
- Соответствие `ThemeData` (`elevatedButtonTheme`, `inputDecorationTheme`, `cardTheme`).
- Готовый сниппет или параметры кастомизации.

> Готовый эталонный пример оформления спецификации доступен в:
> [references/component-spec-example.md](file:///Users/rassma/memeweb/.agents/skills/ui-design-spec/references/component-spec-example.md)

---

## 4. Спецификация экрана или пользовательского сценария (Screen Layout)

Когда задача касается дизайна целого экрана:
1. **Каркас экрана (`Scaffold`)**:
   - `backgroundColor`: `colorScheme.background`
   - `SafeArea`: обязателен ли отступ под системные панели (notch / status bar / home indicator).
2. **Верхняя панель (`AppBar`)**:
   - Высота: `kToolbarHeight` (56dp).
   - Заголовок: `titleLarge`, выравнивание (по центру для iOS/Cupertino, слева для Android).
   - Действия (`Actions`): размер кнопок действий `48x48dp`.
3. **Контентная область (`Body`)**:
   - Скролл: `SingleChildScrollView` или `ListView`.
   - Внешний отступ экрана: `16dp` на мобильных, `24-32dp` на планшетах/десктопе.
4. **Фиксированные панели (`BottomAppBar` / `FloatingActionButton`)**:
   - Sticky CTA кнопки внизу экрана с учетом `MediaQuery.of(context).viewInsets.bottom` (чтобы клавиатура не перекрывала инпуты и кнопку).

---

## 5. Чек-лист проверки спецификации перед отправкой программисту

Перед завершением ответа убедись:
- [ ] Все цвета привязаны к `Theme.of(context).colorScheme` (никаких сырых HEX в коде компонентов).
- [ ] Все размеры и паддинги кратны `4dp` или `8dp`.
- [ ] Описаны все 6 состояний компонента (Default, Hover, Pressed, Disabled, Loading, Error).
- [ ] Учтена минимальная зона нажатия пальцем (`48x48dp`).
- [ ] Учтены переполнения текстов (`TextOverflow.ellipsis`, максимальное количество строк `maxLines`).
- [ ] Указаны правила адаптивности (что происходит при сжатии ширины экрана или длинном тексте).
