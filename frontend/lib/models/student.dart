class Student {
  final String rollNo;
  final String photoUrl;
  final String fullName;
  final String gender;
  final String email;
  final String branch;
  final String section;
  final String course;
  final String fatherName;
  final String motherName;
  final String dateOfBirth;
  final String admissionDate;
  final String casteCategory;
  final String aadharNo;
  final String parentMobile;
  final String studentMobile;
  final String ssc;
  final String inter;
  final String courseCompletionYear;

  Student({
    required this.rollNo,
    required this.photoUrl,
    required this.fullName,
    required this.gender,
    required this.email,
    required this.branch,
    required this.section,
    required this.course,
    required this.fatherName,
    required this.motherName,
    required this.dateOfBirth,
    required this.admissionDate,
    required this.casteCategory,
    required this.aadharNo,
    required this.parentMobile,
    required this.studentMobile,
    required this.ssc,
    required this.inter,
    required this.courseCompletionYear,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      rollNo:
          json['rollNo']?.toString() ??
          json['Roll_No']?.toString() ??
          json['roll_no']?.toString() ??
          '',
      photoUrl:
          json['photoUrl']?.toString() ??
          json['Photo_URL']?.toString() ??
          json['photo_url']?.toString() ??
          '',
      fullName:
          json['fullName']?.toString() ??
          json['Full_Name']?.toString() ??
          json['full_name']?.toString() ??
          '',
      gender: json['gender']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      branch: json['branch']?.toString() ?? '',
      section: json['section']?.toString() ?? '',
      course: json['course']?.toString() ?? '',
      fatherName:
          json['fatherName']?.toString() ??
          json['father_name']?.toString() ??
          '',
      motherName:
          json['motherName']?.toString() ??
          json['mother_name']?.toString() ??
          '',
      dateOfBirth:
          json['dateOfBirth']?.toString() ??
          json['date_of_birth']?.toString() ??
          '',
      admissionDate:
          json['admissionDate']?.toString() ??
          json['admission_date']?.toString() ??
          '',
      casteCategory:
          json['casteCategory']?.toString() ??
          json['caste_category']?.toString() ??
          '',
      aadharNo:
          json['aadharNo']?.toString() ?? json['aadhar_no']?.toString() ?? '',
      parentMobile:
          json['parentMobile']?.toString() ??
          json['parent_mobile']?.toString() ??
          '',
      studentMobile:
          json['studentMobile']?.toString() ??
          json['student_mobile']?.toString() ??
          '',
      ssc: json['ssc']?.toString() ?? '',
      inter: json['inter']?.toString() ?? '',
      courseCompletionYear:
          json['courseCompletionYear']?.toString() ??
          json['course_completion_year']?.toString() ??
          '',
    );
  }
}