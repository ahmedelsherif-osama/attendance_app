import 'package:attendance/src/attendance/domain/entities/bus_route.dart';
import 'package:attendance/src/attendance/domain/entities/school.dart';
import 'package:attendance/src/attendance/domain/entities/student.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum HomePageStateEnum { Home, Attendance, Manage }

class HomePageState extends Equatable {
  HomePageStateEnum homePageStateEnum = HomePageStateEnum.Home;
  HomePageState({required this.homePageStateEnum});

  HomePageState copyWith({
    HomePageStateEnum? homePageStateEnum,
  }) {
    return HomePageState(
      homePageStateEnum: homePageStateEnum ?? this.homePageStateEnum,
    );
  }

  @override
  List<Object?> get props => [homePageStateEnum];
}

class HomePageCubit extends Cubit<HomePageState> {
  HomePageCubit()
      : super(HomePageState(homePageStateEnum: HomePageStateEnum.Home));

  void updateHomePageState({
    HomePageStateEnum? homePageStateEnum,
  }) {
    emit(state.copyWith(homePageStateEnum: homePageStateEnum));
  }
}
