import 'package:flutter_riverpod/legacy.dart';

final speechRateProvider = StateProvider<double>((ref) => 0.5);
final pitchProvider = StateProvider<double>((ref) => 1.0);
final volumeProvider = StateProvider<double>((ref) => 1.0);
