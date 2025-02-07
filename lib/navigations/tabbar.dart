import 'package:flutter/material.dart';
import 'package:untitled/presentation/pages/home_page.dart';
import 'package:untitled/presentation/pages/search_page.dart';
import 'package:untitled/presentation/pages/library_page.dart';
import 'package:untitled/presentation/pages/premium_page.dart';

class Tabbar extends StatefulWidget {
  const Tabbar({super.key});

  @override
  State<StatefulWidget> createState() {
    return TabbarState();
  }
}

class TabbarState extends State<Tabbar> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          renderView(0, const HomePage()),
          renderView(1, const SearchPage()),
          renderView(2, const LibraryPage()),
          renderView(3, const PremiumPage()),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTab,
        onTap: (index) {
          setState(() {
            _selectedTab = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Tìm kiếm',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_music_outlined),
            label: 'Thư viện',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business_center_outlined),
            label: 'Premium',
          ),
        ],
      ),
    );
  }

  Widget renderView(int tabIndex, Widget page) {
    return IgnorePointer(
      ignoring: _selectedTab != tabIndex,
      child: Opacity(
        opacity: _selectedTab == tabIndex ? 1 : 0,
        child: page,
      ),
    );
  }
}
