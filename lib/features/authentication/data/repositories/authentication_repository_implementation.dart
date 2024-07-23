import 'package:dartz/dartz.dart';
import 'package:tdd_tutorial/core/utils/typedef.dart';
import 'package:tdd_tutorial/features/authentication/data/datasources/authentication_remote_data_source.dart';
import 'package:tdd_tutorial/features/authentication/domain/entities/user.dart';
import 'package:tdd_tutorial/features/authentication/domain/repositories/authentication_repository.dart';

class AuthenticationRepositoryImplementation
    implements AuthenticationRepository {
  final AuthenticationRemoteDataSource _remoteDataSource;
  const AuthenticationRepositoryImplementation(this._remoteDataSource);
  @override
  ResultVoid createUser(
      {required String createdAt,
      required String name,
      required String avatar}) async {
    // Test-Driven Development
    // Call the remote data source
    // Check if the method returns the proper data
    //    Check if when the remoteDataSource throws an exception, we return a failure
    // and if it doesn't throw and exception, we return the actual expected data
    await _remoteDataSource.createUser(
        createdAt: createdAt, name: name, avatar: avatar);

    return const Right(null);
  }

  @override
  ResultFuture<List<User>> getUsers() async {
    throw UnimplementedError();
  }
}
