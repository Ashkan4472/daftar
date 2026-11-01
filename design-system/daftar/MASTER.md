# Daftar Design System (Master)

Source of truth for all screens. A page file in `pages/<name>.md` overrides this one for that page.

Generated with ui-ux-pro-max (`personal finance expense tracker mobile data-dense trustworthy calm`, density 7, motion 3),
then adapted for this project:
- The generator proposed dark-only. We ship **light + dark (follow system)**, because the Flutter stack guidelines require both.
- The proposed fonts (Lexend / Source Sans 3) have no Persian glyphs, so we use **Vazirmatn** for both scripts.
- The generator's landing-page pattern does not apply (this is an app, not a marketing site).

## Style

Calm, trustworthy, data-dense. Material 3 base. Flat surfaces with a 1px border, no heavy shadows. Numbers are the hero.

## Color tokens (`lib/theme/tokens.dart`)

| Token | Light | Dark | Use |
|---|---|---|---|
| primary | `#1E40AF` | `#3B82F6` | Brand, primary buttons, selected nav |
| onPrimary | `#FFFFFF` | `#FFFFFF` | |
| income | `#059669` | `#34D399` | Income amounts, positive deltas |
| expense | `#DC2626` | `#F87171` | Expense amounts, over-budget |
| transfer | `#64748B` | `#94A3B8` | Own-account transfers (neutral) |
| warning | `#D97706` | `#FBBF24` | Budget 80%, balance gaps, needs review |
| background | `#F8FAFC` | `#0F172A` | Scaffold |
| surface | `#FFFFFF` | `#101A34` | Cards, sheets |
| border | `#E2E8F0` | `rgba(255,255,255,0.08)` | Dividers, card outlines |
| textPrimary | `#0F172A` | `#F8FAFC` | |
| textMuted | `#64748B` | `#94A3B8` | Secondary text, timestamps |

Rules:
- Never show income/expense by color alone. Always add a sign (`+` / `−`) or a Phosphor arrow icon as well.
- Category colors come from a fixed 16-color picker palette, and each one is checked for 3:1 contrast against `surface` in both themes.
- Widgets get colors from `Theme.of(context)` / a `ThemeExtension`, never from raw hex values.

## Typography

- Font: **Vazirmatn** (variable, bundled, no network), used for both Latin and Persian.
- Amounts use `FontFeature.tabularFigures()` so columns line up.
- Scale (sp): display 32 / headline 24 / title 18 / body 16 / label 14 / caption 12. Body text never goes below 14.
- Persian locale shows Persian digits (۰–۹) and English shows ASCII. Both come from one formatter, never from ad-hoc code.

## Spacing and shape

- Spacing scale: 4, 8, 12, 16, 24, 32. Screen padding is 16.
- Corner radius: 12 for cards and sheets, 8 for chips and inputs, full for FAB and avatars.
- Touch targets are at least 48×48dp, with at least 8dp between adjacent targets.
- A transaction row is a fixed 64dp tall, so the list can use `itemExtent` and scroll quickly through very long lists.

## Icons

- **Phosphor** (`phosphor_flutter`). The Regular weight is the default, Fill marks the selected state, and Duotone is used in category avatars.
- Users pick a custom icon for each category, tag, account and person from the full Phosphor set (searchable), along with a color.
- Stored as `"<name>:<weight>"`. Builds use `--no-tree-shake-icons`, because icons are looked up at runtime.
- No emoji as icons. Icon-only buttons must have a `Semantics` / `tooltip` label.

## Layout and RTL

- Use `EdgeInsetsDirectional` and `AlignmentDirectional` everywhere so the layout mirrors automatically in Persian.
- Directional icons (arrows, chevrons) flip in RTL. Money arrows do **not** flip, because they mean in/out rather than left/right.
- Bottom navigation has 4 tabs (Home, Transactions, Reports, People) plus a center FAB for "Add".

## Motion (subtle)

- 150–250ms with `Curves.easeOutCubic`, and exits are faster than enters.
- Allowed: sheet slide-up, list item fade on insert, number count-up on the Home totals (once per open).
- Respect `MediaQuery.disableAnimations`.

## Charts (`fl_chart`)

- Category share uses a donut with at most 6 slices, with the rest grouped as "Other", always alongside a sorted list with amounts. The list is the primary view.
- Monthly trend uses grouped bars (income vs expense) for 12 Jalali months, with a net line.
- Budget uses a linear progress bar, plus text showing the percentage and the remaining amount.
- Tooltips appear on tap. Charts also get a text summary for screen readers.

## Anti-patterns

- Pure-white dark-mode text on pure-black backgrounds (use the tokens).
- Placeholder-only labels in forms.
- Hover-only affordances.
- Infinite spinners: the import shows determinate progress ("1,240 / 8,300 SMS").
- Confirmation dialogs for reversible actions: use undo snackbars instead.

## Pre-delivery checklist (per screen)

- [ ] Light and dark both pass 4.5:1 contrast for text
- [ ] Layout checked in RTL (fa) and LTR (en)
- [ ] Touch targets are at least 48dp, and icon buttons are labelled
- [ ] Empty, loading and error states exist
- [ ] Works with 100k+ rows (no full-list loads)
- [ ] Reduced motion respected
