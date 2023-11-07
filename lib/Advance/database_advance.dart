import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqflite_learn/Advance/sqflite_service.dart';

class DatabaseAdvanceScreen extends StatefulWidget {
  const DatabaseAdvanceScreen({super.key});

  @override
  State<DatabaseAdvanceScreen> createState() => _DatabaseAdvanceScreenState();
}

class _DatabaseAdvanceScreenState extends State<DatabaseAdvanceScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  List readAllData = [];

  Future<void> addData(String title, String description) async {
    await SqFLiteServiceAdvance.createData(title, description);
    await fetchData();
    setState(() {});
  }

  Future<void> updateData(int id, String title, String description) async {
    await SqFLiteServiceAdvance.updateData(id, title, description);
    await fetchData();
    setState(() {});
  }

  Future<void> deleteData(int id) async {
    await SqFLiteServiceAdvance.deleteData(id);
    await fetchData();
    setState(() {});
  }

  fetchData() async {
    var data = await SqFLiteServiceAdvance.readData();
    setState(() {
      readAllData = data;
    });
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      floatingActionButton: floatingActionButton(context),
      body: readAllData.isEmpty ? emptyDataImage() : buildBody(),
    );
  }

  ListView buildBody() {
    return ListView.builder(
      itemCount: readAllData.length,
      itemBuilder: (context, index) {
        return readAllData.isEmpty
            ? const Center(child: Text("Empty Data"))
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Card(
                  color: Colors.blue[300],
                  child: ListTile(
                    title: Text(readAllData[index]['title']),
                    subtitle: Text(readAllData[index]['description']),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkResponse(
                            onTap: () {
                              fillForm(
                                context,
                                readAllData[index]['id'],
                                currentTitle: readAllData[index]['title'],
                                currentDescription: readAllData[index]['description'],
                              );
                            },
                            child: const Icon(
                              Icons.create,
                              size: 30,
                            ),
                          ),
                          InkResponse(
                            onTap: () async {
                              await deleteCurrentIndex(index, context);
                            },
                            child: const Icon(
                              Icons.delete,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
      },
    );
  }

  Future<dynamic> fillForm(BuildContext context, var currentId,
      {String? currentTitle, String? currentDescription}) {
    titleController.text = currentTitle ?? '';
    descriptionController.text = currentDescription ?? '';

    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 15,
            top: 15,
            right: 15,
            bottom: MediaQuery.of(context).viewInsets.bottom + 120,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(hintText: 'Title'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  hintText: 'Description',
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  FocusScope.of(context).unfocus();
                  try {
                    String title = titleController.text;
                    String description = descriptionController.text;

                    if (title.isNotEmpty && description.isNotEmpty) {
                      if (currentId == null) {
                        await addData(title, description);
                      } else if (currentId != null) {
                        await updateData(currentId, title, description);
                      }
                    } else {
                      showSnackBar(context, "Empty title or description");
                    }

                    titleController.clear();
                    descriptionController.clear();

                    Get.back();
                  } catch (e) {
                    log(e.toString());
                  }
                },
                child: Text(
                  currentId == null ? "Create data" : "Update data",
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> deleteCurrentIndex(int index, BuildContext context) async {
    try {
      await deleteData(readAllData[index]["id"]);

      showSnackBar(context, "Delete Data successfully");
    } catch (e) {
      log(e.toString());
    }
  }

  FloatingActionButton floatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        fillForm(context, null);
      },
      child: const Icon(Icons.add),
    );
  }

  AppBar appBar() {
    return AppBar(
      backgroundColor: Colors.deepPurple[300],
      centerTitle: true,
      title: const Text("Advance Database"),
    );
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(
      BuildContext context, String message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Center emptyDataImage() {
    return Center(
      child: Image.network(
        "https://img.freepik.com/free-vector/no-data-concept-illustration_114360-616.jpg?w=740&t=st=1699336475~exp=1699337075~hmac=58bce25049bed1cfa9a11d0e18c4d9d725b5f6bcece4cdc220b729db7fa66951",
      ),
    );
  }
}
