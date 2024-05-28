import 'package:hive/hive.dart';
import 'package:budget_manager/hive/transaction_box_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'dart:io';

// function to save income log into database
void saveIncomeLog(double amount, DateTime date, String note, String? category, String? imagePath) {
  final box = Hive.box<Income>('income'); // open box
  if (category != null) {
    box.add(Income(amount, date, note, imagePath, category: category)); // create income object and add it to the database (auto increments)
  } else {
    box.add(Income(amount, date, note, imagePath)); // create income object without category and add it to the database (auto increments)
  }
}

// function to save expense log into database
void saveExpenseLog(double amount, DateTime date, String note, String? category, bool recurring, String? imagePath) {
  final box = Hive.box<Expense>('expenses'); // open box
  if (category != null) {
    box.add(Expense(amount, date, note, imagePath, category: category, recurring: recurring)); // create expense object and add it to the database (auto increments)
  } else {
    box.add(Expense(amount, date, note, imagePath, recurring: recurring)); // create expense object without category and add it to the database (auto increments)
  }
}

Future<String?> saveImageLocally(File image) async {
  // Save image to app directory
  final directory = await getApplicationDocumentsDirectory();
  final imagePath = path.join(directory.path, path.basename(image.path)); // create a file path to our apps directory + its name (path provider + path lib)
  final imageFile = File(imagePath); // create file
  await imageFile.writeAsBytes(await image.readAsBytes()); // write the selected image into the file we just created
  return imagePath; // return the path to store into hive
}