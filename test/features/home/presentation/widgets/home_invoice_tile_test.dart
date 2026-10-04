import 'package:app_prototype/features/home/presentation/widgets/home_invoice_tile.dart';
import 'package:app_prototype/features/home/presentation/widgets/home_sample_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(HomeInvoice invoice) {
  return MaterialApp(home: Scaffold(body: HomeInvoiceTile(invoice: invoice)));
}

const _acme = HomeInvoice(
  clientName: 'Acme Studios',
  invoiceNumber: 'INV-0042',
  dueDate: 'May 18',
  amount: 3200,
  status: InvoiceStatus.pending,
);

void main() {
  testWidgets('shows client, reference, due date and amount', (tester) async {
    await tester.pumpWidget(_host(_acme));
    await tester.pumpAndSettle();

    expect(find.text('Acme Studios'), findsOneWidget);
    expect(find.text('INV-0042 • Due May 18'), findsOneWidget);
    expect(find.text(r'$3,200.00'), findsOneWidget);
  });

  testWidgets('shows cents on the amount', (tester) async {
    await tester.pumpWidget(
      _host(
        const HomeInvoice(
          clientName: 'Acme Studios',
          invoiceNumber: 'INV-0042',
          dueDate: 'May 18',
          amount: 3200.5,
          status: InvoiceStatus.pending,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(r'$3,200.50'), findsOneWidget);
  });

  testWidgets('renders the status from the invoice', (tester) async {
    await tester.pumpWidget(_host(_acme));
    await tester.pumpAndSettle();

    expect(find.text('Pending'), findsOneWidget);
  });

  testWidgets('truncates a long client name instead of overflowing', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        const HomeInvoice(
          clientName: 'Bartholomew Featherstonehaugh Consulting Partners',
          invoiceNumber: 'INV-0042',
          dueDate: 'May 18',
          amount: 3200,
          status: InvoiceStatus.pending,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.textContaining('Bartholomew'), findsOneWidget);
  });

  testWidgets('truncates a long metadata line instead of overflowing', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        const HomeInvoice(
          clientName: 'Acme Studios',
          invoiceNumber: 'INV-0042-EXTENDED-REFERENCE',
          dueDate: 'May 18th, sometime in the afternoon',
          amount: 3200,
          status: InvoiceStatus.pending,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });
}
