import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_template/src/features/customers/data/customer_model.dart';
import 'package:flutter_template/src/features/customers/data/customer_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CustomerCollectionNotifier', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('build returns initial list of customers', () {
      final customers = container.read(customerCollectionProvider);

      expect(customers, isA<List<Customer>>());
      expect(customers.length, 2);
      expect(customers[0].companyName, 'Acme Robotics');
      expect(customers[0].contactName, 'Hina Suzuki');
      expect(customers[0].email, 'hina.suzuki@acmerobotics.jp');
      expect(customers[0].industry, 'Manufacturing');
      expect(customers[0].seats, 420);
      expect(
        customers[0].notes,
        'Upsell opportunity: predictive maintenance module.',
      );

      expect(customers[1].companyName, 'Aether Logistics');
      expect(customers[1].contactName, 'Marcus Lee');
      expect(customers[1].email, 'marcus.lee@aetherlogistics.com');
      expect(customers[1].industry, 'Transportation');
      expect(customers[1].seats, 180);
      expect(customers[1].notes, 'At risk, require SLA review.');
    });

    test('initial customers have valid renewal dates', () {
      final customers = container.read(customerCollectionProvider);
      final now = DateTime.now();

      expect(
        customers[0].renewalDate.isAfter(now.add(const Duration(days: 89))),
        isTrue,
      );
      expect(
        customers[0].renewalDate.isBefore(now.add(const Duration(days: 91))),
        isTrue,
      );

      expect(
        customers[1].renewalDate.isAfter(now.add(const Duration(days: 31))),
        isTrue,
      );
      expect(
        customers[1].renewalDate.isBefore(now.add(const Duration(days: 33))),
        isTrue,
      );
    });

    test('add appends new customer to list', () {
      final notifier = container.read(customerCollectionProvider.notifier);
      final initialCustomers = container.read(customerCollectionProvider);

      final newCustomer = Customer(
        id: 'new-id',
        companyName: 'New Company',
        contactName: 'Alice Johnson',
        email: 'alice@newcompany.com',
        industry: 'Software',
        seats: 50,
        renewalDate: DateTime.now().add(const Duration(days: 365)),
      );

      notifier.add(newCustomer);

      final updatedCustomers = container.read(customerCollectionProvider);
      expect(updatedCustomers.length, initialCustomers.length + 1);
      expect(updatedCustomers.last, newCustomer);
      expect(updatedCustomers.last.companyName, 'New Company');
      expect(updatedCustomers.last.contactName, 'Alice Johnson');
    });

    test('add multiple customers increases list size', () {
      final notifier = container.read(customerCollectionProvider.notifier);

      final customer1 = Customer(
        id: 'id-1',
        companyName: 'Company 1',
        contactName: 'Contact 1',
        email: 'contact1@company1.com',
        industry: 'Industry 1',
        seats: 10,
        renewalDate: DateTime.now().add(const Duration(days: 100)),
      );

      final customer2 = Customer(
        id: 'id-2',
        companyName: 'Company 2',
        contactName: 'Contact 2',
        email: 'contact2@company2.com',
        industry: 'Industry 2',
        seats: 20,
        renewalDate: DateTime.now().add(const Duration(days: 200)),
      );

      notifier.add(customer1);
      notifier.add(customer2);

      final customers = container.read(customerCollectionProvider);
      expect(customers.length, 4);
      expect(customers[2], customer1);
      expect(customers[3], customer2);
    });

    test('add does not modify original list', () {
      final notifier = container.read(customerCollectionProvider.notifier);
      final initialCustomers = container.read(customerCollectionProvider);
      final initialLength = initialCustomers.length;

      final newCustomer = Customer(
        id: 'test-id',
        companyName: 'Test',
        contactName: 'Test',
        email: 'test@test.com',
        industry: 'Test',
        seats: 1,
        renewalDate: DateTime.now(),
      );

      notifier.add(newCustomer);

      // Original list should still have same length (immutability check)
      expect(initialCustomers.length, initialLength);
    });
  });

  group('draftCustomerProvider', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('provides draft customer with empty fields', () {
      final draftCustomer = container.read(draftCustomerProvider);

      expect(draftCustomer.id, isNotEmpty);
      expect(draftCustomer.companyName, isEmpty);
      expect(draftCustomer.contactName, isEmpty);
      expect(draftCustomer.email, isEmpty);
      expect(draftCustomer.industry, isEmpty);
      expect(draftCustomer.seats, 1);
      expect(draftCustomer.notes, isEmpty);
    });

    test('draft customer has renewal date one year from now', () {
      final draftCustomer = container.read(draftCustomerProvider);
      final now = DateTime.now();
      final expectedDate = now.add(const Duration(days: 365));

      expect(
        draftCustomer.renewalDate.difference(expectedDate).inHours.abs(),
        lessThan(1),
      );
    });

    test('generates unique IDs for draft customers', () {
      final container1 = ProviderContainer();
      final container2 = ProviderContainer();

      final draft1 = container1.read(draftCustomerProvider);
      final draft2 = container2.read(draftCustomerProvider);

      expect(draft1.id, isNot(draft2.id));

      container1.dispose();
      container2.dispose();
    });
  });
}
