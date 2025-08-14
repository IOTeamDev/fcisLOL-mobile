import 'package:flutter/material.dart';
import 'package:lol/core/data/local_data_provider.dart';
import 'package:lol/core/presentation/cubits/main_cubit/main_cubit.dart';
import 'package:lol/core/utils/components.dart';
import 'package:lol/core/resources/theme/colors_manager.dart';
import 'package:lol/core/resources/theme/values/app_strings.dart';
import 'package:lol/features/home/data/models/semster_model.dart';
import '../../../../core/resources/constants/constants_manager.dart';
import '../../../../core/presentation/app_icons.dart';
import '../../../../core/resources/theme/values/values_manager.dart';

class BasicInfoEdit extends StatefulWidget {
  String userName;
  String email;
  String phone;
  String semester;
  BasicInfoEdit(
      {super.key,
      required this.userName,
      required this.email,
      required this.phone,
      required this.semester});

  @override
  State<BasicInfoEdit> createState() => _BasicInfoEditState();
}

class _BasicInfoEditState extends State<BasicInfoEdit> {
  late TextEditingController _userNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late String _selectedSemester;
  late GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _userNameController = TextEditingController(text: widget.userName);
    _emailController = TextEditingController(text: widget.email);
    _phoneController = TextEditingController(text: widget.phone);
    _selectedSemester = widget.semester;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppPaddings.p20),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.userName,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(
                height: AppSizesDouble.s5,
              ),
              TextFormField(
                controller: _userNameController,
                keyboardType: TextInputType.name,
                validator: (value) {
                  if (value == null) {
                    return AppStrings.emptyFieldWarning;
                  }
                  return null;
                },
                cursorColor: ColorsManager.lightPrimary,
                style: TextStyle(
                    color: ColorsManager.black, fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                  hintText: AppStrings.username,
                  hintStyle: TextStyle(color: ColorsManager.grey),
                  filled: true,
                  fillColor: ColorsManager.grey7,
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide:
                          BorderSide(color: ColorsManager.lightPrimary)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: ColorsManager.white)),
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: ColorsManager.imperialRed)),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                AppStrings.emailAddress,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(
                height: 5,
              ),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null) {
                    return AppStrings.emptyFieldWarning;
                  }
                  return null;
                },
                cursorColor: ColorsManager.lightPrimary,
                style: TextStyle(
                    color: ColorsManager.black, fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                  hintText: AppStrings.emailAddress,
                  hintStyle: TextStyle(color: ColorsManager.grey),
                  filled: true,
                  fillColor: ColorsManager.grey7,
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide:
                          BorderSide(color: ColorsManager.lightPrimary)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: ColorsManager.white)),
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: ColorsManager.imperialRed)),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                AppStrings.phoneNumber,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(
                height: 5,
              ),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null) {
                    return AppStrings.emptyFieldWarning;
                  }
                  return null;
                },
                cursorColor: ColorsManager.lightPrimary,
                style: TextStyle(
                    color: ColorsManager.black, fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                  hintText: AppStrings.phoneNumber,
                  hintStyle: TextStyle(color: ColorsManager.grey),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide:
                          BorderSide(color: ColorsManager.lightPrimary)),
                  filled: true,
                  fillColor: ColorsManager.grey7,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: ColorsManager.white)),
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: ColorsManager.imperialRed)),
                ),
              ),
              SizedBox(
                height: AppSizesDouble.s10,
              ),
              Text(
                AppStrings.semester,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(
                height: AppSizesDouble.s5,
              ),
              Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: ColorsManager.white,
                    borderRadius: BorderRadius.circular(AppPaddings.p50)),
                padding: EdgeInsets.only(
                    left: AppPaddings.p15, right: AppPaddings.p2),
                child: DropdownButton<String>(
                  isExpanded: true,
                  icon: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: AppPaddings.p20,
                          vertical: AppPaddings.p10),
                      decoration: BoxDecoration(
                          color: ColorsManager.lightPrimary,
                          borderRadius:
                              BorderRadius.circular(AppSizesDouble.s25)),
                      child: Icon(
                        AppIcons.dropdownIcon,
                        color: ColorsManager.white,
                      )),
                  value: _selectedSemester,
                  underline: SizedBox(),
                  hint: Text(AppStrings.selectSemester,
                      style: TextStyle(color: ColorsManager.black)),
                  dropdownColor: ColorsManager
                      .white, // Background color for the dropdown list
                  iconEnabledColor:
                      ColorsManager.black, // Color of the dropdown icon
                  style: const TextStyle(
                      color: ColorsManager
                          .white), // Style for the selected item outside
                  items: LocalDataProvider.semesters
                      .map((String item) => DropdownMenuItem(
                            value: item,
                            child: Text(
                              item,
                              style:
                                  const TextStyle(color: ColorsManager.black),
                            ),
                          ))
                      .toList(),
                  selectedItemBuilder: (BuildContext context) {
                    return LocalDataProvider.semesters.map((String item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          item,
                          style: const TextStyle(
                              color: ColorsManager.black,
                              fontSize: AppSizesDouble.s20,
                              fontWeight: FontWeight.w500),
                        ),
                      );
                    }).toList();
                  },
                  onChanged: (value) {
                    setState(() {
                      _selectedSemester = value!;
                    });
                  },
                ),
              ),
              SizedBox(
                height: AppSizesDouble.s25,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: ColorsManager.lightPrimary,
                        foregroundColor: ColorsManager.white,
                        padding:
                            EdgeInsets.symmetric(vertical: AppPaddings.p12)),
                    onPressed: () {
                      MainCubit.get(context).updateCurrentUser(
                          name: _userNameController.text,
                          phone: _phoneController.text,
                          email: _emailController.text,
                          semester: _selectedSemester);
                    },
                    child: Text(AppStrings.saveData)),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _userNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
