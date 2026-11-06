import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodie_admin/constant/helper_method.dart';
import 'package:foodie_admin/features/category/data/model/add_category_model.dart';
import 'package:foodie_admin/features/category/presentation/bloc/add_category/add_category_bloc.dart';
import 'package:foodie_admin/features/category/presentation/bloc/add_category/add_category_event.dart';
import 'package:foodie_admin/features/category/presentation/bloc/add_category/add_category_state.dart';
import 'package:foodie_admin/features/category/presentation/build_Label.dart';
import 'package:image_picker/image_picker.dart';
class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final ImagePicker imagePicker=ImagePicker();
  Uint8List? _imageBytes;
  void _pickImage() async{
    try{
      XFile? image= await imagePicker.pickImage(source: ImageSource.gallery,imageQuality: 80);
      if(image==null) return;
      final Uint8List bytes = await image.readAsBytes();
      if(!mounted) return;
      setState(() {
        _imageBytes = bytes;
      });
    }catch(e){
      if(!mounted) return;
      HelperMethod.showToast('Counld not  select Image:$e', context);
    }
  }
  void _clearForm(){
    _formKey.currentState?.reset();
    _nameController.clear();
    setState(() {
      _imageBytes=null;
    });
  }
  @override
  void dispose() {
   _nameController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Category'),
        backgroundColor: theme.colorScheme.surface,
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                // side: BorderSide(color: theme.dividerColor),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                color: theme.colorScheme.primary,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Center(
                              child: Icon(Icons.category_rounded,color: Colors.white,),
                            ),
                          ),
                         const  SizedBox(width: 10),
                          Expanded(child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                            Text(
                                'Add Category',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Create  a new category for your product',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),

                            ],
                          ))
                        ],
                      ),
                      SizedBox(height: 10),
                      const Divider(color: Colors.grey),
                      SizedBox(height: 10),
                      buildLabel('Category Name'),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          hint: Text('Enter Category name'),
                          prefixIcon: Icon(Icons.person),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Category name is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      buildLabel('Category Image'),
                      const SizedBox(height: 8),
                      InkWell(
                          onTap: _pickImage,
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                              height: 190,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey.shade400,
                                  style: BorderStyle.solid,
                                ),
                                borderRadius: BorderRadius.circular(10),
                                color: const Color(0xFFFFF7F3),
                              ),
                              child: _imageBytes==null ?  Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.cloud_upload_outlined,
                                    size: 48,
                                    color: Color(0xFFFF6B35),
                                  ),
                                  SizedBox(height: 12),
                                  Text(
                                    'Tap to upload image',
                                    style: TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    'Choose an image from your gallery',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ) : ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.memory(
                                    _imageBytes!
                                    ,width: double.infinity,
                                    height: 190,
                                    fit: BoxFit.contain),
                              )
                          )
                      ),
                      const SizedBox(height: 28),
                      const Divider(color: Colors.grey),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          BuildCategoryBtn(theme: theme,typBtn:"cancel",btnText: 'Cancel',onClick:(){
                            if(!_formKey.currentState!.validate()){
                              return;
                            }
                            if(_imageBytes==null){
                              HelperMethod.showToast("Please select the image ", context);
                              return;
                            }
                            _clearForm();
                            HelperMethod.showToast('Cancel', context);
                          },),
                          SizedBox(width: 10),
                          BlocListener<AddCategoryBloc, AddCategoryState>(
                            listener: (context, state) {
                              if (state is SuccessFullAddCategory) {
                                HelperMethod.showToast(state.message, context);
                                _clearForm();
                              }

                              if (state is ErrorAddCategory) {
                                HelperMethod.showToast(state.errorMessage, context);
                              }
                            },
                            child: BlocBuilder<AddCategoryBloc, AddCategoryState>(
                              builder: (context, state) {
                                final isLoading = state is LoadingAddCategory;

                                if (isLoading) {
                                  return  Center(
                                    child: SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color:theme.colorScheme.primary,
                                      ),
                                    ),
                                  );
                                }

                                return BuildCategoryBtn(
                                  theme: theme,
                                  typBtn: "category",
                                  btnText: 'Add Category',
                                  onClick: () async {
                                    if(!_formKey.currentState!.validate()){
                                      return;
                                    }
                                    // if (_nameController.text.trim().isEmpty) {
                                    //   HelperMethod.showToast(
                                    //     'Please enter a category name',
                                    //     context,
                                    //   );
                                    //   return;
                                    // }

                                    if (_imageBytes == null) {
                                      HelperMethod.showToast(
                                        'Please select an image',
                                        context,
                                      );
                                      return;
                                    }

                                    try {
                                      final imageUrl =
                                      await HelperMethod.uploadImage(_imageBytes!);

                                      if (!context.mounted) return;

                                      if (imageUrl == null || imageUrl.isEmpty) {
                                        HelperMethod.showToast(
                                          'Image upload failed',
                                          context,
                                        );
                                        return;
                                      }

                                      final category = AddCategoryModel(
                                        categoryName: _nameController.text.trim(),
                                        categoryImage: imageUrl,
                                      );

                                      context.read<AddCategoryBloc>().add(
                                        AddCategory(addCategoryModel: category),
                                      );

                                    } catch (e) {
                                      if (!context.mounted) return;

                                      HelperMethod.showToast(
                                        'Upload failed: $e',
                                        context,
                                      );
                                    }
                                  },
                                );
                              },
                            ),
                          )

                        ],
                      )



                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BuildCategoryBtn extends StatelessWidget {
  const BuildCategoryBtn({
    super.key,
    required this.theme,
    required this.typBtn,
    required this.btnText,
    required this.onClick

  });

  final ThemeData theme;
  final  String typBtn;
  final String btnText;
  final VoidCallback onClick;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        onClick();
      },
      child: Container(
        height: 30,
        width:typBtn=='category' ?90:70 ,
        decoration: BoxDecoration(
          border: Border.all(color:theme.colorScheme.primary,width: typBtn=='category' ? 0 : 1),
          borderRadius: BorderRadius.circular(5),
          color:typBtn=='category' ?theme.colorScheme.primary : theme.colorScheme.surface
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(btnText,style:theme.textTheme.bodyMedium?.copyWith(
              color: typBtn=='category' ?theme.colorScheme.surface : theme.colorScheme.primary,
              fontSize: 10
            ),),
          ),
        ),
      ),
    );
  }
}
