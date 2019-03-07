import 'package:flutter/material.dart';

class EventsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _EventsPageState();
  }
}

class _EventsPageState extends State<EventsPage> {
  int _eventCount = 0;
  List<String> events = [];
  String text = 'text';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            setState(() {
              _eventCount += 1;
              events.add(_eventCount.toString());
            });
          },
        ),
        appBar: AppBar(
          centerTitle: true,
          title: Text('Events', style: TextStyle(fontWeight: FontWeight.bold)),
          bottom: TabBar(
            tabs: <Widget>[
              Container(padding: EdgeInsets.all(15.0), child: Text('Going')),
              Container(padding: EdgeInsets.all(15.0), child: Text('Hosting')),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            _buildEventsList(),
            Center(child: Text('Hosting')),
          ],
        ),
      ),
    );
  }

  Widget _buildEventsList() {
    Widget eventItem;
    if (events.length > 0) {
      eventItem = ListView.builder(
        itemBuilder: _buildEvent,
        itemCount: _eventCount,
      );
    } else {
      eventItem = Center(
        child: Text('no events found'),
      );
    }

    return eventItem;
  }

  void _eventPressed() {
    text = 'pressed';
  }

  void _deleteEvent(int index) {
    print(events);
    events.removeAt(index);
    print(events);
  }

  Widget _buildEvent(BuildContext context, int index) {
    return Dismissible(
      key: Key(events[index]),
      onDismissed: (DismissDirection direction) {
        _deleteEvent(index);
      },
      child: GestureDetector(
        onTap: () {
          setState(() {
            print('card pressed');
            _eventPressed();
          });
        },
        onLongPress: () {
          setState(() {
            print('card long pressed');
          });
        },
        child: Card(
          elevation: 3.0,
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            child: Row(
              children: <Widget>[
                //TEXT
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Event',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                    Text('${(index + 1)}'),
                    Text('$text'),
                  ],
                ),
                //SPACE BETWEEN PIC AND TEXT
                Expanded(
                  child: SizedBox(),
                ),
                //PICTURE BOX
                Container(
                  width: 100.0,
                  height: 100.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(5.0),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/event.jpg'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
