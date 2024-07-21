import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_tutorial/features/authentication/domain/entities/user.dart';
import 'package:tdd_tutorial/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:tdd_tutorial/features/authentication/domain/usecases/get_users.dart';

import 'authentication_repository.mock.dart';

void main() {
  late GetUsers usecase;
  late AuthenticationRepository repository;

  setUp(() {
    repository = MockAuthenticationRepository();
    usecase = GetUsers(repository);
  });

  final tResponse = [const User.empty()];

  test(
      'should call [AuthenticationRepository.getUsers] and return [List<User>]',
      () async {
    // Arrange
    when(() => repository.getUsers()).thenAnswer((_) async =>  Right(tResponse));

    // Act
    final result = await usecase();

    expect(result, equals( Right<dynamic, List<User>>(tResponse)));

    verify(() => repository.getUsers()).called(1);

    verifyNoMoreInteractions(repository);
  });
}
