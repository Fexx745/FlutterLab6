import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

String formatDateToThai(String dateStr) {
  try {
    // ใช้ DateFormat เพื่อแปลงวันที่ตามรูปแบบที่ได้รับจาก API
    final DateFormat apiDateFormat = DateFormat('yyyy-MM-dd');
    final DateTime date = apiDateFormat.parse(dateStr);
    // รูปแบบวันที่ที่ต้องการแสดง
    final DateFormat dayFormat = DateFormat('d');
    final DateFormat monthFormat = DateFormat('MMMM', 'th');
    final DateFormat yearFormat = DateFormat('yyyy');
    final String day = dayFormat.format(date);
    final String month = monthFormat.format(date);
    final String year = yearFormat.format(date);

    return '$day $month $year';
  } catch (e) {
    // หากเกิดข้อผิดพลาดในการแปลงวันที่ ให้แสดงวันที่ดั้งเดิม
    return dateStr;
  }
}

void main() {
  runApp(const MyApp());
}

class CovidData {
  int year = 0;
  int weekNum = 0;
  int newCase = 0;
  int totalCase = 0;
  int newCaseExcludeabroad = 0;
  int totalCaseExcludeabroad = 0;
  int newRecovered = 0;
  int totalRecovered = 0;
  int newDeath = 0;
  int totalDeath = 0;
  int caseForeign = 0;
  int casePrison = 0;
  int caseWalkin = 0;
  int caseNewPrev = 0;
  int caseNewDiff = 0;
  int deathNewPrev = 0;
  int deathNewDiff = 0;
  String updateDate = '';

  void mapData(Map<String, dynamic> dataIn) {
    year = dataIn['year'];
    weekNum = dataIn['weeknum'];
    newCase = dataIn['new_case'];
    totalCase = dataIn['total_case'];
    newCaseExcludeabroad = dataIn['new_case_excludeabroad'];
    totalCaseExcludeabroad = dataIn['total_case_excludeabroad'];
    newRecovered = dataIn['new_recovered'];
    totalRecovered = dataIn['total_recovered'];
    newDeath = dataIn['new_death'];
    totalDeath = dataIn['total_death'];
    caseForeign = dataIn['case_foreign'];
    casePrison = dataIn['case_prison'];
    caseWalkin = dataIn['case_walkin'];
    caseNewPrev = dataIn['case_new_prev'];
    caseNewDiff = dataIn['case_new_diff'];
    deathNewPrev = dataIn['death_new_prev'];
    deathNewDiff = dataIn['death_new_diff'];
    updateDate = dataIn['update_date'];
  }

  Future<CovidData> getData() async {
    String uri = "https://covid19.ddc.moph.go.th/api/Cases/today-cases-all";
    final response = await http.get(Uri.parse(uri));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      if (jsonResponse.isNotEmpty) {
        Map<String, dynamic> data = jsonResponse[0];
        CovidData covidData = CovidData();
        covidData.mapData(data);
        return covidData;
      } else {
        throw Exception('No data available');
      }
    } else {
      throw Exception('Failed to load data');
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: ''),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<CovidData> futureCovidData;

  @override
  void initState() {
    super.initState();
    futureCovidData = CovidData().getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: FutureBuilder<CovidData>(
          future: futureCovidData,
          builder: (BuildContext context, AsyncSnapshot<CovidData> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LinearProgressIndicator();
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              CovidData covidData = snapshot.data!;
              return Container(
                width: 600,
                height: 600,
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        'สถานการณ์ COVID-19',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      const Text(
                        'ในประเทศไทย',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 300,
                            height: 30,
                            decoration: BoxDecoration(
                              color: Colors.yellow,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  spreadRadius: 5,
                                  blurRadius: 10,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Text(
                                '28 กรกฏาคม 2565',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                    ),
                                    color: Colors.lightGreen,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black
                                            .withOpacity(0.3), // สีของเงา
                                        spreadRadius: 5, // ความกว้างของเงา
                                        blurRadius: 10, // ความเบลอของเงา
                                        offset:
                                            const Offset(0, 2), // ตำแหน่งของเงา
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'หายป่วยวันนี้',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        '+${covidData.newRecovered}',
                                        style: const TextStyle(
                                          fontSize: 40,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(20),
                                    ),
                                    color: Colors.lightGreen,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black
                                            .withOpacity(0.3), // สีของเงา
                                        spreadRadius: 5, // ความกว้างของเงา
                                        blurRadius: 10, // ความเบลอของเงา
                                        offset:
                                            const Offset(0, 2), // ตำแหน่งของเงา
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'หายป่วยสะสม',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const Text(
                                        'ตั้งแต่ 1 มกราคม 2565',
                                        style: TextStyle(
                                          fontSize: 8,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        '+${covidData.totalRecovered}',
                                        style: const TextStyle(
                                          fontSize: 35,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.red[500],
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black
                                          .withOpacity(0.3), // สีของเงา
                                      spreadRadius: 5, // ความกว้างของเงา
                                      blurRadius: 10, // ความเบลอของเงา
                                      offset:
                                          const Offset(0, 2), // ตำแหน่งของเงา
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'จำนวนผู้ป่วยใหม่วันนี้',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      '+${covidData.newCase}',
                                      style: const TextStyle(
                                        fontSize: 40,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Column(
                                          children: [
                                            const Text(
                                              'ผู้ป่วยในประเทศ',
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.white,
                                              ),
                                            ),
                                            Text(
                                              '+${covidData.caseWalkin}',
                                              style: const TextStyle(
                                                fontSize: 10,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(width: 10),
                                        const Text(
                                          '|',
                                          style: TextStyle(
                                            fontSize: 30,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Column(
                                          children: [
                                            const Text(
                                              'ผู้ป่วยต่างชาติ',
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.white,
                                              ),
                                            ),
                                            Text(
                                              '+${covidData.caseForeign}',
                                              style: const TextStyle(
                                                fontSize: 10,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(),
                                  color: Colors.red[400],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'ป่วยสะสม',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const Text(
                                      'ตั้งแต่ 1 มกราคม 2565',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      covidData.totalCase.toString(),
                                      style: const TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(20),
                                    ),
                                    color: Colors.blue[300],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'กำลังรักษา',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        '+${covidData.newRecovered}',
                                        style: const TextStyle(
                                          fontSize: 40,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(),
                                    color: Colors.deepPurple[300],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'ผู้ป่วยปอดอักเสบ',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const Text(
                                        'รักษาตัวอยู่ในโรงพยาบาล',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        covidData.caseNewDiff.toString(),
                                        style: const TextStyle(
                                          fontSize: 40,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      bottomRight: Radius.circular(20),
                                    ),
                                    color: Colors.grey[500],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'เสียชีวิตเพิ่ม',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        covidData.newDeath.toString(),
                                        style: const TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Container(
                                        width: 110,
                                        height: 2,
                                        color: Colors.grey[300],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.only(left: 10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'เสียชีวิตสะสม',
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Text(
                                                  'ตั้งแต่วันที่ 1 มกราคม 2565',
                                                  style: TextStyle(
                                                    fontSize: 5,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 10.0),
                                            child: Column(
                                              children: [
                                                Text(
                                                  covidData.totalDeath
                                                      .toString(),
                                                  style: const TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w900,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'สรุปสถานการณ์ ศูนย์ข้อมูล COVID-19',
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.facebook_rounded,
                                          size: 15,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          'ศูนย์ข้อมูล COVID-19',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        Icon(
                                          Icons.phone_callback_sharp,
                                          size: 15,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          'สายด่วน 1111',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(''),
                                    Text(
                                      'EOC กระทรวงสาธารณสุข',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return const Center(child: Text('No data available'));
            }
          },
        ),
      ),
    );
  }
}
