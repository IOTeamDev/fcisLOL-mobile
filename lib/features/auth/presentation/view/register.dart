import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:googleapis/cloudsearch/v1.dart';
import 'package:lol/core/network/remote/fcm_helper.dart' show FCMHelper;
import 'package:lol/core/utils/components.dart';
import 'package:lol/core/utils/resources/icons_manager.dart';
import 'package:lol/core/utils/resources/values_manager.dart';
import 'package:lol/features/auth/data/models/registration_user_model.dart';
import 'package:lol/features/auth/presentation/view/widgets/custom_drop_down_button.dart';
import 'package:lol/features/auth/presentation/view_model/auth_cubit/auth_cubit.dart';
import 'package:lol/features/auth/presentation/view_model/login_cubit/login_cubit.dart';
import 'package:lol/features/auth/presentation/view_model/login_cubit/login_cubit_states.dart';
import 'package:lol/features/auth/presentation/view/login.dart';
import 'package:lol/core/utils/resources/constants_manager.dart';
import 'package:lol/features/home/presentation/view/home.dart';
import 'package:lol/core/utils/navigation.dart';
import 'package:lol/core/network/local/shared_preference.dart';
import 'package:lol/features/pick_image/presentation/view/select_image.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../core/utils/resources/colors_manager.dart';
import '../../../../core/utils/resources/strings_manager.dart';
import '../../../../core/utils/resources/theme_provider.dart';

class Registerscreen extends StatefulWidget {
  const Registerscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseResponsive(
        mobileLayout: RegisterMobile(),
        tabletLayout: RegisterTablet(),
        desktopLayout: RegisterDesktop());
  }
}
