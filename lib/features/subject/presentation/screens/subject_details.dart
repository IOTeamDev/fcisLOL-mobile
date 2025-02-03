import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lol/core/cubits/main_cubit/main_cubit.dart';
import 'package:lol/main.dart';
import 'package:lol/features/subject/presentation/cubit/get_material_cubit/get_material_cubit_cubit.dart';
import 'package:lol/features/subject/presentation/screens/widgets/build_floating_action_button.dart';
import 'package:lol/features/subject/presentation/screens/widgets/custom_tab_bar.dart';
import 'package:lol/features/subject/presentation/screens/widgets/custom_tab_bar_view.dart';

import '../../../../core/utils/resources/constants_manager.dart';

class SubjectDetails extends StatefulWidget {
  final String subjectName;

  final bool navigate;
  const SubjectDetails(
      {super.key, required this.subjectName, required this.navigate});

  @override
  State<SubjectDetails> createState() => _MaterialDetailsState();
}

class _MaterialDetailsState extends State<SubjectDetails>
    with TickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late TabController _tabControllerOfShowingContent;

  @override
  void initState() {
    _tabControllerOfShowingContent = TabController(length: 2, vsync: this);

    GetMaterialCubit.get(context).getMaterials(subject: widget.subjectName);
    MainCubit.get(context).getProfileInfo();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();

    _tabControllerOfShowingContent.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var cubit = GetMaterialCubit.get(context);
    cubit.subjectName = widget.subjectName;
    return Scaffold(
      floatingActionButton: BuildFloatingActionButton(
        subjectName: widget.subjectName,
        getMaterialCubit: cubit,
      ),
      key: scaffoldKey,
      //backgroundColor: isDark ? HexColor('#23252A') : Colors.white,
      body: Container(
        margin: EdgeInsetsDirectional.only(top: AppQueries.screenHeight(context) / 15),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: MainCubit.get(context).isDark ? Colors.white : Colors.black,
                      size: 30,
                    )),
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      widget.subjectName
                          .replaceAll('_', " ")
                          .replaceAll("and", "&"),
                      style: TextStyle(
                          color: MainCubit.get(context).isDark ? Colors.white : Colors.black,
                          fontSize: AppQueries.screenWidth(context) / 15),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
              child: TextField(
                onChanged: (query) {
                  cubit.runFilter(query: query);
                },
                style: TextStyle(
                    color: MainCubit.get(context).isDark ? Color(0xff1B262C) : HexColor('#757575'),
                    fontSize: 20),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                    fillColor: HexColor('#CDCDCD'),
                    filled: true,
                    prefixIcon: Icon(
                      Icons.search,
                      size: 25,
                      color: HexColor('#757575'),
                    ),
                    contentPadding: const EdgeInsets.all(10.0),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    hintText: 'Search for Videos, Documents',
                    hintStyle: TextStyle(
                      color: HexColor('#757575'),
                      fontSize: 15,
                    )),
              ),
            ),
            CustomTabBar(
                tabController: _tabControllerOfShowingContent,
                title1: 'Videos',
                title2: 'Documents'),
            Expanded(
                child: CustomTabBarView(
                    controller: _tabControllerOfShowingContent)),
          ],
        ),
      ),
    );
  }
}
