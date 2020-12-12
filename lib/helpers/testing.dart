import "package:flutter/material.dart";

class TestStateFull extends StatefulWidget {
  @override
  TestStateFullState createState() => TestStateFullState();
}

class TestStateFullState extends State<TestStateFull> with testMix<TestStateFull> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}


mixin testMix<T extends StatefulWidget> on State<T> {
  @override
  didChangeDependencies(){
    super.didChangeDependencies();
  }
}




//Flutter weg:

class ScreenWrap extends StatelessWidget{
  final Widget child;

  ScreenWrap(this.child);
  @override
  Widget build(BuildContext context){
    //myCode
    print("im a provider, i print stuff");
    //end myCode
    return child;
  }
}