import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:untitled4/tasko/project_model.dart';
import 'package:untitled4/team/task_model.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Color> colorList = [
    const Color.fromRGBO(24, 134, 9, 1),
    const Color.fromRGBO(225, 10, 10, 1),
  ];

  final gradientList = <List<Color>>[
    [
      const Color.fromRGBO(24, 134, 9, 1),
      const Color.fromRGBO(144, 232, 133, 1),
    ],
    [
      const Color.fromRGBO(225, 10, 10, 1),
      const Color.fromRGBO(220, 112, 112, 1),
    ],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromRGBO(215, 224, 219, 1),
        title: const Text(
          "Rate",
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 40,
            ),
            onPressed: () {
              Navigator.of(context).pushNamed("home_Page");
            }),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: ProjectTasks.getAllTasks(FirebaseAuth.instance.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<ProjectTasks> tasks = snapshot.data as List<ProjectTasks>;
            Map<String, double> dataMap = {
              "completed": tasks.where((element) => element.isCompleted).length.toDouble() / tasks.length.toDouble() * 100,
              "Not completed": tasks.where((element) => !element.isCompleted).length.toDouble() / tasks.length.toDouble() * 100,
            };
            return Center(
              child: PieChart(
                dataMap: dataMap,
                colorList: colorList,
                chartRadius: MediaQuery.of(context).size.width / 2,
                centerText: "Rate",
                chartType: ChartType.ring,
                ringStrokeWidth: 30,
                animationDuration: const Duration(seconds: 3),
                chartValuesOptions: const ChartValuesOptions(showChartValues: true, showChartValuesOutside: true, showChartValuesInPercentage: true, showChartValueBackground: false),
                legendOptions: const LegendOptions(showLegends: true, legendShape: BoxShape.rectangle, legendTextStyle: TextStyle(fontSize: 15), legendPosition: LegendPosition.bottom, showLegendsInRow: true),
                gradientList: gradientList,
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
