import 'package:flutter/material.dart';
import 'package:revmo/screens/auth/signup_screen.dart';
import 'package:revmo/shared/colors.dart';

class RevmoBreadcrumb extends AnimatedWidget {
  final double height;
  final double width;
  final Animation<double> animation;
  final Map<int, String> stepsList;
  const RevmoBreadcrumb({required this.stepsList, required this.height, required this.width, required this.animation})
      : super(listenable: animation);

  final double _minHeight = 60;
  final double _nodeDiameter = 28;
  final double _lineHeight = 1.5;

  @override
  Widget build(BuildContext context) {
    double currentStep = SignUpSteps.of(context).stepsAnimator.value;
    double rowWidth = width - _nodeDiameter;
    double boxWidth = (width - _nodeDiameter) / stepsList.entries.length;
    double blueWidth =
        (rowWidth) * ((currentStep) / (stepsList.length-1)) + (((currentStep) / (stepsList.length-1)) * (boxWidth - _nodeDiameter / 2));

    return Container(
        constraints: BoxConstraints(minHeight: _minHeight),
        height: height,
        width: rowWidth,
        child: Stack(alignment: Alignment.topLeft, children: [
          Container(
            margin: EdgeInsets.only(top: _nodeDiameter / 2, left: _nodeDiameter / 2, right: _nodeDiameter / 2),
            height: _lineHeight,
            color: RevmoColors.darkGrey,
          ),
          Container(
            margin: EdgeInsets.only(top: _nodeDiameter / 2, left: _nodeDiameter / 2),
            height: _lineHeight,
            color: RevmoColors.originalBlue,
            width: blueWidth,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: stepsList.entries
                .map((step) => BreadCrumbNode(
                      index: step.key,
                      text: step.value,
                      nodeBoxWidth: boxWidth,
                      isActive: currentStep >= step.key,
                      listLength: stepsList.entries.length,
                      nodeDiameter: _nodeDiameter,
                    ))
                .toList(),
          ),
        ]));
  }
}

class BreadCrumbNode extends StatelessWidget {
  final double _crumbSpacing = 10;

  final double nodeDiameter;
  final int listLength;
  final bool isActive;
  late final bool isFirst;
  final double nodeBoxWidth;
  late final bool isLast;
  final String text;
  final int index;
  BreadCrumbNode(
      {required this.text,
      required this.index,
      required this.listLength,
      required this.nodeBoxWidth,
      required this.isActive,
      this.nodeDiameter = 28}) {
    isFirst = index == 0;
    isLast = listLength == index + 1;
  }
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        child: Column(
          crossAxisAlignment: (isLast) ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              width: nodeDiameter,
              height: nodeDiameter,
              alignment: Alignment.center,
              margin: EdgeInsets.only(left: (((index) / listLength) * (nodeBoxWidth - nodeDiameter / 2))),
              decoration: BoxDecoration(
                  border: Border.all(color: (isActive) ? RevmoColors.originalBlue : RevmoColors.darkGrey),
                  color: (isActive) ? RevmoColors.originalBlue : RevmoColors.darkBlue,
                  shape: BoxShape.circle),
              child: Text((index + 1).toString()),
            ),
            SizedBox(
              height: _crumbSpacing,
            ),
            Container(
              alignment: (isFirst)
                  ? Alignment.centerLeft
                  : isLast
                      ? Alignment.centerRight
                      : Alignment.center,
              child: Text(
                text,
                maxLines: 2,
                textAlign: (isFirst)
                    ? TextAlign.left
                    : isLast
                        ? TextAlign.right
                        : TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ),
      ),
    );
  }
}
