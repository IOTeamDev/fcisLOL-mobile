class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    // SelectedSemester = "Three";
    // print(SelectedSemester);

    var profileModel = MainCubit.get(context).profileModel;
    return Drawer(
      width: screenWidth(context) / 1.3,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TOKEN != null
                ? GestureDetector(
                    onTap: () {
                      print("sdfsd");
                    },
                    child: UserAccountsDrawerHeader(
                      decoration: const BoxDecoration(color: Color(0xff0F4C75)),
                      accountName: Row(
                        children: [
                          Text(
                            profileModel!.name,
                            style: const TextStyle(overflow: TextOverflow.clip),
                          ),
                          const Spacer(),
                          Text(Level(profileModel.semester)),
                          const SizedBox(
                            width: 10,
                          )
                        ],
                      ),
                      // accountEmail: Text("2nd year "),
                      accountEmail: TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(0, 0),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: () => navigate(context, const Profile()),
                          child: const Text(
                            "Profile info",
                            style: TextStyle(color: Colors.orange),
                          )),
                      currentAccountPicture: ClipOval(
                        child: Image.network(
                          profileModel.photo,
                          width: 30,
                          height: 30,
                          fit: BoxFit.cover,
                        ),
                        // backgroundImage: NetworkImage(profileModel.photo),
                      ),
                      // otherAccountsPictures: [
                      //   Icon(Icons.info, color: Colors.white),
                      // ],
                    ),
                  )
                : GestureDetector(
                    onTap: () {
                      print("sdfsd");
                    },
                    child: UserAccountsDrawerHeader(
                      decoration: const BoxDecoration(color: Color(0xff0F4C75)),
                      // accountName: Text(""),
                      // accountEmail: Text("2nd year "),
                      accountName: const Text(""),
                      accountEmail: Text(
                        Level(SelectedSemester!),
                        style: const TextStyle(fontSize: 20),
                      ),
                      // accountEmail:InkWell(
                      //   child: Ink(
                      //     child: Text(
                      //       // style: TextButton.styleFrom(padding: EdgeInsets.all(0)),
                      //       // onPressed: () {
                      //       //   Navigator.push(
                      //       //       context,
                      //       //       MaterialPageRoute(
                      //       //           builder: (context) => const LoginScreen()));
                      //       // },
                      //       // child: const Text(
                      //         "Login",
                      //         style: TextStyle(color: Colors.white),

                      //     ),
                      //   ),
                      // ) ,
                      currentAccountPicture: const CircleAvatar(
                        backgroundImage: NetworkImage(
                            "https://static.vecteezy.com/system/resources/thumbnails/009/292/244/small/default-avatar-icon-of-social-media-user-vector.jpg"),
                      ),
                      otherAccountsPictures: [
                        InkWell(
                          onTap: () =>
                              navigatReplace(context, const LoginScreen()),
                          child: Ink(
                            child: const Text(
                              // style: TextButton.styleFrom(padding: EdgeInsets.all(0)),
                              // onPressed: () {
                              //   Navigator.push(
                              //       context,
                              //       MaterialPageRoute(
                              //           builder: (context) => const LoginScreen()));
                              // },
                              // child: const Text(
                              "Login",
                              style: TextStyle(
                                color: Colors.orange,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
            ListTile(
              leading: const Icon(Icons.announcement),
              title: const Text("Announcements"),
              onTap: () { navigate(context, const AnnouncementsList());},
            ),
            ExpansionTile(
              leading: const Icon(Icons.school),
              title: const Text("Years"),
              children: [
                ExpansionTile(
                  title: const Text("First Year"),
                  children: [
                    ListTile(
                      title: const Text("First Semester"),
                      onTap: () {
                        // MainCubit.get(context).profileModel = null;
                        // TOKEN = null;
                        navigate(
                            context, const SemesterNavigate(semester: "One"));
                      },
                    ),
                    ListTile(
                      title: const Text("Second Semester"),
                      onTap: () {
                        // MainCubit.get(context).profileModel = null;
                        // TOKEN = null;
                        navigate(
                            context, const SemesterNavigate(semester: "Two"));
                      },
                    ),
                  ],
                ),
                ExpansionTile(
                  title: const Text("Second Year"),
                  children: [
                    ListTile(
                      title: const Text("First Semester"),
                      onTap: () {
                        // MainCubit.get(context).profileModel = null;
                        // TOKEN = null;
                        navigate(
                            context, const SemesterNavigate(semester: "Three"));
                      },
                    ),
                    ListTile(
                      title: const Text("Second Semester"),
                      onTap: () {
                        // MainCubit.get(context).profileModel = null;
                        // TOKEN = null;
                        navigate(
                            context, const SemesterNavigate(semester: "Four"));
                      },
                    ),
                  ],
                ),
                ExpansionTile(
                  title: const Text("Third Year"),
                  children: [
                    ListTile(
                      title: const Text("First Semester"),
                      onTap: () {
                        // MainCubit.get(context).profileModel = null;
                        // TOKEN = null;
                        navigate(
                            context, const SemesterNavigate(semester: "Five"));
                      },
                    ),
                    ListTile(
                      title: const Text("Second Semester"),
                      onTap: () {
                        // MainCubit.get(context).profileModel = null;
                        // TOKEN = null;
                        navigate(
                            context, const SemesterNavigate(semester: "Six"));
                      },
                    ),
                  ],
                ),
                InkWell(
                  onTap: () => showToastMessage(
                      message: "Currently Updating ...",
                      states: ToastStates.INFO),
                  child: ExpansionTile(
                    enabled: false,
                    title: const Text("Seniors"),
                    children: [
                      ListTile(
                        title: const Text("First Semester"),
                        onTap: () {
                          // MainCubit.get(context).profileModel = null;
                          // TOKEN = null;
                          navigate(
                              context, const SemesterNavigate(semester: "One"));
                        },
                      ),
                      ListTile(
                        title: const Text("Second Semester"),
                        onTap: () {
                          // MainCubit.get(context).profileModel = null;
                          // TOKEN = null;
                          navigate(
                              context, const SemesterNavigate(semester: "Two"));
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            ExpansionTile(
              leading: const Icon(Icons.drive_file_move),
              title: const Text("Drive"),
              children: [
                ListTile(
                  title: const Text("2027"),
                  onTap: () async {
                    LinkableElement url = LinkableElement('drive',
                        'https://drive.google.com/drive/folders/1-1_Ef2qF0_rDzToD4OlqIl5xubgpMGU0');
                    await onOpen(context, url);
                  },
                ),
                ListTile(
                  title: const Text("2026"),
                  onTap: () async {
                    LinkableElement url = LinkableElement('drive',
                        'https://drive.google.com/drive/folders/1CdZDa3z97RN_yRjFlC7IAcLfmw6D1yLy');
                    await onOpen(context, url);
                  },
                ),
                ListTile(
                  title: const Text("2025"),
                  onTap: () async {
                    LinkableElement url = LinkableElement('drive',
                        'https://drive.google.com/drive/folders/1BAXez9FJKF_ASx79usd_-Xi47TdUYK73?fbclid=IwAR3cRtEV1aJrcvKoGNBLCbqBu2LMLrsWYfQkOZUb6SQE2dtT3ZtqrcCjxno');
                    await onOpen(context, url);
                  },
                ),
                ListTile(
                  title: const Text("2024"),
                  onTap: () async {
                    LinkableElement url = LinkableElement('drive',
                        'https://drive.google.com/drive/u/0/folders/11egB46e3wtl1Q69wdCBBam87bwMF7Qo-');
                    await onOpen(context, url);
                  },
                ),
              ],
            ),
            ListTile(
              leading: const Icon(Icons.group),
              title: const Text("About Us"),
              onTap: () {},
            ),
            if (profileModel?.role == "ADMIN")
              ListTile(
                leading: const Icon(Icons.admin_panel_settings),
                title: const Text("Admin"),
                onTap: () {navigate(context, AdminPanal());},
              ),
            if (TOKEN != null)
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text(
                  "Log out",
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  MainCubit.get(context).logout(context);
                  Provider.of<ThemeProvide>(context,
                                        listen: false)
                                    .isDark = false;
                                Provider.of<ThemeProvide>(context,
                                        listen: false)
                                    .notifyListeners();
                },
              ),
            SizedBox(
              height: screenHeight(context) / 5,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: DarkLightModeToggle(context),
            ),
          ],
        ),
      ),
    );
  }
}
drawer:  CustomDrawer(context, name: TOKEN==null?"":profile!.name, semester: profile!.semester, photo: profile.photo, role: profile?.role, logout:(){} ),
android:enableOnBackInvokedCallback="true"
