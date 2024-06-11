part of 'fluttercon_bloc.dart';

abstract class FlutterconEvent extends Equatable {
  const FlutterconEvent();

  @override
  List<Object> get props => [];
}

class UserPreferencesChangeEvent extends FlutterconEvent {}

class InitializeAppEvent extends FlutterconEvent {}

class OnScrollToTopEvent extends FlutterconEvent {}

class OnDismissEvent extends FlutterconEvent {
  final bool isBeingDismissed;
  const OnDismissEvent(this.isBeingDismissed);
}

class OnFabToggle extends FlutterconEvent {
  final bool isFabOpen;
  const OnFabToggle(this.isFabOpen);
}

class OnFabSummonToggle extends FlutterconEvent {
  final bool isFabSummoned;
  const OnFabSummonToggle(this.isFabSummoned);
}

class OnAddAnonymousInstance extends FlutterconEvent {
  final String instance;
  const OnAddAnonymousInstance(this.instance);
}

class OnRemoveAnonymousInstance extends FlutterconEvent {
  final String instance;
  const OnRemoveAnonymousInstance(this.instance);
}

class OnSetCurrentAnonymousInstance extends FlutterconEvent {
  final String instance;
  const OnSetCurrentAnonymousInstance(this.instance);
}
