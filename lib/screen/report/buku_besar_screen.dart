import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:minikasi/model/account_code.dart';
import 'package:minikasi/screen/report/report_screen.dart';
import 'package:minikasi/services/firebase_db.dart';
import 'package:minikasi/utils/helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/constant.dart';

class BukuBesarScreen extends StatefulWidget {
  static const routeName = '/buku_besar';
  const BukuBesarScreen({super.key});

  @override
  State<BukuBesarScreen> createState() => _BukuBesarScreenState();
}

class _BukuBesarScreenState extends State<BukuBesarScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<String> uid;
  final db = FirebaseDbServices();
  late Future<int> selectedCode;
  late Future<AccountCode> selectedCodeName;
  int? dropdownValue;
  String? codeName;

  @override
  void initState() {
    super.initState();
    uid = _prefs.then((SharedPreferences prefs) {
      return prefs.getString(uidPrefKey) ?? '';
    });
    selectedCodeName = db.getFirstAccountCode().then((value) {
      return value;
    });
    selectedCode = db.getFirstAccountCode().then((value) {
      codeName = value.name;
      return value.code;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, ReportScreen.routeName);
        return false;
      },
      child: FutureBuilder(
        future: uid,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? Scaffold(
                  appBar: AppBar(
                    title: const Text('Buku Besar'),
                    centerTitle: true,
                    actions: [
                      postingButton(snapshot, width),
                    ],
                  ),
                  body: buildTableBukuBesar(snapshot.data.toString()),
                )
              : const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
        },
      ),
    );
  }

  Column buildTableBukuBesar(
    String uid,
  ) {
    return Column(
      children: [
        FutureBuilder(
          future: selectedCodeName,
          builder: (context, snapshot) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Akun: ',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 20),
                  ),
                  Expanded(
                    child: Wrap(
                      children: [
                        Text(
                          snapshot.hasData
                              ? '${snapshot.data!.code} - ${snapshot.data!.name}'
                              : 'Loading...',
                          style: const TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        Table(
          columnWidths: columnWidths(),
          children: [
            TableRow(
              children: [
                Helper.headerTable('Tanggal'),
                Helper.headerTable('Keterangan'),
                Helper.headerTable('Debit'),
                Helper.headerTable('Kredit'),
              ],
            )
          ],
        ),
        Expanded(
          child: FutureBuilder(
              future: selectedCode,
              builder: (context, snapshotFuture) {
                if (!snapshotFuture.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return StreamBuilder(
                    stream: db.getJurnalUmumByAccountCode(
                        uid, snapshotFuture.data!),
                    builder: (context, snapshotStream) {
                      if (!snapshotStream.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return ListView.builder(
                          itemCount: snapshotStream.data!.length,
                          itemBuilder: (context, index) {
                            return Table(
                              columnWidths: columnWidths(),
                              children: [
                                TableRow(
                                  children: [
                                    Helper.dataTable(
                                      snapshotStream.data![index].date,
                                    ),
                                    Helper.dataTable(
                                      snapshotStream.data![index].description,
                                    ),
                                    Helper.dataTable(
                                      snapshotStream.data![index].debit
                                          .toString(),
                                    ),
                                    Helper.dataTable(
                                      snapshotStream.data![index].kredit
                                          .toString(),
                                    ),
                                  ],
                                )
                              ],
                            );
                          },
                        );
                      }
                    },
                  );
                }
              }),
        )
      ],
    );
  }

  StreamBuilder<List<AccountCode>> postingButton(
    AsyncSnapshot<String> snapshot,
    double width,
  ) {
    return StreamBuilder(
      stream: db.getAccountCode(snapshot.data.toString()),
      builder: (context, snapshot) {
        dropdownValue = snapshot.data!.first.code;
        codeName = snapshot.data!.map((e) => e.name).first;
        print(dropdownValue);
        return IconButton(
          icon: const Icon(Icons.account_balance),
          onPressed: () {
            if (snapshot.hasData) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Pilih Akun yang akan diposting'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownButtonFormField(
                        value: dropdownValue,
                        hint: Text('$dropdownValue - $codeName'),
                        items: snapshot.data!.map<DropdownMenuItem<int>>(
                          (e) {
                            return DropdownMenuItem(
                              value: e.code,
                              child: SizedBox(
                                width: width * 0.5,
                                child: Text(
                                  '${e.code} - ${e.name}',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            );
                          },
                        ).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedCodeName = Future.value(snapshot.data!
                                .where((element) => element.code == value)
                                .first);
                            selectedCode = Future.value(value);
                            dropdownValue = value;
                          });
                          Navigator.pop(context);
                        },
                      )
                    ],
                  ),
                ),
              );
            } else {
              null;
            }
          },
        );
      },
    );
  }

  Map<int, TableColumnWidth> columnWidths() {
    return const <int, TableColumnWidth>{
      0: FixedColumnWidth(90),
      1: FlexColumnWidth(),
      2: FixedColumnWidth(60),
      3: FixedColumnWidth(60),
    };
  }
}
