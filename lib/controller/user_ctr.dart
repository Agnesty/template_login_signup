import '../database/db_helper.dart';
import '../models/user_model.dart';
import 'package:get/get.dart';

class UserController extends GetxController{

  @override
  void onReady() {
    // getUser();
    super.onReady();
  }

  var taskList = <UserModel>[].obs;

  Future<int> addUser({UserModel? userModel}) async {
    return await DatabaseHelper.insertUser(userModel);
  }

  // Future<UserModel?> loginUser ({UserModel? userModel}) async {
  //   return await DatabaseHelper.getLoginUser(userModel!.email!, userModel.password!);
  // }

  // void getUser() async {
  //   List<Map<String, dynamic>> tasks = await DatabaseHelper.query();
  //   taskList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());
  // }

  // void delete(UserModel userModel){
  //  DatabaseHelper.delete(userModel);
  //  getUser();
  // }

  // void markTaskCompleted(int id) async {
  //   await DatabaseHelper.update(id);
  //   getUser();
  // }
}