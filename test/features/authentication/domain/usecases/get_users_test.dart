import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_tutorial/features/authentication/domain/entities/user.dart';
import 'package:tdd_tutorial/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:tdd_tutorial/features/authentication/domain/usecases/get_users.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

void main() {
  late AuthenticationRepository repository;
  late GetUsers usecase;

  setUp(() {
    repository = MockAuthenticationRepository();
    usecase = GetUsers(repository);
  });

  test('should call [Repository.getUsers]', () async {
    //Arrange
    when(() => repository.getUsers()).thenAnswer(
      (_) async => const Right(
        [User.empty()],
      ),
    );
    //Act

    final result = await usecase();
    //Assert

    expect(result, equals(const Right<dynamic, List<User>>([User.empty()])));
  });
}
