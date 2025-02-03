import 'package:flutter/material.dart';

navigatReplace(context, targetPage) {
  Navigator.of(context).pushReplacement(MaterialPageRoute(
    builder: (context) => targetPage,
  ));
}

navigate(context, targetPage) {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => targetPage,
  ));
}

navigatePushNamed(context, routes){
  Navigator.pushReplacementNamed(
    context,
    routes
  );
}
