// ignore_for_file: prefer_const_constructors
import 'package:test/test.dart';
import 'package:type_mapper/type_mapper.dart';

void main() {
  group('TypeMapper', () {
    tearDown(TypeMapper.I.reset);

    group('TypeMapNotRegistered', () {
      test('should return correct message', () {
        expect(
          TypeMapNotRegistered<int, String>().toString(),
          equals('A type mapping does not exist for int -> String'),
        );
      });
    });

    group('TypeMapAlreadyRegistered', () {
      test('should return correct message', () {
        expect(
          TypeMapAlreadyRegistered<int, String>().toString(),
          equals('A type mapping already exists for int -> String'),
        );
      });
    });

    test('should always return the same instance', () {
      expect(TypeMapper.instance, equals(TypeMapper.instance));
      expect(TypeMapper.I, equals(TypeMapper.I));
    });

    group('isRegistered', () {
      test('should return true when mapping exists', () {
        TypeMapper.I.registerMapping<int, String>(
          (source) => source.toString(),
        );

        expect(TypeMapper.I.isRegistered<int, String>(), isTrue);
      });

      test('should return false when mapping does not exist', () {
        expect(TypeMapper.I.isRegistered<int, String>(), isFalse);
      });
    });

    group('registerMapping', () {
      test('should throw error when mapping is already registered', () {
        TypeMapper.I.registerMapping<int, String>(
          (source) => source.toString(),
        );

        expect(
          () => TypeMapper.I.registerMapping<int, String>(
            (source) => source.toString(),
          ),
          throwsA(isA<TypeMapAlreadyRegistered<int, String>>()),
        );
      });

      test('should throw error when mapping is not registered', () {
        expect(
          () => TypeMapper.I.map<int, String>(1),
          throwsA(isA<TypeMapNotRegistered<int, String>>()),
        );
      });
    });

    group('map', () {
      test('should map source to destination type', () {
        TypeMapper.I.registerMapping<int, String>(
          (source) => source.toString(),
        );

        expect(TypeMapper.I.map<int, String>(2), equals('2'));
      });
    });

    group('reset', () {
      test('should clear all registrations', () {
        TypeMapper.I.registerMapping<int, String>(
          (source) => source.toString(),
        );

        expect(TypeMapper.I.isRegistered<int, String>(), isTrue);

        TypeMapper.I.reset();

        expect(TypeMapper.I.isRegistered<int, String>(), isFalse);
      });
    });
  });
}
