import 'package:dogs_path/Models/dashboard_path_model.dart';
import 'package:dogs_path/Services/services.dart';
import 'package:dogs_path/Utils/custom_style.dart';
import 'package:dogs_path/Utils/dimensions.dart';
import 'package:dogs_path/Utils/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = true;
  List<DashboardPathModel> dashboardPaths = [];

  double screenHeight;
  double screenWidth;

  List<PageController> pageController = <PageController>[];
  List<ScrollController> scrollController = <ScrollController>[];

  @override
  void initState() {
    getPaths().then((data) {
      if (data.length != 0) {
        dashboardPaths = data;
      }
      pageController.length = dashboardPaths.length;
      scrollController.length = dashboardPaths.length;
      for (int i = 0; i < dashboardPaths.length; i++) {
        pageController[i] =
            PageController(initialPage: 0, keepPage: true, viewportFraction: 1);
        scrollController[0] = ScrollController(keepScrollOffset: true);
      }
      setState(() {
        isLoading = false;
      });
    }).catchError((error) {
      print(error);
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.black54,
      appBar: AppBar(
        title: Text(Strings.appName, style: CustomStyle.headerStyle),
        centerTitle: true,
        backgroundColor: Colors.grey,
        elevation: 0,
      ),
      body: (!isLoading)
          ? Container(
              child: ListView.builder(
                  itemCount: 15,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Container(
                      margin:
                          EdgeInsets.only(bottom: Dimensions.marginSize * 0.5),
                      height: screenHeight * 0.5,
                      width: screenWidth * 0.5,
                      child: subPathWidget(
                          context, dashboardPaths.elementAt(index), index),
                    );
                  }),
            )
          : Container(
              height: screenWidth * 2,
              width: screenWidth * 2,
              color: Colors.white,
              child: Center(child: CircularProgressIndicator()),
            ),
    ));
  }

  Widget subPathWidget(BuildContext context, DashboardPathModel dashboardPaths,
      int verticalListIdx) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Container(
        height: screenHeight,
        width: screenWidth,
        color: Colors.black54,
        child: Column(children: <Widget>[
          Container(
            color: Colors.grey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(dashboardPaths.title ?? '',
                      style: CustomStyle.headerStyle),
                  Text('${dashboardPaths.subPaths.length ?? 0} Sub Paths',
                      style: CustomStyle.textStyle)
                ]),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    color: Colors.black54,
                    child: TextButton(
                        onPressed: null,
                        child: Text(Strings.openPath,
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: Dimensions.defaultTextSize))),
                  ),
                )
              ],
            ),
          ),
          Container(
            height: screenHeight * 0.35,
            width: screenWidth,
            child: PageView.builder(
                itemCount: dashboardPaths.subPaths.length,
                scrollDirection: Axis.horizontal,
                controller: pageController.elementAt(verticalListIdx),
                itemBuilder: (context, index) {
                  return Image.network(
                    dashboardPaths.subPaths.elementAt(index).image,
                    height: screenHeight * 0.4,
                    width: screenWidth,
                    fit: BoxFit.cover,
                    errorBuilder: (BuildContext context, Object exception,
                        StackTrace stackTrace) {
                      return Center(
                          child: Text('Image not Found',
                              style: TextStyle(color: Colors.white)));
                    },
                  );
                }),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: dashboardPaths.subPaths.length,
                scrollDirection: Axis.horizontal,
                controller: scrollController.elementAt(verticalListIdx),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      onIdxChange(index, verticalListIdx);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        (index != 0)
                            ? Icon(Icons.arrow_forward, color: Colors.white)
                            : Container(),
                        (index != 0)
                            ? SizedBox(width: Dimensions.marginSize * 0.5)
                            : Container(),
                        Text(dashboardPaths.title ?? '',
                            style: CustomStyle.headerStyle),
                        SizedBox(width: Dimensions.marginSize * 0.5),
                      ],
                    ),
                  );
                }),
          )
        ]));
  }

  onIdxChange(int idx, int verticalListIdx) {
    print(idx);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      pageController.elementAt(verticalListIdx).animateToPage(idx,
          duration: Duration(milliseconds: 100), curve: Curves.bounceInOut);
    });
  }
}
