import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'customer_model.dart';

const _uuid = Uuid();

final customerCollectionProvider =
    NotifierProvider<CustomerCollectionNotifier, List<Customer>>(
      CustomerCollectionNotifier.new,
    );

class CustomerCollectionNotifier extends Notifier<List<Customer>> {
  @override
  List<Customer> build() {
    return [
      Customer(
        id: _uuid.v4(),
        companyName: 'Acme Robotics',
        contactName: 'Hina Suzuki',
        email: 'hina.suzuki@acmerobotics.jp',
        industry: 'Manufacturing',
        seats: 420,
        renewalDate: DateTime.now().add(const Duration(days: 90)),
        notes: 'Upsell opportunity: predictive maintenance module.',
      ),
      Customer(
        id: _uuid.v4(),
        companyName: 'Aether Logistics',
        contactName: 'Marcus Lee',
        email: 'marcus.lee@aetherlogistics.com',
        industry: 'Transportation',
        seats: 180,
        renewalDate: DateTime.now().add(const Duration(days: 32)),
        notes: 'At risk, require SLA review.',
      ),
    ];
  }

  void add(Customer customer) {
    state = [...state, customer];
  }
}

final draftCustomerProvider = Provider<Customer>((ref) {
  return Customer(
    id: _uuid.v4(),
    companyName: '',
    contactName: '',
    email: '',
    industry: '',
    seats: 1,
    renewalDate: DateTime.now().add(const Duration(days: 365)),
    notes: '',
  );
});
