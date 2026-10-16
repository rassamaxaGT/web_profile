# Пример подробной спецификации компонента для разработчика

Этот документ показывает эталонный вид спецификации элемента интерфейса, подготовленный для программиста (на примере Flutter).

---

# Спецификация: `AppTextField` (Поле ввода текста)

## 1. Назначение и контекст
Универсальное поле ввода текста для форм регистрации, поиска и ввода параметров. Поддерживает заголовок (label), плейсхолдер, иконки (prefix/suffix), вспомогательный текст и состояние ошибки валидации.

---

## 2. Анатомия и геометрия

```
┌─────────────────────────────────────────────────────────────┐
│ [Label Text (type.bodySmall, color.onSurfaceVariant)]       │  <- gap: space.xs (4dp)
├─────────────────────────────────────────────────────────────┤
│ ┌────┐                                               ┌────┐ │
│ │[Ic]│ [Placeholder / Input Text]                    │[Ic]│ │  <- minHeight: 48dp (тап-зона)
│ └────┘                                               └────┘ │
└─────────────────────────────────────────────────────────────┘
  │                                                      │
  [Helper Text / Error Text]                             │       <- gap: space.xs (4dp)
```

### Размеры и отступы:
- **Высота контейнера**: `48dp` (фикс/минимальная для мобильных по стандарту Touch Target Size).
- **Скругление углов (`borderRadius`)**: `radius.md` (`12dp`).
- **Толщина рамки (`borderWidth`)**: `1.0dp` (в фокусе/ошибке: `1.5dp` или `2.0dp`).
- **Внутренний padding**:
  - `horizontal`: `space.base` (`16dp`)
  - `vertical`: `space.md` (`12dp`)
- **Расстояние между элементами внутри (gap)**:
  - Между prefix icon и текстом: `space.sm` (`8dp`)
  - Между текстом и suffix icon: `space.sm` (`8dp`)
- **Размер иконок**: `20x20dp` (Touch target иконки-кнопки в suffix: `40x40dp`).

---

## 3. Матрица состояний (State Matrix)

| Состояние | Фон (`fillColor`) | Граница (`borderColor`) | Текст ввода | Placeholder | Иконки |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Default (Idle)** | `color.surfaceVariant` (или transparent) | `color.outline` | `color.onSurface` | `color.onSurfaceVariant` | `color.onSurfaceVariant` |
| **Hover** (Desktop/Web) | `color.surfaceVariant` (hover overlay 4%) | `color.onSurface` | `color.onSurface` | `color.onSurfaceVariant` | `color.onSurface` |
| **Focused** | `color.surface` | `color.primary` (толщина 2dp) | `color.onSurface` | `color.onSurfaceVariant` | `color.primary` |
| **Filled (с текстом)** | `color.surfaceVariant` | `color.outline` | `color.onSurface` | — | `color.onSurface` |
| **Error (Ошибка)** | `color.surface` | `color.error` (толщина 1.5dp) | `color.onSurface` | `color.onSurfaceVariant` | `color.error` |
| **Disabled** | `color.surfaceVariant` (opacity 38%) | `color.outline` (opacity 12%) | `color.onSurface` (opacity 38%) | `color.onSurface` (opacity 38%) | `color.onSurface` (opacity 38%) |
| **Loading** (при автокомплите)| как Focused | `color.primary` | `color.onSurface` | — | `CircularProgressIndicator` (18dp) |

---

## 4. Типографика
- **Label (над полем)**: `type.bodySmall` (12sp, Medium 500, `color.onSurfaceVariant`)
- **Вводимый текст**: `type.bodyLarge` (16sp, Regular 400, `color.onSurface`)
- **Placeholder**: `type.bodyLarge` (16sp, Regular 400, `color.onSurfaceVariant`)
- **Helper text**: `type.bodySmall` (12sp, Regular 400, `color.onSurfaceVariant`)
- **Error text**: `type.bodySmall` (12sp, Medium 500, `color.error`)

---

## 5. Поведение и анимации
- **Переход состояний (Focus / Error)**: Анимация изменения цвета границы за `200ms` кривой `Curves.easeInOut`.
- **Очистка поля**: При наличии текста в suffix появляется `IconButton` с иконкой `Icons.clear` (размер 18dp), по клику очищающая поле.
- **Клавиатура**: Должен передаваться корректный `TextInputType` (`emailAddress`, `phone`, `number` и т.д.) и `TextInputAction` (`next`, `done`).

---

## 6. Пример имплементации во Flutter (Theme / Widget Specs)

```dart
// Рекомендуемая настройка InputDecorationTheme в ThemeData:
InputDecorationTheme appInputDecorationTheme(ColorScheme colors) {
  return InputDecorationTheme(
    filled: true,
    fillColor: colors.surfaceContainerHighest.withOpacity(0.5),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: colors.outline),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: colors.outline.withOpacity(0.5)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: colors.primary, width: 2.0),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: colors.error, width: 1.5),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: colors.error, width: 2.0),
    ),
    labelStyle: TextStyle(fontSize: 14, color: colors.onSurfaceVariant),
    hintStyle: TextStyle(fontSize: 16, color: colors.onSurfaceVariant.withOpacity(0.7)),
    errorStyle: TextStyle(fontSize: 12, color: colors.error, fontWeight: FontWeight.w500),
  );
}
```
