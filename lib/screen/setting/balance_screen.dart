import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:minikasi/model/initial_balance.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/firebase_db.dart';
import '../../utils/constant.dart';

class BalanceScreen extends StatefulWidget {
  static const routeName = '/balance';
  const BalanceScreen({super.key});

  @override
  State<BalanceScreen> createState() => _BalanceScreenState();
}

class _BalanceScreenState extends State<BalanceScreen> {
  final db = FirebaseDbServices();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<String> uid;
  @override
  void initState() {
    super.initState();
    uid = _prefs.then((SharedPreferences prefs) {
      return prefs.getString(uidPrefKey) ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saldo Awal'),
      ),
      body: FutureBuilder(
          future: uid,
          builder: (context, snapshot) {
            return StreamBuilder(
                stream: db.getInitialBalance(snapshot.data.toString()),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        Table(
                          columnWidths: columnWidths(),
                          children: [
                            TableRow(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  child: headerTable('Kode'),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  child: headerTable('Nama Akun'),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  child: headerTable('Debet'),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  child: headerTable('Kredit'),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  child: headerTable(''),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Expanded(
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return Table(
                                columnWidths: columnWidths(),
                                children: [
                                  TableRow(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        child: Text(snapshot.data![index].code
                                            .toString()),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        child: Text(snapshot.data![index].name),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        child: Text(snapshot.data![index].debit
                                            .toString()),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        child: Text(snapshot.data![index].kredit
                                            .toString()),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          showEditSaldoDialog(
                                            context,
                                            snapshot,
                                            index,
                                          );
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          child:
                                              const Icon(Icons.edit, size: 14),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        Table(
                          columnWidths: columnWidths(),
                          children: [
                            TableRow(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  child: headerTable(''),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  child: headerTable('Total'),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  child: headerTable(totalDebet(
                                    snapshot.data!,
                                  ).toString()),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  child: headerTable(totalKredit(
                                    snapshot.data!,
                                  ).toString()),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  child: headerTable(''),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    );
                  } else {
                    return const Center(child: Text('Loading...'));
                  }
                });
          }),
    );
  }

  totalDebet(List<InitialBalance> data) {
    int total = 0;
    for (var i = 0; i < data.length; i++) {
      total += data[i].debit;
    }
    return total;
  }

  totalKredit(List<InitialBalance> data) {
    int total = 0;
    for (var i = 0; i < data.length; i++) {
      total += data[i].kredit;
    }
    return total;
  }

  Future<dynamic> showEditSaldoDialog(
    BuildContext context,
    AsyncSnapshot<List<InitialBalance>> snapshot,
    int index,
  ) {
    final debitController = TextEditingController(
      text: snapshot.data![index].debit.toString(),
    );
    final kreditController = TextEditingController(
      text: snapshot.data![index].kredit.toString(),
    );
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              '[${snapshot.data![index].code}] ${snapshot.data![index].name}',
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: debitController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Debet',
                  ),
                ),
                TextField(
                  controller: kreditController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Kredit',
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  db.updateInitialBalance(
                    snapshot.data![index].code,
                    int.parse(kreditController.text),
                    int.parse(debitController.text),
                  ).then((value) => Navigator.of(context).pop());
                },
                child: const Text('Save'),
              ),
            ],
          );
        });
  }

  Text headerTable(String text) {
    return Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.bold),
    );
  }

  Map<int, TableColumnWidth> columnWidths() {
    return const <int, TableColumnWidth>{
      0: FixedColumnWidth(59),
      1: FlexColumnWidth(),
      2: FixedColumnWidth(60),
      3: FixedColumnWidth(60),
      4: FixedColumnWidth(30),
    };
  }
}
