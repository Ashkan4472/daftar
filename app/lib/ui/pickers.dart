import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../db/database.dart';
import '../db/seed.dart';
import '../icons/app_icon.dart';
import '../icons/phosphor_codepoints.g.dart';
import '../l10n/app_localizations.dart';
import '../repo.dart';
import '../state.dart';
import '../theme/palette.dart';
import '../theme/theme.dart';
import 'widgets.dart';

/// Category grid with one level of children.
///
/// Tapping a category without children selects it at once. Tapping one with
/// children opens its children row; "All (name)" picks the parent itself.
class CategoryPicker extends ConsumerStatefulWidget {
  const CategoryPicker({super.key, required this.kind, required this.selected, required this.onChanged, this.suggestion});
  final CategoryKind kind;
  final int? selected;
  final ValueChanged<int?> onChanged;

  /// Shown first, highlighted (e.g. "same as last time").
  final int? suggestion;

  @override
  ConsumerState<CategoryPicker> createState() => _CategoryPickerState();
}

class _CategoryPickerState extends ConsumerState<CategoryPicker> {
  int? _open;

  @override
  void didUpdateWidget(CategoryPicker old) {
    super.didUpdateWidget(old);
    if (old.kind != widget.kind || old.selected != widget.selected) _open = null;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final prefs = ref.watch(prefsProvider);
    final all = (ref.watch(categoriesProvider).value ?? const <Category>[]).where((c) => !c.archived).toList();
    final parents = all.where((c) => c.parentId == null && c.kind == widget.kind).toList();
    final byId = {for (final c in all) c.id: c};
    final selected = byId[widget.selected];
    final selectedParent = selected == null ? null : (selected.parentId ?? selected.id);
    final open = _open ?? (selected?.parentId != null ? selected!.parentId : null);
    final kids = open == null ? const <Category>[] : all.where((c) => c.parentId == open).toList();
    final sug = byId[widget.suggestion];

    Widget tile(Category c) {
      final children = all.any((k) => k.parentId == c.id);
      final isSel = selectedParent == c.id;
      return _CatTile(
        name: displayName(c.name, c.nameKey, prefs.lang),
        icon: c.icon,
        color: c.color,
        selected: isSel,
        hasChildren: children,
        onTap: () {
          if (isSel && !children) {
            widget.onChanged(null);
          } else if (children) {
            setState(() => _open = _open == c.id ? null : c.id);
          } else {
            widget.onChanged(c.id);
          }
        },
      );
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (sug != null && sug.kind == widget.kind && widget.selected != sug.id) ...[
        FilledButton.tonalIcon(
          onPressed: () => widget.onChanged(sug.id),
          icon: Icon(appIcon(sug.icon)),
          label: Text('${l.sameAsLast}: ${displayName(sug.name, sug.nameKey, prefs.lang)}'),
          style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
        ),
        const SizedBox(height: 12),
      ],
      Wrap(spacing: 4, runSpacing: 8, children: [for (final c in parents) tile(c)]),
      if (kids.isNotEmpty) ...[
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Color(byId[open]!.color).withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Wrap(spacing: 8, runSpacing: 8, children: [
            ChoiceChip(
              avatar: Icon(appIcon(byId[open]!.icon), size: 18),
              label: Text(l.allOf(displayName(byId[open]!.name, byId[open]!.nameKey, prefs.lang))),
              selected: widget.selected == open,
              onSelected: (_) => widget.onChanged(widget.selected == open ? null : open),
            ),
            for (final k in kids)
              ChoiceChip(
                avatar: Icon(appIcon(k.icon), size: 18),
                label: Text(displayName(k.name, k.nameKey, prefs.lang)),
                selected: widget.selected == k.id,
                onSelected: (_) => widget.onChanged(widget.selected == k.id ? null : k.id),
              ),
          ]),
        ),
      ],
    ]);
  }
}

class _CatTile extends StatelessWidget {
  const _CatTile({required this.name, required this.icon, required this.color, required this.selected, required this.hasChildren, required this.onTap});
  final String name, icon;
  final int color;
  final bool selected, hasChildren;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      button: true,
      selected: selected,
      label: name,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: SizedBox(
          width: 84,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Stack(clipBehavior: Clip.none, children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: selected ? scheme.primary : Colors.transparent, width: 2),
                  ),
                  padding: const EdgeInsets.all(2),
                  child: IconAvatar(icon, color, size: 44),
                ),
                if (hasChildren)
                  PositionedDirectional(
                    end: -2,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(1),
                      decoration: BoxDecoration(color: scheme.surface, shape: BoxShape.circle),
                      child: Icon(appIcon('caret-down:bold'), size: 12, color: context.money.muted),
                    ),
                  ),
              ]),
              const SizedBox(height: 4),
              Text(name,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500, height: 1.25)),
            ]),
          ),
        ),
      ),
    );
  }
}

/// Wrap of toggleable tag chips.
class TagSelector extends ConsumerWidget {
  const TagSelector({super.key, required this.selected, required this.onToggle});
  final Set<int> selected;
  final void Function(int tagId, bool on) onToggle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(prefsProvider);
    final tags = ref.watch(tagsProvider).value ?? const <Tag>[];
    return Wrap(spacing: 8, runSpacing: 8, children: [
      for (final t in tags)
        Builder(builder: (context) {
          final on = selected.contains(t.id);
          final color = Color(t.color);
          return FilterChip(
            avatar: Icon(appIcon(on ? 'check-circle:fill' : t.icon), size: 18, color: color),
            label: Text(displayName(t.name, t.nameKey, prefs.lang), style: TextStyle(fontWeight: on ? FontWeight.w700 : FontWeight.w400)),
            selected: on,
            showCheckmark: false,
            selectedColor: color.withValues(alpha: 0.18),
            side: BorderSide(color: on ? color : Theme.of(context).dividerColor, width: on ? 1.5 : 1),
            onSelected: (v) => onToggle(t.id, v),
          );
        }),
    ]);
  }
}

// ---- icon picker -------------------------------------------------------------

/// Persian search words -> Phosphor name fragments.
const _faKeywords = {
  'غذا': ['fork-knife', 'pizza', 'hamburger', 'bowl-food', 'cooking-pot', 'bread', 'egg'],
  'رستوران': ['fork-knife', 'knife', 'bowl-food'],
  'قهوه': ['coffee', 'cup'],
  'کافه': ['coffee', 'cup'],
  'خرید': ['shopping-cart', 'shopping-bag', 'basket', 'storefront', 'tag'],
  'ماشین': ['car', 'taxi', 'steering-wheel'],
  'سوخت': ['gas-pump'],
  'بنزین': ['gas-pump'],
  'تاکسی': ['taxi'],
  'اتوبوس': ['bus'],
  'مترو': ['train', 'subway'],
  'سفر': ['airplane', 'suitcase', 'map-trifold', 'compass'],
  'هواپیما': ['airplane'],
  'خانه': ['house', 'door', 'key'],
  'اجاره': ['key', 'house'],
  'برق': ['lightning', 'plug'],
  'آب': ['drop', 'waves'],
  'گاز': ['flame', 'fire'],
  'اینترنت': ['wifi', 'globe'],
  'موبایل': ['device-mobile', 'phone'],
  'تلفن': ['phone'],
  'سلامت': ['heart', 'first-aid', 'pill', 'stethoscope'],
  'دارو': ['pill', 'first-aid'],
  'دکتر': ['stethoscope', 'first-aid'],
  'لباس': ['t-shirt', 'dress', 'pants', 'sneaker'],
  'کفش': ['sneaker', 'boot'],
  'آموزش': ['graduation-cap', 'book', 'student', 'chalkboard'],
  'کتاب': ['book', 'books'],
  'فیلم': ['film', 'popcorn', 'video'],
  'بازی': ['game-controller', 'puzzle-piece', 'dice'],
  'موسیقی': ['music-note', 'headphones'],
  'ورزش': ['barbell', 'soccer-ball', 'basketball', 'person-simple-run', 'bicycle'],
  'هدیه': ['gift'],
  'خانواده': ['users', 'baby', 'person-simple'],
  'بچه': ['baby', 'baby-carriage'],
  'حیوان': ['paw-print', 'dog', 'cat'],
  'حقوق': ['briefcase', 'money', 'coins'],
  'پول': ['money', 'coins', 'wallet', 'currency'],
  'نقد': ['money', 'wallet'],
  'بانک': ['bank', 'credit-card'],
  'کارت': ['credit-card'],
  'مالیات': ['receipt', 'bank', 'percent'],
  'قسط': ['calendar-check', 'calendar'],
  'خیریه': ['hand-heart', 'heart'],
  'کار': ['briefcase', 'laptop', 'desktop'],
  'کامپیوتر': ['laptop', 'desktop'],
  'اشتراک': ['repeat', 'arrows-clockwise'],
  'تعمیر': ['wrench', 'hammer', 'screwdriver'],
  'زیبایی': ['sparkle', 'scissors', 'lipstick'],
  'آرایشگاه': ['scissors'],
  'ستاره': ['star'],
  'پس‌انداز': ['piggy-bank'],
  'سرمایه': ['chart-line-up', 'trend-up'],
  'طلا': ['coins', 'diamond'],
};

class IconChoice {
  const IconChoice(this.icon, this.color);
  final String icon;
  final int color;
}

Future<IconChoice?> showIconPicker(BuildContext context, {required String icon, required int color}) =>
    showModalBottomSheet<IconChoice>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => _IconPicker(icon: icon, color: color),
    );

class _IconPicker extends StatefulWidget {
  const _IconPicker({required this.icon, required this.color});
  final String icon;
  final int color;

  @override
  State<_IconPicker> createState() => _IconPickerState();
}

class _IconPickerState extends State<_IconPicker> {
  late String _name = widget.icon.split(':').first;
  late String _weight = widget.icon.contains(':') ? widget.icon.split(':').last : 'regular';
  late int _color = widget.color;
  String _q = '';
  static final _all = (phosphorCodepoints.keys.toList()..sort());

  List<String> get _filtered {
    final q = _q.trim().toLowerCase();
    if (q.isEmpty) return _all;
    final frags = <String>{q};
    for (final e in _faKeywords.entries) {
      if (e.key.contains(q) || q.contains(e.key)) frags.addAll(e.value);
    }
    return _all.where((n) => frags.any(n.contains)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final names = _filtered;
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.92,
      maxChildSize: 0.95,
      builder: (context, scroll) => Column(children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(children: [
            IconAvatar('$_name:$_weight', _color, size: 56),
            const SizedBox(width: 12),
            Expanded(child: Text(l.chooseIcon, style: Theme.of(context).textTheme.titleLarge)),
            FilledButton(
              style: FilledButton.styleFrom(minimumSize: const Size(88, 48)),
              onPressed: () => Navigator.pop(context, IconChoice('$_name:$_weight', _color)),
              child: Text(l.done),
            ),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: TextField(
            decoration: InputDecoration(hintText: l.searchIcons, prefixIcon: Icon(appIcon('magnifying-glass'))),
            onChanged: (v) => setState(() => _q = v),
          ),
        ),
        SizedBox(
          height: 56,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            children: [
              for (final w in phosphorWeights)
                Padding(
                  padding: const EdgeInsetsDirectional.only(end: 8),
                  child: ChoiceChip(
                    avatar: Icon(appIcon('$_name:$w'), size: 18),
                    label: Text(w),
                    selected: _weight == w,
                    onSelected: (_) => setState(() => _weight = w),
                  ),
                ),
            ],
          ),
        ),
        SizedBox(
          height: 52,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            children: [
              for (final c in pickerPalette)
                Semantics(
                  button: true,
                  selected: _color == c,
                  label: l.color,
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () => setState(() => _color = c),
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(color: Color(c), shape: BoxShape.circle),
                        child: _color == c ? Icon(Icons.check, color: onColor(Color(c)), size: 20) : null,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: names.isEmpty
              ? Center(child: Text(l.noResults))
              : GridView.builder(
                  controller: scroll,
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 64, mainAxisSpacing: 4, crossAxisSpacing: 4),
                  itemCount: names.length,
                  itemBuilder: (_, i) {
                    final n = names[i];
                    final sel = n == _name;
                    return Tooltip(
                      message: n,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => setState(() => _name = n),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: sel ? Color(_color).withValues(alpha: 0.16) : null,
                            border: sel ? Border.all(color: Color(_color), width: 2) : null,
                          ),
                          child: Icon(appIcon('$n:$_weight'), size: 28, color: sel ? Color(_color) : null),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ]),
    );
  }
}

/// Compact category row once chosen; full grid while empty or after "Change".
class CategoryField extends ConsumerStatefulWidget {
  const CategoryField({super.key, required this.kind, required this.selected, required this.onChanged});
  final CategoryKind kind;
  final int? selected;
  final ValueChanged<int?> onChanged;

  @override
  ConsumerState<CategoryField> createState() => _CategoryFieldState();
}

class _CategoryFieldState extends ConsumerState<CategoryField> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final prefs = ref.watch(prefsProvider);
    final cats = ref.watch(categoryMapProvider);
    final sel = cats[widget.selected];
    if (sel != null && !_open) {
      final parent = cats[sel.parentId];
      final name = displayName(sel.name, sel.nameKey, prefs.lang);
      return Card(
        child: ListTile(
          leading: IconAvatar(sel.icon, sel.color),
          title: Text(parent == null ? name : '${displayName(parent.name, parent.nameKey, prefs.lang)} › $name'),
          trailing: TextButton(onPressed: () => setState(() => _open = true), child: Text(l.edit)),
          onTap: () => setState(() => _open = true),
        ),
      );
    }
    return CategoryPicker(
      kind: widget.kind,
      selected: widget.selected,
      onChanged: (c) {
        setState(() => _open = false);
        widget.onChanged(c);
      },
    );
  }
}
