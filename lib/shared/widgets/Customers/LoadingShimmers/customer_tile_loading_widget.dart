import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../UIwidgets/skeleton_loading.dart';




class CustomTileLoadingWidget extends StatelessWidget {
  const CustomTileLoadingWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.all(10),
      // margin: EdgeInsets.only(bottom: 20),
      // color: Colors.white,
      // height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
                top: 10, left: 15, right: 15, bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: SkeletonLoading(
                        child: Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white),
                            padding: EdgeInsets.symmetric(
                                vertical: 6, horizontal: 3),
                            child: Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                            )),
                      )),
                ),
                Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      mainAxisAlignment:
                      MainAxisAlignment.spaceEvenly,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                            padding:
                            EdgeInsets.only(bottom: 10),
                            child: SkeletonLoading(
                                child: Container(
                                  width: 50,
                                  height: 10,
                                  color: Colors.white,
                                ))),
                        Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            SkeletonLoading(
                              child: _CircleLoading(
                                radius: 25,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            SkeletonLoading(
                                child: Container(
                                  width: 50,
                                  height: 10,
                                  color: Colors.white,
                                )),
                            const SizedBox(
                              height: 5,
                            ),
                            SkeletonLoading(
                                child: Container(
                                  width: 80,
                                  height: 10,
                                  color: Colors.white,
                                ))
                          ],
                        ),
                        const  SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            SkeletonLoading(
                              child: _CircleLoading(
                                radius: 10,
                              ),
                            ),
                            const     SizedBox(
                              width: 5,
                            ),
                            SkeletonLoading(
                                child: Container(
                                  width: 50,
                                  height: 10,
                                  color: Colors.white,
                                )),
                          ],
                        ),
                        SizedBox(height: 10,)
                      ],
                    )),
                Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.center,
                      mainAxisAlignment:
                      MainAxisAlignment.spaceEvenly,
                      children: [
                        const  SizedBox(
                          height: 10,
                        ),
                        Lottie.asset('assets/images/car-loading-animation.json',
                            repeat: false, height: 110, frameRate: FrameRate.composition),
                        SkeletonLoading(
                            child: Container(
                              width: 120,
                              height: 20,
                              color: Colors.grey.withOpacity(0.6),
                            )),
                        const  SizedBox(
                          height: 17,
                        ),

                      ],
                    ))
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 25, right: 10,bottom: 10,top: 10),
            height: 30,
            decoration: BoxDecoration(
              color: Color(0xff26AEE4).withOpacity(0.041),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SkeletonLoading(child: Container(height: 15,width: 15,
                      color: Colors.white,)),
                    const      SizedBox(
                      width: 10,
                    ),
                    SkeletonLoading(
                        child: Container(
                          width: 40,
                          height: 15,
                          color: Colors.white,
                        )),
                  ],
                ),


                Row(children: [
                  SkeletonLoading(
                      child: Container(
                        width: 100,
                        height: 15,
                        color: Colors.white,
                      )),
                  SizedBox(
                    width: 10,
                  ),
                  SkeletonLoading(
                      child: Container(
                        width: 100,
                        height: 15,
                        color: Colors.white,
                      )),
                ],)
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _CircleLoading extends StatelessWidget {
  _CircleLoading({
    Key? key,
    required this.radius,
  }) : super(key: key);
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
        padding: EdgeInsets.symmetric(vertical: 6, horizontal: 3),
        child: Container(
          height: radius,
          width: radius,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
        ));
  }
}
