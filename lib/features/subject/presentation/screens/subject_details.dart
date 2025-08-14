import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lol/core/presentation/cubits/main_cubit/main_cubit.dart';
import 'package:lol/core/presentation/screen_size.dart';
import 'package:lol/core/resources/theme/colors_manager.dart';
import 'package:lol/core/resources/theme/theme_provider.dart';
import 'package:lol/main.dart';
import 'package:lol/features/subject/presentation/view_model/get_material_cubit/get_material_cubit.dart';
import 'package:lol/features/subject/presentation/screens/widgets/build_floating_action_button.dart';
import 'package:lol/features/subject/presentation/screens/widgets/custom_tab_bar.dart';
import 'package:lol/features/subject/presentation/screens/widgets/custom_tab_bar_view.dart';
import 'package:provider/provider.dart';
import '../../../../core/resources/theme/values/app_strings.dart';
import '../../../../core/resources/theme/values/values_manager.dart';
import '../../../../core/resources/constants/constants_manager.dart';

class SubjectDetails extends StatefulWidget {
  final String subjectName;

  const SubjectDetails({super.key, required this.subjectName});

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
          title: FittedBox(
        child: Text(
          widget.subjectName
              .replaceAll(AppStrings.underScore, AppStrings.space),
          style: Theme.of(context).textTheme.displayMedium!.copyWith(
                fontSize: ScreenSize.width(context) / AppSizes.s15,
              ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      )),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: AppPaddings.p16, vertical: AppPaddings.p10),
            child: TextField(
              onChanged: (query) {
                cubit.runFilter(query: query);
              },
              style: TextStyle(color: ColorsManager.black, fontSize: 20),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                  fillColor: ColorsManager.grey7,
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
              child:
                  CustomTabBarView(controller: _tabControllerOfShowingContent)),
        ],
      ),
    );
  }
}
