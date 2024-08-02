import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tdd_tutorial/core/utils/typedef.dart';
import 'package:tdd_tutorial/features/authentication/data/models/user_model.dart';
import 'package:tdd_tutorial/features/authentication/domain/entities/user.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tModel = UserModel.empty();
  test('should be a subclass of [User] entity', () {
    //Arrange
    //Assert
    expect(tModel, isA<User>());
  });
  final tJson = fixture('user.json');
  final tMap = jsonDecode(tJson) as DataMap;

  group('fromMap', () {
    test('should return a [UserModel] with the right data', () {
      //Arrange

      //Act
      final result = UserModel.fromMap(tMap);
      //Assert
      expect(result, equals(tModel));
    });
  });

  group('fromJson', () {
    test('should return a [UserModel] with the right data', () {
      //Arrange
      //Act
      final result = UserModel.fromJson(tJson);
      //Assert
      expect(result, equals(tModel));
    });
  });

  group('toMap', () {
    test('should return a [Map] with the right data ', () {
      //Arrange
      //Act
      final result = tModel.toMap();
      //Assert
      expect(result, tMap);
    });
  });

  group('toJson', () {
    test('should return a [Json] with the right data', () {
      final result = tModel.toJson();

      final tJson = jsonEncode({
        "id": "1",
        "createdAt": "_empty.createdAt",
        "name": "_empty.name",
        "avatar": "_empty.avatar"
      });

      expect(result, tJson);
    });
  });

  group('copyWith', () {
    test('should return a [UserModel] with different data', () {
      final result = tModel.copyWith(id: "2");

      expect(result.id, equals("2"));
    });
  });
}
