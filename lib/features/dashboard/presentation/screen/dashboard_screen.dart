import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodie_admin/constant/helper_method.dart';
import 'package:foodie_admin/constant/routes/app_routes.dart';
import 'package:foodie_admin/features/auth/bloc/auth_bloc.dart';
import 'package:foodie_admin/features/auth/bloc/auth_event.dart';
import 'package:foodie_admin/features/auth/bloc/auth_state.dart';
import 'package:foodie_admin/features/dashboard/bloc/dashboard_bloc/dashboard_bloc.dart';
import 'package:foodie_admin/features/dashboard/bloc/dashboard_bloc/dashboard_event.dart';
import 'package:foodie_admin/features/dashboard/bloc/dashboard_bloc/dashboard_state.dart';
import 'package:foodie_admin/features/dashboard/bloc/recentorder_bloc/recent_order_bloc.dart';
import 'package:foodie_admin/features/dashboard/bloc/recentorder_bloc/recent_order_event.dart';
import 'package:foodie_admin/features/dashboard/bloc/recentorder_bloc/recent_order_state.dart';
import 'package:foodie_admin/features/dashboard/bloc/recentuser_bloc/recent_user_bloc.dart';
import 'package:foodie_admin/features/dashboard/bloc/recentuser_bloc/recent_user_event.dart';
import 'package:foodie_admin/features/dashboard/bloc/recentuser_bloc/recent_user_state.dart';
import 'package:foodie_admin/features/product/presentation/widgets/build_app_bar.dart';
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String isSideBarItemSelected='Dashboard';
 @override
  void initState() {
   context.read<DashboardBloc>().add(
    LoadDashboardEvent()
   );
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    void navigateScreen(String screenName){
      switch(screenName){
        case "Dashboard":
          Navigator.pushNamed(context, AppRoutes.dashboard);
          break;
        case "Orders":
          Navigator.pushNamed(context, AppRoutes.order);
          break;
        case "Users":
          Navigator.pushNamed(context, AppRoutes.users);
          break;
        case "Category":
          Navigator.pushNamed(context, AppRoutes.category);
          break;
        case "Setting":
          Navigator.pushNamed(context, AppRoutes.setting);
          break;
        case "Reviews":
          Navigator.pushNamed(context, AppRoutes.review);
          break;
        case "Product":
          Navigator.pushNamed(context, AppRoutes.product);
          break;
        case "Logout":
          context.read<AuthBloc>().add(LogoutEvent());
           break;
        default:
          debugPrint("Screen not found: $screenName");
          break;
          return;

      }
    }
    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Row(
        children: [
          // Left sidebar
          Container(
            width: 210,
            color: const Color(0xFF202329),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Icon(
                        Icons.restaurant,
                        color: Color(0xFFFF6B35),
                        size: 30,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Foodie Admin',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(color: Colors.white12),

                BlocListener<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is SuccessState) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.login,
                            (route) => false,
                      );
                    }

                    if (state is ErrorState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.error)),
                      );
                    }
                  },
                  child: Expanded(
                    child: ListView.builder(
                        itemCount: HelperMethod.sideBarList.length,
                        itemBuilder: (context,index){
                          final item=HelperMethod.sideBarList[index];
                          return _SidebarItem(
                            icon: item.icon,title: item.title,selected: isSideBarItemSelected==item.title, onClick: () {
                            debugPrint('Sidebar clicked: ${item.title}');
                            setState(() {
                              isSideBarItemSelected=item.title;
                            });
                            navigateScreen(item.title);

                          },);
                        }),
                  ),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
          // Main dashboard
    Expanded(
    child: LayoutBuilder(
    builder: (context, constraints) {
      final isWide = constraints.maxWidth >= 900;

      final leftContent = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: buildAppBar(false))
            ],
          ),
          const Text(
            'Welcome Back, Admin!',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            "Here's what's happening with your food application today.",
            style: TextStyle(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 20),

          // Statistics cards
          BlocBuilder<DashboardBloc,DashboardState>(builder: (context,state){
               if(state is LoadingDashboardState || state is InitialDashboardState){
                  return Center(
                    child: CircularProgressIndicator(),
                  );
               }
               if(state is ErrorDashboardState){
                 return Center(
                   child: Column(
                     children: [
                       Text("Dashboard data is not loading"),
                       Text("Error:${state.Error}"),
                       ElevatedButton(onPressed: (){
                         context.read<DashboardBloc>().add(LoadDashboardEvent());
                       }, child: Text('Retry'))
                     ],
                   ),
                 );
               }
               if(state is LoadedDashboardState){
                 final data=state.dashboardData;
                 return    Wrap(
                   spacing: 12,
                   runSpacing: 12,
                   children: [
                     _StatCard(
                       title: 'Total Orders',
                       value :data.totalOrders.toString(),
                       icon: Icons.shopping_cart,
                       color: Color(0xFFFF6B35),
                       change: '↑ 12%',
                     ),
                     _StatCard(
                       title: 'Total Users',
                       value: data.totalUsers.toString(),
                       icon: Icons.person,
                       color: Color(0xFF4285F4),
                       change: '↑ 8%',
                     ),
                     _StatCard(
                       title: 'Total Products',
                       value: data.totalProducts.toString(),
                       icon: Icons.inventory_2,
                       color: Color(0xFF119B63),
                       change: '↑ 5%',
                     ),
                     _StatCard(
                       title: 'Total Revenue',
                       value: data.totalReveneu.toStringAsFixed(0),
                       icon: Icons.attach_money,
                       color: Color(0xFF9B59D0),
                       change: '↑ 15%',
                     ),
                   ],
                 );

               }
               return SizedBox();
          }),

          const SizedBox(height: 20),

          const _SalesOverview(),
          const SizedBox(height: 20),

          const _RecentOrders(),
        ],
      );

      final rightContent = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Quick Actions
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Quick Actions',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),

                ...HelperMethod.quickActionList.map(
                      (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: QuickAction(
                      onTap: () {
                        HelperMethod.showToast('${item.title}', context);
                        Navigator.pushNamed(context, item.route);
                      },
                      title: item.title,
                      icon: item.icon,
                      color: item.color,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Recent Users
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Recent Users',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        // Navigate to the users screen here.
                      },
                      child: const Row(
                        children: [
                          Text(
                            'View All',
                            style: TextStyle(
                              color: Colors.deepOrange,
                              fontSize: 11,
                            ),
                          ),
                          SizedBox(width: 3),
                          Icon(
                            Icons.arrow_forward,
                            color: Colors.deepOrange,
                            size: 14,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // ...List.generate(5, (index) {
                //   return Padding(
                //     padding: const EdgeInsets.only(bottom: 10),
                //     child: RecentUser(
                //       name: [
                //         'Ali Raza',
                //         'Ayesha Khan',
                //         'Usman Tariq',
                //         'Sara Ahmed',
                //         'Zainab Fatima',
                //       ][index],
                //       email: [
                //         'ali@example.com',
                //         'ayesha@example.com',
                //         'usman@example.com',
                //         'sara@example.com',
                //         'zainab@example.com',
                //       ][index],
                //       icon: Icons.person,
                //       date: index < 2
                //           ? 'Sep 28, 2026'
                //           : 'Sep 27, 2026',
                //       color: [
                //         Colors.blue,
                //         Colors.deepOrange,
                //         Colors.blue,
                //         Colors.orange,
                //         Colors.purple,
                //       ][index],
                //     ),
                //   );
                // }),

                BlocBuilder<RecentUserBloc, RecentUserState>(
                    builder: (context, state) {

                      if (state is LoadingRecentUserState) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (state is ErrorRecentUserState) {
                        return Column(
                          children: [
                            Text('Failed to load users: ${state.Error}'),
                            TextButton(
                              onPressed: () {
                                context.read<RecentUserBloc>().add(
                                  LoadRecentUserEvent()
                                );
                              },
                              child: const Text('Retry'),
                            ),
                          ],
                        );
                      }

                      if (state is LoadedRecentUserState) {
                        final users = state.recentUsers;

                        if (users.isEmpty) {
                          return const Text('No users registered yet.');
                        }

                        return Column(
                          children: users.map((user) {
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: CircleAvatar(
                                backgroundColor:
                                Theme.of(context).colorScheme.primaryContainer,
                                child: Text(
                                  user.name.isNotEmpty
                                      ? user.name[0].toUpperCase()
                                      : '?',
                                ),
                              ),
                              title: Text(
                                user.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                user.email,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: Text(
                                user.role,
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                            );
                          }).toList(),
                        );
                      }

                   // if(state is LoadedRecentUserState){
                   //    final recenUsers=state.recentUsers;
                   //    return ListView.builder(itemBuilder: (context,index){
                   //         final item=recenUsers[index];
                   //         print('recentUser:${item.name}');
                   //         return RecentUser(name:item.name , email: item.email, icon: Icons.person, color: index%2==0 ? Colors.blue :Colors.orange);
                   //    });
                   // }
                      return SizedBox.shrink();
                })
              ],
            ),
          ),
        ],
      );

      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: isWide
            ? Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: leftContent,
            ),
            const SizedBox(width: 16),
            SizedBox(
              width: 250,
              child: rightContent,
            ),
          ],
        )
            : Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            leftContent,
            const SizedBox(height: 20),
            rightContent,
          ],
        ),
      );
    },
    ),
    ),
        ],
      ),
    );
  }
}

class QuickAction extends StatefulWidget {
  String title;
  IconData icon;
  Color color;
  VoidCallback onTap;
  QuickAction({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap
  });

  @override
  State<QuickAction> createState() => _QuickActionState();
}

class _QuickActionState extends State<QuickAction> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:widget.onTap,
      child: Container(
        height: 35,
        decoration: BoxDecoration(
          color: widget.color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(4),
        ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Icon(widget.icon ,size: 25,color: widget.color),
              ),
              Expanded(child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(widget.title,style: TextStyle(fontSize: 10,color: widget.color),),
              )),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.arrow_forward_ios_rounded ,size: 15,color: widget.color),
              )
            ],
          ),
      ),
    );
  }
}
 class RecentUser extends StatefulWidget{
  final String name;
  final String email;
  final IconData icon;
  final Color color;
  RecentUser({super.key,required this.name,required this.email,required this.icon,required this.color});

  @override
  State<RecentUser> createState() => _RecentUserState();
}

class _RecentUserState extends State<RecentUser> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
            radius: 16,
          backgroundColor: widget.color.withOpacity(0.3),
            child: Icon(widget.icon ,size: 15,color: widget.color)),
        SizedBox(width: 10),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.name,style: TextStyle(fontSize: 7,color: widget.color),),
            Text(widget.email,style: TextStyle(fontSize: 7,color: Colors.grey),),
          ],
        )),
      ],
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: const Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Row(
        children: [
          const Icon(Icons.menu),
          const SizedBox(width: 24),
          Expanded(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 350),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search anything...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: const Color(0xFFF3F5F9),
                  contentPadding: EdgeInsets.zero,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
          const Spacer(),
          const Icon(Icons.notifications_none),
          const SizedBox(width: 12),
          const CircleAvatar(radius: 17, child: Icon(Icons.person, size: 20)),
          const SizedBox(width: 8),
          const Text('Admin'),
          const SizedBox(width: 8),
          const Icon(Icons.keyboard_arrow_down),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool selected;
  final VoidCallback onClick;

   _SidebarItem({
    required this.icon,
    required this.title,
    this.selected = false,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFFFF6B35) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        dense: true,
        leading: Icon(icon, color: Colors.white, size: 20),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 13),
        ),
        onTap: () {
         onClick();
         debugPrint('Sidebar clicked: ${selected}');
        },
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String change;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.change,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 10),
          ),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontSize: 10)),
          const SizedBox(height: 5),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            change,
            style: const TextStyle(
              color: Color(0xFF119B63),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Text(
            'vs last week',
            style: TextStyle(color: Colors.grey, fontSize: 10),
          ),
        ],
      ),
    );
  }
}

class _SalesOverview extends StatelessWidget {
  const _SalesOverview();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sales Overview',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 180,
              width: double.infinity,
              child: CustomPaint(painter: _SalesChartPainter()),
            ),
          ],
        ),
      ),
    );
  }
}

class _SalesChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = const Color(0xFFE5E7EB)
      ..strokeWidth = 0.7;

    final linePaint = Paint()
      ..color = const Color(0xFFFF6B35)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    const left = 30.0;
    const right = 8.0;
    const top = 8.0;
    const bottom = 24.0;

    final chartWidth = size.width - left - right;
    final chartHeight = size.height - top - bottom;

    for (var i = 0; i <= 4; i++) {
      final y = top + chartHeight * i / 4;
      canvas.drawLine(
        Offset(left, y),
        Offset(size.width - right, y),
        gridPaint,
      );
    }

    final values = [0.25, 0.32, 0.40, 0.46, 0.58, 0.83, 0.66];
    final points = <Offset>[];

    for (var i = 0; i < values.length; i++) {
      points.add(
        Offset(
          left + chartWidth * i / (values.length - 1),
          top + chartHeight * (1 - values[i]),
        ),
      );
    }

    final path = Path()..moveTo(points.first.dx, points.first.dy);

    for (var i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    canvas.drawPath(path, linePaint);

    final dotPaint = Paint()..color = const Color(0xFFFF6B35);

    for (final point in points) {
      canvas.drawCircle(point, 3, dotPaint);
    }

    const days = [
      'Sep 22',
      'Sep 23',
      'Sep 24',
      'Sep 25',
      'Sep 26',
      'Sep 27',
      'Sep 28',
    ];

    final textStyle = const TextStyle(color: Color(0xFF64748B), fontSize: 9);

    for (var i = 0; i < days.length; i++) {
      final text = TextPainter(
        text: TextSpan(text: days[i], style: textStyle),
        textDirection: TextDirection.ltr,
      )..layout();

      text.paint(
        canvas,
        Offset(points[i].dx - text.width / 2, size.height - 15),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _SalesChartPainter oldDelegate) {
    return false;
  }
}

class _RecentOrders extends StatelessWidget {
  const _RecentOrders();

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<RecentOrderBloc,RecentOrderState>(builder: (context,state){
      if(state is LoadedRecentOrderState   && state is InitialRecentOrderState){
        return Center(
          child: Card(
            child:Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircularProgressIndicator(strokeWidth: 10,),
            ) ,
          ),
        );
      }
      if(state is ErrorRecentOrderState){
        return Column(
          children: [
            Text('Failed to load the RecentOrder'),
            SizedBox(height: 8),
            ElevatedButton(onPressed: (){
              context.read<RecentOrderBloc>().add(LoadRecentOrderEvent());
            }, child: Text('Rerty'))
          ],
        );
      }
      if(state is LoadedRecentOrderState){
        final orders=state.recentOrders;
        return Card(
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Recent Orders',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 14),
                if(orders.isEmpty)
                  const Center(child: Text('No orders found'))
                else
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowHeight: 38,
                    dataRowMinHeight: 42,
                    dataRowMaxHeight: 48,
                    columns: const [
                      DataColumn(label: Text('#')),
                      DataColumn(label: Text('Customer')),
                      DataColumn(label: Text('Items')),
                      DataColumn(label: Text('Total')),
                      DataColumn(label: Text('Status')),
                      DataColumn(label: Text('Date')),
                    ],
                    rows: List.generate(orders.length, (index) {
                      final order = orders[index];
                      print('orders:${order.customerName}');
                      return DataRow(
                        cells: [
                          DataCell(Text('${index + 1}')),
                          DataCell(Text(order.customerName)),
                          DataCell(Text('${order.itemCount} items')),
                          DataCell(
                            Text(
                              'PKR ${order.total.toStringAsFixed(0)}',
                            ),
                          ),
                          DataCell(
                            Text(order.status.replaceAll('_', ' ')),
                          ),
                          DataCell(
                            Text(
                              order.createdAt == null
                                  ? '—'
                                  : '${order.createdAt!.day}/'
                                  '${order.createdAt!.month}/'
                                  '${order.createdAt!.year}',
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        );
      }
      return const SizedBox.shrink();

    });

  }
}

class _OrderStatus extends StatelessWidget {
  final String status;

  const _OrderStatus({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      'Delivered' => const Color(0xFF119B63),
      'Preparing' => const Color(0xFFF59E0B),
      'Out for Delivery' => const Color(0xFF4285F4),
      'Confirmed' => const Color(0xFF8B5CF6),
      _ => const Color(0xFFEF4444),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(status, style: TextStyle(color: color, fontSize: 11)),
    );
  }
}
