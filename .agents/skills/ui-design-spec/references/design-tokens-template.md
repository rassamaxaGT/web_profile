# Design Tokens Template (Flutter & Cross-Platform)

Этот шаблон описывает базовую систему токенов (Design Tokens), обеспечивающую строгое единообразие (дизайн-код) всего интерфейса.

---

## 1. Цветовая палитра (Color Palette)

Придерживайтесь семантического именования (согласно Material 3 и современным дизайн-системам). Избегайте использования случайных HEX-значений в компонентах — каждый цвет должен иметь семантическую роль.

### 1.1. Primary (Бренд и ключевые действия)
| Токен | Название роли | Светлая тема | Тёмная тема | Назначение |
| :--- | :--- | :--- | :--- | :--- |
| `color.primary` | Primary | `#6750A4` | `#D0BCFF` | Главные кнопки (CTA), активные вкладки, фокус |
| `color.onPrimary` | On Primary | `#FFFFFF` | `#381E72` | Текст и иконки поверх `primary` |
| `color.primaryContainer` | Primary Container | `#EADDFF` | `#4F378B` | Выделенные плашки, мягкие акценты |
| `color.onPrimaryContainer` | On Primary Container | `#21005D` | `#EADDFF` | Текст поверх `primaryContainer` |

### 1.2. Secondary & Tertiary (Второстепенные акценты)
| Токен | Название роли | Светлая тема | Тёмная тема | Назначение |
| :--- | :--- | :--- | :--- | :--- |
| `color.secondary` | Secondary | `#625B71` | `#CCC2DC` | Второстепенные элементы управления, чипсы |
| `color.onSecondary` | On Secondary | `#FFFFFF` | `#332D41` | Текст/иконки поверх `secondary` |
| `color.tertiary` | Tertiary | `#7D5260` | `#EFB8C8` | Баджи, предупреждающие акценты, теги |
| `color.onTertiary` | On Tertiary | `#FFFFFF` | `#492532` | Текст/иконки поверх `tertiary` |

### 1.3. Neutral & Surface (Фоны, поверхности, разделители)
| Токен | Название роли | Светлая тема | Тёмная тема | Назначение |
| :--- | :--- | :--- | :--- | :--- |
| `color.background` | Background | `#FEF7FF` | `#141218` | Общий фон экрана (`Scaffold`) |
| `color.surface` | Surface | `#FEF7FF` | `#141218` | Карточки, модальные окна, панели |
| `color.surfaceVariant` | Surface Variant | `#E7E0EC` | `#49454F` | Поля ввода, разделители, неактивные плашки |
| `color.onSurface` | On Surface (High Emphasis) | `#1D1B20` | `#E6E1E5` | Основной текст, заголовки (opacity: 100%) |
| `color.onSurfaceVariant` | On Surface Variant (Medium) | `#49454F` | `#CAC4D0` | Второстепенный текст, подсказки, иконки |
| `color.outline` | Outline / Border | `#79747E` | `#938F99` | Границы карточек, инпутов, сепараторы |
| `color.outlineVariant` | Subtle Border | `#CAC4D0` | `#444746` | Тонкие разделители списка (Divider) |

### 1.4. Semantic States (Обратная связь)
| Токен | Роль | HEX | Описание |
| :--- | :--- | :--- | :--- |
| `color.error` | Error Base | `#B3261E` | Ошибки валидации, критические действия |
| `color.onError` | On Error | `#FFFFFF` | Текст поверх `error` |
| `color.success` | Success Base | `#198754` | Успешное выполнение, галочки, статус онлайн |
| `color.warning` | Warning Base | `#FF9900` | Предупреждения, требующие внимания |
| `color.info` | Info Base | `#0D6EFD` | Информационные подсказки |

---

## 2. Типографика (Typography Scale)

Базовый шрифт: Inter, Roboto или системный шрифт платформы (`SF Pro` для iOS, `Roboto` для Android).
Шкала подчиняется 13 стандартным текстовым стилям Flutter (`TextTheme`).

| Токен | Стиль Flutter | Размер (pt/sp) | Высота строки (lh) | Начертание (Weight) | Назначение |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `type.displayLarge` | `displayLarge` | 57 | 64 | Regular (400) | Главные промо-цифры/заголовки |
| `type.displayMedium` | `displayMedium` | 45 | 52 | Regular (400) | Крупные заголовки лендингов |
| `type.headlineLarge` | `headlineLarge` | 32 | 40 | SemiBold (600) | Заголовки экранов первого уровня |
| `type.headlineMedium`| `headlineMedium`| 28 | 36 | SemiBold (600) | Заголовки модальных окон/секций |
| `type.titleLarge` | `titleLarge` | 22 | 28 | Medium (500) | Заголовок AppBar, карточки |
| `type.titleMedium` | `titleMedium` | 16 | 24 | Medium (500) | Заголовки списков, полей ввода |
| `type.bodyLarge` | `bodyLarge` | 16 | 24 | Regular (400) | Основной текст чтения |
| `type.bodyMedium` | `bodyMedium` | 14 | 20 | Regular (400) | Стандартный вспомогательный текст |
| `type.bodySmall` | `bodySmall` | 12 | 16 | Regular (400) | Сноски, дата/время, мелкие описания |
| `type.labelLarge` | `labelLarge` | 14 | 20 | Medium (500) | Текст кнопок (Buttons), табы |
| `type.labelMedium` | `labelMedium` | 12 | 16 | Medium (500) | Текст чипсов, бейджей |
| `type.labelSmall` | `labelSmall` | 11 | 16 | Medium (500) | Подписи к иконкам в BottomNav |

---

## 3. Сетка и Отступы (Spacing Grid - 8pt / 4pt)

Все внешние и внутренние отступы (padding, margin, gap) должны быть кратны 4 или 8:

| Токен | Значение (dp/px) | Назначение в Flutter |
| :--- | :--- | :--- |
| `space.2xs` | 2 | Тонкие микро-смещения |
| `space.xs` | 4 | Минимальный отступ между иконкой и текстом, бейджи |
| `space.sm` | 8 | Внутренний отступ мелких элементов, расстояние между чипсами |
| `space.md` | 12 | Внутренний отступ полей ввода (vertical), мелкие карточки |
| `space.base` | 16 | **Базовый шаг**. Стандартный отступ от краев экрана, padding карточек |
| `space.lg` | 24 | Расстояние между независимыми блоками формы/экрана |
| `space.xl` | 32 | Расстояние между секциями |
| `space.2xl`| 48 | Отступ сверху до hero-элемента |
| `space.3xl`| 64 | Разделители масштабных экранов онбординга |

---

## 4. Скругления углов (Border Radius)

| Токен | Радиус (dp) | Применение |
| :--- | :--- | :--- |
| `radius.none` | 0 | Прямоугольные баннеры, разделители во всю ширину |
| `radius.xs` | 4 | Мелкие теги, подсказки (Tooltips) |
| `radius.sm` | 8 | Чекбоксы, кнопки малого размера, инпуты |
| `radius.md` | 12 | Стандартные кнопки, поля ввода, диалоговые окна |
| `radius.lg` | 16 | Карточки контента, выпадающие меню |
| `radius.xl` | 24 | BottomSheet верхняя кромка, большие карточки |
| `radius.full` | 999 (Pill) | FAB, круглые аватары, круглые чипсы |

---

## 5. Тени и Возвышение (Elevation & Shadow)

| Уровень | Elevation | Shadow CSS / BoxShadow | Применение |
| :--- | :--- | :--- | :--- |
| `elevation.0` | 0dp | None | Плоские карточки с `outline` границей |
| `elevation.1` | 1dp | `BoxShadow(color: #000000 5%, blur: 3, offset: (0, 1))` | Карточки в списке, приподнятые плашки |
| `elevation.2` | 3dp | `BoxShadow(color: #000000 8%, blur: 6, offset: (0, 2))` | AppBar при скролле, выпадающие списки |
| `elevation.3` | 6dp | `BoxShadow(color: #000000 12%, blur: 10, offset: (0, 4))` | Модальные окна, BottomSheet, Диалоги |
| `elevation.4` | 8dp+ | `BoxShadow(color: #000000 16%, blur: 16, offset: (0, 6))` | Floating Action Button (FAB), всплывающие тосты |
