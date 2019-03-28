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
  final Map<String, dynamic> _formData = {
    'title': null,
    'description': null,
  };

  DateTime _startDateTime = DateTime.now();
  DateTime _endDateTime = DateTime.now();

  Widget _buildPageContent({BuildContext context, Event event}) {
    return Scaffold(
      floatingActionButton: _buildSubmitButton(),
      appBar: AppBar(
        title: Text('Create an Event'),
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
                // showLocationResults
                //     ? CustomSearchScaffold()
                //     : TextFormField(initialValue: location),
                CustomSearchScaffold(),
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
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Title',
        labelStyle: TextStyle(color: Colors.grey, fontSize: 22.0),
      ),
      initialValue: '',
      style: TextStyle(fontSize: 22.0),
      validator: (String value) {
        if (value.isEmpty || value.length < 1) {
          return 'Please Enter a Title Over 5 Characters Long';
        }
      },
      onSaved: (String value) {
        _formData['title'] = value;
      },
    );
  }

  Widget _buildDescriptionTextField() {
    return TextFormField(
      maxLines: 4,
      decoration: InputDecoration(
        labelText: 'Description',
        labelStyle: TextStyle(color: Colors.grey),
      ),
      initialValue: '',
      validator: (String value) {
        if (value.isEmpty || value.length < 1) {
          return 'Please Enter a Description Over 10 Characters Long';
        }
      },
      onSaved: (String value) {
        _formData['description'] = value;
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

  Widget _buildSubmitButton() {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return model.isLoading
            ? FloatingActionButton(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                onPressed: () {},
              )
            : FloatingActionButton(
                child: Icon(Icons.check),
                onPressed: () => _submitForm(model.addEvent),
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
      return;
    }

    _formKey.currentState.save();
    addEvent(
      _formData['title'],
      _formData['description'],
      latitude,
      longitude,
      location,
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
