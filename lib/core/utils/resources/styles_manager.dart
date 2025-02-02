import 'package:flutter/material.dart';
import 'fonts_manager.dart';

TextStyle _getTextStyle(double fontSize, FontWeight fontWeight, Color color) {
  return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      //fontFamily: FontConstants.fontFamily,
      color: color
  );
}

//light style
TextStyle? getLightStyle({double fontSize = FontSize.size14, required Color color})
{
  return _getTextStyle(fontSize, FontWeightManager.light, color);
}

//regular style
TextStyle? getRegularStyle({double fontSize = FontSize.size14, required Color color})
{
  return _getTextStyle(fontSize, FontWeightManager.regular, color);
}

//medium style
TextStyle? getMediumStyle({double fontSize = FontSize.size14, required Color color})
{
  return _getTextStyle(fontSize, FontWeightManager.medium, color);
}

//semi bold style
TextStyle? getSemiBoldStyle({double fontSize = FontSize.size14, required Color color})
{
  return _getTextStyle(fontSize, FontWeightManager.semiBold, color);
}

//bold style
TextStyle? getBoldStyle({double fontSize = FontSize.size14, required Color color})
{
  return _getTextStyle(fontSize, FontWeightManager.bold, color);
}
