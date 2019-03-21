import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scoped_models/main_model.dart';
import '../models/event.dart';

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
    'location': null,
  };

  Widget _buildPageContent({BuildContext context, Event event}) {
    return Scaffold(
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
                _buildDescriptionTextField(),
                SizedBox(height: 10.0),
                _buildLocationTextField(),
                // LocationInput(_setLocation, elf),
                SizedBox(height: 10.0),
                _buildSubmitButton(),
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
      decoration: InputDecoration(labelText: 'Title'),
      initialValue: '',
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
      decoration: InputDecoration(labelText: 'Description'),
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

  Widget _buildLocationTextField() {
    return TextFormField(
      maxLines: 4,
      decoration: InputDecoration(labelText: 'Location'),
      initialValue: '',
      validator: (String value) {
        if (value.isEmpty) {
          return 'Please Enter a Location';
        }
      },
      onSaved: (String value) {
        _formData['location'] = value;
      },
    );
  }

  Widget _buildSubmitButton() {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return model.isLoading
            ? Center(child: CircularProgressIndicator())
            : RaisedButton(
                child: Text('Create'),
                color: Theme.of(context).accentColor,
                onPressed: () => _submitForm(model.addEvent),
              );
      },
    );
  }

  void _submitForm(Function addEvent) {
    //if the form is not valid then exit the function
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    addEvent(
      _formData['title'],
      _formData['description'],
      _formData['location'],
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
