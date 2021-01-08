import '../../backend/cont.dart';
import '../../backend/model.dart';
import '../../screens/glossary/glossary.dart';
import '../../screens/percentMac/percentmac.dart';
import '../../screens/units/units.dart';
import '../../widgets/display/text.dart';
import '../../widgets/input/leadingMDS.dart';
import '../../widgets/input/moreOpPopup.dart';
import 'package:flutter/material.dart';

class BottomNav extends StatefulWidget {
  final Aircraft air;
  final MoreOp moreOp;
  var tabPages =List<Widget>();
  BottomNav(this.air, this.moreOp){
    tabPages.add(Units());
    tabPages.add(PerMacScreen(air));
    tabPages.add(GlossaryScreen(air));
  }

  @override
  _BottomNavState createState() => new _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _pageIndex = 0;
  PageController _pageController;
  var titleArr = ['Units', 'MAC%', 'Glossary'];

  @override
  void initState() {
    _pageController = PageController(initialPage: _pageIndex);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      this._pageIndex = page;
    });
  }

  void onTabTapped(int index) {
    this._pageController.animateToPage(index,
        duration: const Duration(milliseconds: Const.animationDuration), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
        onPointerDown: (_) {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            currentFocus.focusedChild.unfocus();
          }
        },
        child: Scaffold(
          backgroundColor: Const.background,
          appBar: AppBar(
            leadingWidth: Const.pickerWidth ,
            leading: LeadingMDS(
              text: this.widget.air.name,
              onPressed: (){Navigator.pop(context);},
            ),
            backgroundColor: Const.bottombarcolor,
            title: Tex(titleArr[_pageIndex]),
            actions: [MoreOpPopup(this.widget.moreOp)],
          ),
          bottomNavigationBar: BottomNavigationBar(
            showSelectedLabels: true,
            showUnselectedLabels: true,
            currentIndex: _pageIndex,
            onTap: onTabTapped,
            backgroundColor: Const.bottombarcolor,
            selectedItemColor: Const.navBarSelected,
            unselectedItemColor: Const.navBarDeselected,
            type: BottomNavigationBarType.fixed,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.access_alarm),
                label: 'Units',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.flight_land),
                label: 'MAC%',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.receipt),
                label: 'Glossary',
              ),
            ],
          ),
          body: PageView(
            children: this.widget.tabPages,
            onPageChanged: onPageChanged,
            controller: _pageController,
          ),
        ));
  }
}
