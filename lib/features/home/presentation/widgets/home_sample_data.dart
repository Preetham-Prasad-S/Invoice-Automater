/// Presentation-layer stand-in for the data the home dashboard renders.
///
/// Kept as constants here on purpose: this increment is about reproducing the
/// reference screen, and wiring the real repository belongs to the Invoices
/// feature. Everything the dashboard needs is funnelled through this one file
/// so that swapping in a repository later is a single-file deletion plus a
/// provider, rather than an edit to every widget.
///
/// The invoice figures below are copied verbatim from
/// `ui_refrerence/screens/home_screen.png`.
library;

/// How an invoice is doing, which drives every colour and label on the screen.
enum InvoiceStatus { paid, pending, overdue }

/// One row of the "Recent Invoices" list.
class HomeInvoice {
  const HomeInvoice({
    required this.clientName,
    required this.invoiceNumber,
    required this.dueDate,
    required this.amount,
    required this.status,
  });

  final String clientName;

  /// Human-readable invoice reference, e.g. `INV-0042`. Not a number because
  /// it carries a prefix and leading zeros that must survive formatting.
  final String invoiceNumber;

  /// Pre-formatted due date, e.g. `May 18`. Kept as text rather than a
  /// [DateTime] until there is a real source to parse, so the screen does not
  /// have to invent a year for a value the design never showed.
  final String dueDate;

  final double amount;
  final InvoiceStatus status;
}

/// The figures and copy the dashboard is currently hardcoded to show.
abstract final class HomeSampleData {
  /// Amount invoiced but not yet collected.
  static const double paid = 19820;

  /// Amount invoiced and awaiting payment.
  static const double pending = 6180;

  /// Amount invoiced past its due date.
  static const double overdue = 2450;

  /// Sum of the three statuses above, shown as the hero figure.
  ///
  /// Declared rather than summed at build time so the hero total and the
  /// segmented bar cannot drift apart; [totalOf] asserts the relationship in
  /// tests.
  static const double totalInvoiced = 28450;

  /// Month-on-month growth shown in the trend badge, as a percentage.
  static const double trendPercent = 12;

  /// First name, shown in the greeting: "Good morning, Alex".
  static const String userName = 'Alex';

  /// Avatar initials. Not derivable from [userName] — the design pairs the
  /// first name "Alex" with the initials "AL", which implies a surname the
  /// greeting never shows.
  static const String userInitials = 'AL';

  /// Most recent invoices, newest first.
  static const List<HomeInvoice> recentInvoices = [
    HomeInvoice(
      clientName: 'Acme Studios',
      invoiceNumber: 'INV-0042',
      dueDate: 'May 18',
      amount: 3200,
      status: InvoiceStatus.pending,
    ),
    HomeInvoice(
      clientName: 'Linear Labs',
      invoiceNumber: 'INV-0041',
      dueDate: 'May 12',
      amount: 5400,
      status: InvoiceStatus.paid,
    ),
    HomeInvoice(
      clientName: 'Pulse Agency',
      invoiceNumber: 'INV-0040',
      dueDate: 'Apr 28',
      amount: 1850,
      status: InvoiceStatus.overdue,
    ),
    HomeInvoice(
      clientName: 'Supabase Inc',
      invoiceNumber: 'INV-0039',
      dueDate: 'May 02',
      amount: 4120,
      status: InvoiceStatus.paid,
    ),
  ];

  /// Total of the three status amounts, which is what the segmented bar
  /// normalises against.
  static double totalOf({
    required double paid,
    required double pending,
    required double overdue,
  }) => paid + pending + overdue;
}
