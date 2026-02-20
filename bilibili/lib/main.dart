import 'package:bilibili/profile_screen.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart';

// 【为什么要用 main 函数和 runApp？】
// 这是 Flutter 应用的唯一入口。runApp 会告诉系统：请把括号里的小部件（Widget）作为整个 App 的根节点画在屏幕上。
void main() {
  runApp(const BilibiliApp());
}

// 【为什么要继承 StatelessWidget？】
// BilibiliApp 是最外层的配置层，它的状态（比如主题色、应用名称）一旦设定就不会改变，所以用无状态组件 StatelessWidget。
class BilibiliApp extends StatelessWidget {
  const BilibiliApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 【为什么要用 MaterialApp？】
    // 它是 Google Material Design 设计规范的顶级大管家。
    // 它帮我们在底层处理好了页面的路由跳转逻辑、全局的文字排版方向、以及最重要的全局主题色。
    return MaterialApp(
      title: 'Bilibili Clone',
      // 主题配置：我们将全局的主题色设置为 B站的标志性“哔哩粉”
      theme: ThemeData(
        primaryColor: const Color(0xFFFB7299), 
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFB7299)),
        useMaterial3: true,
      ),
      home: const MainScreen(), // home 属性决定了 App 启动后看到的第一个页面
    );
  }
}

// 【为什么要继承 StatefulWidget？】
// 因为我们的底部导航栏需要“点击切换”状态。
// 当前选中了哪个 Tab（用数字索引表示，如0, 1, 2）是一个经常在变化的数据，需要用有状态组件 StatefulWidget 来管理。
class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // 核心变量：记录当前点击了底部的哪一个按钮，默认 0 代表第一个（首页）
  int _currentIndex = 0;

  // 页面列表：存放我们要展示的三个主体页面。这里先用简单的文字占位。
  final List<Widget> _pages = [
    const HomeScreen(),
    const Center(child: Text('第一阶段占位：发布页面', style: TextStyle(fontSize: 20))),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    // 【为什么要用 Scaffold？】
    // 它的中文名叫“脚手架”。开发 App 就像盖房子，Scaffold 提供了一个标准的页面骨架。
    // 它自带了顶部 AppBar、底部 BottomNavigationBar、侧滑菜单 Drawer 等固定插槽，直接往里填东西就行。
    return Scaffold(
      
      // 【为什么要用 IndexedStack 而不是直接放一个 Widget？】
      // 这是个大坑！如果直接根据 _currentIndex 切换页面，每次切换原来的页面都会被“销毁”。
      // 比如你在“首页”往下滑了很长，点了一下“我的”，再点回“首页”，页面会回到最顶部！
      // IndexedStack 就是为了解决这个问题，它把所有页面像扑克牌一样叠在一起，
      // 只显示 index 对应的那一张，其他的隐藏但不销毁，从而完美保留滑动进度和状态。
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),

      // 配置底部的导航栏
      // 【为什么要用 BottomNavigationBar？】
      // 它是 Material 规范里最标准、最常用的底部切换栏组件。
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex, // 告诉导航栏当前应该高亮哪一个
        // 当用户点击某个 Tab 时触发这个回调函数
        onTap: (index) {
          // 【为什么要用 setState？】
          // 仅仅改变 _currentIndex 的值是不够的，必须包在 setState 里，
          // 这样才能通知 Flutter 框架：“数据变了，请拿着新的数据把界面重新画一遍！”
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: const Color(0xFFFB7299), // 选中的颜色设为粉色
        unselectedItemColor: Colors.grey,          // 未选中的设为灰色
        type: BottomNavigationBarType.fixed,       // 固定类型，防止图标超过3个时产生奇怪的滑动动画
        
        // items 里面定义了具体的按钮样式
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined), // 未选中时的空心图标
            activeIcon: Icon(Icons.home),    // 选中时的实心图标
            label: '首页',
          ),
          
          // 【为什么要这样写中间的按钮？】
          // B站中间的加号按钮是一个带圆角的粉色小方块，单纯的 Icon 无法实现。
          // 所以我们用 Container（容器）给它画一个粉色背景和圆角，里面再塞一个白色的 + 号图标。
          BottomNavigationBarItem(
            icon: Container(
              width: 40,
              height: 30,
              decoration: BoxDecoration(
                color: const Color(0xFFFB7299),
                borderRadius: BorderRadius.circular(10), // 圆角
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 20),
            ),
            label: '', // 中间通常不显示文字
          ),
          
          const BottomNavigationBarItem(
            icon: Icon(Icons.tv_outlined), // 暂时用电视机图标代表“我的”
            activeIcon: Icon(Icons.tv),
            label: '我的',
          ),
        ],
      ),
    );
  }
}