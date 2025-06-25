import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mush_on/services/models.dart';
import '../test_helpers/mock_providers.mocks.dart';
import '../test_helpers/test_setup.dart';
import '../fake_dogs.dart';

void main() {
  group('MainProvider with Mockito', () {
    late MockMainProvider mockMainProvider;

    setUp(() {
      mockMainProvider = TestSetup.createMainProvider();
    });

    test('provides default empty dogs list', () {
      expect(mockMainProvider.dogs, isEmpty);
      expect(mockMainProvider.loaded, isTrue);
    });

    test('can be configured with test data', () {
      final dogsById = <String, Dog>{
        for (var dog in fakeDogs) dog.id: dog
      };
      
      mockMainProvider = TestSetup.createMainProvider(
        dogs: fakeDogs,
        dogsById: dogsById,
        loaded: true,
      );

      expect(mockMainProvider.dogs, hasLength(3));
      expect(mockMainProvider.dogs.first.name, 'Fido');
      expect(mockMainProvider.dogsById, containsPair('id_Fido', fakeDogs[0]));
      expect(mockMainProvider.loaded, isTrue);
    });

    test('can simulate loading states', () {
      mockMainProvider = TestSetup.createMainProvider(loaded: false);
      
      expect(mockMainProvider.loaded, isFalse);
    });

    test('allows verification of method calls', () {
      // Simulate a method call
      mockMainProvider.dogs;
      mockMainProvider.loaded;
      
      // Verify the getters were called
      verify(mockMainProvider.dogs).called(1);
      verify(mockMainProvider.loaded).called(1);
      verifyNoMoreInteractions(mockMainProvider);
    });

    test('can stub methods to return different values', () {
      // Initially returns empty list
      expect(mockMainProvider.dogs, isEmpty);
      
      // Change the stubbed behavior
      when(mockMainProvider.dogs).thenReturn(fakeDogs);
      
      // Now returns fake dogs
      expect(mockMainProvider.dogs, hasLength(3));
      expect(mockMainProvider.dogs.first.name, 'Fido');
    });
  });
}