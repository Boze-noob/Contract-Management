import 'dart:async';
import 'package:contract_management/_all.dart';

class CurrentUserBloc extends Bloc<CurrentUserEvent, CurrentUserState> {
  IAccount accountRepo;
  late StreamSubscription authStreamSubscription;
  CurrentUserBloc({
    required this.accountRepo,
    required AuthBloc authBloc,
  }) : super(initialState()) {
    on<CurrentUserGetEvent>(_get);
    on<CurrentUserInitEvent>(_init);
    authStreamSubscription = authBloc.stream.listen((state) {
      if (state.status == AuthStateStatus.Authenticated) {
        add(CurrentUserGetEvent());
      }
    });
  }

  static CurrentUserState initialState() => CurrentUserState(
        status: CurrentUserStateStatus.init,
      );

  void _get(CurrentUserGetEvent event, Emitter<CurrentUserState> emit) async {
    emit(
      state.copyWith(
        status: CurrentUserStateStatus.getting,
      ),
    );
    final UserModel? userModel = await accountRepo.getUserFromDatabase();
    if (userModel != null) {
      emit(
        state.copyWith(
          userModel: userModel,
          status: CurrentUserStateStatus.success,
        ),
      );
    } else {
      emit(state.copyWith(
        status: CurrentUserStateStatus.error,
      ));
    }
  }

  void _init(CurrentUserInitEvent event, Emitter<CurrentUserState> emit) {
    initialState();
  }

  @override
  Future<void> close() {
    authStreamSubscription.cancel();
    return super.close();
  }
}