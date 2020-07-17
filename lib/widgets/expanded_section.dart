import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:stagpus/Marketplace/ControllerMarket/item_state.dart';

class ExpandedSection extends StatefulWidget{
  final Widget child;
  final bool expand;

  const ExpandedSection({Key key, this.expand, this.child}) : super(key: key);

  @override
  _ExpandedSectionState createState() => _ExpandedSectionState();
  
  }
  
  class _ExpandedSectionState extends State<ExpandedSection> with SingleTickerProviderStateMixin {
  AnimationController expandController;
  Animation<double> animation; 


  @override
  void initState() {
    super.initState();
    prepareAnimations();
  }

  void prepareAnimations() {
    expandController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    Animation curve = CurvedAnimation(parent: expandController, curve: Curves.fastOutSlowIn);
    animation = Tween(begin: 0.0, end: 1.0).animate(curve)..addListener(() {
      setState(() {});
    });
  }

  @override
  void didUpdateWidget(ExpandedSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(widget.expand) {
      expandController.forward();
    }
    else {
      expandController.reverse();
    }
  }

  @override
  void dispose() {
    expandController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
   return SizeTransition(
     sizeFactor: animation,
     axisAlignment: 1.0,
     child: widget.child,
   );
  }
}