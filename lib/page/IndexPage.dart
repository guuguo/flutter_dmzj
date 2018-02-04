import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/page/mainPage.dart';
import 'package:flutter_demo/page/mainpage/recommend.dart';
import 'package:flutter_demo/utils/db.dart';

class IndexPage extends StatefulWidget {
  IndexPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _IndexPageState createState() => new _IndexPageState();
}
//
//class TabBean {
//  var title = "";
//  Widget page;
//  Icon icon;
//
//  TabBean(this.title, this.page, this.icon);
//}

class _IndexPageState extends State<IndexPage>
    with TickerProviderStateMixin {
  int _currentIndex = 0;

  List<NavigationView> _allPages;

  @override
  void initState() {
    super.initState();
    DB.open();
    _allPages = [
      new NavigationView (
          "推荐", new MainPage(), const Icon(Icons.access_alarm), this),
      new NavigationView (
          "收藏", new EmptyPage(), const Icon(Icons.favorite), this),
      new NavigationView (
          "历史", new EmptyPage(), const Icon(Icons.history), this),
    ];
    _allPages.forEach((v) =>v.controller.addListener(_rebuild));
    _allPages[_currentIndex].controller.value = 1.0;
  }

  void _rebuild() {
    setState(() {
      // Rebuild in order to animate views.
    });
  }
  @override
  void dispose() {
    _allPages.forEach((v) =>v.controller.dispose());
    super.dispose();
  }

  Widget _buildTransitionsStack() {
    final List<FadeTransition> transitions = _allPages.map((bean) =>
        bean.transition()).toList();

    // We want to have the newly animating (fading in) views on top.
    transitions.sort((FadeTransition a, FadeTransition b) {
      final Animation<double> aAnimation = a.opacity;
      final Animation<double> bAnimation = b.opacity;
      final double aValue = aAnimation.value;
      final double bValue = bAnimation.value;
      return aValue.compareTo(bValue);
    });

    return new Stack(children: transitions);
  }

  @override
  Widget build(BuildContext context) {
    final BottomNavigationBar botNavBar = new BottomNavigationBar(
      items: _allPages.map((NavigationView bean) => bean.item).toList(),
      currentIndex: _currentIndex,
      type: BottomNavigationBarType.fixed,
      onTap: (int index) {
        setState(() {
          _allPages[_currentIndex].controller.reverse();
          _currentIndex = index;
          _allPages[_currentIndex].controller.forward();
        });
      },
    );
    return new DefaultTabController(
      length: _allPages.length,
      child: new Scaffold(
//        appBar: new AppBar(
//            iconTheme: Theme
//                .of(context)
//                .primaryIconTheme,
//            brightness: Brightness.dark,
////            title: new TabBar(
////                controller: _tabController,
////                tabs: _allPages.keys.map((String str) {
////                return new Tab(text: str);
////              }).toList(),
////            ),
//            actions: <Widget>[
//              new IconButton(
//                  icon: const Icon(Icons.search),
//                  tooltip: 'Search',
//                  onPressed: () {
//                    Navigator.of(context, rootNavigator: true).push(
//                      new CupertinoPageRoute<Null>(
//                        builder: (BuildContext context) => new SearchPage(),
//                      ),
//                    );
//                  }),
//            ]),
        body: new Center(
            child: _buildTransitionsStack()
        ),
        bottomNavigationBar: botNavBar,
      ),
    );
  }
}

class NavigationView {
  NavigationView(this.title,
      Widget page,
      this.icon,
      TickerProvider vsync,)
      : page = page,
        controller = new AnimationController(
          duration: kThemeAnimationDuration,
          vsync: vsync,
        ),
        item = new BottomNavigationBarItem(
          icon: icon,
          title: new Text(title),
        ) {
    _animation = new CurvedAnimation(
      parent: controller,
      curve: const Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
    );
  }

  final String title;
  final Widget page;
  final Icon icon;
  final BottomNavigationBarItem item;

  final AnimationController controller;
  CurvedAnimation _animation;

  FadeTransition transition() {
    return new FadeTransition(
      opacity: _animation,
      child: new SlideTransition(
        position: new Tween<Offset>(
          begin: const Offset(0.0, 0.02), // Slightly down.
          end: Offset.zero,
        ).animate(_animation),
        child: page,
      ),
    );
  }
}

