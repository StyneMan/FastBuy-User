import 'package:customer/models/vendor_category_model.dart';

List<VendorCategoryModel> vendorCategories = [
  VendorCategoryModel(
    reviewAttributes: ['Quality', 'Punctuality', 'Customer Service'],
    photo: 'assets/images/store.png',
    description: 'Top-rated vendor category with high-quality service.',
    id: 'category123',
    title: 'Restaurants',
  ),
  VendorCategoryModel(
    reviewAttributes: ['Pricing', 'Reliability', 'Support'],
    photo: 'assets/images/grocery_cart.png',
    description: 'Affordable vendors with great value.',
    id: 'category456',
    title: 'Grocery',
  ),
  VendorCategoryModel(
    reviewAttributes: ['Expertise', 'Trustworthiness'],
    photo: 'assets/images/deliver_bike.png',
    description: 'Highly experienced and trusted vendors.',
    id: 'category789',
    title: 'Send Packages',
  ),
];
