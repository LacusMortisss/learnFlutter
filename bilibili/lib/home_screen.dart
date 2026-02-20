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
              //  AssetImage 加载本地图片
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
                  "搜索", // 使用空字符串占位
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
          ),

          // 3. actions: AppBar 右侧的专属插槽，通常放一排操作按钮
          actions: [
            // 游戏中心图标
            IconButton(
              icon: const Icon(
                Icons.sports_esports_outlined,
                color: Colors.black54,
              ),
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
        // 【为什么要用 TabBarView？】
        // 它与顶部的 TabBar 联动，负责展示不同分类下的页面内容。
        body: TabBarView(
          children: [
            const Center(
              child: Text('这里是【直播】页面', style: TextStyle(fontSize: 20)),
            ),

            // 🌟 核心 1：【推荐】页面的双列网格
            // 【为什么要用 GridView.builder 而不是 GridView.count？】
            // .builder 是“懒加载”的，只有滑动到屏幕上的卡片才会被渲染，
            // 像 B站这样有无数个视频的列表，如果不用懒加载，手机会直接卡死内存溢出。
            GridView.builder(
              padding: const EdgeInsets.all(8.0), // 整个网格的外边距
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 【为什么是2？】定义为双列布局
                crossAxisSpacing: 8.0, // 列与列之间的间距
                mainAxisSpacing: 8.0, // 行与行之间的间距
                childAspectRatio: 0.85, // 【控制卡片高宽比】数字越小卡片越长，你可以根据感觉微调这个数字
              ),
              itemCount: 50, // 假设先加载 10 个视频
              itemBuilder: (context, index) {
                // 每次循环，就画出一个我们在下面自定义的 RecommendCard
                return const RecommendCard();
              },
            ),

            // 🌟 核心 2：【热门】页面的单列列表
            // 【为什么要用 ListView.builder？】
            // 同理，这也是为了无限滚动的懒加载。它天然就是单列往下排的。
            ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: 10,
              itemBuilder: (context, index) {
                // 每次循环，画出一个 HotVideoCard
                return const HotVideoCard();
              },
            ),

            const Center(
              child: Text('这里是【动画】页面', style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }
}

class RecommendCard extends StatelessWidget {
  const RecommendCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                color: Colors.grey[300],
                child: Image.asset("assets/images/2.png", fit: BoxFit.cover),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "占位符",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.play_circle_outline,
                        size: 14,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        "11.1万",
                        style: TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                      const Spacer(),
                      const Icon(Icons.more_vert, size: 14, color: Colors.grey),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HotVideoCard extends StatelessWidget {
  const HotVideoCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      height: 100,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 160,
              height: 100,
              color: Colors.grey[300],
              child: Image.asset("assets/images/3.png", fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "占位文字",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFFFB7299),
                          width: 0.5,
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: const Text(
                        "百万播放",
                        style: TextStyle(
                          fontSize: 10,
                          color: Color(0xFFFB7299),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: const [
                        Icon(
                          Icons.person_outline,
                          size: 14,
                          color: Colors.grey,
                        ),
                        SizedBox(width: 4),
                        Text(
                          "占位符",
                          style: TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                        Spacer(),
                        Icon(Icons.more_vert, size: 14, color: Colors.grey),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
