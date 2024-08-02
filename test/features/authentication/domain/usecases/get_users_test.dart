import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_tutorial/features/authentication/domain/entities/user.dart';
import 'package:tdd_tutorial/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:tdd_tutorial/features/authentication/domain/usecases/get_users.dart';

import 'authentication_repository.mock.dart';

void main() {
  late AuthenticationRepository repository;
  late GetUsers usecase;
  const tResponse = [User.empty()];

  setUp(() {
    repository = MockAuthenticationRepository();
    usecase = GetUsers(repository);
  });

  test('should call [Repository.getUsers] and return [List<User>]', () async {
    //Arrange
    when(() => repository.getUsers()).thenAnswer(
      (_) async => const Right(
        tResponse,
      ),
    );
    //Act

    final result = await usecase();
    //Assert

    expect(
      result,
      equals(
        const Right<dynamic, List<User>>(tResponse),
      ),
    );

    verify(() => repository.getUsers()).called(1);

    verifyNoMoreInteractions(repository);
  });
}
