import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

// Events
abstract class PaymentEvent extends Equatable {
  const PaymentEvent();
}

class ChangePayment extends PaymentEvent {
  final int index;

  ChangePayment(this.index);

  @override
  List<Object?> get props => [index];
}

// States
class PaymentState extends Equatable {
  final int index;

  const PaymentState(this.index);

  @override
  List<Object?> get props => [index];
}

// Bloc
class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  PaymentBloc() : super(PaymentState(0));

  @override
  Stream<PaymentState> mapEventToState(PaymentEvent event) async* {
    if (event is ChangePayment) {
      yield PaymentState(event.index);
    }
  }
}

void main() {
  final PaymentBloc bloc = PaymentBloc();

  bloc.add(ChangePayment(1)); // Example of triggering a state change

  bloc.stream.listen((state) {
    print('Current Index: ${state.index}');
  });
}
