import 'package:flutter/material.dart';
import 'package:jsonplaceholder/pages/tabs/posts_tab.dart';
import 'package:jsonplaceholder/pages/tabs/comments_tab.dart';
import 'package:jsonplaceholder/pages/tabs/albums_tab.dart';
import 'package:jsonplaceholder/pages/tabs/users_tab.dart';
import 'package:jsonplaceholder/pages/tabs/photos_tab.dart';
import 'package:jsonplaceholder/pages/tabs/todos_tab.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  static const _tabs = [
    (label: 'Posts', icon: Icons.article_outlined, count: '100'),
    (label: 'Comments', icon: Icons.forum_outlined, count: '500'),
    (label: 'Albums', icon: Icons.photo_library_outlined, count: '100'),
    (label: 'Users', icon: Icons.people_alt_outlined, count: '10'),
    (label: 'Photos', icon: Icons.image_outlined, count: '5,000'),
    (label: 'Todos', icon: Icons.task_alt_outlined, count: '200'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(_handleTabChanged);
  }

  void _handleTabChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 1100;
        final isTablet = constraints.maxWidth >= 700;

        if (isDesktop) {
          return Scaffold(
            body: Row(
              children: [
                _DesktopSidebar(
                  controller: _tabController,
                  tabs: _tabs,
                ),
                Expanded(
                  child: Column(
                    children: [
                      _TopBar(controller: _tabController, tabs: _tabs),
                      Expanded(child: _buildTabView()),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        if (isTablet) {
          return Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  selectedIndex: _tabController.index,
                  onDestinationSelected: (index) => setState(() {
                    _tabController.animateTo(index);
                  }),
                  labelType: NavigationRailLabelType.all,
                  backgroundColor: Colors.white,
                  indicatorColor: const Color(0xFFECECFB),
                  selectedIconTheme: const IconThemeData(
                    color: Color(0xFF5B5BD6),
                  ),
                  selectedLabelTextStyle: const TextStyle(
                    color: Color(0xFF5B5BD6),
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                  destinations: [
                    for (final tab in _tabs)
                      NavigationRailDestination(
                        icon: Icon(tab.icon),
                        label: Text(tab.label),
                      ),
                  ],
                ),
                const VerticalDivider(width: 1),
                Expanded(
                  child: Column(
                    children: [
                      _TopBar(controller: _tabController, tabs: _tabs),
                      Expanded(child: _buildTabView()),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 64,
            title: const _BrandTitle(compact: true),
            actions: [
              IconButton(
                tooltip: 'Refresh',
                onPressed: () => setState(() {}),
                icon: const Icon(Icons.refresh_rounded),
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: _buildTabView(),
          bottomNavigationBar: _MobileNavigation(
            controller: _tabController,
            tabs: _tabs,
          ),
        );
      },
    );
  }

  Widget _buildTabView() {
    return TabBarView(
      controller: _tabController,
      children: const [
        PostsTab(),
        CommentsTab(),
        AlbumsTab(),
        UsersTab(),
        PhotosTab(),
        TodosTab(),
      ],
    );
  }
}

class _BrandTitle extends StatelessWidget {
  final bool compact;

  const _BrandTitle({this.compact = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: compact ? 36 : 40,
          height: compact ? 36 : 40,
          decoration: BoxDecoration(
            color: const Color(0xFF5B5BD6),
            borderRadius: BorderRadius.circular(11),
          ),
          child: const Icon(
            Icons.grid_view_rounded,
            color: Colors.white,
            size: 20,
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Nexa',
              style: TextStyle(
                color: Color(0xFF16182A),
                fontSize: 17,
                height: 1,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.4,
              ),
            ),
            if (!compact) ...[
              const SizedBox(height: 4),
              const Text(
                'API Workspace',
                style: TextStyle(
                  color: Color(0xFF8A90A3),
                  fontSize: 11,
                  height: 1,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _DesktopSidebar extends StatelessWidget {
  final TabController controller;
  final List<({String label, IconData icon, String count})> tabs;

  const _DesktopSidebar({
    required this.controller,
    required this.tabs,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 248,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 18),
            child: _BrandTitle(),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
            child: Text(
              'WORKSPACE',
              style: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 1,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                for (var index = 0; index < tabs.length; index++)
                  _SidebarItem(
                    tab: tabs[index],
                    selected: controller.index == index,
                    onTap: () => controller.animateTo(index),
                  ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 18,
                  backgroundColor: Color(0xFFEEF0FA),
                  child: Text(
                    'KA',
                    style: TextStyle(
                      color: Color(0xFF5B5BD6),
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Kenz Workspace',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF22243A),
                        ),
                      ),
                      Text(
                        'Developer',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF9297A8),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.more_horiz_rounded,
                  color: Colors.grey.shade400,
                  size: 18,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final ({String label, IconData icon, String count}) tab;
  final bool selected;
  final VoidCallback onTap;

  const _SidebarItem({
    required this.tab,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFF0F0FC) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(
                tab.icon,
                size: 19,
                color: selected
                    ? const Color(0xFF5B5BD6)
                    : const Color(0xFF8A90A3),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  tab.label,
                  style: TextStyle(
                    color: selected
                        ? const Color(0xFF4D4DAA)
                        : const Color(0xFF62677A),
                    fontSize: 13,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: selected ? Colors.white : const Color(0xFFF5F6F9),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  tab.count,
                  style: TextStyle(
                    color: selected
                        ? const Color(0xFF5B5BD6)
                        : const Color(0xFF9A9FAE),
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final TabController controller;
  final List<({String label, IconData icon, String count})> tabs;

  const _TopBar({
    required this.controller,
    required this.tabs,
  });

  @override
  Widget build(BuildContext context) {
    final tab = tabs[controller.index];
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE8EBF2))),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  tab.label,
                  style: const TextStyle(
                    color: Color(0xFF171927),
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 3),
                const Text(
                  'Kelola dan telusuri data JSONPlaceholder',
                  style: TextStyle(
                    color: Color(0xFF969BAD),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 38,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F8FB),
              borderRadius: BorderRadius.circular(9),
              border: Border.all(color: const Color(0xFFE8EBF2)),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.cloud_done_outlined,
                  size: 17,
                  color: Color(0xFF18A875),
                ),
                SizedBox(width: 7),
                Text(
                  'API Online',
                  style: TextStyle(
                    color: Color(0xFF62677A),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MobileNavigation extends StatelessWidget {
  final TabController controller;
  final List<({String label, IconData icon, String count})> tabs;

  const _MobileNavigation({
    required this.controller,
    required this.tabs,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: controller.index,
      onTap: (index) => controller.animateTo(index),
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: const Color(0xFF5B5BD6),
      unselectedItemColor: const Color(0xFF9A9FAE),
      selectedFontSize: 11,
      unselectedFontSize: 10,
      elevation: 8,
      items: [
        for (final tab in tabs)
          BottomNavigationBarItem(
            icon: Icon(tab.icon),
            label: tab.label,
          ),
      ],
    );
  }
}
