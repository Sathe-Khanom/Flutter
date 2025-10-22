
import 'package:code/entity/education.dart';
import 'package:code/entity/experience.dart';
import 'package:code/entity/extracurricular.dart';
import 'package:code/entity/hobby.dart';
import 'package:code/entity/jobSeeker.dart';
import 'package:code/entity/language.dart';
import 'package:code/entity/reference.dart';
import 'package:code/entity/skill.dart';
import 'package:code/entity/training.dart';

class ApplyDTO {
  final int id;
  final int jobId;
  final String jobTitle;
  final int employerId;
  final String employerName;
  final int jobSeekerId;
  final String jobSeekerName;
  final String phone;
  final String email;


  // Optional detailed info
  final JobSeeker? jobSeeker;
  final List<Education>? educations;
  final List<Experience>? experiences;
  final List<Skill>? skills;
  final List<Training>? trainings;
  final List<Extracurricular>? extracurriculars;
  final List<Language>? languages;
  final List<Hobby>? hobbies;
  final List<Reference>? references;

  ApplyDTO({
    required this.id,
    required this.jobId,
    required this.jobTitle,
    required this.employerId,
    required this.employerName,
    required this.jobSeekerId,
    required this.jobSeekerName,
    required this.phone,
    required this.email,
    this.jobSeeker,
    this.educations,
    this.experiences,
    this.skills,
    this.trainings,
    this.extracurriculars,
    this.languages,
    this.hobbies,
    this.references,
  });

  factory ApplyDTO.fromJson(Map<String, dynamic> json) {
    return ApplyDTO(
      id: json['id'],
      jobId: json['jobId'],
      jobTitle: json['jobTitle'],
      employerId: json['employerId'],
      employerName: json['employerName'],
      jobSeekerId: json['jobSeekerId'],
      jobSeekerName: json['jobSeekerName'],
      phone: json['phone'],
      email: json['email'],
      jobSeeker: json['jobSeeker'] != null ? JobSeeker.fromJson(json['jobSeeker']) : null,
      educations: (json['educations'] as List?)?.map((e) => Education.fromJson(e)).toList(),
      experiences: (json['experiences'] as List?)?.map((e) => Experience.fromJson(e)).toList(),
      skills: (json['skills'] as List?)?.map((e) => Skill.fromJson(e)).toList(),
      trainings: (json['trainings'] as List?)?.map((e) => Training.fromJson(e)).toList(),
      extracurriculars: (json['extracurriculars'] as List?)?.map((e) => Extracurricular.fromJson(e)).toList(),
      languages: (json['languages'] as List?)?.map((e) => Language.fromJson(e)).toList(),
      hobbies: (json['hobbies'] as List?)?.map((e) => Hobby.fromJson(e)).toList(),
      references: (json['references'] as List?)?.map((e) => Reference.fromJson(e)).toList(),
    );
  }
}
