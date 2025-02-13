class OnBoardingModel {
  String? title;
  String? body;
  String? image;
  OnBoardingModel(
      {required this.title, required this.body, required this.image});
}

List<OnBoardingModel> onBoardingItemsList = [
  OnBoardingModel(
      title: "All In One Place",
      body: "Videos 🎬, Notes 📝, Recordings 📹, Exams 🖊... and more ",
      image: "images/Checklist.png"),
  OnBoardingModel(
      title: "Study anytime anywhere",
      body:
          " Whether you’re on the bus or at home, your learning is always within reach.",
      image: "images/Subway-cuate.png"),
  OnBoardingModel(
      title: "A+ is Just a Tap Away !",
      body:
          "Why wait? Jump into your studies and watch your grades climb to the top.",
      image: "images/Grades-pana.png"),
];
