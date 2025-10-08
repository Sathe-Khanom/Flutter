


class Education {
  int? id;
  String? level;
  String? institute;
  String? board;
  String? result;
  String? year;

  Education({this.id, this.level, this.institute, this.board, this.result, this.year});

  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(
      id: json['id'],
      level: json['level'],
      institute: json['institute'],
      board: json['board'],
      result: json['result'],
      year: json['year'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'level': level,
      'institute': institute,
      'board': board,
      'result': result,
      'year': year,
      // Do NOT include jobSeeker
    };
  }
}
