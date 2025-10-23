class Summary {

  final int id;
  final String fatherName;
  final String motherName;
  final String nationality;
  final String religion;
  final String bloodGroup;
  final String height;
  final String weight;
  final String nid;
  final String description;

  Summary({
    required this.id,
    required this.fatherName,
    required this.motherName,
    required this.nationality,
    required this.religion,
    required this.bloodGroup,
    required this.height,
    required this.weight,
    required this.nid,
    required this.description,
  });

  factory Summary.fromJson(Map<String, dynamic> json) {
    return Summary(
      id: json['id'],
      fatherName: json['fatherName'] ?? '',
      motherName: json['motherName'] ?? '',
      nationality: json['nationality'] ?? '',
      religion: json['religion'] ?? '',
      bloodGroup: json['bloodGroup'] ?? '',
      height: json['height'] ?? '',
      weight: json['weight'] ?? '',
      nid: json['nid'] ?? '',
      description: json['description'] ?? '',
    );
  }

  // ⭐️ toJson Method (CV Generator-এর জন্য প্রয়োজনীয়)
  Map<String, dynamic> toJson() {
    return {
      // 'id': id, // ID সাধারণত POST-এ লাগে না, তবে CV Map-এ রাখা যেতে পারে
      'fatherName': fatherName,
      'motherName': motherName,
      'nationality': nationality,
      'religion': religion,
      'bloodGroup': bloodGroup,
      'height': height,
      'weight': weight,
      'nid': nid,
      'description': description,
    };
  }
}