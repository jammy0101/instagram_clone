

import 'package:intl/intl.dart';

String formatDataByMMMYYYY(DateTime dateTime){

  return DateFormat('d,MMM,yyyy').format(dateTime);
}
