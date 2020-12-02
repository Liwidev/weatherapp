import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Current extends Equatable {
  final double tempc;
  final double tempf;
  final double windmph;
  final double windkph;
  final double pressuremb;
  final double pressurein;
  final int humidity;
  final double uv;

  Current({
    @required this.tempc,
    @required this.tempf,
    @required this.windmph,
    @required this.windkph,
    @required this.pressuremb,
    @required this.pressurein,
    @required this.humidity,
    @required this.uv,
  });

  @override
  List<Object> get props => [
        tempc,
        tempf,
        windmph,
        windkph,
        pressuremb,
        pressurein,
        humidity,
        uv,
      ];
}
