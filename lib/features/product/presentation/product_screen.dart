import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodie_admin/constant/helper_method.dart';
import 'package:foodie_admin/features/category/presentation/bloc/category_bloc.dart';
import 'package:foodie_admin/features/category/presentation/bloc/category_state.dart';
import 'package:foodie_admin/features/category/presentation/build_Label.dart';
import 'package:foodie_admin/features/product/data/product_model.dart';
import 'package:foodie_admin/features/product/presentation/bloc/add_product_bloc.dart';
import 'package:foodie_admin/features/product/presentation/bloc/add_product_event.dart';
import 'package:foodie_admin/features/product/presentation/bloc/add_product_state.dart';
import 'package:image_picker/image_picker.dart';
class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});
  @override
  State<ProductScreen> createState() => _ProductScreenState();
}
class _ProductScreenState extends State<ProductScreen> {
  int _formVersion = 0;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
  final ImagePicker imagePicker=ImagePicker();
  Uint8List? _imageBytes;
  String? _selectedCategory;
  final List<String> _categories = [
    'Burgers',
    'Pizza',
    'Drinks',
    'Desserts',
    'Chicken',
  ];
  void _pickImage() async{
    try{
      XFile? image= await imagePicker.pickImage(source: ImageSource.gallery,
          imageQuality: 80
      );
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

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text('Add Product'),
        backgroundColor: theme.colorScheme.surface,
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Card(
              elevation: 0,
              color: theme.colorScheme.surface,
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
                      Text(
                        'Product Information',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Enter the details to add a new product.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 28),

                      LayoutBuilder(
                        builder: (context, constraints) {
                          if (constraints.maxWidth < 650) {
                            return Column(
                              children: [
                                _buildProductFields(),
                                const SizedBox(height: 24),
                                _buildImageAndCategory(),
                              ],
                            );
                          }

                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: _buildProductFields()),
                              const SizedBox(width: 28),
                              Expanded(child: _buildImageAndCategory()),
                            ],
                          );
                        },
                      ),

                      const SizedBox(height: 28),
                      const Divider(),
                      const SizedBox(height: 20),

                      BlocListener<AddProductBloc, AddProductState>(
                        listener: (context, state) {
                          print("state:${state}");
                          if (state is SubmitProductState) {
                            print("clear calling");
                            HelperMethod.showToast(state.message, context);
                            _clearForm();
                          }

                          if (state is ErrorProductState) {
                            HelperMethod.showToast(state.error, context);
                          }
                        },
                        child:
                        BlocBuilder<AddProductBloc, AddProductState>(
                          builder: (context, state) {
                            final isLoading = state is LoadingProductState;

                            return ElevatedButton.icon(
                              onPressed: isLoading
                                  ? null
                                  : () async {
                                // Validate price
                                final price = double.tryParse(
                                  _priceController.text.trim(),
                                );

                                if (price == null || price <= 0) {
                                  HelperMethod.showToast(
                                    'Please enter a valid price',
                                    context,
                                  );
                                  return;
                                }

                                if (_selectedCategory == null) {
                                  HelperMethod.showToast(
                                    'Please select a category',
                                    context,
                                  );
                                  return;
                                }

                                if (_imageBytes == null) {
                                  HelperMethod.showToast(
                                    'Please select an image',
                                    context,
                                  );
                                  return;
                                }

                                try {
                                  // Upload image
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

                                  final product = AddProductModel(
                                    name: _nameController.text.trim(),
                                    price: price,
                                    description: _descriptionController.text.trim(),
                                    categoryId: _selectedCategory!,
                                    imageUrl: imageUrl,
                                    rating: 0.0
                                  );

                                  context.read<AddProductBloc>().add(
                                    AddProductSubmitted(
                                      addProductModel: product,
                                    ),
                                  );
                                } catch (e) {
                                  if (!context.mounted) return;

                                  HelperMethod.showToast(
                                    'Upload failed: $e',
                                    context,
                                  );
                                }
                              },
                              icon: isLoading
                                  ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                                  : const Icon(Icons.add),
                              label: Text(
                                isLoading ? 'Adding Product...' : 'Add Product',
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFF6B35),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 18,
                                ),
                              ),
                            );
                          },
                        )
                        ,
                      ),

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

  Widget _buildProductFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildLabel('Product Name'),
        const SizedBox(height: 8),
        TextFormField(
          controller: _nameController,
          decoration: _inputDecoration(
            hint: 'Enter product name',
            icon: Icons.fastfood_outlined,
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Product name is required';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),

        buildLabel('Description'),
        const SizedBox(height: 8),
        TextFormField(
          controller: _descriptionController,
          maxLines: 4,
          decoration: _inputDecoration(
            hint: 'Enter product description',
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Description is required';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),

        buildLabel('Price'),
        const SizedBox(height: 8),
        TextFormField(
          controller: _priceController,
          keyboardType: const TextInputType.numberWithOptions(
            decimal: true,
          ),
          decoration: _inputDecoration(
            hint: 'Enter price',
            icon: Icons.currency_exchange,
          ),
          validator: (value) {
            final price = double.tryParse(value?.trim() ?? '');

            if (price == null || price <= 0) {
              return 'Enter a valid price';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildImageAndCategory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildLabel('Product Image'),
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

        const SizedBox(height: 24),
        buildLabel('Category'),
        const SizedBox(height: 8),
   BlocBuilder<CategoryBloc,CategoryState>(builder: (context,state){
           if(state is InitialCategoryState || state is LoadingCategoryState){
             return CircularProgressIndicator(strokeWidth: 8);
           }
           if(state is ErrorCategoryState){
             return  Text('Error:${state.errorMessage}');
           }
           if (state is LoadedCategoryState) {
             final categories = state.categories;

             if (categories.isEmpty) {
               return const Text('No categories available');
             }
             return DropdownButtonFormField<String>(
               key: ValueKey(_formVersion),
               value: _selectedCategory,
               isExpanded: true,
               icon: const Icon(
                 Icons.keyboard_arrow_down_rounded,
                 color: Color(0xFFFF6B35),
               ),
               decoration: InputDecoration(
                 labelText: 'Category',
                 hintText: 'Select product category',
                 prefixIcon: const Icon(
                   Icons.category_outlined,
                   color: Color(0xFFFF6B35),
                 ),
                 filled: true,
                 fillColor: Theme.of(context).colorScheme.surface,
                 contentPadding: const EdgeInsets.symmetric(
                   horizontal: 16,
                   vertical: 16,
                 ),
                 border: OutlineInputBorder(
                   borderRadius: BorderRadius.circular(12),
                   borderSide: BorderSide(
                     color: Colors.grey.shade300,
                   ),
                 ),
                 enabledBorder: OutlineInputBorder(
                   borderRadius: BorderRadius.circular(12),
                   borderSide: BorderSide(
                     color: Colors.grey.shade300,
                   ),
                 ),
                 focusedBorder: OutlineInputBorder(
                   borderRadius: BorderRadius.circular(12),
                   borderSide: const BorderSide(
                     color: Color(0xFFFF6B35),
                     width: 1.8,
                   ),
                 ),
                 labelStyle: TextStyle(
                   color: Colors.grey.shade600,
                 ),
               ),
               dropdownColor: Theme.of(context).colorScheme.surface,
               borderRadius: BorderRadius.circular(12),
               items: categories.map((category) {
                 return DropdownMenuItem<String>(
                   value: category.id,
                   child: Text(
                     category.name,
                     overflow: TextOverflow.ellipsis,
                     style: const TextStyle(
                       fontSize: 14,
                       fontWeight: FontWeight.w500,
                     ),
                   ),
                 );
               }).toList(),
               onChanged: (value) {
                 setState(() {
                   _selectedCategory = value;
                 });
               },
               validator: (value) {
                 if (value == null || value.isEmpty) {
                   return 'Please select a category';
                 }
                 return null;
               },
             );
           }
           return SizedBox.shrink();
   }),
        const SizedBox(height: 24),
        buildLabel('Stock Quantity'),
        const SizedBox(height: 8),

        TextFormField(
          controller: _stockController,
          keyboardType: TextInputType.number,
          decoration: _inputDecoration(
            hint: 'Enter stock quantity',
            icon: Icons.inventory_2_outlined,
          ),
          validator: (value) {
            final stock = int.tryParse(value?.trim() ?? '');

            if (stock == null || stock < 0) {
              return 'Enter a valid stock quantity';
            }
            return null;
          },
        ),
      ],
    );
  }



  InputDecoration _inputDecoration({
    required String hint,
    IconData? icon,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: icon == null ? null : Icon(icon, size: 20),
      filled: true,
      fillColor: Theme.of(context).colorScheme.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 16,
      ),
    );
  }

  void submitForm() {
    if (!_formKey.currentState!.validate()) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Form is valid. Firebase saving will be added next.',
        ),
      ),
    );
  }

  void _clearForm() {
    print('_clearForm called');
    _formKey.currentState?.reset();
    _nameController.clear();
    _descriptionController.clear();
    _priceController.clear();
    _stockController.clear();
    print(" name :${_nameController.text},description ${_descriptionController.text},price:${_priceController.text},stock: ${_stockController.text}");
    setState(() {
      _imageBytes = null;
      _selectedCategory = null;
      _formVersion++;
    });

    print("image: ${_imageBytes}");
    print("select category:${_selectedCategory}");
  }
}
