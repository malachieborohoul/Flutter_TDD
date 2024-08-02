import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_tutorial/features/authentication/data/datasources/authentication_remote_data_source.dart';
import 'package:tdd_tutorial/features/authentication/data/repositories/authentication_repository_implementation.dart';

class MockAuthenticationRemoteDataSource extends Mock
    implements AuthenticationRemoteDataSource {}

void main() {
  late AuthenticationRemoteDataSource remoteDataSource;
  late AuthenticationRepositoryImplementation repositoryImplementation;
  setUp(() {
    remoteDataSource = MockAuthenticationRemoteDataSource();
    repositoryImplementation =
        AuthenticationRepositoryImplementation(remoteDataSource);
  });

  group('createUser', () {
    test(
        'should call the [RemoteDataSource.createUser] and complete '
        'successfully when the call to the remote source is successful ',
        () async {
      //Arrange
      when(() => remoteDataSource.createUser(
              createdAt: any(named: 'createdAt'),
              name: any(named: 'name'),
              avatar: any(named: 'avatar')))
          .thenAnswer((_) async => Future.value());

      const createdAt = 'createdAt';
      const name = 'name';
      const avatar = 'avatar';
      //Act
      final result = await repositoryImplementation.createUser(
          createdAt: createdAt, name: name, avatar: avatar);
      //Assert

      expect(result, equals(const Right(null)));

      verify(() => remoteDataSource.createUser(
          createdAt: createdAt, name: name, avatar: avatar)).called(1);

      verifyNoMoreInteractions(remoteDataSource);
    });
  });
}
