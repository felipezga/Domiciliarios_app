import 'package:domiciliarios_app/Modelo/PerfilUsuarioModel.dart';
import 'package:domiciliarios_app/Servicios/PerfilUsuarioServicio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ProfileEvent {}

class GetUser extends ProfileEvent {
  final String userName;
  GetUser(this.userName);
}

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final PerfilUserRepository profileRepo;
  ProfileBloc({this.profileRepo}) : super(ProfileInitial());

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    // TODO: implement mapEventToState
    try {
      if (event is GetUser) {
        yield (ProfileLoading());
        final profile = await profileRepo.fetchUser(event.userName);
        print(profile);
        yield (ProfileLoaded(profile));
      }
    } on UserNotFoundException {
      yield (ProfileError('This User was Not Found!'));
    }
  }
}

abstract class ProfileState {
  const ProfileState();
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileLoaded extends ProfileState {
  final PerfilUser profile;
  const ProfileLoaded(this.profile);
}

class ProfileError extends ProfileState {
  final String error;
  const ProfileError(this.error);
}
