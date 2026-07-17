/// 底部导航栏组件
/// 用于在海洋、聊天、我的三个主页面间切换
library;

import 'package:flutter/material.dart';

/// 底部导航栏组件
/// 配合主题中的 bottomNavigationBarTheme 样式
class NavBar extends StatelessWidget {
  /// 当前选中的标签索引
  final int currentIndex;

  const NavBar({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      backgroundColor: const Color(0xE6023E8A),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.waves),
          label: '海洋',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat_bubble_outline),
          label: '聊天',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: '我的',
        ),
      ],
      onTap: (index) => _onItemTapped(context, index),
    );
  }

  /// 处理标签点击事件
  /// 跳转到对应的路由页面，并清除路由栈
  void _onItemTapped(BuildContext context, int index) {
    // 点击当前页面时不跳转
    if (index == currentIndex) return;

    // 路由映射表
    const routes = ['/ocean', '/chats', '/profile'];
    final route = routes[index];

    Navigator.pushNamedAndRemoveUntil(
      context,
      route,
      (route) => false,
    );
  }
}
