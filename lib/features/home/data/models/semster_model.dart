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
  SubjectModel(subjectName: "Introduction_to_Computer_Sciences", subjectImage: "images/c-.png"),
  SubjectModel(subjectName: "Physics", subjectImage: "images/physics.png"),
  SubjectModel(subjectName: "Calculus", subjectImage: "images/integral.png"),
  SubjectModel(subjectName: "Psychology", subjectImage: "images/autism.png"),
  SubjectModel(subjectName: "Probability_and_Statistics", subjectImage: "images/dice.png"),
  SubjectModel(subjectName: "English", subjectImage: "images/english.png"),
];

List<SubjectModel> semesterTwo = [
  SubjectModel(
      subjectName: "Structured_Programming", subjectImage: "images/SP (2).png"),
  SubjectModel(subjectName: "Ethics", subjectImage: "images/ethics.png"),
  SubjectModel(subjectName: "Physics_II", subjectImage: "images/physics2.png"),
  SubjectModel(
      subjectName: "Business", subjectImage: "images/bnussiness (2).png"),
  SubjectModel(subjectName: "Calculus_II", subjectImage: "images/Calc2.png"),
  SubjectModel(
      subjectName: "Electronics",
      subjectImage: "images/Elec-removebg-preview.png"),
];

List<SubjectModel> semesterThree = [
  SubjectModel(
      subjectName: "OOP",
      subjectImage:"images/sm_5afbf1d28feb1-removebg-preview.png"),
  SubjectModel(
      subjectName: "Statistical_Analysis",
      subjectImage: "images/analysis.png"),
  SubjectModel(subjectName: "Logic_Design", subjectImage: "images/Logic.png"),
  SubjectModel(
      subjectName: "Discrete_Mathematics",
      subjectImage: "images/discrete-math.png"),
  SubjectModel(
      subjectName: "Database_Management_Systems",
      subjectImage: "images/DB.png"),
  SubjectModel(
      subjectName: "Report_Writing", subjectImage: "images/Report.png"),
];

List<SubjectModel> semesterFour = [
  SubjectModel(
      subjectName: "Computer_Architecture",
      subjectImage: "images/architecture.png"),
  SubjectModel(
      subjectName: "Data_Structures", subjectImage: "images/DataSt.png"),
  SubjectModel(subjectName: "Linear_Algebra", subjectImage: "images/Alg.png"),
  SubjectModel(
      subjectName: "Artificial_Intelligence", subjectImage: "images/AI.png"),
  SubjectModel(
      subjectName: "Operations_Research", subjectImage: "images/Op_Re.png"),
];

List<SubjectModel> semesterFive = [
  SubjectModel(subjectName: "Operating_Systems", subjectImage: "images/linux-logo.png"),
  SubjectModel(
      subjectName: "DSP",
      subjectImage:
          "images/webpage.png"), //
  SubjectModel(
      subjectName: "Computer_Networks",
      subjectImage:
          "images/radio-antenna.png"),
  SubjectModel(
      subjectName: "System_Analysis_and_Design",
      subjectImage: "images/data-analysis.png"),
  SubjectModel(
      subjectName: "Data_Mining", subjectImage: "images/data-mining.png"),
  SubjectModel(
      subjectName: "Compiler_Theory", subjectImage: "images/compiler.png"),
  SubjectModel(
      subjectName: "Numerical_Computing",
      subjectImage:
          "images/binary-code.png"), //
  SubjectModel(
      subjectName: "Statistical_Inference",
      subjectImage:
          "images/analysis (1).png"), //
  SubjectModel(
      subjectName: "Microprocessors_and_interfacing",
      subjectImage: "images/microprocessor.png"), //
];

List<SubjectModel> semesterSix = [
  SubjectModel(
      subjectName: "Software_Engineering",
      subjectImage:
          "images/prototype.png"), //
  SubjectModel(
      subjectName: "Concepts_of_Programming_Languages",
      subjectImage: "images/coding-language.png"), //
  SubjectModel(
      subjectName: "HPC",
      subjectImage: "images/performance.png"), //
  SubjectModel(
      subjectName: "Analysis_and_Design_of_Algorithms",
      subjectImage: "images/algorithm.png"), //
  SubjectModel(
      subjectName: "Data_Security", subjectImage: "images/secure-data.png"), //
  SubjectModel(
      subjectName: "Computer_Graphics",
      subjectImage: "images/web-design.png"), //
  SubjectModel(
      subjectName: "Machine_Learning",
      subjectImage: "images/machine-learning.png"), //
  SubjectModel(
      subjectName: "Web_Development", subjectImage: "images/code.png"), //
  SubjectModel(
      subjectName: "Business_Intelligence",
      subjectImage: "images/business-intelligence.png"), //
  SubjectModel(
      subjectName: "Data_Communication",
      subjectImage: "images/computer (1).png"), //
  SubjectModel(
      subjectName: "NLP",
      subjectImage: "images/natural-language-processing.png"), //
  SubjectModel(
      subjectName: "Embedded_Systems", subjectImage: "images/microchip.png"), //
];

List<SemesterModel> semesters = [
  SemesterModel(semester: "One", subjects: semesterOne),
  SemesterModel(semester: "Two", subjects: semesterTwo),
  SemesterModel(semester: "Three", subjects: semesterThree),
  SemesterModel(semester: "Four", subjects: semesterFour),
  SemesterModel(semester: "Five", subjects: semesterFive),
  SemesterModel(semester: "Six", subjects: semesterSix),
  SemesterModel(semester: "Seven", subjects: semesterSix),
  SemesterModel(semester: "Eight", subjects: semesterSix),
];

int getSemesterIndex(String semester) {
  switch (semester) {
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

    case 'Seven':
      return 6;

    case 'Eight':
      return 7;
  }
  return -1;
}
