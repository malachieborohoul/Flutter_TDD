// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:tdd_tutorial/core/usecase/usecase.dart';
import 'package:tdd_tutorial/core/utils/typedef.dart';
import 'package:tdd_tutorial/features/authentication/domain/repositories/authentication_repository.dart';

class CreateUser extends UsecaseWithParams<void, CreateUserParams> {
  final AuthenticationRepository _repository;

  CreateUser(this._repository);

  @override
  ResultFuture call(params) async => _repository.createUser(
      createdAt: params.createdAt, name: params.name, avatar: params.avatar);
}

class CreateUserParams extends Equatable {
  final String createdAt;
  final String name;
  final String avatar;
  const CreateUserParams({
    required this.createdAt,
    required this.name,
    required this.avatar,
  });
  const CreateUserParams.empty()
      : this(
            createdAt: '_empty.createdAt',
            name: '_empty.name',
            avatar: '_empty.avatar');
  @override
  List<Object?> get props => [createdAt, name, avatar];
}
