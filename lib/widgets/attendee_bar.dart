import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped_models/main_model.dart';

class AttendeeAmountBar extends StatelessWidget {
  final int index;
  AttendeeAmountBar(this.index);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
        builder: (BuildContext context, Widget child, MainModel model) {
      double attendeeAmount =
          model.allEvents[index].attendees.length.toDouble() - 1;
      double attendeeLimit = model.allEvents[index].attendeeLimit.toDouble();
      double percent = attendeeAmount / attendeeLimit;

      return LinearPercentIndicator(
        width: 100.0,
        lineHeight: 8.0,
        alignment: MainAxisAlignment.center,
        backgroundColor: Colors.grey[300],
        percent: percent,
        progressColor:
            percent > 0.7 ? Colors.red : Theme.of(context).accentColor,
      );
    });
  }
}
