class CRMProducts {
  late int item;
  late String code;
  late String name;
  late String price;
  late String description;

  CRMProducts(
    this.item,
    this.code,
    this.name,
    this.price,
    this.description,
  );
  CRMProducts.fromJson(Map<String, dynamic> json) {
    item = json['item'];
    code = json['code'];
    name = json['name'];
    price = json['price'];
    description = json['description'];
  }
}
