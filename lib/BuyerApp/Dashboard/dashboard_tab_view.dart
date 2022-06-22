import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:revmo/BuyerApp/Dashboard/dashboard_viewModel.dart';
import 'package:revmo/BuyerApp/buyer_app.dart';
import 'package:revmo/shared/colors.dart';
import 'package:revmo/Configurations/Extensions/extensions.dart';
import '../../providers/Buyer/home_provider.dart';
import '../../screens/home/dashboard_tab.dart';
import 'package:pmvvm/pmvvm.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MVVM(view: (_,__ ) => MyView(), viewModel: DashboardViewModel());
  }
}



class MyView extends HookView<DashboardViewModel> {
  /// Set [reactive] to [false] if you don't want the view to listen to the ViewModel.
  /// It's [true] by default.
  const MyView({Key? key}) : super(key: key, reactive: true);

  @override
  Widget render(context, vmodel) {
    var mediaQuery = MediaQuery.of(context);

    return Scaffold(
      backgroundColor: Color(0xfffafafa),
      body:  SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30,),
                ElevatedButton(onPressed: (){
                  // pushNewScreen(
                  //   context,
                  //   screen: Test(),
                  //   withNavBar: true, // OPTIONAL VALUE. True by default.
                  //   pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  // );
                  vmodel.customerProvider.loadPendingOffers();
                  // vmodel.increase();
                  // vmodel.customerProvider.setAppBar();
                }, child: Text('hide')),

                Text(vmodel.counter.toString(), style: TextStyle(color: Colors.black),),
                WelcomeContainer(name: 'Marc Maged'),
                const SizedBox(
                  height: 40,
                ),
                Text('New To Market'),
              ],
            ).setPageHorizontalPadding(context),
            const SizedBox(
              height: 3,
            ),
            SizedBox(height: 210,
              width: mediaQuery.size.width,
              child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) =>
                      FadeInRight(
                        duration: Duration(milliseconds: 500),
                        child: Padding(
                          padding: (index == 0)
                              ? const EdgeInsets.only(
                            left: 14,
                          )
                              : const EdgeInsets.all(0),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Stack(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10),
                                  width: 350,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(
                                            0.1),
                                        spreadRadius: 3,
                                        blurRadius: 5,
                                      ),
                                    ],

                                  ),
                                  child:Stack(
                                    clipBehavior: Clip.none,
                                    children: [

                                      Positioned(
                                          top:-50,
                                          right: -70,
                                          child: SizedBox(
                                            height: 200,
                                            child: Image.network(vmodel.customerProvider.pending[index].car.mainImageURL),
                                          )),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 10,),

                                          SizedBox(
                                              height:30,
                                              child: Image.network('https://img.icons8.com/color/344/mitsubishi.png')),
                                          const SizedBox(height: 10,),
                                          SizedBox(
                                              width: 100,
                                              child: Text('Mitsubishi Outlander, 2022', style: TextStyle(color: RevmoColors.darkBlue, fontWeight: FontWeight.w600),)),
                                          const SizedBox(height: 30,),
                                          SizedBox(
                                              width: 100,
                                              child: Text('Starting Price', style: TextStyle(color: RevmoColors.darkBlue, fontWeight: FontWeight.w600, fontSize: 12),)),
                                          const SizedBox(height: 10,),

                                          Text('540,000 EGP', style: TextStyle(color: RevmoColors.darkBlue, fontWeight: FontWeight.bold, fontSize: 20),),


                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ).setOnlyPadding(context,
                              right: index + 1 == index
                                  ? 15
                                  : 0,
                              enableMediaQuery: false),
                        ),
                      ),
                  separatorBuilder: (context, index) =>
                      SizedBox(width: 20,),
                  itemCount: vmodel.customerProvider.pending.length),
            ),
            const  SizedBox(height: 20,),
            Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Color(0xff0fffafafa)
                ),
                child: const   Text('Base On Your Search', style: TextStyle(color: RevmoColors.darkBlue),)).setPageHorizontalPadding(context),

            SizedBox(height: 210,
              width: mediaQuery.size.width,
              child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) =>
                      FadeInRight(
                        duration: Duration(milliseconds: 500),
                        child: Padding(
                          padding: (index == 0)
                              ? const EdgeInsets.only(
                            left: 14,
                          )
                              : const EdgeInsets.all(0),
                          child: Padding(
                            padding: const EdgeInsets.all(7),
                            child: Container(
                              padding: EdgeInsets.all(5),
                              width: 360,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(
                                        0.1),
                                    spreadRadius: 3,
                                    blurRadius: 5,
                                    // changs position of shadow
                                  ),
                                ],

                              ),
                              child:Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                      flex:3,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,

                                        children: [
                                          SizedBox(height: 160,
                                            child: Image.network('https://pngimg.com/uploads/volvo/volvo_PNG74.png'),
                                          ),



                                        ],)),
                                  const  SizedBox(width: 10,),

                                  Expanded(
                                      flex:2,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,

                                        children: [
                                          const SizedBox(height: 10,),

                                          SizedBox(
                                              height:30,
                                              child: Image.network('https://pngimg.com/uploads/volvo/small/volvo_PNG73.png')),
                                          const SizedBox(height: 10,),
                                          SizedBox(
                                              width: 100,
                                              child: Text('Volvo, XC90', style: TextStyle(color: RevmoColors.darkBlue, fontWeight: FontWeight.bold),)),
                                          Text('A/T/ INSCRIPTION 2021', style: TextStyle(color: RevmoColors.darkBlue, fontWeight: FontWeight.w400),),
                                          const SizedBox(height: 20,),
                                          Text('Price', style: TextStyle(color: RevmoColors.darkBlue, fontWeight: FontWeight.w600, fontSize: 12),),
                                          const SizedBox(height: 5,),

                                          Text('1,540,000 EGP', style: TextStyle(color: RevmoColors.darkBlue, fontWeight: FontWeight.bold, fontSize: 20),),

                                        ],)),


                                ],
                              ),
                            ),
                          ).setOnlyPadding(context,
                              right: index + 1 == index
                                  ? 15
                                  : 0,
                              enableMediaQuery: false),
                        ),
                      ),
                  separatorBuilder: (context, index) =>
                      SizedBox(width: 20,),
                  itemCount: 10),
            ),
            const  SizedBox(height: 20,),

            Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Color(0xff0fffafafa)
                ),
                child: const   Text('Showrooms', style: TextStyle(color: RevmoColors.darkBlue),).setPageHorizontalPadding(context)),
            SizedBox(height: 180,
              width: mediaQuery.size.width,
              child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) =>
                      FadeInRight(
                        duration: Duration(milliseconds: 500),
                        child: Padding(
                          padding: (index == 0)
                              ? const EdgeInsets.only(
                            left: 14,
                          )
                              : const EdgeInsets.all(0),
                          child: Padding(
                            padding: const EdgeInsets.all(7),
                            child: Container(
                                padding: EdgeInsets.all(5),
                                width: 200,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(
                                          0.1),
                                      spreadRadius: 3,
                                      blurRadius: 5,
                                      // changs position of shadow
                                    ),
                                  ],

                                ),
                                child:Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 30,
                                      child: Image.network('https://contactcars.fra1.cdn.digitaloceanspaces.com/contactcars-production/Images/Small/Dealers/1230610_c09123b2-514f-4a34-a5a2-bf946e6712a9.jpeg'),
                                    ),
                                    Text('Cars', style: TextStyle(color: Colors.black,letterSpacing: 10),)
                                  ],
                                )
                            ),
                          ).setOnlyPadding(context,
                              right: index + 1 == index
                                  ? 15
                                  : 0,
                              enableMediaQuery: false),
                        ),
                      ),
                  separatorBuilder: (context, index) =>
                      SizedBox(width: 20,),
                  itemCount: 10),
            ),
            const  SizedBox(height: 20,),
            Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Color(0xff0fffafafa)
                ),
                child: const   Text('Recent News', style: TextStyle(color: RevmoColors.darkBlue),).setPageHorizontalPadding(context)),

            const   SizedBox(height: 5,),
            SizedBox(height: 100,)

          ],
        ),
      ),

//       Stack(
//         children: [
//           Positioned(
//             top: 0,
//             left: 0,
//             child: Container(
//               width: MediaQuery
//                   .of(context)
//                   .size
//                   .width,
//               height: MediaQuery
//                   .of(context)
//                   .size
//                   .height * 0.2,
//               color: RevmoColors.darkBlue,
//             ),
//           ),
//           Positioned(
//             top: 0,
//             bottom: 0,
//             left: 0,
//             right: 0,
//             child: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       SizedBox(height: 30,),
//                       ElevatedButton(onPressed: (){
//                         // pushNewScreen(
//                         //   context,
//                         //   screen: Test(),
//                         //   withNavBar: true, // OPTIONAL VALUE. True by default.
//                         //   pageTransitionAnimation: PageTransitionAnimation.cupertino,
//                         // );
// vmodel.increase();
//
//                         // vmodel.customerProvider.setAppBar();
//
//                       }, child: Text('hide')),
//
//                       Text(vmodel.counter.toString()),
//                       WelcomeContainer(name: 'Marc Maged'),
//                       const SizedBox(
//                         height: 40,
//                       ),
//                       Text('New To Market'),
//                     ],
//                   ).setPageHorizontalPadding(context),
//                   const SizedBox(
//                     height: 3,
//                   ),
//                   SizedBox(height: 210,
//                     width: mediaQuery.size.width,
//                     child: ListView.separated(
//                         scrollDirection: Axis.horizontal,
//                         itemBuilder: (context, index) =>
//                             FadeInRight(
//                               duration: Duration(milliseconds: 500),
//                               child: Padding(
//                                 padding: (index == 0)
//                                     ? const EdgeInsets.only(
//                                   left: 14,
//                                 )
//                                     : const EdgeInsets.all(0),
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(10),
//                                   child: Stack(
//                                     children: [
//                                       Container(
//                                         padding: EdgeInsets.all(10),
//                                         width: 350,
//                                         decoration: BoxDecoration(
//                                           borderRadius: BorderRadius.circular(7),
//                                           color: Colors.white,
//                                           boxShadow: [
//                                             BoxShadow(
//                                               color: Colors.black.withOpacity(
//                                                   0.1),
//                                               spreadRadius: 3,
//                                               blurRadius: 5,
//                                             ),
//                                           ],
//
//                                         ),
//                                         child:Stack(
//                                           clipBehavior: Clip.none,
//                                           children: [
//
//                                             Positioned(
//                                                 top:-50,
//                                                 right: -70,
//                                                 child: SizedBox(
//                                                   height: 200,
//                                                   child: Image.network("https://pngimg.com/uploads/mitsubishi/mitsubishi_PNG185.png"),
//                                                 )),
//                                             Column(
//                                               crossAxisAlignment: CrossAxisAlignment.start,
//                                               children: [
//                                                 const SizedBox(height: 10,),
//
//                                                 SizedBox(
//                                                     height:30,
//                                                     child: Image.network('https://img.icons8.com/color/344/mitsubishi.png')),
//                                                 const SizedBox(height: 10,),
//                                                 SizedBox(
//                                                     width: 100,
//                                                     child: Text('Mitsubishi Outlander, 2022', style: TextStyle(color: RevmoColors.darkBlue, fontWeight: FontWeight.w600),)),
//                                                 const SizedBox(height: 30,),
//                                                 SizedBox(
//                                                     width: 100,
//                                                     child: Text('Starting Price', style: TextStyle(color: RevmoColors.darkBlue, fontWeight: FontWeight.w600, fontSize: 12),)),
//                                                 const SizedBox(height: 10,),
//
//                                                 Text('540,000 EGP', style: TextStyle(color: RevmoColors.darkBlue, fontWeight: FontWeight.bold, fontSize: 20),),
//
//
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ).setOnlyPadding(context,
//                                     right: index + 1 == index
//                                         ? 15
//                                         : 0,
//                                     enableMediaQuery: false),
//                               ),
//                             ),
//                         separatorBuilder: (context, index) =>
//                             SizedBox(width: 20,),
//                         itemCount: 10),
//                   ),
//                   const  SizedBox(height: 20,),
//                   Container(
//                       padding: EdgeInsets.all(5),
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(6),
//                           color: Color(0xff0fffafafa)
//                       ),
//                       child: const   Text('Base On Your Search', style: TextStyle(color: RevmoColors.darkBlue),)).setPageHorizontalPadding(context),
//
//                   SizedBox(height: 210,
//                     width: mediaQuery.size.width,
//                     child: ListView.separated(
//                         scrollDirection: Axis.horizontal,
//                         itemBuilder: (context, index) =>
//                             FadeInRight(
//                               duration: Duration(milliseconds: 500),
//                               child: Padding(
//                                 padding: (index == 0)
//                                     ? const EdgeInsets.only(
//                                   left: 14,
//                                 )
//                                     : const EdgeInsets.all(0),
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(7),
//                                   child: Container(
//                                     padding: EdgeInsets.all(5),
//                                     width: 360,
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(7),
//                                       color: Colors.white,
//                                       boxShadow: [
//                                         BoxShadow(
//                                           color: Colors.black.withOpacity(
//                                               0.1),
//                                           spreadRadius: 3,
//                                           blurRadius: 5,
//                                           // changs position of shadow
//                                         ),
//                                       ],
//
//                                     ),
//                                     child:Row(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         Expanded(
//                                             flex:3,
//                                             child: Column(
//                                               crossAxisAlignment: CrossAxisAlignment.start,
//                                               mainAxisAlignment: MainAxisAlignment.center,
//
//                                               children: [
//                                                 SizedBox(height: 160,
//                                                   child: Image.network('https://pngimg.com/uploads/volvo/volvo_PNG74.png'),
//                                                 ),
//
//
//
//                                               ],)),
//                                         const  SizedBox(width: 10,),
//
//                                         Expanded(
//                                             flex:2,
//                                             child: Column(
//                                               crossAxisAlignment: CrossAxisAlignment.start,
//
//                                               children: [
//                                                 const SizedBox(height: 10,),
//
//                                                 SizedBox(
//                                                     height:30,
//                                                     child: Image.network('https://pngimg.com/uploads/volvo/small/volvo_PNG73.png')),
//                                                 const SizedBox(height: 10,),
//                                                 SizedBox(
//                                                     width: 100,
//                                                     child: Text('Volvo, XC90', style: TextStyle(color: RevmoColors.darkBlue, fontWeight: FontWeight.bold),)),
//                                                 Text('A/T/ INSCRIPTION 2021', style: TextStyle(color: RevmoColors.darkBlue, fontWeight: FontWeight.w400),),
//                                                 const SizedBox(height: 20,),
//                                                 Text('Price', style: TextStyle(color: RevmoColors.darkBlue, fontWeight: FontWeight.w600, fontSize: 12),),
//                                                 const SizedBox(height: 5,),
//
//                                                 Text('1,540,000 EGP', style: TextStyle(color: RevmoColors.darkBlue, fontWeight: FontWeight.bold, fontSize: 20),),
//
//                                               ],)),
//
//
//                                       ],
//                                     ),
//                                   ),
//                                 ).setOnlyPadding(context,
//                                     right: index + 1 == index
//                                         ? 15
//                                         : 0,
//                                     enableMediaQuery: false),
//                               ),
//                             ),
//                         separatorBuilder: (context, index) =>
//                             SizedBox(width: 20,),
//                         itemCount: 10),
//                   ),
//                   const  SizedBox(height: 20,),
//
//                   Container(
//                       padding: EdgeInsets.all(10),
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(6),
//                           color: Color(0xff0fffafafa)
//                       ),
//                       child: const   Text('Showrooms', style: TextStyle(color: RevmoColors.darkBlue),).setPageHorizontalPadding(context)),
//                   SizedBox(height: 180,
//                     width: mediaQuery.size.width,
//                     child: ListView.separated(
//                         scrollDirection: Axis.horizontal,
//                         itemBuilder: (context, index) =>
//                             FadeInRight(
//                               duration: Duration(milliseconds: 500),
//                               child: Padding(
//                                 padding: (index == 0)
//                                     ? const EdgeInsets.only(
//                                   left: 14,
//                                 )
//                                     : const EdgeInsets.all(0),
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(7),
//                                   child: Container(
//                                       padding: EdgeInsets.all(5),
//                                       width: 200,
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(7),
//                                         color: Colors.white,
//                                         boxShadow: [
//                                           BoxShadow(
//                                             color: Colors.black.withOpacity(
//                                                 0.1),
//                                             spreadRadius: 3,
//                                             blurRadius: 5,
//                                             // changs position of shadow
//                                           ),
//                                         ],
//
//                                       ),
//                                       child:Column(
//                                         mainAxisAlignment: MainAxisAlignment.center,
//                                         children: [
//                                           SizedBox(
//                                             height: 30,
//                                             child: Image.network('https://contactcars.fra1.cdn.digitaloceanspaces.com/contactcars-production/Images/Small/Dealers/1230610_c09123b2-514f-4a34-a5a2-bf946e6712a9.jpeg'),
//                                           ),
//                                           Text('Cars', style: TextStyle(color: Colors.black,letterSpacing: 10),)
//                                         ],
//                                       )
//                                   ),
//                                 ).setOnlyPadding(context,
//                                     right: index + 1 == index
//                                         ? 15
//                                         : 0,
//                                     enableMediaQuery: false),
//                               ),
//                             ),
//                         separatorBuilder: (context, index) =>
//                             SizedBox(width: 20,),
//                         itemCount: 10),
//                   ),
//                   const  SizedBox(height: 20,),
//                   Container(
//                       padding: EdgeInsets.all(10),
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(6),
//                           color: Color(0xff0fffafafa)
//                       ),
//                       child: const   Text('Recent News', style: TextStyle(color: RevmoColors.darkBlue),).setPageHorizontalPadding(context)),
//
//                   const   SizedBox(height: 5,),
//                   SizedBox(height: 100,)
//
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
    );
  }
}



class DashboardBuyerView extends StatefulWidget {
  @override
  _DashboardBuyerViewState createState() => _DashboardBuyerViewState();
}

class _DashboardBuyerViewState extends State<DashboardBuyerView> {
  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    final customerProvider = Provider.of<HomeProvider>(context);

    return Scaffold(
      backgroundColor: Color(0xfffafafa),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.2,
              color: RevmoColors.darkBlue,
            ),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 30,),
                      ElevatedButton(onPressed: (){
                        pushNewScreen(
                          context,
                          screen: Test(),
                          withNavBar: true, // OPTIONAL VALUE. True by default.
                          pageTransitionAnimation: PageTransitionAnimation.cupertino,
                        );
                        customerProvider.setAppBar();

                      }, child: Text('hide')),
                      WelcomeContainer(name: 'Marc Maged'),
                      const SizedBox(
                        height: 40,
                      ),
                      Text('New To Market'),
                    ],
                  ).setPageHorizontalPadding(context),
                  const SizedBox(
                    height: 3,
                  ),
                  SizedBox(height: 210,
                    width: mediaQuery.size.width,
                    child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) =>
                            FadeInRight(
                              duration: Duration(milliseconds: 500),
                              child: Padding(
                                padding: (index == 0)
                                    ? const EdgeInsets.only(
                                  left: 14,
                                )
                                    : const EdgeInsets.all(0),
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Stack(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(10),
                                        width: 350,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(7),
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                  0.1),
                                              spreadRadius: 3,
                                              blurRadius: 5,
                                            ),
                                          ],

                                        ),
                                        child:Stack(
                                          clipBehavior: Clip.none,
                                          children: [

                                            Positioned(
                                              top:-50,
                                                right: -70,
                                                child: SizedBox(
                                              height: 200,
                                                  child: Image.network("https://pngimg.com/uploads/mitsubishi/mitsubishi_PNG185.png"),
                                            )),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(height: 10,),

                                                SizedBox(
                                                    height:30,
                                                    child: Image.network('https://img.icons8.com/color/344/mitsubishi.png')),
                                               const SizedBox(height: 10,),
                                                SizedBox(
                                                    width: 100,
                                                    child: Text('Mitsubishi Outlander, 2022', style: TextStyle(color: RevmoColors.darkBlue, fontWeight: FontWeight.w600),)),
                                                const SizedBox(height: 30,),
                                                SizedBox(
                                                    width: 100,
                                                    child: Text('Starting Price', style: TextStyle(color: RevmoColors.darkBlue, fontWeight: FontWeight.w600, fontSize: 12),)),
                                                const SizedBox(height: 10,),

                                                Text('540,000 EGP', style: TextStyle(color: RevmoColors.darkBlue, fontWeight: FontWeight.bold, fontSize: 20),),


                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ).setOnlyPadding(context,
                                    right: index + 1 == index
                                        ? 15
                                        : 0,
                                    enableMediaQuery: false),
                              ),
                            ),
                        separatorBuilder: (context, index) =>
                            SizedBox(width: 20,),
                        itemCount: 10),
                  ),
                 const  SizedBox(height: 20,),
                  Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: Color(0xff0fffafafa)
                      ),
                      child: const   Text('Base On Your Search', style: TextStyle(color: RevmoColors.darkBlue),)).setPageHorizontalPadding(context),

                  SizedBox(height: 210,
                    width: mediaQuery.size.width,
                    child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) =>
                            FadeInRight(
                              duration: Duration(milliseconds: 500),
                              child: Padding(
                                padding: (index == 0)
                                    ? const EdgeInsets.only(
                                  left: 14,
                                )
                                    : const EdgeInsets.all(0),
                                child: Padding(
                                  padding: const EdgeInsets.all(7),
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    width: 360,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(
                                              0.1),
                                          spreadRadius: 3,
                                          blurRadius: 5,
                                          // changs position of shadow
                                        ),
                                      ],

                                    ),
                                    child:Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                            flex:3,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.center,

                                              children: [
                                                 SizedBox(height: 160,
                                                child: Image.network('https://pngimg.com/uploads/volvo/volvo_PNG74.png'),
                                                ),



                                              ],)),
                                       const  SizedBox(width: 10,),

                                        Expanded(
                                          flex:2,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,

                                            children: [
                                            const SizedBox(height: 10,),

                                            SizedBox(
                                                height:30,
                                                child: Image.network('https://pngimg.com/uploads/volvo/small/volvo_PNG73.png')),
                                            const SizedBox(height: 10,),
                                            SizedBox(
                                                width: 100,
                                                child: Text('Volvo, XC90', style: TextStyle(color: RevmoColors.darkBlue, fontWeight: FontWeight.bold),)),
                                              Text('A/T/ INSCRIPTION 2021', style: TextStyle(color: RevmoColors.darkBlue, fontWeight: FontWeight.w400),),
                                            const SizedBox(height: 20,),
                                            Text('Price', style: TextStyle(color: RevmoColors.darkBlue, fontWeight: FontWeight.w600, fontSize: 12),),
                                            const SizedBox(height: 5,),

                                            Text('1,540,000 EGP', style: TextStyle(color: RevmoColors.darkBlue, fontWeight: FontWeight.bold, fontSize: 20),),

                                          ],)),


                                      ],
                                    ),
                                  ),
                                ).setOnlyPadding(context,
                                    right: index + 1 == index
                                        ? 15
                                        : 0,
                                    enableMediaQuery: false),
                              ),
                            ),
                        separatorBuilder: (context, index) =>
                            SizedBox(width: 20,),
                        itemCount: 10),
                  ),
                  const  SizedBox(height: 20,),

                  Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: Color(0xff0fffafafa)
                      ),
                      child: const   Text('Showrooms', style: TextStyle(color: RevmoColors.darkBlue),).setPageHorizontalPadding(context)),
                  SizedBox(height: 180,
                    width: mediaQuery.size.width,
                    child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) =>
                            FadeInRight(
                              duration: Duration(milliseconds: 500),
                              child: Padding(
                                padding: (index == 0)
                                    ? const EdgeInsets.only(
                                  left: 14,
                                )
                                    : const EdgeInsets.all(0),
                                child: Padding(
                                  padding: const EdgeInsets.all(7),
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    width: 200,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(
                                              0.1),
                                          spreadRadius: 3,
                                          blurRadius: 5,
                                          // changs position of shadow
                                        ),
                                      ],

                                    ),
                                    child:Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 30,
                                          child: Image.network('https://contactcars.fra1.cdn.digitaloceanspaces.com/contactcars-production/Images/Small/Dealers/1230610_c09123b2-514f-4a34-a5a2-bf946e6712a9.jpeg'),
                                        ),
                                        Text('Cars', style: TextStyle(color: Colors.black,letterSpacing: 10),)
                                      ],
                                    )
                                  ),
                                ).setOnlyPadding(context,
                                    right: index + 1 == index
                                        ? 15
                                        : 0,
                                    enableMediaQuery: false),
                              ),
                            ),
                        separatorBuilder: (context, index) =>
                            SizedBox(width: 20,),
                        itemCount: 10),
                  ),
                  const  SizedBox(height: 20,),
                  Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: Color(0xff0fffafafa)
                      ),
                      child: const   Text('Recent News', style: TextStyle(color: RevmoColors.darkBlue),).setPageHorizontalPadding(context)),

                  const   SizedBox(height: 5,),
                  SizedBox(height: 100,)

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
