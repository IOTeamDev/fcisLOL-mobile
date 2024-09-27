class SemesterModel {
  late String semester;
  late List<SubjectModel> subjects;

  SemesterModel({required this.semester, required this.subjects});
}

class SubjectModel {
  late String subjectName;
  late String subjectImage;
  
  SubjectModel({required this.subjectName, required this.subjectImage});
}

List<SubjectModel> semesterOne = [
  SubjectModel(subjectName: "Introduction to Computer Sciences", subjectImage: "https://cdn.vectorstock.com/i/500p/31/09/big-data-and-artificial-intelligence-concept-vector-20763109.jpg"),
  SubjectModel(subjectName: "Physics", subjectImage: "https://miro.medium.com/v2/resize:fit:1024/1*bWlRl9D3jkJR06_oO0cP_Q.png"),
  SubjectModel(subjectName: "Calculus", subjectImage: "https://apasseducation.com/wp-content/uploads/2017/06/calc268f.jpg"),
  SubjectModel(subjectName: "Psychology", subjectImage: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQf9bkOyzyRJc-ypJsSp4KmqsogNe4spQfYNw&s"),
  SubjectModel(subjectName: "Probability & Statistics", subjectImage: "https://cdn.builtin.com/cdn-cgi/image/f=auto,fit=cover,w=1200,h=635,q=80/https://builtin.com/sites/www.builtin.com/files/2022-10/dice-data-science-probability-statistics.png"),
  SubjectModel(subjectName: "English", subjectImage: "https://storage.googleapis.com/schoolnet-content/blog/wp-content/uploads/2022/07/How-to-Learn-English-Speaking-at-Home.jpg"),
];

List<SubjectModel> semesterTwo = [
  SubjectModel(subjectName: "Ethics", subjectImage: ""),
  SubjectModel(subjectName: "Structured Programming", subjectImage: ""),
  SubjectModel(subjectName: "Business", subjectImage: ""),
  SubjectModel(subjectName: "Calculus II", subjectImage: ""),
  SubjectModel(subjectName: "Physics II", subjectImage: ""),
  SubjectModel(subjectName: "Electronics", subjectImage: ""),
];

List<SubjectModel> semesterThree = [
  SubjectModel(subjectName: "Report Writing", subjectImage: ""),
  SubjectModel(subjectName: "Object Oriented Programming", subjectImage: ""),
  SubjectModel(subjectName: "Discrete Mathematics", subjectImage: ""),
  SubjectModel(subjectName: "Logic Design", subjectImage: ""),
  SubjectModel(subjectName: "Database Management Systems", subjectImage: ""),
  SubjectModel(subjectName: "Statistical Analysis", subjectImage: ""),
];

List<SubjectModel> semesterFour = [
  SubjectModel(subjectName: "Computer Architecture", subjectImage: ""),
  SubjectModel(subjectName: "Data Structures", subjectImage: ""),
  SubjectModel(subjectName: "Linear Algebra", subjectImage: ""),
  SubjectModel(subjectName: "Artificial Intelligence", subjectImage: ""),
  SubjectModel(subjectName: "Operations Research", subjectImage: ""),
];

List<SubjectModel> semesterFive = [
  SubjectModel(subjectName: "Operating Systems", subjectImage: ""),
  SubjectModel(subjectName: "Computer Networks", subjectImage: ""),
  SubjectModel(subjectName: "System Analysis & Design", subjectImage: ""),
  SubjectModel(subjectName: "Data Mining", subjectImage: ""),
  SubjectModel(subjectName: "Compiler Theory", subjectImage: ""),
  SubjectModel(subjectName: "Numerical Computing", subjectImage: ""),//
  SubjectModel(subjectName: "Digital Signal Processing", subjectImage: ""),//
  SubjectModel(subjectName: "Statistical Inference", subjectImage: ""),//
  SubjectModel(subjectName: "Microprocessors & interfacing", subjectImage: ""),//
];

List<SubjectModel> semesterSix = [
  SubjectModel(subjectName: "Software Engineering", subjectImage: ""),//
  SubjectModel(subjectName: "Concepts of Programming Languages", subjectImage: ""),//
  SubjectModel(subjectName: "High Performance Computing", subjectImage: ""),//
  SubjectModel(subjectName: "Analysis & Design of Algorithms", subjectImage: ""),//
  SubjectModel(subjectName: "Data Security", subjectImage: ""),//
  SubjectModel(subjectName: "Computer Graphics", subjectImage: ""),//
  SubjectModel(subjectName: "Machine Learning", subjectImage: ""),//
  SubjectModel(subjectName: "Web Development & Design ", subjectImage: ""),//
  SubjectModel(subjectName: "Business Intelligence", subjectImage: ""),//
  SubjectModel(subjectName: "Computer & Network Security", subjectImage: ""),//
  SubjectModel(subjectName: "Data Communication", subjectImage: ""),//
  SubjectModel(subjectName: "Natural Language Processing", subjectImage: ""),//
  SubjectModel(subjectName: "Embedded Systems", subjectImage: ""),//
];


List<SemesterModel> semesters = [
  SemesterModel(semester: "One", subjects: semesterOne),
  SemesterModel(semester: "Two", subjects: semesterTwo),
  SemesterModel(semester: "Three", subjects: semesterThree),
  SemesterModel(semester: "Four", subjects: semesterFour),
  SemesterModel(semester: "Five", subjects: semesterFive),
  SemesterModel(semester: "Six", subjects: semesterSix),
];

int semsesterIndex(String semester){


switch(semester) {

case "One":
  return 0;
  
  case "Two":
  return 1;

  case "Three":
  return 2;

  case "Four":
  return 3;

  case "Five":
  return 4;

  case "Six":
  return 5;
} 
return -1;

}