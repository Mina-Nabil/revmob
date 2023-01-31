// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
//
// import '../colors.dart';
// import 'home/single_nav_tab.dart';
//
// class BottomNavStyle15 extends StatelessWidget {
//   BottomNavStyle15({
//     Key? key,
//     required this.item
//   });
//   List<SingleNavigationTabContainer> item;
//   Widget _buildItem(BuildContext context, SingleNavigationTabContainer item,
//       bool isSelected, double? height) {
//     return Container(
//       width: 150.0,
//       height: height,
//       color: Colors.transparent,
//       padding: EdgeInsets.only(top: 0.15, bottom: 0.12),
//       child: Container(
//         alignment: Alignment.center,
//         height: height,
//         child: ListView(
//           shrinkWrap: true,
//           physics: NeverScrollableScrollPhysics(),
//           scrollDirection: Axis.horizontal,
//           children: <Widget>[
//             Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: <Widget>[
//                 Expanded(
//                   child: IconTheme(
//                     data: IconThemeData(
//                         size: 20,
//                         color: isSelected
//                             ? RevmoColors.navbarColorSelectedIcon
//                             : RevmoColors.unSelectedTab),
//                     child: SvgPicture.asset(
//                       item.iconPath,
//                       color: isSelected
//                           ? RevmoColors.navbarColorSelectedIcon
//                           : RevmoColors.unSelectedTab,
//                     ),
//                   ),
//                 ),
//                 item.tabText == null
//                     ? SizedBox.shrink()
//                     : Padding(
//                         padding: const EdgeInsets.only(top: 15.0),
//                         child: Material(
//                           type: MaterialType.transparency,
//                           child: FittedBox(
//                               child: Text(
//                             item.tabText!,
//                             style:  TextStyle(
//                                 color: isSelected ? RevmoColors.navbarColorSelectedIcon : RevmoColors.unSelectedTab,
//                                 fontWeight: FontWeight.w400,
//                                     fontSize: 12.0),
//                           )),
//                         ),
//                       )
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildMiddleItem(
//       SingleNavigationTabContainer item, bool isSelected, double? height) {
//     return  Padding(
//             padding: EdgeInsets.only(
//                 top: 0.0,
//                 bottom: 0.0),
//             child: Stack(
//               children: <Widget>[
//                 Transform.translate(
//                   offset: Offset(0, -23),
//                   child: Center(
//                     child: Container(
//                       width: 150.0,
//                       height: height,
//                       margin: EdgeInsets.only(top: 2.0),
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: RevmoColors.navbarColorSelectedIcon,
//                         border:
//                             Border.all(color: Colors.transparent, width: 5.0),
//                         // boxShadow: this.navBarDecoration!.boxShadow,
//                       ),
//                       child: Container(
//                         alignment: Alignment.center,
//                         height: height,
//                         child: ListView(
//                           shrinkWrap: true,
//                           physics: NeverScrollableScrollPhysics(),
//                           scrollDirection: Axis.horizontal,
//                           children: <Widget>[
//                             Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: <Widget>[
//                                 Expanded(
//                                   child: IconTheme(
//                                     data: IconThemeData(
//                                         size: 20,
//                                       color: isSelected ? RevmoColors.navbarColorSelectedIcon : RevmoColors.unSelectedTab,
//                                     ),
//                                     child:SvgPicture.asset(
//                                       item.iconPath,
//                                       color: isSelected ? RevmoColors.navbarColorSelectedIcon : RevmoColors.unSelectedTab,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               Padding(
//                         padding: const EdgeInsets.only(bottom: 5.0),
//                         child: Align(
//                           alignment: Alignment.bottomCenter,
//                           child: Material(
//                             type: MaterialType.transparency,
//                             child: FittedBox(
//                                 child: Text(
//                               item.tabText,
//                               style:TextStyle(
//                                   color: isSelected ? RevmoColors.navbarColorSelectedIcon : RevmoColors.unSelectedTab,
//
//                                   fontWeight: FontWeight.w400,
//                                       fontSize: 12.0),
//                             )),
//                           ),
//                         ),
//                       )
//               ],
//             ),
//           );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       height: MediaQuery.of(context).size.height * 0.1,
//       child: Stack(
//         children: <Widget>[
//           ClipRRect(
//             borderRadius:
//                  BorderRadius.zero,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: this.item.map((item) {
//                 int index = this.item.indexOf(item);
//                 return Flexible(
//                   child: GestureDetector(
//                     onTap: () {
//                       // if (this.item[index].onPressed !=
//                       //     null) {
//                       //   this.navBarEssentials!.items![index].onPressed!(this
//                       //       .navBarEssentials!
//                       //       .selectedScreenBuildContext);
//                       // } else {
//                       //   this.navBarEssentials!.onItemSelected!(index);
//                       // }
//                     },
//                     child:
//                     // index == midIndex
//                     //     ? Container(width: 150, color: Colors.transparent)
//                     //     :
//                     _buildItem(
//                             context,
//                             item,
//                             this.item.selectedIndex == index,
//                             this.navBarEssentials!.navBarHeight),
//                   ),
//                 );
//               }).toList(),
//             ),
//           ),
//           this.navBarEssentials!.navBarHeight == 0
//               ? SizedBox.shrink()
//               : Center(
//                   child: GestureDetector(
//                       onTap: () {
//                         if (this.navBarEssentials!.items![midIndex].onPressed !=
//                             null) {
//                           this.navBarEssentials!.items![midIndex].onPressed!(
//                               this
//                                   .navBarEssentials!
//                                   .selectedScreenBuildContext);
//                         } else {
//                           this.navBarEssentials!.onItemSelected!(midIndex);
//                         }
//                       },
//                       child: _buildMiddleItem(
//                           this.navBarEssentials!.items![midIndex],
//                           this.navBarEssentials!.selectedIndex == midIndex,
//                           this.navBarEssentials!.navBarHeight)),
//                 )
//         ],
//       ),
//     );
//   }
// }
