import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer/models/user_model.dart';

// Dummy user data for John Doe
UserModel johnDoe = UserModel(
  id: "user_12345",
  firstName: "John",
  lastName: "Doe",
  email: "johndoe@example.com",
  profilePictureURL: "https://example.com/profile_pic.jpg",
  fcmToken: "dummyFcmToken",
  countryCode: "+1",
  phoneNumber: "1234567890",
  walletAmount: 100.50,
  active: true,
  isActive: true,
  isDocumentVerify: true,
  createdAt: Timestamp.now(),
  role:
      "user", // Replace with Constant.userRoleDriver or Constant.userRoleVendor if needed
  location: UserLocation(
    latitude: 40.7128,
    longitude: -74.0060,
  ),
  // userBankDetails: UserBankDetails(
  //   bankName: "Example Bank",
  //   branchName: "Main Branch",
  //   holderName: "John Doe",
  //   accountNumber: "123456789",
  //   otherDetails: "Savings account",
  // ),
  shippingAddress: [
    ShippingAddress(
      id: "address_1",
      address: "123 Main St",
      addressAs: "Home",
      landmark: "Near Central Park",
      locality: "New York",
      isDefault: true,
      location: UserLocation(latitude: 40.7128, longitude: -74.0060),
    ),
    ShippingAddress(
      id: "address_2",
      address: "456 Market St",
      addressAs: "Work",
      landmark: "Near Wall Street",
      locality: "New York",
      isDefault: false,
      location: UserLocation(latitude: 40.7070, longitude: -74.0100),
    ),
  ],
  carName: "Toyota Camry",
  carNumber: "XYZ1234",
  carPictureURL: "https://example.com/car_pic.jpg",
  inProgressOrderID: ["order_001", "order_002"],
  orderRequestData: ["order_data_1", "order_data_2"],
  vendorID: "vendor_67890",
  zoneId: "zone_001",
  rotation: 0.0,
);

// void main() {
//   // Example: Convert johnDoe to JSON for saving to Firestore or printing
//   Map<String, dynamic> johnDoeJson = johnDoe.toJson();
//   print(johnDoeJson);
// }
