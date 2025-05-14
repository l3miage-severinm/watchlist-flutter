class CustomList {
  final String name;

  CustomList({
    required this.name
  });

  factory CustomList.fromJson(Map<String, dynamic> json) {
    return CustomList(
      name: json['name']
    );
  }
}