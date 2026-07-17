/// DriftBottle 应用入口
/// 初始化Supabase、Provider、路由配置
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'config/theme.dart';
import 'providers/user_provider.dart';
import 'providers/bottle_provider.dart';
import 'services/supabase_service.dart';
import 'screens/ocean_screen.dart';
import 'screens/throw_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/chat_list_screen.dart';
import 'screens/profile_screen.dart';

void main() async {
  // 确保Flutter绑定初始化
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化Supabase服务（内部会初始化Supabase Flutter SDK）
  await SupabaseService.instance.initialize();

  runApp(const DriftBottleApp());
}

/// DriftBottle应用根Widget
class DriftBottleApp extends StatelessWidget {
  const DriftBottleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>(
          create: (_) => UserProvider()..init(),
        ),
        ChangeNotifierProvider<BottleProvider>(
          create: (_) => BottleProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'DriftBottle',
        debugShowCheckedModeBanner: false,
        theme: getAppTheme(),
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/ocean': (context) => const OceanScreen(),
          '/throw': (context) => const ThrowScreen(),
          '/chat': (context) => const ChatScreen(),
          '/chats': (context) => const ChatListScreen(),
          '/profile': (context) => const ProfileScreen(),
        },
      ),
    );
  }
}

/// 启动页 - 等待用户初始化完成后跳转到海洋页面
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        // 加载中 - 显示启动动画
        if (userProvider.isLoading) {
          return Container(
            decoration: getOceanBackground(),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 瓶子图标
                    Icon(
                      Icons.local_drink,
                      size: 80,
                      color: secondaryColor.withValues(alpha: 0.8),
                    ),
                    const SizedBox(height: 24),
                    // 应用名称
                    Text(
                      'DriftBottle',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: textPrimary,
                            letterSpacing: 2,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '漂流瓶 · 连接世界',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: textHint,
                          ),
                    ),
                    const SizedBox(height: 40),
                    // 加载指示器
                    CircularProgressIndicator(
                      color: secondaryColor.withValues(alpha: 0.6),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        // 初始化完成 - 跳转到海洋页面
        // 使用postCallback确保在build完成后执行导航
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacementNamed(context, '/ocean');
        });

        // 返回空容器（导航会在下一帧执行）
        return Container(
          decoration: getOceanBackground(),
          child: const Scaffold(
            backgroundColor: Colors.transparent,
            body: SizedBox.shrink(),
          ),
        );
      },
    );
  }
}
