# Daftar — Tasks

Each milestone is described in [PLAN.md §9](PLAN.md). Tick a box when the task is done and its check passes.

## M0 Skeleton
- [x] Monorepo layout: `app/`, `packages/core/` (`cli/` created in M6)
- [x] `core`: money formatting (Rial/Toman, Persian/ASCII digits), Jalali helpers
- [x] Flutter app created (Android only, package `ir.ashkan.daftar`)
- [x] Theme tokens light/dark + Vazirmatn bundled + Phosphor
- [x] ARB en/fa, runtime language switch, RTL
- [x] Drift schema (all PLAN §4 tables + indexes) on a background isolate (FTS table added with search in M2; SQLCipher in M6)
- [x] Default categories and tags seeded on first run
- [x] App shell: bottom nav (Home, Transactions, Reports, People) + FAB (end-aligned; center-docked overlapped NavigationBar)

## M1 SMS core
- [x] `core`: SMS normalizer (digits, ی/ک, bidi marks)
- [x] `core`: template engine (named groups, kind words) + Resalat template + tests
- [x] `core`: generic heuristic fallback parser
- [x] `core`: year inference + balance reconciliation + tests
- [x] Kotlin plugin: inbox query by date range (paged)
- [x] Importer: dedupe hash, raw_sms store, account resolve/create, batch insert, progress
- [x] Import screen: Jalali date range, progress, cancel
- [x] Unmatched SMS list

## M2 Transactions
- [x] Transaction list: ordered by (occurred_at, id) index, grows 100 rows at a time, Jalali day headers, fixed row height
- [x] Filters + FTS search
- [x] Detail / edit sheet (raw SMS view, exclude switch)
- [x] Manual entry + Cash wallet
- [x] Categories/tags management + Phosphor icon picker (search, weight, color)
- [x] Notes, marks, soft delete + undo, trash
- [x] Review queue with "same as last time" suggestion
- [x] Bulk actions

## M3 Reports and budgets
- [x] Month overview (income, expense, net, savings rate, vs previous month / 3-month avg)
- [x] Category donut + ranked list + drill-down
- [x] 12-month trend; by tag, account, person; custom range
- [x] Budgets per category + progress
- [x] Leaks screen (spikes, small-expense count, uncategorized, balance gaps)

## M4 People
- [x] People CRUD with icon
- [x] Splits (equal / percent / exact) + "I owe"
- [x] Balances, person ledger, settle up linked to a deposit
- [x] Reports count only my share

## M5 Live and notifications
- [x] SMS receiver -> WorkManager one-off sync; periodic 15-min sync
- [x] Capture notification with Categorize / Note (inline reply) / Mark
- [x] Reminders (exact alarms, reboot-safe)
- [x] Budget and leak alerts; monthly Jalali summary
- [x] Transfer pairing with confirm
- [x] Recurring detection + upcoming list
- [x] In-app notification center

## M6 Security and data
- [ ] SQLCipher with Keystore key (not done on purpose: see PLAN §12)
- [x] PIN + fingerprint lock, auto-lock, FLAG_SECURE
- [x] Encrypted `.daftar` backup/restore with safety copy (auto weekly backup replaced by a Home nudge: Android blocks silent writes to a user folder)
- [x] CSV export (UTF-8 BOM) and CSV import (own format + column mapping)
- [x] CLI: `decrypt`, `export`

## M7 Polish
- [x] Template builder (tap tokens -> regex, live test)
- [x] Full fa translation pass
- [x] 1M-row seed + performance targets (PLAN §7)
- [x] Release-signed APK

## Added after the first plan
- [x] Several accounts: bank (with the number printed in its SMS) and cash, balances, archive, per-account transaction list
- [x] Manual transfers between accounts (cash and accounts without SMS)
- [x] Primary actions pinned to the bottom of every screen and sheet
- [x] Logo, launcher icon, splash screen
