class AddCategoryModel {
  final String categoryName;
  final String categoryImage;
  AddCategoryModel({required this.categoryName,required this.categoryImage});
   Map<String ,dynamic> toMap(){
     return {
       'name':categoryName,
       'image':categoryImage,
     };
}
}