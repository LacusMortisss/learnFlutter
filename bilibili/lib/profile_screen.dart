import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 【为什么要用 Scaffold？】
    // 依然是提供基础页面骨架。这里我们将背景色设为纯白，与截图一致。
    return Scaffold(
      backgroundColor: Colors.white,
      
      // 1. 顶部操作栏
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // 右侧的一排小图标：投屏、皮肤、夜间模式
        actions: [
          IconButton(icon: const Icon(Icons.cast, color: Colors.grey), onPressed: () {}),
          IconButton(icon: const Icon(Icons.checkroom, color: Colors.grey), onPressed: () {}),
          IconButton(icon: const Icon(Icons.dark_mode_outlined, color: Colors.grey), onPressed: () {}),
          const SizedBox(width: 10),
        ],
      ),

      // 2. 页面主体内容
      // 【为什么要用 SingleChildScrollView？】
      // 个人中心的内容往往很多。如果不包裹一层“允许单一方向滚动”的视图，
      // 当内容超出屏幕高度时，Flutter 会直接在屏幕底部报 "Bottom overflowed" 的黄黑条警告。
      // 包裹它之后，整个 Column 就可以自由上下滑动了。
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 区块 A：用户信息 ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              // 【为什么用 Row？】左边头像，中间名字和等级，右边“空间”入口，这是经典的水平排布。
              child: Row(
                children: [
                  // 左侧大头像
                  const CircleAvatar(
                    radius: 35, // radius 控制头像大小，比首页的要大一些
                    backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=32'),
                  ),
                  const SizedBox(width: 16),
                  
                  // 中间的信息列
                  // 【为什么要用 Expanded？】让中间的文字部分占满剩下的空间，把右边的“空间 >”推到最边缘。
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 昵称和等级
                        Row(
                          children: [
                            const Text(
                              '脆香若叶睦', // 你的截图昵称
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFFB7299)),
                            ),
                            const SizedBox(width: 8),
                            // 模拟等级标签
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                              decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(2)),
                              child: const Text('LV6', style: TextStyle(color: Colors.white, fontSize: 10, fontStyle: FontStyle.italic)),
                            )
                          ],
                        ),
                        const SizedBox(height: 4),
                        // 大会员标识和硬币信息
                        const Text('年度大会员', style: TextStyle(fontSize: 12, color: Color(0xFFFB7299))),
                        const SizedBox(height: 4),
                        const Text('B币: 5.2   硬币: 732', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ),
                  
                  // 右侧空间入口
                  const Text('空间 >', style: TextStyle(color: Colors.grey, fontSize: 14)),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // --- 区块 B：动态 / 关注 / 粉丝 数据 ---
            // 【为什么要用 Row + mainAxisAlignment: spaceAround？】
            // spaceAround 可以自动计算剩余空间，均匀地把这三个数据块分散在水平方向上，不需要手动写死间距。
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatColumn('10', '动态'),
                _buildStatColumn('35', '关注'),
                _buildStatColumn('36', '粉丝'),
              ],
            ),
            const SizedBox(height: 24),

            // --- 区块 C：大会员促销横幅 ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              // 【为什么用 Container 构建横幅？】我们需要一个带圆角、浅粉色背景的完整色块。
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF0F3), // 极浅的粉色背景
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('您的特惠福利已到账', style: TextStyle(color: Color(0xFFFB7299), fontWeight: FontWeight.bold)),
                        Text('大会员x联合会员低至4.0折 >', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                    // 模拟右侧的粉色按钮
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFB7299),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      child: const Text('会员中心', style: TextStyle(color: Colors.white)),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // --- 区块 D：常用功能区 (4个图标) ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildIconText(Icons.download_for_offline_outlined, '离线缓存', Colors.blue),
                _buildIconText(Icons.history, '历史记录', Colors.blue),
                _buildIconText(Icons.star_border, '我的收藏', Colors.blue),
                _buildIconText(Icons.watch_later_outlined, '稍后再看', Colors.blue),
              ],
            ),
            
            const SizedBox(height: 24),
            // 【为什么要用 Divider？】这是一条极简的水平分割线，用来区分不同的功能大类。
            const Divider(thickness: 8, color: Color(0xFFF4F4F4)), 

            // --- 区块 E：创作中心 ---
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('创作中心', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  // 截图里右侧那个显眼的发布按钮
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: const Color(0xFFFB7299), borderRadius: BorderRadius.circular(15)),
                    child: Row(
                      children: const [
                        Icon(Icons.upload, color: Colors.white, size: 16),
                        SizedBox(width: 4),
                        Text('发布', style: TextStyle(color: Colors.white, fontSize: 12)),
                      ],
                    ),
                  )
                ],
              ),
            ),
            // 创作中心的两个图标
            Row(
              children: [
                const SizedBox(width: 24),
                _buildIconText(Icons.lightbulb_outline, '创作中心', Colors.orange),
                const SizedBox(width: 48),
                _buildIconText(Icons.video_library_outlined, '稿件管理', Colors.orange),
              ],
            ),

            const SizedBox(height: 16),
            const Divider(thickness: 8, color: Color(0xFFF4F4F4)),

            // --- 区块 F：更多服务 ---
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('更多服务', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            // 【为什么要用 ListTile？】
            // ListTile 是 Material Design 里专门用来做列表项的组件，自带左侧图标 (leading)、
            // 中间文字 (title)、右侧图标 (trailing) 的排版，非常适合做“设置”这种菜单项。
            ListTile(
              leading: const Icon(Icons.settings_outlined, color: Color(0xFFFB7299)),
              title: const Text('设置'),
              trailing: const Icon(Icons.chevron_right, color: Colors.grey),
              onTap: () {}, // 点击事件
            ),
            const SizedBox(height: 40), // 底部留白，防止被导航栏遮挡
          ],
        ),
      ),
    );
  }

  // --- 辅助构建函数 ---
  // 【为什么要提取这些小函数？】
  // 为了让代码更干净！如果不提取，你需要把同样格式的 Column 复制粘贴好几遍。
  // 提取成方法后，只需要传不同的数值和文字进去就行了，大大提高了代码的可读性和复用性。

  // 构建：数字 + 文字 的数据列（用于粉丝、关注等）
  Widget _buildStatColumn(String count, String label) {
    return Column(
      children: [
        Text(count, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  // 构建：图标 + 文字 的功能按钮列（用于离线缓存等）
  Widget _buildIconText(IconData icon, String label, Color iconColor) {
    return Column(
      children: [
        Icon(icon, color: iconColor, size: 28),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.black87)),
      ],
    );
  }
}