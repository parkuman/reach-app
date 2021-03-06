import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:intl/intl.dart';

import '../scoped_models/main_model.dart';
import '../models/event.dart';

import '../widgets/custom_location_search_bar.dart';

double latitude;
double longitude;
String location;
bool showLocationResults = true;

void setLocation(double lat, double lng, String loc) {
  print('set location with lat: $lat, lng: $lng, and location: $location');
  latitude = lat;
  longitude = lng;
  location = loc;
  showLocationResults = false;
}

class EventCreatePage extends StatefulWidget {
  final MainModel model;
  EventCreatePage(this.model);

  @override
  _EventCreatePageState createState() => _EventCreatePageState();
}

class _EventCreatePageState extends State<EventCreatePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _titleTextController = TextEditingController();
  final _descriptionTextController = TextEditingController();

  DateTime _startDateTime = DateTime.now();
  DateTime _endDateTime = DateTime.now();

  double attendeeLimit = 5.0;
  bool limitAttendees = true;

  Widget _buildPageContent({BuildContext context, Event event}) {
    return Scaffold(
      floatingActionButton: _buildSubmitButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        title: Text('Create an Event'),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          margin: EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                _buildTitleTextField(),
                SizedBox(height: 10.0),
                _buildDescriptionTextField(),
                SizedBox(height: 10.0),
                Text('Date',
                    style: TextStyle(color: Colors.grey, fontSize: 16.0)),
                _buildDateTimeSelector(isStartDate: true),
                Divider(),
                _buildDateTimeSelector(isStartDate: false),
                Divider(color: Colors.black),
                SizedBox(height: 10.0),
                Text('Max Attendees',
                    style: TextStyle(color: Colors.grey, fontSize: 16.0)),
                _buildLimitAttendees(),
                Divider(color: Colors.black),
                SizedBox(height: 10.0),
                // showLocationResults
                //     ? CustomSearchScaffold()
                //     : TextFormField(initialValue: location),
                CustomSearchScaffold(),
                SizedBox(height: 70.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        return _buildPageContent();
      },
    );
  }

  Widget _buildTitleTextField() {
    // this code is because when the user scolls so far down the textfield is no longer visible, and therefore the title is lost. This preserves that.
    if (_titleTextController.text.trim() == '') {
      _titleTextController.text = '';
    } else {
      _titleTextController.text = _titleTextController.text;
    }
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Title',
        labelStyle: TextStyle(color: Colors.grey, fontSize: 22.0),
      ),
      controller: _titleTextController,
      autocorrect: false,
      style: TextStyle(fontSize: 22.0),
      validator: (String value) {
        if (value.length <= 3 || value.isEmpty) {
          return 'Please Enter a Title Over 3 Characters Long';
        }
      },
    );
  }

  Widget _buildDescriptionTextField() {
    // this code is because when the user scolls so far down the textfield is no longer visible, and therefore the title is lost. This preserves that.
    if (_descriptionTextController.text.trim() == '') {
      _descriptionTextController.text = '';
    } else {
      _descriptionTextController.text = _descriptionTextController.text;
    }
    return TextFormField(
      maxLines: 4,
      decoration: InputDecoration(
        labelText: 'Description',
        labelStyle: TextStyle(color: Colors.grey),
      ),
      controller: _descriptionTextController,
      validator: (String value) {
        if (value.isEmpty || value.length < 1) {
          return 'Please Enter a Description Over 1 Character Long';
        }
      },
    );
  }

  Widget _buildDateTimeSelector({bool isStartDate}) {
    return Row(
      children: <Widget>[
        InkWell(
          onTap: () {
            setState(() {
              _selectDate(isStartDate: isStartDate);
            });
          },
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            height: 50.0,
            child: Text(isStartDate
                ? DateFormat.EEEE().add_yMMMMd().format(_startDateTime)
                : DateFormat.EEEE().add_yMMMMd().format(_endDateTime)),
          ),
        ),
        Expanded(
          child: Container(),
        ),
        InkWell(
          onTap: () {
            _selectTime(isStartDate: isStartDate);
          },
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            height: 50.0,
            child: Text(isStartDate
                ? DateFormat.jm().format(_startDateTime)
                : DateFormat.jm().format(_endDateTime)),
          ),
        ),
      ],
    );
  }

  Future _selectDate({bool isStartDate}) async {
    DateTime pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime(2022),
    );
    if (pickedDate != null) {
      setState(() => (isStartDate)
          ? _startDateTime = pickedDate
          : _endDateTime = pickedDate);
    }
    print(_startDateTime.toString());
    print(_endDateTime.toString());
  }

  Future _selectTime({bool isStartDate}) async {
    TimeOfDay pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() => (isStartDate)
          ? _startDateTime = DateTime(_startDateTime.year, _startDateTime.month,
              _startDateTime.day, pickedTime.hour, pickedTime.minute)
          : _endDateTime = DateTime(_endDateTime.year, _endDateTime.month,
              _endDateTime.day, pickedTime.hour, pickedTime.minute));
    }
    print(_startDateTime.toString());
    print(_endDateTime.toString());
  }

  Widget _buildLimitAttendees() {
    return Container(
      child: Column(
        children: <Widget>[
          CheckboxListTile(
            value: limitAttendees,
            title: Text('Limit Attendees'),
            onChanged: (bool value) {
              setState(() {
                limitAttendees = value;
              });
            },
          ),
          limitAttendees
              ? Container(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        width: 50.0,
                        child: Text('${attendeeLimit.toInt()}'),
                      ),
                      Expanded(
                        child: Slider(
                          activeColor: Theme.of(context).accentColor,
                          inactiveColor: Colors.grey,
                          value: attendeeLimit,
                          min: 1,
                          max: 100,
                          onChanged: (double value) {
                            setState(() {
                              attendeeLimit = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return model.isLoading
            ? CircularProgressIndicator()
            : RaisedButton(
                child: Container(
                  width: 150.0,
                  height: 50.0,
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      SizedBox(width: 10.0),
                      Text('CREATE EVENT',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                color: Theme.of(context).accentColor,
                onPressed: () => _submitForm(model.addEvent),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0)),
              );
      },
    );
  }

  void _submitForm(Function addEvent) {
    //if the form is not valid then exit the function
    if (!_formKey.currentState.validate() ||
        location == null ||
        latitude == null ||
        longitude == null) {
      print('not valid');
      return;
    }

    _formKey.currentState.save();
    addEvent(
      _titleTextController.text,
      _descriptionTextController.text,
      latitude,
      longitude,
      location,
      _startDateTime,
      _endDateTime,
      limitAttendees
          ? attendeeLimit.toInt()
          : -1, // if the user said to not limit attendees, set it to -1 so we can check later
    ).then(
      (bool success) {
        if (success) {
          Navigator.pop(context);
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Error, no response from HTTP'),
                content: Text('Please try gain'),
                actions: <Widget>[
                  FlatButton(
                    child: Text('OK'),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
              );
            },
          );
        }
      },
    );
  }
}
