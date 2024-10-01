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
  SubjectModel(
      subjectName: "Introduction_to_Computer_Sciences",
      subjectImage:
          "https://cdn.vectorstock.com/i/500p/31/09/big-data-and-artificial-intelligence-concept-vector-20763109.jpg"),
  SubjectModel(
      subjectName: "Physics",
      subjectImage:
          "https://miro.medium.com/v2/resize:fit:1024/1*bWlRl9D3jkJR06_oO0cP_Q.png"),
  SubjectModel(
      subjectName: "Calculus",
      subjectImage:
          "https://apasseducation.com/wp-content/uploads/2017/06/calc268f.jpg"),
  SubjectModel(
      subjectName: "Psychology",
      subjectImage:
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQf9bkOyzyRJc-ypJsSp4KmqsogNe4spQfYNw&s"),
  SubjectModel(
      subjectName: "Probability_and_Statistics",
      subjectImage:
          "https://cdn.builtin.com/cdn-cgi/image/f=auto,fit=cover,w=1200,h=635,q=80/https://builtin.com/sites/www.builtin.com/files/2022-10/dice-data-science-probability-statistics.png"),
  SubjectModel(
      subjectName: "English",
      subjectImage:
          "https://storage.googleapis.com/schoolnet-content/blog/wp-content/uploads/2022/07/How-to-Learn-English-Speaking-at-Home.jpg"),
];

List<SubjectModel> semesterTwo = [
  SubjectModel(
      subjectName: "Structured_Programming",
      subjectImage:
          "https://www.springboard.com/blog/wp-content/uploads/2022/08/programming-skills.png"),
  SubjectModel(
      subjectName: "Ethics",
      subjectImage:
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRP9IzvM6HTqfSalkZi5VE38DYwCcOCgmssYw&s"),
  SubjectModel(
      subjectName: "Physics_II",
      subjectImage:
          "https://thumbs.dreamstime.com/b/captivating-image-features-abstract-representation-quantum-physics-particle-dynamics-vibrant-colors-blue-purple-322222806.jpg"),
  SubjectModel(
      subjectName: "Business",
      subjectImage:
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS34wULJo7LChwKRBw6JjiCpp-LYIjCqU6uQXd8xBZfqsPOJSc4"),
  SubjectModel(
      subjectName: "Calculus_II",
      subjectImage:
          "https://imageio.forbes.com/specials-images/imageserve/663a317a0c62c92476f504f4/Mathematics-function-integra-graph-formulas-on-the-chalkboard-/960x0.jpg?format=jpg&width=960"),
  SubjectModel(
      subjectName: "Electronics",
      subjectImage:
          "https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcT9aDj6Cw6APTvOFhsQK20H2GCsiwW9btt_p-ewKsJ2T78N0HIS"),
];

List<SubjectModel> semesterThree = [
  SubjectModel(
      subjectName: "OOP",
      subjectImage:
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTG4e4tadUqb6A59hAbirAX0tk4ZXBMAIoWFdvRgBYyqyogglFC-ghxQJGp4ZWujaGglsY&usqp=CAU"),
  SubjectModel(
      subjectName: "Statistical_Analysis",
      subjectImage:
          "https://www.thesenior.com.au/images/transform/v1/crop/frm/matthew.crossman/2802f874-e561-4b7e-8873-41c68abcb44e.jpg/r0_0_4996_3286_w1200_h678_fmax.jpg"),
  SubjectModel(
      subjectName: "Logic_Design",
      subjectImage:
          "https://learningmonkey.in/wp-content/uploads/2021/06/Digital-Logic-Design.jpg"),
  SubjectModel(
      subjectName: "Discrete_Mathematics",
      subjectImage:
          "https://img.freepik.com/premium-vector/maths-learning-vector-line-round-colored-banner-math-concept-illustration_104589-5586.jpg"),
  SubjectModel(
      subjectName: "Database_Management_Systems",
      subjectImage:
          "https://zeenea.com/wp-content/uploads/2023/01/databases-zeenea.jpg.webp"),
  SubjectModel(
      subjectName: "Report_Writing",
      subjectImage:
          "https://schools.firstnews.co.uk/wp-content/uploads/sites/3/2019/10/Writing-a-newspaper-report-Featured-1200x900.jpg"),
];

List<SubjectModel> semesterFour = [
  SubjectModel(
      subjectName: "Computer_Architecture",
      subjectImage:
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQvw_SJDKJ2LMN1ao7koeC4IcrHmBbnCISzYqUlVOPP5qJJQ87z1GRLsfua_Fyvd935UrI&usqp=CAU"),
  SubjectModel(
      subjectName: "Data_Structures",
      subjectImage:
          "https://futureskillsprime.in/sites/default/files/inline-images/Blog%20Images_Internal_551x313_Saurabh%27s%20blog%20image%201.jpg"),
  SubjectModel(
      subjectName: "Linear_Algebra",
      subjectImage:
          "https://img-c.udemycdn.com/course/240x135/1714498_8a8c_4.jpg"),
  SubjectModel(
      subjectName: "Artificial_Intelligence",
      subjectImage:
          "https://scitechdaily.com/images/Artificial-Intelligence-Robot-Thinking-Brain.jpg"),
  SubjectModel(
      subjectName: "Operations_Research",
      subjectImage:
          "https://ieor.columbia.edu/sites/default/files/styles/cu_crop/public/content/images/masters-msor-01.jpg?itok=BfVY0pZ4"),
];

List<SubjectModel> semesterFive = [
  SubjectModel(
      subjectName: "Operating_Systems",
      subjectImage: "https://cloudpso.com/wp-content/uploads/2024/01/ops2.jpg"),
  SubjectModel(
      subjectName: "DSP",
      subjectImage:
          "https://4.img-dpreview.com/files/p/articles/7461037188/digic_chip.jpeg"), //
  SubjectModel(
      subjectName: "Computer_Networks",
      subjectImage:
          "https://miro.medium.com/v2/resize:fit:1024/0*yDZ4O2EsLoVJSdDC.jpeg"),
  SubjectModel(
      subjectName: "System_Analysis_and_Design",
      subjectImage:
          "https://www.shutterstock.com/image-photo/intelligence-bi-business-analytics-ba-600nw-1081970570.jpg"),
  SubjectModel(
      subjectName: "Data_Mining",
      subjectImage:
          "https://artoftesting.com/wp-content/uploads/2022/02/data-mining.png"),
  SubjectModel(
      subjectName: "Compiler_Theory",
      subjectImage:
          "https://codequotient.com/blog/wp-content/uploads/2022/05/Difference-Between-Compiler-And-Interpreter-In-Java.jpg"),
  SubjectModel(
      subjectName: "Numerical_Computing",
      subjectImage:
          "https://www.mathworks.com/moler/index_ncm/_jcr_content/mainParsys/column_1/2/image_0.adapt.full.medium.png/1642102580164.png"), //
  SubjectModel(
      subjectName: "Statistical_Inference",
      subjectImage:
          "https://www.statisticsteacher.org/files/2023/03/1Thumbnail1_topic-advisor.png"), //
  SubjectModel(
      subjectName: "Microprocessors_and_interfacing",
      subjectImage:
          "https://thumbs.dreamstime.com/b/aerial-view-colorful-digital-microprocessor-glowing-lighting-digital-interface-aerial-view-colorful-digital-325063205.jpg"), //
];

List<SubjectModel> semesterSix = [
  SubjectModel(
      subjectName: "Software_Engineering",
      subjectImage:
          "https://t3.ftcdn.net/jpg/05/69/49/34/360_F_569493492_Y41ak1sGwkR0C1d9VZjnBjQcbF6mlWfl.jpg"), //
  SubjectModel(
      subjectName: "Concepts_of_Programming_Languages",
      subjectImage:
          "https://www.dignited.com/wp-content/uploads/2022/08/top10lan.jpg"), //
  SubjectModel(
      subjectName: "HPC",
      subjectImage:
          "https://miro.medium.com/v2/resize:fit:1000/1*v1icYZnjM6tXmXe1tRXZjA.jpeg"), //
  SubjectModel(
      subjectName: "Analysis_and_Design_of_Algorithms",
      subjectImage:
          "https://static.vecteezy.com/system/resources/previews/025/144/709/non_2x/algorithm-icon-design-vector.jpg"), //
  SubjectModel(
      subjectName: "Data_Security",
      subjectImage:
          "https://media.istockphoto.com/id/1412282189/photo/lock-network-technology-concept.jpg?s=612x612&w=0&k=20&c=hripuxLs9pS_7Ln6YWQR-Ow2_-BU5RdQ4vOY8s1q1iQ="), //
  SubjectModel(
      subjectName: "Computer_Graphics",
      subjectImage:
          "https://cdn.prod.website-files.com/61d6943d6b59241863c825d6/62cfb819803fdd30ff2deea5_compgraphic.jpeg"), //
  SubjectModel(
      subjectName: "Machine_Learning",
      subjectImage:
          "https://media.licdn.com/dms/image/D5612AQF_GlBbDplIzQ/article-cover_image-shrink_720_1280/0/1689792786512?e=2147483647&v=beta&t=u6lBTG-DRAzHPpjpydQttxCmvzA1sqxJZaFmWh1GKoE"), //
  SubjectModel(
      subjectName: "Web_Development",
      subjectImage:
          "https://www.sectorlink.com/img/blog/web-devel-important.jpg"), //
  SubjectModel(
      subjectName: "Business_Intelligence",
      subjectImage:
          "https://images.ctfassets.net/xj0skx6m69u2/4xvFydVm2Pip0aVDK3aIyc/1306529dc227db3c7268209d457e9881/business-intellgence.jpg?fm=jpg&w=648&h=426&fit=fill&f=Center&q=85"), //
  SubjectModel(
      subjectName: "Data_Communication",
      subjectImage:
          "https://hasonss.com/blogs/wp-content/uploads/2024/03/25001339_7030492.webp"), //
  SubjectModel(
      subjectName: "NLP",
      subjectImage:
          "https://www.expert.ai/wp-content/uploads/2021/06/NLP-examples-scaled.jpeg"), //
  SubjectModel(
      subjectName: "Embedded_Systems",
      subjectImage:
          "https://sklc-tinymce-2021.s3.amazonaws.com/comp/2023/05/Embedded%20Systems_1684763782.png"), //
];

List<SemesterModel> semesters = [
  SemesterModel(semester: "One", subjects: semesterOne),
  SemesterModel(semester: "Two", subjects: semesterTwo),
  SemesterModel(semester: "Three", subjects: semesterThree),
  SemesterModel(semester: "Four", subjects: semesterFour),
  SemesterModel(semester: "Five", subjects: semesterFive),
  SemesterModel(semester: "Six", subjects: semesterSix),
];

int semsesterIndex(String semester) {
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
  }
  return -1;
}
