import 'package:chatwala/core/utils/app_theme.dart';
import 'package:chatwala/feature/home/cubit/home_cubit.dart';
import 'package:chatwala/feature/home/cubit/home_state.dart';
import 'package:chatwala/feature/home/widgets/chat_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = AppTheme.primary(context);

    return NestedScrollView(
      floatHeaderSlivers: true,
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
        SliverAppBar(
          floating: true,
          pinned: true,
          snap: true,
          automaticallyImplyLeading: false,
          toolbarHeight: 60,
          expandedHeight: 180,
          backgroundColor: AppTheme.surface(context),
          surfaceTintColor: Colors.transparent,
          forceElevated: innerBoxIsScrolled,
          shadowColor: AppTheme.shadow(context),
          elevation: 0.5,
          titleSpacing: 20,
          title: Text(
            'Messages',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary(context),
              fontSize: 26,
              letterSpacing: -0.3,
            ),
          ),
          centerTitle: false,
          actions: [
            _HeaderActionIcon(icon: Icons.camera_alt_outlined, onTap: () {}),
            const SizedBox(width: 8),
            _HeaderActionIcon(icon: Icons.more_vert_rounded, onTap: () {}),
            const SizedBox(width: 12),
          ],
          flexibleSpace: FlexibleSpaceBar(
            collapseMode: CollapseMode.pin,
            background: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.only(top: 70, bottom: 56),
                child: Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppTheme.inputFill(context),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (query) {
                          context.read<HomeCubit>().search(query);
                        },
                        decoration: InputDecoration(
                          hintText: 'Search conversations...',
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: AppTheme.textHint(context),
                            fontSize: 14,
                          ),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(left: 12, right: 8),
                            child: Icon(
                              Icons.search_rounded,
                              color: AppTheme.textHint(context),
                              size: 20,
                            ),
                          ),
                          prefixIconConstraints: const BoxConstraints(
                            minWidth: 0,
                            minHeight: 0,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16,
                          ),
                        ),
                        style: TextStyle(
                          color: AppTheme.textPrimary(context),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(56),
            child: Container(
              color: AppTheme.surface(context),
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: AppTheme.inputFill(context),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(11),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withValues(alpha: 0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  labelColor: Colors.white,
                  unselectedLabelColor: AppTheme.textHint(context),
                  labelStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  labelPadding: EdgeInsets.zero,
                  tabs: const [
                    Tab(text: 'Active', height: 36),
                    Tab(text: 'All', height: 36),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return Center(
              child: CircularProgressIndicator(color: primaryColor),
            );
          }

          if (state is HomeError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error_outline, color: AppTheme.error, size: 48),
                  const SizedBox(height: 12),
                  Text(
                    state.message,
                    style: TextStyle(color: AppTheme.textSecondary(context)),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          if (state is HomeLoaded) {
            return TabBarView(
              controller: _tabController,
              children: [
                _buildUserList(context, state.filteredActive, 'active'),
                _buildUserList(context, state.filteredAll, 'all'),
              ],
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildUserList(
    BuildContext context,
    List<ChatUser> users,
    String key,
  ) {
    if (users.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              key == 'active'
                  ? Icons.person_off_outlined
                  : Icons.chat_bubble_outline,
              color: AppTheme.textHint(context),
              size: 56,
            ),
            const SizedBox(height: 12),
            Text(
              key == 'active' ? 'No active users' : 'No conversations yet',
              style: TextStyle(
                color: AppTheme.textSecondary(context),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              key == 'active'
                  ? 'Active users will appear here'
                  : 'Start chatting with someone!',
              style: TextStyle(color: AppTheme.textHint(context), fontSize: 13),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      key: PageStorageKey<String>(key),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: ChatTile(
            user: user,
            currentUserId: context.read<HomeCubit>().currentUserId,
          ),
        );
      },
    );
  }
}


class _HeaderActionIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _HeaderActionIcon({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: AppTheme.inputFill(context),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: AppTheme.textSecondary(context), size: 20),
      ),
    );
  }
}
