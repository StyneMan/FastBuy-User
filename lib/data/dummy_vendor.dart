import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer/models/vendor_model.dart';

final dummyVendor = VendorModel(
  author: "John Doe",
  dineInActive: true,
  openDineTime: "08:00 AM",
  categoryID: "cat_001",
  id: "vendor_001",
  categoryPhoto: "https://example.com/category_photo.jpg",
  restaurantMenuPhotos: [
    "https://example.com/menu1.jpg",
    "https://example.com/menu2.jpg"
  ],
  workingHours: [
    WorkingHours(
      day: "Monday",
      timeslot: [
        Timeslot(from: "09:00 AM", to: "09:00 PM"),
      ],
    ),
    WorkingHours(
      day: "Tuesday",
      timeslot: [
        Timeslot(from: "09:00 AM", to: "09:00 PM"),
      ],
    ),
  ],
  location: "123 Street, City",
  fcmToken: "dummy_fcm_token",
  g: G(
    geohash: "abc123",
    geopoint: const GeoPoint(37.7749, -122.4194),
  ),
  hidephotos: false,
  reststatus: true,
  filters: Filters(
    goodForLunch: "Yes",
    outdoorSeating: "No",
    liveMusic: "Yes",
    vegetarianFriendly: "Yes",
    goodForDinner: "Yes",
    goodForBreakfast: "No",
    freeWiFi: "Yes",
    takesReservations: "Yes",
  ),
  reviewsCount: 120,
  photo: "https://example.com/photo.jpg",
  description: "A great place to dine with family.",
  walletAmount: 200.0,
  closeDineTime: "10:00 PM",
  zoneId: "zone_123",
  createdAt: Timestamp.now(),
  longitude: -122.4194,
  enabledDiveInFuture: true,
  restaurantCost: "20-50",
  deliveryCharge: DeliveryCharge(
    minimumDeliveryChargesWithinKm: 5,
    minimumDeliveryCharges: 10,
    deliveryChargesPerKm: 2,
    vendorCanModify: true,
  ),
  authorProfilePic: "https://example.com/author.jpg",
  authorName: "John Doe",
  phonenumber: "+123456789",
  specialDiscount: [
    SpecialDiscount(
      day: "Monday",
      timeslot: [
        SpecialDiscountTimeslot(
          discount: "10%",
          discountType: "Percentage",
          to: "11:00 AM",
          type: "Breakfast",
          from: "09:00 AM",
        ),
      ],
    ),
  ],
  specialDiscountEnable: true,
  coordinates: const GeoPoint(37.7749, -122.4194),
  reviewsSum: 4.5,
  photos: ["https://example.com/photo1.jpg", "https://example.com/photo2.jpg"],
  title: "Amazing Restaurant",
  categoryTitle: "Dine-in",
  latitude: 37.7749,
);
