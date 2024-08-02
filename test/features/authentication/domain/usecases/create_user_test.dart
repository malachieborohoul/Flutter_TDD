import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_tutorial/features/authentication/domain/entities/user.dart';
import 'package:tdd_tutorial/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:tdd_tutorial/features/authentication/domain/usecases/create_user.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

void main() {
  late AuthenticationRepository repository;
  late CreateUser usecase;
  const params = CreateUserParams.empty();
  setUp(() {
    repository = MockAuthenticationRepository();
    usecase = CreateUser(repository);
  });

  test('should call [Repository.createUser]', () async {
    //Arrange
    when(() => repository.createUser(
            createdAt: any(named: 'createdAt'),
            name: any(named: 'name'),
            avatar: any(named: 'avatar')))
        .thenAnswer((_) async => const Right(null));
    //Act
    final result = await usecase(params);
    //Assert

    expect(result, equals(const Right<dynamic, void>(null)));

    verify(() => repository.createUser(
        createdAt: params.createdAt,
        name: params.name,
        avatar: params.avatar)).called(1);

    verifyNoMoreInteractions(repository);
  });
}
