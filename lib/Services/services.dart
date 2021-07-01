import 'dart:convert';

import 'package:dogs_path/Models/dashboard_path_model.dart';
import 'package:dogs_path/Utils/constants.dart';
import 'package:http/http.dart' as http;

Future<List<DashboardPathModel>> getPaths() async {
  List<DashboardPathModel> dashBoardPaths = [];
  final response = await http.get(Uri.parse(BASE_URL));
  print(response.body);

  try {
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      dashBoardPaths = (json.decode(response.body) as List)
          .map((data) => DashboardPathModel.fromJson(data))
          .toList();
      return dashBoardPaths;
    } else {
      return dashBoardPaths;
    }
  } catch (err) {
    print(err);
    return dashBoardPaths;
  }
}
