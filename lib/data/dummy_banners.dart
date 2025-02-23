import 'package:customer/models/BannerModel.dart';

List<BannerModel> bannerModels = [
  BannerModel(
    setOrder: 1,
    photo:
        'https://graphicsfamily.com/wp-content/uploads/edd/2024/12/Ecommerce-Shoes-Website-Banner-Ad-Design-scaled.jpg',
    title: 'Summer Sale',
    isPublish: true,
    redirect_type: 'product',
    redirect_id: 'product123',
  ),
  BannerModel(
    setOrder: 2,
    photo: 'https://i.imgur.com/HBZdxh7.jpeg',
    title: 'New Arrivals',
    isPublish: true,
    redirect_type: 'category',
    redirect_id: 'category456',
  ),
  BannerModel(
    setOrder: 3,
    photo:
        'https://moodiedavittreport.com/wp-content/uploads/2023/07/glenfiddich-perpetual.jpg',
    title: 'Flash Deals',
    isPublish: false,
    redirect_type: 'promotion',
    redirect_id: 'promo789',
  ),
  BannerModel(
    setOrder: 4,
    photo:
        'https://counseal.com/app/uploads/2024/01/website-featured-Starting-Your-Delivery-Business-in-Nigeria.jpg',
    isPublish: true,
    redirect_type: 'collection',
    redirect_id: 'collection101',
  ),
  BannerModel(
    setOrder: 5,
    photo:
        'https://images.pexels.com/photos/262978/pexels-photo-262978.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
    title: 'Best Sellers',
    isPublish: true,
    redirect_type: 'product',
    redirect_id: 'product202',
  ),
];
