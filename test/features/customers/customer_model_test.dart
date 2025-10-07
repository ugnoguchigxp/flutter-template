import 'package:flutter_template/src/features/customers/data/customer_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Customer', () {
    test('creates instance with required fields', () {
      final renewalDate = DateTime(2024, 12, 31);
      final customer = Customer(
        id: 'test-id',
        companyName: 'Test Company',
        contactName: 'John Doe',
        email: 'john@test.com',
        industry: 'Technology',
        seats: 100,
        renewalDate: renewalDate,
      );

      expect(customer.id, 'test-id');
      expect(customer.companyName, 'Test Company');
      expect(customer.contactName, 'John Doe');
      expect(customer.email, 'john@test.com');
      expect(customer.industry, 'Technology');
      expect(customer.seats, 100);
      expect(customer.renewalDate, renewalDate);
      expect(customer.notes, isNull);
    });

    test('creates instance with notes', () {
      final customer = Customer(
        id: 'test-id',
        companyName: 'Test Company',
        contactName: 'John Doe',
        email: 'john@test.com',
        industry: 'Technology',
        seats: 100,
        renewalDate: DateTime(2024, 12, 31),
        notes: 'Important client',
      );

      expect(customer.notes, 'Important client');
    });

    test('fromJson creates valid Customer', () {
      final json = {
        'id': 'json-id',
        'companyName': 'JSON Company',
        'contactName': 'Jane Smith',
        'email': 'jane@json.com',
        'industry': 'Finance',
        'seats': 50,
        'renewalDate': '2024-12-31T00:00:00.000',
        'notes': 'Test note',
      };

      final customer = Customer.fromJson(json);

      expect(customer.id, 'json-id');
      expect(customer.companyName, 'JSON Company');
      expect(customer.contactName, 'Jane Smith');
      expect(customer.email, 'jane@json.com');
      expect(customer.industry, 'Finance');
      expect(customer.seats, 50);
      expect(customer.renewalDate, DateTime.parse('2024-12-31T00:00:00.000'));
      expect(customer.notes, 'Test note');
    });

    test('toJson creates valid JSON', () {
      final renewalDate = DateTime(2024, 12, 31);
      final customer = Customer(
        id: 'test-id',
        companyName: 'Test Company',
        contactName: 'John Doe',
        email: 'john@test.com',
        industry: 'Technology',
        seats: 100,
        renewalDate: renewalDate,
        notes: 'Important',
      );

      final json = customer.toJson();

      expect(json['id'], 'test-id');
      expect(json['companyName'], 'Test Company');
      expect(json['contactName'], 'John Doe');
      expect(json['email'], 'john@test.com');
      expect(json['industry'], 'Technology');
      expect(json['seats'], 100);
      expect(json['renewalDate'], renewalDate.toIso8601String());
      expect(json['notes'], 'Important');
    });

    test('copyWith creates new instance with updated fields', () {
      final customer = Customer(
        id: 'test-id',
        companyName: 'Test Company',
        contactName: 'John Doe',
        email: 'john@test.com',
        industry: 'Technology',
        seats: 100,
        renewalDate: DateTime(2024, 12, 31),
      );

      final updated = customer.copyWith(
        companyName: 'Updated Company',
        seats: 200,
      );

      expect(updated.id, customer.id);
      expect(updated.companyName, 'Updated Company');
      expect(updated.contactName, customer.contactName);
      expect(updated.email, customer.email);
      expect(updated.industry, customer.industry);
      expect(updated.seats, 200);
      expect(updated.renewalDate, customer.renewalDate);
    });

    test('equality works correctly', () {
      final renewalDate = DateTime(2024, 12, 31);
      final customer1 = Customer(
        id: 'test-id',
        companyName: 'Test Company',
        contactName: 'John Doe',
        email: 'john@test.com',
        industry: 'Technology',
        seats: 100,
        renewalDate: renewalDate,
      );

      final customer2 = Customer(
        id: 'test-id',
        companyName: 'Test Company',
        contactName: 'John Doe',
        email: 'john@test.com',
        industry: 'Technology',
        seats: 100,
        renewalDate: renewalDate,
      );

      final customer3 = customer1.copyWith(companyName: 'Different Company');

      expect(customer1, customer2);
      expect(customer1, isNot(customer3));
      expect(customer1.hashCode, customer2.hashCode);
    });
  });
}
