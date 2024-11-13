import 'package:customer/models/BannerModel.dart';

List<BannerModel> bannerModels = [
  BannerModel(
    setOrder: 1,
    photo:
        'https://img.jagranjosh.com/images/2024/August/2582024/janmashtami-images.jpg',
    title: 'Summer Sale',
    isPublish: true,
    redirect_type: 'product',
    redirect_id: 'product123',
  ),
  BannerModel(
    setOrder: 2,
    photo:
        'https://t3.ftcdn.net/jpg/03/24/73/92/360_F_324739203_keeq8udvv0P2h1MLYJ0GLSlTBagoXS48.jpg',
    title: 'New Arrivals',
    isPublish: true,
    redirect_type: 'category',
    redirect_id: 'category456',
  ),
  BannerModel(
    setOrder: 3,
    photo:
        'https://images.ctfassets.net/hrltx12pl8hq/5596z2BCR9KmT1KeRBrOQa/4070fd4e2f1a13f71c2c46afeb18e41c/shutterstock_451077043-hero1.jpg?fit=fill&w=600&h=400',
    title: 'Flash Deals',
    isPublish: false,
    redirect_type: 'promotion',
    redirect_id: 'promo789',
  ),
  BannerModel(
    setOrder: 4,
    photo:
        'https://img.jagranjosh.com/images/2024/August/2582024/janmashtami-images.jpg',
    title: 'Winter Collection',
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
