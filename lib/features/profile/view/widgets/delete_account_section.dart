import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lol/core/utils/resources/assets_manager.dart';
import 'package:lol/core/utils/resources/colors_manager.dart';

import '../../../../core/cubits/main_cubit/main_cubit.dart';
import '../../../../core/utils/resources/icons_manager.dart';
import '../../../../core/utils/resources/strings_manager.dart';

class DeleteAccountSection extends StatelessWidget {
  const DeleteAccountSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Image(image: AssetImage(AssetsManager.danger_info_logo), height: 100,),
            RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 20,),
                children: [
                  TextSpan(text: 'By '),
                  TextSpan(text: 'Deleting ', style: TextStyle(color: ColorsManager.imperialRed)),
                  TextSpan(text: 'Your Account, You will '),
                  TextSpan(text: 'Lose all of your data', style: TextStyle(color: ColorsManager.imperialRed)),
                  TextSpan(text: ', including Your score progress, all of Your personal information, and everything related to you except the uploaded material, will be added to the system account, and '),
                  TextSpan(text: "You won't be able to recover them again.", style: TextStyle(color: ColorsManager.imperialRed)),
                ]
              )
            ),
            SizedBox(height: 15,),
            ElevatedButton.icon(
              label: Text(
                'Delete Account',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(color: ColorsManager.white),
              ),
              icon: Icon(IconsManager.deleteIcon,),
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith(
                  (states) {
                    return ColorsManager.imperialRed;
                  },
                ),
                iconColor: WidgetStateProperty.resolveWith(
                  (states) {
                    return ColorsManager.white;
                  },
                ),
              ),
              onPressed: () {
                AwesomeDialog(
                  context: context,
                  title: StringsManager.delete,
                  dialogType: DialogType.warning,
                  body: Text(
                    textAlign: TextAlign.center,
                    'If you press "DELETE", your Uni-Notes account will be deleted PERMANENTLY',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  animType: AnimType.scale,
                  btnOk: ElevatedButton(
                    onPressed: () {
                      context.read<MainCubit>().deleteAccount(
                          id: context.read<MainCubit>().profileModel!.id);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: ColorsManager.imperialRed),
                    child: Text(
                      StringsManager.delete,
                      style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: ColorsManager.white),
                    ),
                  ),
                  btnCancel: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: ColorsManager.grey4),
                      child: Text(
                        StringsManager.cancel,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: ColorsManager.black),
                      )),
                ).show();
              },
            )
          ],
        ),
      ),
    );
  }
}
