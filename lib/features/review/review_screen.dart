import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodie_admin/constant/helper_method.dart';
import 'package:foodie_admin/features/review/presentation/bloc/review_bloc.dart';
import 'package:foodie_admin/features/review/presentation/bloc/review_event.dart';
import 'package:foodie_admin/features/review/presentation/bloc/review_state.dart';
import 'package:foodie_admin/theme/bloc/theme_bloc.dart';
import 'package:foodie_admin/theme/bloc/theme_event.dart';
import 'package:intl/intl.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool isHidden =false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title:  Text('Reviews',style:theme.textTheme.headlineMedium),
        backgroundColor: theme.colorScheme.surface,
        surfaceTintColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Card(
          elevation: 0,
          color: theme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
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
                            child: Icon(Icons.star, color: Colors.white),
                          ),
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Reviews',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'View and manage customer review for your product',
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
                    padding: EdgeInsets.all(8.0),
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
                          hintText: 'Search by customer name or review...',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(vertical: 8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              BlocBuilder<ReviewBloc,ReviewState>(builder: (context,state){
                if(state is LoadingReviewState){
                  return Center(
                    child:CircularProgressIndicator(strokeWidth: 2),
                  );
                }
                if(state is ErrorReviewState){
                   return Column(
                     children: [
                       Text('Reviews laoding failed'),
                       SizedBox(height: 10),
                       Text('Error:${state.errorMessage}'),
                       SizedBox(height: 10),
                       ElevatedButton(onPressed: (){
                         context.read<ReviewBloc>().add(LoadReviewEvent());
                       }, child: Text('Reload'))
                     ],
                   );
                }
                if(state is LoadedReviewState){
                  final reviews=state.reviewList;
                  debugPrint('Review:${reviews.length}');
                  if(reviews.isEmpty){
                    return Text('Reviews list is empty');
                  }
                  final searchQuery=_searchController.text.toLowerCase();
                  final reviewList=reviews.where((review){
                    return  review.userName.toLowerCase().contains(searchQuery) || review.comment.toLowerCase().contains(searchQuery);
                  });

                  return Expanded(
                    child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(12),
                          side: BorderSide(color: theme.dividerColor.withOpacity(0.1)),
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: DataTable(
                              dividerThickness: 0.4,
                              headingRowColor: WidgetStatePropertyAll(
                                theme.colorScheme.onSurface.withOpacity(0.100),
                              ),
                              dataRowMinHeight: 40,
                              dataRowMaxHeight: 50,
                              columnSpacing: 40,
                              horizontalMargin: 10,
                              columns: [
                                DataColumn(label: Text('Customer',style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,fontSize:10
                                ))),
                                DataColumn(label: Text('Product',style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,fontSize:10
                                ))),
                                DataColumn(label: Text('Rating',style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,fontSize:10
                                ))),
                                DataColumn(label: Text('Review',style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,fontSize:10
                                ))),
                                DataColumn(label: Text('Date',style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,fontSize:10
                                ))),
                                DataColumn(label: Text('Action',style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,fontSize:10
                                ))),
                              ],
                              rows:reviewList.map((review){
                                debugPrint('review:${review.date}');
                                return  DataRow(

                                  cells: [
                                    DataCell(Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 15,
                                          child: Center(
                                            child: Text(review.userName[0],style: theme.textTheme.titleMedium?.copyWith(
                                              fontSize: 10
                                            ),),
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        Text(review.userName,style: theme.textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.bold,fontSize:10
                                        ),)
                                        
                                      ],
                                    )),
                                    DataCell(Text(review.productName,style: theme.textTheme.bodySmall,)),
                                    DataCell(RatingWidget(rating: review.rating,theme:theme)),
                                    DataCell(Text(review.comment,style: theme.textTheme.labelSmall?.copyWith(
                                      fontWeight: FontWeight.w300
                                    ))),
                                    DataCell(Text(DateFormat('dd MMM yyyy,\n hh:mm a').format(review.date),style:theme.textTheme.labelSmall)),
                                    DataCell(Row(children: [
                                      buildHiddenBtn(theme,review.isHidden ? Icons.visibility : Icons.visibility_off,(){
                                        context.read<ReviewBloc>().add(HiddenReviewEvent(reviewId: review.id,
                                            isHidden: !review.isHidden));
                                        HelperMethod.showToast("Hide button click", context);

                                      },review.isHidden),
                                      SizedBox(width: 5),
                                      buildDeleteBtn(theme,(){
                                        context.read<ReviewBloc>().add(DeleteReviewEvent(reviewId: review.id));
                                        HelperMethod.showToast("Delete button click", context);

                                      })
                                    ])),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                  );
                  }
                return SizedBox();
              }),

            ],
          ),
        ),
      ),
    );
  }

  Container buildHiddenBtn(ThemeData theme,IconData icon,VoidCallback onClick,bool isHidden) {
    return  Container(
        height: 30,
        width: 30,
        decoration: BoxDecoration(
          color: theme.primaryColor.withOpacity(0.2),
          borderRadius: BorderRadiusGeometry.circular(6),
        ),
        child: Center(
          child: IconButton(
            padding: EdgeInsets.zero,
            tooltip: isHidden ? 'Unhide review' : 'Hide review',
            onPressed: (){
           onClick();
          }, icon: Icon(icon,color: theme.primaryColor,size: 16,),
          // child: Icon(
          //   icon,
          //   size: 13,
          //   color: theme.primaryColor,
          // ),
        ),
      ));

  }
 Container buildDeleteBtn(ThemeData theme,VoidCallback onClick) {
    return  Container(
      height: 30,
      width: 30,
      decoration: BoxDecoration(
        color: theme.primaryColor.withOpacity(0.2),
        borderRadius: BorderRadiusGeometry.circular(6),
      ),
      child: Center(
        child: IconButton(
          padding: EdgeInsets.zero,

            onPressed: (){
          onClick();
        }, icon: Icon(Icons.delete_forever,color: theme.primaryColor,size:16,)),
      ),
    );

  }

}


class RatingWidget extends StatelessWidget {
  final double rating;
  final ThemeData theme;

  const RatingWidget({
    super.key,
    required this.rating,
    required this.theme
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(5, (index) {
              return Icon(
                index < rating.floor()
                    ? Icons.star
                    : index < rating
                    ? Icons.star_half
                    : Icons.star_border,
                color: Colors.amber,
                size: 12,
              );
            }),
          ),
          SizedBox(height: 4),
          Text(rating.toString(),style:theme.textTheme.labelSmall,)
        ],
      ),
    );
  }
}

