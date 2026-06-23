import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mush_on/customer_management/partners/models.dart';
import 'package:mush_on/customer_management/partners/repository.dart';

void main() {
  group('PartnersRepository', () {
    late FakeFirebaseFirestore db;
    late PartnersRepository repository;

    setUp(() {
      db = FakeFirebaseFirestore();
      repository = PartnersRepository(account: 'account-1', db: db);
    });

    Future<Map<String, dynamic>?> rawPartner(String id) async {
      final doc = await db
          .collection('accounts')
          .doc('account-1')
          .collection('data')
          .doc('bookingManager')
          .collection('partners')
          .doc(id)
          .get();
      return doc.data();
    }

    test('savePartner writes the id as a field and as the doc id', () async {
      const partner = Partner(
        id: 'partner-1',
        name: 'Acme Tours',
        code: 'acme',
        discountRate: 0.1,
        allowDeferred: true,
        deferredDays: 7,
      );

      await repository.savePartner(partner);

      final data = await rawPartner('partner-1');
      expect(data, isNotNull);
      expect(data!['id'], 'partner-1');
      expect(data['code'], 'acme');
      expect(data['allowDeferred'], true);
    });

    test('archivePartner sets archived without deleting the doc', () async {
      await repository.savePartner(const Partner(id: 'partner-1', code: 'acme'));

      await repository.archivePartner('partner-1');

      final data = await rawPartner('partner-1');
      expect(data, isNotNull, reason: 'partner must never be deleted');
      expect(data!['archived'], true);
    });

    test('fetchPartners returns all partners parsed into models', () async {
      await repository.savePartner(const Partner(id: 'a', code: 'alpha'));
      await repository.savePartner(
        const Partner(id: 'b', code: 'beta', archived: true),
      );

      final partners = await repository.fetchPartners();

      expect(partners.map((p) => p.id), containsAll(['a', 'b']));
      expect(partners.firstWhere((p) => p.id == 'b').archived, true);
    });
  });
}
</content>
