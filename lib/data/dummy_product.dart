import 'package:customer/models/product_model.dart';

List<ProductModel> dummyProducts = [
  ProductModel(
    fats: 10,
    vendorID: "vendor_001",
    veg: true,
    publish: true,
    addOnsTitle: ["Extra cheese", "Bacon"],
    calories: 250,
    proteins: 15,
    addOnsPrice: [1.5, 2.0],
    reviewsSum: 4.5,
    takeawayOption: true,
    name: "Deluxe Veggie Pizza",
    reviewAttributes: {"taste": 5, "freshness": 4.5},
    productSpecification: {"size": "Large", "crust": "Thin"},
    itemAttribute: ItemAttribute(
      attributes: [
        Attributes(
          attributeId: "attr_001",
          attributeOptions: ["Option 1", "Option 2"],
        ),
      ],
      variants: [
        Variants(
          variantId: "var_001",
          variantImage: "image_url_1",
          variantPrice: "12.99",
          variantQuantity: "100",
          variantSku: "SKU001",
        ),
      ],
    ),
    id: "product_001",
    quantity: 20,
    grams: 500,
    reviewsCount: 10,
    disPrice: "10.99",
    photos: ["photo_url_1", "photo_url_2"],
    nonveg: false,
    photo: "main_photo_url",
    price: "12.99",
    categoryID: "cat_001",
    description:
        "A delicious veggie pizza with a thin crust and fresh toppings.",
  ),
  ProductModel(
    fats: 10,
    vendorID: "vendor_001",
    veg: true,
    publish: true,
    addOnsTitle: ["Extra cheese", "Bacon"],
    calories: 250,
    proteins: 15,
    addOnsPrice: [1.5, 2.0],
    reviewsSum: 4.5,
    takeawayOption: true,
    name: "Deluxe Veggie Pizza",
    reviewAttributes: {"taste": 5, "freshness": 4.5},
    productSpecification: {"size": "Large", "crust": "Thin"},
    itemAttribute: ItemAttribute(
      attributes: [
        Attributes(
            attributeId: "attr_001",
            attributeOptions: ["Option 1", "Option 2"]),
      ],
      variants: [
        Variants(
          variantId: "var_001",
          variantImage: "image_url_1",
          variantPrice: "12.99",
          variantQuantity: "100",
          variantSku: "SKU001",
        ),
      ],
    ),
    id: "product_001",
    quantity: 20,
    grams: 500,
    reviewsCount: 10,
    disPrice: "10.99",
    photos: ["photo_url_1", "photo_url_2"],
    nonveg: false,
    photo: "main_photo_url",
    price: "12.99",
    categoryID: "cat_001",
    description:
        "A delicious veggie pizza with a thin crust and fresh toppings.",
  )
];
