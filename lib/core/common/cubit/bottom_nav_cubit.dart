// import 'package:flutter_bloc/flutter_bloc.dart';
//
// class BottomNavCubit extends Cubit<int> {
//   BottomNavCubit() : super(0); // default index is 0 (Home)
//
//   void setTab(int index) => emit(index);
// }
import 'package:flutter_bloc/flutter_bloc.dart';

class BottomNavCubit extends Cubit<int> {
  BottomNavCubit() : super(0);

  void setTab(int index) => emit(index);
}
