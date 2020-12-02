import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'current.dart';
import 'location.dart';

class Weather extends Equatable {
  final Location location;
  final Current current;

  Weather({@required this.location, @required this.current});

  @override
  List<Object> get props => [location, current];
}
