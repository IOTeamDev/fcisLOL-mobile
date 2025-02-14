import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lol/core/cubits/main_cubit/main_cubit.dart';
import 'package:lol/core/utils/resources/colors_manager.dart';
import 'package:lol/core/utils/resources/theme_provider.dart';
import 'package:lol/main.dart';
import 'package:lol/features/subject/presentation/cubit/get_material_cubit/get_material_cubit_cubit.dart';
import 'package:lol/features/subject/presentation/screens/widgets/build_floating_action_button.dart';
import 'package:lol/features/subject/presentation/screens/widgets/custom_tab_bar.dart';
import 'package:lol/features/subject/presentation/screens/widgets/custom_tab_bar_view.dart';
import 'package:provider/provider.dart';
import '../../../../../core/utils/resources/strings_manager.dart';
import '../../../../../core/utils/resources/values_manager.dart';
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
      appBar: AppBar(
          title: Text(
        widget.subjectName
            .replaceAll(StringsManager.underScore, StringsManager.space)
            .replaceAll(StringsManager.andWord, StringsManager.andSymbol),
        style: Theme.of(context).textTheme.displayMedium!.copyWith(
              fontSize: AppQueries.screenWidth(context) / AppSizes.s15,
            ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      )),
      body: Container(
        margin: EdgeInsetsDirectional.only(
            top: AppQueries.screenHeight(context) / AppSizes.s15),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: AppPaddings.p16, vertical: AppPaddings.p10),
              child: TextField(
                onChanged: (query) {
                  cubit.runFilter(query: query);
                },
                style: TextStyle(
                    color: Provider.of<ThemeProvider>(context).isDark
                        ? Color(0xff1B262C)
                        : ColorsManager.lightGrey,
                    fontSize: 20),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                    fillColor: Color(0xffCDCDCD),
                    filled: true,
                    prefixIcon: Icon(
                      Icons.search,
                      size: 25,
                      color: ColorsManager.lightGrey,
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
                      color: ColorsManager.lightGrey,
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
