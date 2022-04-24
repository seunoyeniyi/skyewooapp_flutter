// ignore_for_file: unnecessary_this

class Product {
  String id = "";
  String type = "";
  String name = "";
  String description = "";
  String price = "";
  String regularPrice = "";
  String productType = "";
  String categories = "[]";
  String image = "";
  String inWishList = "";
  String stockStatus = "";
  String lowestPrice = "0";
  String highestPrice = "0";

  Product({this.id = "", this.name = ""});

  get getID => this.id;

  set setID(String id) => this.id = id;

  String get getType => this.type;

  set setType(type) => this.type = type;

  get getName => this.name;

  set setName(name) => this.name = name;

  get getDescription => this.description;

  set setDescription(description) => this.description = description;

  get getPrice => this.price;

  set setPrice(price) => this.price = price;

  get getRegularPrice => this.regularPrice;

  set setRegularPrice(regularPrice) => this.regularPrice = regularPrice;

  get getProductType => this.productType;

  set setProductType(productType) => this.productType = productType;

  get getCategories => this.categories;

  set setCategories(categories) => this.categories = categories;

  get getImage => this.image;

  set setImage(image) => this.image = image;

  get getInWishList => this.inWishList;

  set setInWishList(inWishList) => this.inWishList = inWishList;

  get getStockStatus => this.stockStatus;

  set setStockStatus(stockStatus) => this.stockStatus = stockStatus;

  get getLowestPrice => this.lowestPrice;

  set setLowestPrice(lowestPrice) => this.lowestPrice = lowestPrice;

  get getHighestPrice => this.highestPrice;

  set setHighestPrice(highestPrice) => this.highestPrice = highestPrice;

  // JSONArray variations = new JSONArray();
  // JSONArray attributes = new JSONArray();

}
