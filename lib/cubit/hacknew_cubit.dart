import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'hacknew_state.dart';

class HacknewCubit extends Cubit<HacknewState> {
  HacknewCubit() : super(HacknewInitial());
}
