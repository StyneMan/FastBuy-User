import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer/models/cart_product_model.dart';
import 'package:customer/models/tax_model.dart';
import 'package:customer/models/user_model.dart';
import 'package:customer/models/vendor_model.dart';

import '../models/order_model.dart';

List<OrderModel> dummyOrderModels = [
  OrderModel(
    address: ShippingAddress(
      address: "123 Main St",
      landmark: "Springfield",
      locality: "12345",
      addressAs: "USA",
    ),
    status: "pending",
    couponId: "coupon123",
    vendorID: "vendor123",
    driverID: "driver123",
    discount: 10,
    authorID: "author123",
    estimatedTimeToPrepare: "30 minutes",
    createdAt: Timestamp.fromDate(DateTime.now()),
    triggerDelivery:
        Timestamp.fromDate(DateTime.now().add(Duration(minutes: 15))),
    taxSetting: [
      TaxModel(
        type: "VAT",
        tax: "5",
        country: "NG",
        enable: true,
      ),
    ],
    paymentMethod: "credit_card",
    products: [
      CartProductModel(
        id: "prod123",
        quantity: 2,
        price: "20",
        categoryId: "1",
        discountPrice: "150.0",
        extrasPrice: "12.0",
        name: "Name",
        photo: "",
        vendorID: 'vendor_001',
      ),
    ],
    adminCommissionType: "percentage",
    vendor: VendorModel(
      title: "Best Vendor",
      reviewsCount: 4.5,
      author: 'Jonny Doe',
    ),
    id: "order123",
    adminCommission: "5",
    couponCode: "SUMMER10",
    specialDiscount: {"type": "seasonal", "value": 5},
    deliveryCharge: "3.99",
    scheduleTime: Timestamp.fromDate(DateTime.now().add(Duration(hours: 1))),
    tipAmount: "2.00",
    notes: "Leave at the door",
    author: UserModel(
      firstName: "John",
      lastName: "Doe",
      email: "john@example.com",
    ),
    driver: UserModel(
      firstName: "Jane",
      lastName: "Smith",
      email: "jane@example.com",
    ),
    takeAway: false,
    rejectedByDrivers: ["driver789", "driver456"],
  ),
  OrderModel(
    address: ShippingAddress(
      address: "14 Main St",
      landmark: "Springfield",
      locality: "12345",
      addressAs: "USA",
    ),
    status: "pending",
    couponId: "coupon123",
    vendorID: "vendor123",
    driverID: "driver123",
    discount: 11,
    authorID: "author123",
    estimatedTimeToPrepare: "30 minutes",
    createdAt: Timestamp.fromDate(DateTime.now()),
    triggerDelivery:
        Timestamp.fromDate(DateTime.now().add(Duration(minutes: 15))),
    taxSetting: [
      TaxModel(
        type: "VAT",
        tax: "5",
        country: "NG",
        enable: true,
      ),
    ],
    paymentMethod: "credit_card",
    products: [
      CartProductModel(
        id: "prod123",
        quantity: 3,
        price: "20",
        vendorID: 'vendor_001',
      ),
      CartProductModel(
        id: "prod456",
        quantity: 2,
        price: "15",
        vendorID: 'vendor_002',
      ),
    ],
    adminCommissionType: "percentage",
    vendor: VendorModel(
      title: "Best Vendor",
      reviewsCount: 4.5,
      author: 'Jonny Doe',
    ),
    id: "order123",
    adminCommission: "5",
    couponCode: "SUMMER10",
    specialDiscount: {"type": "seasonal", "value": 5},
    deliveryCharge: "3.99",
    scheduleTime: Timestamp.fromDate(DateTime.now().add(Duration(hours: 1))),
    tipAmount: "2.00",
    notes: "Leave at the door",
    author: UserModel(
      firstName: "John",
      lastName: "Doe",
      email: "john@example.com",
    ),
    driver: UserModel(
      firstName: "Jane",
      lastName: "Smith",
      email: "jane@example.com",
    ),
    takeAway: false,
    rejectedByDrivers: ["driver789", "driver456"],
  ),
];
