import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_tutorial/core/errors/exceptions.dart';
import 'package:tdd_tutorial/core/errors/failure.dart';
import 'package:tdd_tutorial/features/authentication/data/datasources/authentication_remote_data_source.dart';
import 'package:tdd_tutorial/features/authentication/data/models/user_model.dart';
import 'package:tdd_tutorial/features/authentication/data/repositories/authentication_repository_implementation.dart';
import 'package:tdd_tutorial/features/authentication/domain/repositories/authentication_repository.dart';

class MockAuthenticationRemoteDataSource extends Mock
    implements AuthenticationRemoteDataSource {}

void main() {
  late AuthenticationRemoteDataSource _remoteDataSource;
  late AuthenticationRepository repository;
  const createdAt = "createdAt";
  const name = "name";
  const avatar = "avatar";
  setUp(() {
    _remoteDataSource = MockAuthenticationRemoteDataSource();
    repository = AuthenticationRepositoryImplementation(_remoteDataSource);
  });

  const tException =
      APIException(message: 'Server error as occured', statusCode: 500);
  group('createUser', () {
    test(
        'should call [RemoteDataSource.createUser] and complete successfully '
        'when the call of remote data source is successful', () async {
      //Arrange
      when(() => _remoteDataSource.createUser(
              createdAt: any(named: 'createdAt'),
              name: any(named: 'name'),
              avatar: any(named: 'avatar')))
          .thenAnswer((_) async => Future.value());

      //Act

      final result = await repository.createUser(
          createdAt: createdAt, name: name, avatar: avatar);

      //Assert

      expect(result, equals(const Right(null)));

      verify(() => _remoteDataSource.createUser(
          createdAt: createdAt, name: name, avatar: avatar)).called(1);

      verifyNoMoreInteractions(_remoteDataSource);
    });

    test('should call [RemoteDatasource.createUser] and return Exception',
        () async {
      when(() => _remoteDataSource.createUser(
          createdAt: any(named: 'createdAt'),
          name: any(named: 'name'),
          avatar: any(named: 'avatar'))).thenThrow(tException);

      final result = await repository.createUser(
          createdAt: createdAt, name: name, avatar: avatar);

      expect(result, equals(Left(APIFailure.fromException(tException))));

      verify(() => _remoteDataSource.createUser(
          createdAt: createdAt, name: name, avatar: avatar)).called(1);

      verifyNoMoreInteractions(_remoteDataSource);
    });
  });

  group('getUsers', () {
    test('should call [RemoteDataSource.getUsers] and return [List<Users>]',
        () async {
      when(() => _remoteDataSource.getUsers())
          .thenAnswer((_) async => [const UserModel.empty()]);

      final result = await repository.getUsers();

      expect(result, isA<Right<Failure, List<UserModel>>>());
      //expect(result.getOrElse(() => []), equals([const UserModel.empty()]));

      verify(() => _remoteDataSource.getUsers()).called(1);

      verifyNoMoreInteractions(_remoteDataSource);
    });

    test('should return an [APIFailure] and if the call of the remote source is unsuccessfull',
        () async {
      when(() => _remoteDataSource.getUsers()).thenThrow(tException);

      final result = await repository.getUsers();

      expect(result, equals(Left(APIFailure.fromException(tException))));

      verify(() => _remoteDataSource.getUsers()).called(1);

      verifyNoMoreInteractions(_remoteDataSource);
    });
  });
}
