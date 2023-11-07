import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:sqflite_learn/basic/sqflite_service.dart';

class BasicDatabaseScreen extends StatefulWidget {
  const BasicDatabaseScreen({super.key});

  @override
  State<BasicDatabaseScreen> createState() => _BasicDatabaseScreenState();
}

class _BasicDatabaseScreenState extends State<BasicDatabaseScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () async {
              await BasicSqFLiteService.sqFLiteService.insertData({
                BasicSqFLiteService.columnName: 'Hello World',
              });
            },
            child: const Text("Create"),
          ),
          ElevatedButton(
            onPressed: () async {
              var data = await BasicSqFLiteService.sqFLiteService.getData();
              log('$data');
            },
            child: const Text("Read"),
          ),
          ElevatedButton(
            onPressed: () async {
              await BasicSqFLiteService.sqFLiteService.updateData({
                BasicSqFLiteService.columnId: 1,
                BasicSqFLiteService.columnName: "hello",
              });
            },
            child: const Text("Update"),
          ),
          ElevatedButton(
            onPressed: () async {
              await BasicSqFLiteService.sqFLiteService.deleteData(5);
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      // backgroundColor: Colors.deepPurple,
      centerTitle: true,
      title: const Text("Basic Database"),
    );
  }
}
