import 'dart:async';

class Debouncer {
  Debouncer({this.milliseconds = 500});

  final int milliseconds;

  Timer? _timer;

  //Call Function after specified duration
  run(void Function() action, {int? milliseconds}) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds ?? this.milliseconds), action);
  }
}
