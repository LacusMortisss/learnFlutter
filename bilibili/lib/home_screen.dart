import 'package:flutter/material.dart';

// 【为什么要用 StatelessWidget？】
// 这里的 HomeScreen 主要是用来展示 UI 结构的，状态管理（比如当前滑到了哪个 Tab）
// 交给了 DefaultTabController 来自动处理，所以不需要自己写 State。
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 【为什么要用 DefaultTabController？】
    // 这是一个非常方便的“包裹”组件。我们要实现顶部的 Tab 按钮和下方页面的左右滑动联动。
    // 如果不用它，我们需要自己写 Controller、混入动画生命周期（TickerProviderStateMixin），非常繁琐。
    // 用了 DefaultTabController，只要声明 length（有几个 Tab），它就会自动把内部的 TabBar 和 TabBarView 绑定在一起！
    return DefaultTabController(
      length: 4, // 根据截图，我们先做4个分类：直播、推荐、热门、动画
      
      // 【为什么要再套一个 Scaffold？】
      // 虽然我们在 main.dart 已经有了一个最外层的 Scaffold，但那是为了装底部导航栏的。
      // 现在的 HomeScreen 是其中的一个页面，它自己也需要一个标准的“顶部栏 (AppBar)”，
      // 所以页面内部再用一个 Scaffold 是非常合理的嵌套方式。
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white, // B站顶部是白色的
          elevation: 0, // 【为什么要设为0？】去掉 AppBar 默认自带的底部阴影，让它和下面的页面融为一体，更现代。
          
          // 1. leading: AppBar 左侧的专属插槽，通常放返回键，这里放用户头像
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            // 【为什么要用 CircleAvatar？】
            // 如果自己用 Container 写圆角裁剪图片很麻烦。CircleAvatar 专门用来做圆形头像，
            // 只需要给它一张图片，它自动帮你裁成完美的圆形。
            child: const CircleAvatar(
              // 这里暂时用网络占位图，后续你可以换成 AssetImage 加载本地图片
              backgroundImage: AssetImage("assets/images/1.jpg"), 
              radius: 20,
            ),
          ),
          
          // 2. title: AppBar 中间的专属插槽，放搜索框
          title: Container(
            height: 36, // 控制假搜索框的高度
            // 【为什么要用 BoxDecoration？】
            // 我们不想在这里放一个真实的输入框（TextField），因为在主流 App 中，
            // 首页的搜索框通常是个“假按钮”，点击后跳转到专门的搜索页才弹出键盘。
            // BoxDecoration 可以帮我们画出那个灰色的、带圆角的胶囊背景。
            decoration: BoxDecoration(
              color: Colors.grey[100], 
              borderRadius: BorderRadius.circular(18), // 圆角弧度等于高度的一半，就是完美的胶囊形
            ),
            child: Row(
              children: const [
                SizedBox(width: 10), // 左边留点空隙
                Icon(Icons.search, color: Colors.grey, size: 20), // 放大镜图标
                SizedBox(width: 5),
                Text(
                  '鸣潮光头哥', // 对应你截图里的搜索词
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
          ),

          // 3. actions: AppBar 右侧的专属插槽，通常放一排操作按钮
          actions: [
            // 游戏中心图标
            IconButton(
              icon: const Icon(Icons.sports_esports_outlined, color: Colors.black54),
              onPressed: () {
                // 点击事件留空，后续可以加跳转
              },
            ),
            // 消息信封图标
            IconButton(
              icon: const Icon(Icons.mail_outline, color: Colors.black54),
              onPressed: () {},
            ),
            const SizedBox(width: 10), // 最右侧留一点边距，避免贴边太紧
          ],

          // 4. bottom: AppBar 底部的专属插槽，最适合用来放 TabBar
          bottom: const TabBar(
            // 【为什么要单独配置颜色？】
            // 定制成 B站的粉色风格。
            labelColor: Color(0xFFFB7299), // 选中的文字颜色（哔哩粉）
            unselectedLabelColor: Colors.grey, // 未选中的文字颜色（灰色）
            indicatorColor: Color(0xFFFB7299), // 底部指示器（那根滑动的小横线）的颜色
            // 【为什么用 label 尺寸？】
            // 默认情况下小横线会占满整个格子的宽度，设为 label 后，横线只会和文字一样宽，更精致。
            indicatorSize: TabBarIndicatorSize.label, 
            // 移除点击时的水波纹高亮效果，更贴近原生 App 体验
            splashFactory: NoSplash.splashFactory,
            tabs: [
              Tab(text: '直播'),
              Tab(text: '推荐'),
              Tab(text: '热门'),
              Tab(text: '动画'),
            ],
          ),
        ),
        
        // 【为什么要用 TabBarView？】
        // 它是 TabBar 的最佳搭档。TabBar 控制头部标签，TabBarView 控制身体内容。
        // 它自带左右滑动手势。注意：这里的 children 数量（4个）必须和上面 tabs 的数量严格一致，否则会报错！
        body: const TabBarView(
          children: [
            Center(child: Text('这里是【直播】页面', style: TextStyle(fontSize: 20))),
            Center(child: Text('这里是【推荐】页面\n（下一阶段我们在这里画视频网格）', textAlign: TextAlign.center)),
            Center(child: Text('这里是【热门】页面\n（下一阶段我们在这里画大卡片列表）', textAlign: TextAlign.center)),
            Center(child: Text('这里是【动画】页面', style: TextStyle(fontSize: 20))),
          ],
        ),
      ),
    );
  }
}