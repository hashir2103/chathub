enum UserState {
  Offline,
  Online,
  Waiting,
}

int stateToNum(UserState userState) {
  switch (userState) {
    case UserState.Offline:
      return 0;

    case UserState.Online:
      return 1;

    default:
      return 2;
  }
}

UserState numToState(int number) {
  switch (number) {
    case 0:
      return UserState.Offline;

    case 1:
      return UserState.Online;

    default:
      return UserState.Waiting;
  }
}
