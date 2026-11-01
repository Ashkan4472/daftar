# Daftar

Local-only expense tracker for Android. Reads bank SMS, categorizes by hand, tracks shared money, budgets and spending leaks. English and Persian (RTL, Jalali calendar). No cloud.

- `app/` Flutter app. Build: `cd app && flutter build apk --release --no-tree-shake-icons --split-per-abi` (the flag is needed because icons are chosen at runtime).
- `packages/core/` Pure Dart: SMS parser and template builder, Jalali helpers, backup crypto, CSV. `dart test`.
- `cli/` Desktop tool: `dart run bin/daftar.dart decrypt backup.daftar -o out.sqlite` or `export backup.daftar -o out.csv`.
- `docs/PLAN.md`, `docs/TASKS.md` Plan and progress. `design-system/daftar/MASTER.md` UI rules.
- `app/tool/strings.py` regenerates the English/Persian strings; `app/tool/make_brand.py` redraws the logo.
- Performance check: `cd app && flutter test test/perf_test.dart` (seeds 1M transactions).
