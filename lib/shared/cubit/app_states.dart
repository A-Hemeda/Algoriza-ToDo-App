abstract class AppStates {}

class AppInitialState extends AppStates {}

class AppChangeBootomNavBarState extends AppStates {}

class AppSetCheckedSuccess extends AppStates {
  final bool value;

  AppSetCheckedSuccess(this.value);
}

class AppCreateDatabaseLoading extends AppStates {}

class AppCreateDatabaseSuccess extends AppStates {}

class AppCreateDatabaseError extends AppStates {
  final String error;

  AppCreateDatabaseError(this.error);
}

class AppInitDatabaseLoadingState extends AppStates {}

class AppInitDatabaseSuccess extends AppStates {}

class AppInitDatabaseError extends AppStates {
  final String error;

  AppInitDatabaseError(this.error);
}

class AppInsertDatabaseLoadingState extends AppStates {}

class AppInsertDatabaseSuccessfulState extends AppStates {}

class AppInsertDatabaseErrorState extends AppStates {
  final String error;

  AppInsertDatabaseErrorState(this.error);
}

class AppUpdateTaskStatusLoadingState extends AppStates {}

class AppUpdateTaskStatusSuccessfulState extends AppStates {}

class AppUpdateTaskStatusErrorState extends AppStates {
  final String error;

  AppUpdateTaskStatusErrorState(this.error);
}

class AppUpdateDatabaseLoadingState extends AppStates {}

class AppUpdateDatabaseSuccessfulState extends AppStates {}

class AppUpdateDatabaseErrorState extends AppStates {
  final String error;

  AppUpdateDatabaseErrorState(this.error);
}

class AppSetFavLoadingState extends AppStates {}

class AppSetFavSuccessfulState extends AppStates {}

class AppSetFavErrorState extends AppStates {
  final String error;

  AppSetFavErrorState(this.error);
}

class AppDeleteDatabaseState extends AppStates {}

class AppGetDatabaseLoadingState extends AppStates {}

class AppGetDatabaseSuccessfulState extends AppStates {}

class AppGetDatabaseErrorState extends AppStates {
  final String error;

  AppGetDatabaseErrorState(this.error);
}

class AppDeleteTaskLoadingState extends AppStates {}

class AppDeleteTaskSuccessfulState extends AppStates {}

class AppDeleteTaskErrorState extends AppStates {
  final String error;

  AppDeleteTaskErrorState(this.error);
}

class AppChangeColorStates extends AppStates {}

class AppChangeDateStates extends AppStates {}
