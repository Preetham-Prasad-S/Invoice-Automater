# Home screen

Implementation notes for the dashboard built from
`ui_refrerence/screens/home_screen.png`.

## Source of truth

The reference is a 720x1600 mock of a 360x800dp phone, so every measurement in
this document is the pixel coordinate in the image divided by two. Where a
measurement was ambiguous, the value chosen and why are noted.

## Where the code lives

```
lib/features/home/presentation/
  pages/home_page.dart                  the screen: scaffold, scrolling column, width cap
  widgets/home_greeting_header.dart     avatar, greeting, notification button
  widgets/home_total_card.dart          "Total Invoiced" card and its trend badge
  widgets/home_segmented_bar.dart       the proportional status bar
  widgets/home_status_summary.dart      the three Paid/Pending/Overdue cards
  widgets/home_new_invoice_button.dart  the "+ New Invoice" call to action
  widgets/home_section_header.dart      "Recent Invoices" heading and "See all"
  widgets/home_invoice_tile.dart        one row of the invoice list
  widgets/home_status_pill.dart         the coloured status pill
  widgets/home_bottom_nav.dart          the four-tab bar
  widgets/home_sample_data.dart         the placeholder figures and copy

lib/core/widgets/app_card.dart             white surface, border, soft shadow
lib/core/widgets/app_progress_segments.dart  proportional stacked bar
lib/core/utils/formatters.dart             money formatting
```

Routing: `lib/app/router/app_router.dart` maps `RoutePaths.home` to `HomePage`.
The splash screen already navigated here, so no change was needed there.

## Widget tree

```
Scaffold
├─ body: Container (background gradient)
│  └─ SafeArea
│     └─ LayoutBuilder
│        └─ ListView                        (key: HomePage.contentKey)
│           ├─ HomeGreetingHeader
│           ├─ HomeTotalCard
│           │  └─ AppCard
│           │     ├─ Row: "Total Invoiced" + _TrendBadge
│           │     ├─ Text: hero amount
│           │     └─ HomeSegmentedBar → AppProgressSegments
│           ├─ HomeStatusSummary
│           │  └─ IntrinsicHeight → Row of three _StatusCard (AppCard each)
│           ├─ HomeNewInvoiceButton
│           ├─ HomeSectionHeader
│           └─ HomeInvoiceTile x4
│              └─ AppCard → Row: text column + (amount, HomeStatusPill)
└─ bottomNavigationBar: HomeBottomNav
```

## Design tokens

Added to the existing token files. All additions are additive; nothing the
splash screen depends on was changed.

### Colours — `lib/app/theme/app_colors.dart`

| Token | Value | Used by |
| --- | --- | --- |
| `statusPaid` | `#22C55E` | Paid dot, pill text |
| `statusPending` | `#F59E0B` | Pending dot, pill text |
| `statusOverdue` | `#EF4444` | Overdue dot, pill text |
| `statusPaidTint` | `#E7F8F0` | Paid pill background |
| `statusPendingTint` | `#FEF3E2` | Pending pill background |
| `statusOverdueTint` | `#FDE9EC` | Overdue pill background |
| `barPaid` | `#137A4A` | Bar segment |
| `barPending` | `#F5A623` | Bar segment |
| `barOverdue` | `#E8384F` | Bar segment |
| `trendPositive` | `#0E9F6E` | Trend badge icon and text |
| `trendPositiveTint` | `#E8F8F0` | Trend badge background |
| `cardShadow` | `#140B0B14` | Card shadow, ~8% black |
| `navInactive` | `#9AA0AE` | Inactive tab icon and label |

The bar segments are deliberately a deeper green than the Paid dot. In the
reference the dot is a bright mint green while the bar segment is a forest
green; using one colour for both loses that contrast.

### Radii — `lib/app/theme/app_radii.dart`

`card = 20` for the large white cards and invoice rows, `chip = 14` for the
status cards and the call to action. The existing `pill` radius covers the
trend badge and status pills.

### Typography — `lib/app/theme/app_typography.dart`

Added as standalone `TextStyle` constants rather than new `TextTheme` slots,
since they are dashboard-specific names (`heroAmount`, `greetingName`,
`sectionTitle`, `invoiceClient`, `statusAmount`, `cardLabel`, `invoiceMeta`,
`pillLabel`, `navLabel`, `ctaLabel`, `avatarInitials`). All use Quicksand, the
family already declared by the app.

## Section by section

### Page frame

The reference background is a very light lavender wash, not flat white, so the
body reuses the splash screen's `backgroundStart → backgroundEnd` gradient.
Horizontal padding is 24dp (`AppSpacing.lg`), confirmed by the status row
measuring 3 x 96dp cards plus 2 x 12dp gaps inside a 312dp content width.

The content is capped at 420dp and centred when the viewport is wider. The
design is a phone layout, and without the cap a status card would stretch to
several hundred dp wide and strand its label and amount at opposite edges.

### Greeting header

36dp blue circle with white initials, two lines of text taking the remaining
width, then a 37dp outlined bell button. The greeting is hardcoded to "Good
morning" because the reference says so; making it time-aware was out of scope
and is listed as a gap below.

The avatar initials are **not** derived from the greeting name. The design
shows the first name "Alex" next to the initials "AL", which implies a surname
the greeting never displays, so `HomeSampleData` carries `userName` and
`userInitials` separately. `HomeGreetingHeader.initialsOf` does derive initials
when a full name is all that is available.

### Total Invoiced card

An `AppCard` with a label row, the hero amount and the bar. The label is
`Expanded` with an ellipsis rather than a `Spacer`, so a longer translation
degrades instead of overflowing.

The hero amount keeps its cents (`$28,450.00`), unlike the status cards below.

### The proportional bar

This is the one piece of real logic on the screen. The bar is a readout of the
totals, not decoration. Measuring the reference gives green 365/531 of the bar
against `19820 / 28450 = 69.7%` paid, amber 22.6% against 21.7% pending and red
8.7% against 8.6% overdue — the segments are the three status amounts as
fractions of their sum.

`AppProgressSegments` therefore takes raw weights and normalises them. Layout
uses `Expanded` per slice plus a fixed 2.5dp gap between them, so the gaps are
not subtracted from the slices and the proportions stay honest. Two edge cases
are handled explicitly: a single slice renders as one continuous fill (a lone
gap would read as a rendering fault), and a zero total renders an empty track
without dividing by zero.

`AppProgressBar` was not reused or modified. It animates a single fill for task
progress and cannot express three proportional segments, and the splash screen
depends on its exact behaviour.

### Status summary

Three equal cards, dot and label above a compact amount. The figures drop
`.00` (`$19,820`), which is what the design shows at that size — hence
`Formatters.usdCompact` alongside `Formatters.usd`. An amount with real cents
falls back to full formatting, and `FittedBox` shrinks an unexpectedly large
figure rather than overflowing.

The row is wrapped in `IntrinsicHeight` so the cards can stretch to match each
other. A bare `CrossAxisAlignment.stretch` row inside the scrolling column
asks for infinite height and throws; this was a real bug caught by the page
test.

### Call to action

The design draws a blue gradient with a blue glow beneath, so this is a
decorated `Container` with its own `InkWell` rather than a themed
`FilledButton` — a filled button cannot produce a gradient without faking it,
and the glow is part of the design rather than a state effect.

The reference shows a duplicated `+` before the label, which is a mock artefact.
One icon is used.

### Recent invoices

Section heading plus "See all", then one `HomeInvoiceTile` per invoice. Each
tile is an `AppCard` with the client name and `INV-0042 • Due May 18` on the
left and the amount above the status pill on the right. The client column is
`Expanded` with ellipsis so long names truncate instead of pushing the amount
off the card.

Tiles carry 5dp of vertical padding each, which produces the 10dp gap between
cards without double-counting padding at the list edges.

### Bottom navigation

Four tabs with `Ionicons.grid`, `receipt_outline`, `people_outline` and
`settings_outline`. Home is active in `AppColors.primary`, the rest in
`AppColors.navInactive`. The bar is the scaffold's `bottomNavigationBar`, so it
stays put while the content scrolls.

It is decorative: every tab's `onTap` is a no-op and Home stays selected. Tabs
use `Expanded` so the four share the bar equally and labels ellipsize on a
narrow phone or at a large text scale.

## Deliberate choices worth knowing

**Money formatting is hand-rolled.** `Formatters` inserts its own thousands
separators rather than depending on `intl`, to avoid adding a dependency for
grouping and a currency symbol. The sign goes before the symbol (`-$2,450.00`).

**Layouts do not depend on font metrics.** Widget tests substitute a font where
every glyph is the same width, which is far wider than Quicksand, and text
overflow errors surfaced immediately. Every variable-width piece of text is
`Expanded`/`Flexible` with an ellipsis or a `FittedBox`. This is worth having
regardless of tests: it is what keeps the screen intact at large text scales
and with longer translations.

## Tests

```
test/core/utils/formatters_test.dart
test/core/widgets/app_card_test.dart
test/core/widgets/app_progress_segments_test.dart
test/features/home/presentation/pages/home_page_test.dart
test/features/home/presentation/widgets/home_greeting_header_test.dart
test/features/home/presentation/widgets/home_total_card_test.dart
test/features/home/presentation/widgets/home_status_summary_test.dart
test/features/home/presentation/widgets/home_invoice_tile_test.dart
test/features/home/presentation/widgets/home_status_pill_test.dart
test/features/home/presentation/widgets/home_bottom_nav_test.dart
test/app/router/app_router_test.dart
```

Notable coverage: the bar's slice widths are asserted against the status
amounts as fractions; the page is pumped at 320x568, 360x800, 834x1112 and
1400x900 to catch overflows and confirm the width cap centres; the bottom nav
test pins the decorative behaviour so it fails loudly when tabs become real;
and the router test asserts `/home` serves `HomePage` rather than a
placeholder.

## Known gaps

These are deliberate and out of scope for this increment:

- **Data is hardcoded.** `HomeSampleData` holds the figures from the design.
  Everything the screen needs is funnelled through that one file so replacing it
  with a repository is a single-file deletion plus a provider.
- **No domain or data layer.** With static figures there is nothing for a
  repository to abstract; that arrives with the Invoices feature.
- **The bottom nav does not navigate.** See above.
- **"New Invoice" has no action**, and "See all" has no action.
- **The greeting is not time-aware** and always says "Good morning".
- **No entrance animations**, by choice, so the screen can be compared directly
  against the reference.
- **No loading, empty or error states.** The screen renders a populated
  dashboard; those need the real data source to be meaningful.
