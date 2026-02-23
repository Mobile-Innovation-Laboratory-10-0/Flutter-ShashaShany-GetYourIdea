import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:tugas_besar_motion/data/db_helper.dart';
import 'package:tugas_besar_motion/core/app_colors.dart';
import 'package:flutter/material.dart';

class IdeaController extends GetxController {
  var isLoading = true.obs;
  var publicIdeas = [].obs;
  var savedIdeas = [].obs;
  final dbHelper = DBHelper();

  @override
  void onInit() {
    fetchPublicIdeas();
    loadSavedIdeas();
    super.onInit();
  }

  // Fetch API Eksternal
  void fetchPublicIdeas() async {
    try {
      isLoading(true);
      var response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/posts'),
      );
      if (response.statusCode == 200) {
        publicIdeas.value = json.decode(response.body);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal mengambil data API',
        backgroundColor: AppColors.secondary,
      );
    } finally {
      isLoading(false);
    }
  }

  // Load dari SQLite
  void loadSavedIdeas() async {
    var data = await dbHelper.getSavedIdeas();
    savedIdeas.value = data;
  }

  // CREATE ke SQLite
  void saveIdea(int id, String title, String body) async {
    await dbHelper.insertIdea({'id': id, 'title': title, 'body': body});
    loadSavedIdeas();
    Get.snackbar(
      'Berhasil',
      'Ide disimpan!',
      backgroundColor: AppColors.primary,
      colorText: AppColors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(10),
    );
  }

  // UPDATE ke SQLite
  void updateIdeaContent(int id, String newBody) async {
    await dbHelper.updateIdea(id, newBody);
    loadSavedIdeas();
  }

  // DELETE dari SQLite
  void removeIdea(int id) async {
    await dbHelper.deleteIdea(id);
    loadSavedIdeas();
  }
}
