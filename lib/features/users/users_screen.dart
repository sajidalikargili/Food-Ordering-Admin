import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodie_admin/features/dashboard/bloc/recentuser_bloc/recent_user_bloc.dart';
import 'package:foodie_admin/features/dashboard/bloc/recentuser_bloc/recent_user_event.dart';
import 'package:foodie_admin/features/dashboard/bloc/recentuser_bloc/recent_user_state.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final TextEditingController  _searchController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('User'),
        backgroundColor: theme.colorScheme.surface,
        surfaceTintColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
        child: SizedBox(
          width: double.infinity,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.category_rounded,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Users',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Manage your user here',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),

                    Padding(
                      padding:  EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 250,
                        height: 45,
                        child: TextField(
                          controller: _searchController,
                          onChanged: (value) {
                            setState(() {});
                            debugPrint('Search text: $value');
                          },
                          decoration: const InputDecoration(
                            hintText: 'Search by email or name...',
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(vertical: 8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: BlocBuilder<RecentUserBloc,RecentUserState>(builder: (context,state){
                    if(state is LoadingRecentUserState){
                      return Center(
                        child:CircularProgressIndicator(strokeWidth: 2) ,
                      );
                    }
                    if (state is LoadedRecentUserState){
                      final users = state.recentUsers;
                      final searchQuery = _searchController.text.trim().toLowerCase();
                      final usersList = users.where((user) {
                        return user.name.toLowerCase().contains(searchQuery) ||
                            user.email.toLowerCase().contains(searchQuery);
                      }).toList();
                      return  Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Card(
                          elevation: 0,
                          color: theme.colorScheme.surface,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: theme.dividerColor.withOpacity(0.3),
                            ),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                                dividerThickness: 0.4,
                              headingRowColor: WidgetStatePropertyAll(
                                theme.colorScheme.surfaceContainerHighest,
                              ),
                              dataRowMinHeight: 60,
                              dataRowMaxHeight: 70,
                              columnSpacing: 40,
                              horizontalMargin: 16,
                              columns: const [
                                DataColumn(label: Text('Name')),
                                DataColumn(label: Text('Email')),
                                DataColumn(label: Text('Role')),
                              ],
                              rows:usersList.map((user){
                                return DataRow(
                                    cells:[
                                        DataCell(buildUserName(theme,user.name)),
                                        DataCell(Text(user.name)),
                                        DataCell(buildRoleShip(theme,user.role)),
                                    ] );
                              }).toList()
                              // rows: [
                              //   DataRow(
                              //     cells: [
                              //       DataCell(buildUserName(theme,"Sajid")),
                              //       const DataCell(Text('sajid@gmail.com')),
                              //       DataCell(buildRoleShip(theme,"Admine")),
                              //     ],
                              //   ),
                              // ],
                            ),
                          ),
                        ),
                      );
                    }
                    if(state is  ErrorRecentUserState){
                      return Column(
                        children: [
                          Text('User is not laoding'),
                          SizedBox(height: 10),
                          Text('Error:${state.Error}'),
                          SizedBox(height: 10),
                          ElevatedButton(onPressed: (){
                            context.read<RecentUserBloc>().add(LoadRecentUserEvent());
                          }, child: Text('Reload'))
                        ],
                      );
                    }
                    return SizedBox.shrink();

                  }),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Container buildRoleShip(ThemeData theme,String role) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        role,
        style: TextStyle(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  Row buildUserName(ThemeData theme,String userName) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 17,
          backgroundColor: theme.colorScheme.primary.withOpacity(0.12),
          child: Text(
            userName[0],
            style: TextStyle(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(userName),
      ],
    );
  }
}
