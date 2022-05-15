import 'package:flutter/material.dart';
import 'package:revmo/shared/colors.dart';
import 'package:revmo/shared/theme.dart';

class RevmoExpandableInfoCard extends StatefulWidget {
  final String title;
  final Widget body;
  final double minHeight;
  final double maxHeight;
  final bool isLoading;
  final bool initialStateExpanded;
  const RevmoExpandableInfoCard(
      {required this.title,
      required this.body,
      required this.minHeight,
      required this.maxHeight,
      this.initialStateExpanded = false})
      : isLoading = false;
  RevmoExpandableInfoCard.placeholder({required this.minHeight})
      : isLoading = true,
        title = "N/A",
        body = Container(),
        initialStateExpanded = false,
        maxHeight = 0;

  @override
  _RevmoExpandableInfoCardState createState() => _RevmoExpandableInfoCardState();
}

class _RevmoExpandableInfoCardState extends State<RevmoExpandableInfoCard> with SingleTickerProviderStateMixin {
  final Duration _boxAnimationDuration = const Duration(seconds: 1);
  final Duration _arrowAnimationDuration = const Duration(milliseconds: 200);

  late double _currentHeight;
  late AnimationController _controller;
  late double _tweenBegin;
  late double _tweenEnd;
  late bool _isExpanded;

  toggleBox() {
    if (_currentHeight == widget.minHeight)
      setState(() {
        _controller.forward();
        _currentHeight = widget.maxHeight;
        _isExpanded = true;
      });
    else
      setState(() {
        _controller.reverse();
        _currentHeight = widget.minHeight;
        _isExpanded = false;
      });
  }

  @override
  void initState() {
    _currentHeight = (widget.initialStateExpanded) ? widget.maxHeight : widget.minHeight;
    _tweenBegin = (widget.initialStateExpanded) ? 0.25 : 0.0;
    _tweenEnd = (widget.initialStateExpanded) ? 0.0 : 0.25;
    _controller = AnimationController(
      duration: _arrowAnimationDuration,
      vsync: this,
    );
    _isExpanded = widget.initialStateExpanded;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: _boxAnimationDuration,
      constraints: BoxConstraints(minHeight: widget.minHeight, maxHeight: _currentHeight),
      curve: RevmoTheme.BOXES_CURVE,
      width: double.infinity,

      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(5))),
      child: ListView(
        physics: NeverScrollableScrollPhysics(),
        children: [
          //card title
          GestureDetector(
            onTap: toggleBox,
            child: Container(
              height: widget.minHeight,
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  RotationTransition(
                    turns: Tween(begin: _tweenBegin, end: _tweenEnd).animate(_controller),
                    child: Icon(
                      Icons.arrow_right,
                      color: RevmoColors.originalBlue,
                    ),
                  ),
                  Expanded(
                      child: Container(
                          alignment: Alignment.centerLeft,
                          color: Colors.transparent,
                          child: FittedBox(child: RevmoTheme.getSemiBold(widget.title, 1, color: RevmoColors.darkBlue)))),
                ],
              ),
            ),
          ),
          //card content
          Container(
              constraints: BoxConstraints(minHeight: 0, maxHeight: widget.maxHeight - widget.minHeight),
              child: ListView(
                shrinkWrap: true,
                physics: AlwaysScrollableScrollPhysics(),
                children: [widget.body],
              )),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
