class Blog {
  int id;
  String name;
  int year;
  String color;
  String pantone_value;

  Blog({
    required this.id,
    required this.name,
    required this.year,
    required this.color,
    required this.pantone_value,
  });

  factory Blog.fromJson(Map<String, dynamic> json) {
    return Blog(
      id: json['id'],
      name: json['name'],
      year: json['year'],
      color: json['color'],
      pantone_value: json['pantone_value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'year': year,
      'color': color,
      'pantone_value': pantone_value,
    };
  }
}