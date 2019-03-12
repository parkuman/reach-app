import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';

class SimpleBottomAppBar extends StatefulWidget {
  //TO USE THIS IN THE STATE CLASS USE "widget.onSelectTab()"
  final Function onSelectTab;
  SimpleBottomAppBar({this.onSelectTab});

  @override
  State<StatefulWidget> createState() {
    return _SimpleBottomAppBarState();
  }
}

class _SimpleBottomAppBarState extends State<SimpleBottomAppBar>
    with TickerProviderStateMixin {

  int currentIndex = 1;
  int previousIndex;
  List<int> flexValues = [100, 150, 100];
  List<double> opacityValues = [0.0, 1.0, 0.0];
  List<double> fractionalOffsetValues = [0.0, 0.0, 0.0];
  List<double> verticalShiftValues = [8.0, -4.0, 8.0];
  List<double> skewValues = [0.0, 0.0, 0.0];
  AnimationController _controller;
  Animation animation;
  Animation skewFirstHalfAnimation;
  Animation skewSecondHalfAnimation;
  Animation translationFirstHalfAnimation;
  Animation translationSecondHalfAnimation;
  Animation opacityFirstHalfAnimation;
  Animation opacitySecondHalfAnimation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 250));
    animation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(curve: Curves.easeInOut, parent: _controller));
    translationFirstHalfAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            curve: Interval(0.0, 0.85, curve: Curves.easeIn),
            parent: _controller));
    translationSecondHalfAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(
            curve: Interval(0.15, 1.0, curve: Curves.easeOut),
            parent: _controller));
    opacityFirstHalfAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            curve: Interval(0.0, 0.50, curve: Curves.easeIn),
            parent: _controller));
    opacitySecondHalfAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            curve: Interval(0.50, 1.0, curve: Curves.easeOut),
            parent: _controller));
    skewFirstHalfAnimation = Tween<double>(begin: 0.0, end: 0.1).animate(
        CurvedAnimation(
            curve: Interval(0.0, 0.3, curve: Curves.easeIn),
            parent: _controller));
    skewSecondHalfAnimation = Tween<double>(begin: 0.0, end: 0.1).animate(
        CurvedAnimation(
            curve: Interval(0.7, 1.0, curve: Curves.easeOut),
            parent: _controller));

    animation.addListener(() {
      setState(() {
        flexValues[previousIndex] = 150 - (50 * animation.value).toInt();
        flexValues[currentIndex] = 100 + (50 * animation.value).toInt();
        opacityValues[previousIndex] = 1.0 - opacityFirstHalfAnimation.value;
        opacityValues[currentIndex] = 0.0 + opacitySecondHalfAnimation.value;
        verticalShiftValues[currentIndex] = 8 - (12 * animation.value);
        verticalShiftValues[previousIndex] = -4 + (12 * animation.value);
        if (currentIndex > previousIndex) {
          fractionalOffsetValues[currentIndex] =
              -1 + translationSecondHalfAnimation.value;
          fractionalOffsetValues[previousIndex] =
              translationFirstHalfAnimation.value;
          skewValues[currentIndex] =
              skewFirstHalfAnimation.value - skewSecondHalfAnimation.value;
          skewValues[previousIndex] =
              -skewFirstHalfAnimation.value + skewSecondHalfAnimation.value;
        } else if (currentIndex < previousIndex) {
          fractionalOffsetValues[currentIndex] =
              1 - translationSecondHalfAnimation.value;
          fractionalOffsetValues[previousIndex] =
              -translationFirstHalfAnimation.value;
          skewValues[currentIndex] =
              -skewFirstHalfAnimation.value + skewSecondHalfAnimation.value;
          skewValues[previousIndex] =
              skewFirstHalfAnimation.value - skewSecondHalfAnimation.value;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Container(
        width: double.infinity,
        height: 56.0,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Flexible(
              fit: FlexFit.tight,
              flex: flexValues[0],
              child: FlatButton(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                clipBehavior: Clip.none,
                padding: EdgeInsets.all(0.0),
                onPressed: () {
                  _onOptionClicked(pressedIndex: 0);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Transform.translate(
                      offset: Offset(0.0, verticalShiftValues[0]),
                      child: Transform(
                        transform: Matrix4.skewY(skewValues[0]),
                        child: Icon(
                          Icons.event,
                          size: 22.0,
                        ),
                      ),
                    ),
                    ClipRect(
                      child: FractionalTranslation(
                        translation: Offset(fractionalOffsetValues[0], 0.0),
                        child: Opacity(
                            opacity: opacityValues[0],
                            child: Center(
                              child: Text(
                                'My Events',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            )),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Flexible(
              fit: FlexFit.tight,
              flex: flexValues[1],
              child: FlatButton(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                clipBehavior: Clip.none,
                padding: EdgeInsets.all(0.0),
                onPressed: () {
                  _onOptionClicked(pressedIndex: 1);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Transform.translate(
                      offset: Offset(0.0, verticalShiftValues[1]),
                      child: Transform(
                        transform: Matrix4.skewY(skewValues[1]),
                        child: Icon(
                          Icons.home,
                          size: 22.0,
                        ),
                      ),
                    ),
                    ClipRect(
                      child: FractionalTranslation(
                        translation: Offset(fractionalOffsetValues[1], 0.0),
                        child: Opacity(
                          opacity: opacityValues[1],
                          child: Center(
                            child: Text(
                              'Home',
                              style: TextStyle(fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              fit: FlexFit.tight,
              flex: flexValues[2],
              child: FlatButton(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                clipBehavior: Clip.none,
                padding: EdgeInsets.all(0.0),
                onPressed: () {
                  _onOptionClicked(pressedIndex: 2);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Transform.translate(
                      offset: Offset(0.0, verticalShiftValues[2]),
                      child: Transform(
                        transform: Matrix4.skewY(skewValues[2]),
                        child: Icon(
                          Icons.person,
                          size: 22.0,
                        ),
                      ),
                    ),
                    ClipRect(
                      child: FractionalTranslation(
                        translation: Offset(fractionalOffsetValues[2], 0.0),
                        child: Opacity(
                          opacity: opacityValues[2],
                          child: Center(
                            child: Text(
                              'Profile',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onOptionClicked({@required int pressedIndex}) {
    if (pressedIndex  != currentIndex) {
      previousIndex = currentIndex;
      currentIndex = pressedIndex;
      widget.onSelectTab(currentIndex);
      _controller.reset();
      _controller.forward();
    }
  }
}
