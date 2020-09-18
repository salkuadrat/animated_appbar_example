import 'package:curved_animation_controller/curved_animation_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animated AppBar Like Tokopedia',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Tokopedia(),
    );
  }
}

class Tokopedia extends StatefulWidget {
  @override
  _TokopediaState createState() => _TokopediaState();
}

class _TokopediaState extends State<Tokopedia> with TickerProviderStateMixin {

  ScrollController _scrollController = ScrollController();
  CurvedAnimationController<Color> _animationBackground;
  CurvedAnimationController<Color> _animationInput;
  CurvedAnimationController<Color> _animationIcon;

  double get _systemBarHeight => MediaQuery.of(context).padding.top;
  double get _appBarHeight => kToolbarHeight + _systemBarHeight;
  double get _appBarPaddingVertical => 10;
  double get _appBarPaddingTop => _systemBarHeight + _appBarPaddingVertical;
  double get _appBarPaddingBottom => _appBarPaddingVertical;

  Color _appbarBackgroundColorBegin = Colors.white.withOpacity(0.0);
  Color _appbarBackgroundColorEnd = Colors.white;

  Color _inputBackgroundColorBegin = Colors.white.withOpacity(0.92);
  Color _inputBackgroundColorEnd = Color(0xFFEFEFEF);

  Color _iconColorBegin = Colors.white.withOpacity(0.92);
  Color _iconColorEnd = Colors.grey;

  @override
  void initState() {
    _initAnimation();
    super.initState();
    _initScroll();
  }

  _initAnimation() {
    _animationBackground = CurvedAnimationController<Color>.tween(
      ColorTween(begin: _appbarBackgroundColorBegin, end: _appbarBackgroundColorEnd), 
      Duration(milliseconds: 300),
      curve: Curves.ease,
      vsync: this,
    );

    _animationInput = CurvedAnimationController<Color>.tween(
      ColorTween(begin: _inputBackgroundColorBegin, end: _inputBackgroundColorEnd), 
      Duration(milliseconds: 300),
      curve: Curves.ease,
      vsync: this,
    );

    _animationIcon = CurvedAnimationController<Color>.tween(
      ColorTween(begin: _iconColorBegin, end: _iconColorEnd), 
      Duration(milliseconds: 300),
      curve: Curves.ease,
      vsync: this,
    );

    _animationBackground.addListener(() => setState((){}));
    _animationInput.addListener(() => setState((){}));
    _animationIcon.addListener(() => setState((){}));
  }

  _initScroll() {
    _scrollController.addListener(() {
      double startAnimationAfterOffset = kToolbarHeight;
      double scrollOffsetBackground = 200;
      double scrollOffsetInput = 200;
      double scrollOffsetIcon = 150;

      // delay animation to start animate only after scrolling 
      // as far as startAnimationAfterOffset value
      // this is for a smoother effect
      if(_scrollController.offset > startAnimationAfterOffset) 
      {
        double offset = _scrollController.offset - startAnimationAfterOffset;

        _animationBackground.progress = (offset / scrollOffsetBackground);
        _animationInput.progress = (offset / scrollOffsetInput);
        _animationIcon.progress = (offset / scrollOffsetIcon);
      }
    });
  }

  Widget get _appbar => Container(
    height: _appBarHeight,
    padding: EdgeInsets.only(
      top: _appBarPaddingTop,
      bottom: _appBarPaddingBottom,
    ),
    color: _animationBackground.value,
    child: Row(
      children: [
        SizedBox(width: 15),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 0),
            decoration: BoxDecoration(
              color: _animationInput.value,
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: TextField(
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                border: InputBorder.none,
                hintText: 'Search...',
                hintStyle: TextStyle(
                  color: Colors.black38, 
                  fontSize: 14,
                ),
              ),
              style: TextStyle(color: Colors.black54, fontSize: 14),
            ),
          ),
        ),
        SizedBox(width: 13),
        IconButton(
          icon: Icon(Icons.favorite, color: _animationIcon.value), 
          onPressed: (){},
        ),
        IconButton(
          icon: Icon(Icons.notifications_active, color: _animationIcon.value), 
          onPressed: (){},
        ),
        IconButton(
          icon: Icon(Icons.add_shopping_cart, color: _animationIcon.value), 
          onPressed: (){},
        ),
      ],
    ),
  );

  Widget get _content => SingleChildScrollView(
    controller: _scrollController,
    child: Column(
      children: [
        Container(
          height: 300,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.0, 1.0],
              colors: [
                Color(0xFF000046),
                Color(0xFF1CB5E0)
              ],
            ),
          ),
        ),
        Container(height: 1, color: Color(0xFF000046)),
        Container(height: 1200, color: Color(0xFFEEEEEE)),
      ],
    ),
  );

  Widget get _navbar => BottomNavigationBar(
    selectedItemColor: Colors.black87,
    unselectedItemColor: Colors.black45,
    showUnselectedLabels: true,
    iconSize: 25,
    selectedFontSize: 12,
    unselectedFontSize: 12,
    currentIndex: 0,
    items: [
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        title: Text('Home'),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.favorite_border),
        title: Text('Loved'),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person_outline),
        title: Text('Account'),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.search),
        title: Text('Search'),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _content,
          _appbar,
        ],
      ),
      bottomNavigationBar: _navbar,
    );
  }
}