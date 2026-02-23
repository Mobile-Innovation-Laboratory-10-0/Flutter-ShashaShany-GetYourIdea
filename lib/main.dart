import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/app_colors.dart';
import 'controllers/idea_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MotionApp());
}

class MotionApp extends StatelessWidget {
  const MotionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'GetYourIdea',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          elevation: 0,
        ),
      ),
      home: HomeScreen(),
    );
  }
}

//  LAYAR 1: HOME (Menampilkan API)
class HomeScreen extends StatelessWidget {
  final IdeaController controller = Get.put(IdeaController());

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Public Ideas',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark),
            onPressed: () => Get.to(() => SavedScreen()),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }
        return ListView.builder(
          itemCount: controller.publicIdeas.length,
          itemBuilder: (context, index) {
            var idea = controller.publicIdeas[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                title: Text(
                  idea['title'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textMain,
                  ),
                ),
                subtitle: Text(
                  idea['body'],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: IconButton(
                  icon: const Icon(
                    Icons.bookmark_add_outlined,
                    color: AppColors.primary,
                  ),
                  onPressed: () {
                    controller.saveIdea(
                      idea['id'],
                      idea['title'],
                      idea['body'],
                    );
                  },
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

// LAYAR 2: SAVED IDEAS (Menampilkan Local DB)
class SavedScreen extends StatelessWidget {
  final IdeaController controller = Get.find();

  SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Saved Ideas')),
      body: Obx(() {
        if (controller.savedIdeas.isEmpty) {
          return const Center(
            child: Text(
              'Belum ada ide yang disimpan.',
              style: TextStyle(color: AppColors.textMain),
            ),
          );
        }
        return ListView.builder(
          itemCount: controller.savedIdeas.length,
          itemBuilder: (context, index) {
            var item = controller.savedIdeas[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                title: Text(
                  item['title'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textMain,
                  ),
                ),
                subtitle: Text(item['body']),

                onTap: () => _showEditDialog(context, item['id'], item['body']),

                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => controller.removeIdea(item['id']),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  void _showEditDialog(BuildContext context, int id, String currentBody) {
    TextEditingController bodyController = TextEditingController(
      text: currentBody,
    );
    Get.defaultDialog(
      title: 'Edit Konten Ide',
      titleStyle: const TextStyle(
        color: AppColors.primary,
        fontWeight: FontWeight.bold,
      ),
      content: TextField(
        controller: bodyController,
        maxLines: 3,
        decoration: InputDecoration(
          hintText: 'Ubah teks di sini...',
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColors.primary),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      textConfirm: 'Update',
      textCancel: 'Batal',
      confirmTextColor: AppColors.white,
      buttonColor: AppColors.primary,
      cancelTextColor: AppColors.primary,
      onConfirm: () {
        controller.updateIdeaContent(id, bodyController.text);
        Get.back();
      },
    );
  }
}
