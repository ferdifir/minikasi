import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:minikasi/model/jurnal_umum.dart';
import 'package:minikasi/screen/dashboard_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/firebase_db.dart';
import '../../utils/constant.dart';
import 'add_journal_screen.dart';

class JournalScreen extends StatefulWidget {
  static const routeName = '/journal';
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<String> uid;
  final db = FirebaseDbServices();
  final dateController = TextEditingController();
  final descriptionController = TextEditingController();
  final debitController = TextEditingController(text: '0');
  final creditController = TextEditingController(text: '0');
  Map<int, TableColumnWidth> columnWidth = const <int, TableColumnWidth>{
    0: FixedColumnWidth(120),
    1: FlexColumnWidth(),
    2: IntrinsicColumnWidth(),
    3: IntrinsicColumnWidth(),
  };
  String? docId;

  @override
  void initState() {
    super.initState();
    uid = _prefs.then((SharedPreferences prefs) {
      return prefs.getString(uidPrefKey) ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, DashboardScreen.routeName);
        return false;
      },
      child: FutureBuilder(
        future: uid,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            docId = snapshot.data;
            return StreamBuilder(
              stream: db.getJurnalUmum(snapshot.data!),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Scaffold(
                    body: Center(
                      child: Text('Loading...'),
                    ),
                  );
                } else {
                  return Scaffold(
                    appBar: AppBar(
                      title: const Text('Jurnal Umum'),
                      centerTitle: true,
                    ),
                    body: Column(
                      children: [
                        Table(
                          columnWidths: columnWidth,
                          border: TableBorder.symmetric(
                            outside: const BorderSide(
                              color: Colors.black,
                              width: 1,
                              style: BorderStyle.solid,
                            ),
                          ),
                          children: [
                            TableRow(
                              decoration: BoxDecoration(
                                color: Colors.blue[300],
                              ),
                              children: [
                                Container(
                                  height: 30,
                                  alignment: Alignment.centerLeft,
                                  margin: const EdgeInsets.all(8),
                                  child: const Text(
                                    'Tanggal',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 30,
                                  alignment: Alignment.centerLeft,
                                  margin: const EdgeInsets.all(8),
                                  child: const Text(
                                    'Keterangan',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                Container(),
                                Container(),
                              ],
                            )
                          ],
                        ),
                        buildListTableRow(snapshot, width),
                      ],
                    ),
                    floatingActionButton: FloatingActionButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, AddJournalScreen.routeName);
                      },
                      child: const Icon(Icons.add),
                    ),
                  );
                }
              },
            );
          }
        },
      ),
    );
  }

  Expanded buildListTableRow(
    AsyncSnapshot<List<JurnalUmum>> snapshot,
    double width,
  ) {
    return Expanded(
      child: ListView.builder(
        itemCount: snapshot.data!.length,
        itemBuilder: (context, index) {
          return Table(
            columnWidths: columnWidth,
            border: TableBorder.symmetric(
              outside: const BorderSide(
                color: Colors.black,
                width: 1,
                style: BorderStyle.solid,
              ),
            ),
            children: [
              TableRow(
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    margin: const EdgeInsets.all(8),
                    child: Text(
                      snapshot.data![index].date,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    margin: const EdgeInsets.all(8),
                    child: Text(
                      snapshot.data![index].description,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.all(8),
                    child: InkWell(
                      onTap: () {
                        showJurnalDialog(
                          context,
                          width,
                          snapshot.data![index],
                        );
                      },
                      child: const Icon(
                        Icons.edit,
                        size: 18,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.all(8),
                    child: InkWell(
                      onTap: () {
                        showDeleteJurnalDialog(context, snapshot, index);
                      },
                      child: const Icon(
                        Icons.delete,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              )
            ],
          );
        },
      ),
    );
  }

  Future<dynamic> showDeleteJurnalDialog(
    BuildContext context,
    AsyncSnapshot<List<JurnalUmum>> snapshot,
    int index,
  ) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hapus Data'),
          content: Text(
              'Apakah anda yakin ingin menghapus data tentang ${snapshot.data![index].description}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Tidak'),
            ),
            TextButton(
              onPressed: () {
                db
                    .deleteJurnalUmum(
                  snapshot.data![index].accountCode,
                )
                    .then((value) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Data berhasil dihapus'),
                    ),
                  );
                });
              },
              child: const Text('Ya'),
            ),
          ],
        );
      },
    );
  }

  Future<dynamic> showJurnalDialog(
    BuildContext context,
    double width,
    JurnalUmum? jurnalUmum,
  ) {
    int? selectedCodeAccount;
    String? selectedNameAccount;
    String? selectedTypeAccount;
    if (jurnalUmum != null) {
      dateController.text = jurnalUmum.date;
      descriptionController.text = jurnalUmum.description;
      debitController.text = jurnalUmum.debit.toString();
      creditController.text = jurnalUmum.kredit.toString();
      selectedCodeAccount = jurnalUmum.accountCode;
      selectedNameAccount = jurnalUmum.accountName;
      selectedTypeAccount =
          '${jurnalUmum.accountCode} - ${jurnalUmum.accountName}';
    } else {
      dateController.text = '';
      descriptionController.text = '';
      debitController.text = '0';
      creditController.text = '0';
      selectedTypeAccount = 'Pilih Akun';
    }
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tambah Jurnal'),
          content: SizedBox(
            width: width * 0.8,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: dateController,
                    readOnly: true,
                    onTap: () {
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      ).then((value) {
                        dateController.text = value.toString().substring(0, 10);
                        dateController.text =
                            dateController.text.replaceAll('-', '/');
                        dateController.text =
                            '${dateController.text.substring(8, 10)}/${dateController.text.substring(5, 7)}/${dateController.text.substring(0, 4)}';
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Tanggal',
                    ),
                  ),
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Keterangan',
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Pilih Akun Debit',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  StreamBuilder(
                    stream: db.getAccountCode(docId!),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Text('Loading...');
                      } else {
                        return DropdownButtonFormField(
                          value: jurnalUmum != null
                              ? jurnalUmum.accountCode
                              : selectedCodeAccount,
                          hint: Text(selectedTypeAccount!),
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
                              selectedCodeAccount = value;
                              selectedNameAccount = snapshot.data!
                                  .where((element) => element.code == value)
                                  .first
                                  .name;
                            });
                          },
                        );
                      }
                    },
                  ),
                  TextField(
                    controller: debitController,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        creditController.text = '0';
                      }
                    },
                    decoration: const InputDecoration(
                      labelText: 'Debit',
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Pilih Akun Kredit',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  StreamBuilder(
                    stream: db.getAccountCode(docId!),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Text('Loading...');
                      } else {
                        return DropdownButtonFormField(
                          value: jurnalUmum != null
                              ? jurnalUmum.accountCode
                              : selectedCodeAccount,
                          hint: Text(selectedTypeAccount!),
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
                              selectedCodeAccount = value;
                              selectedNameAccount = snapshot.data!
                                  .where((element) => element.code == value)
                                  .first
                                  .name;
                            });
                          },
                        );
                      }
                    },
                  ),
                  TextField(
                    controller: creditController,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        debitController.text = '0';
                      }
                    },
                    decoration: const InputDecoration(
                      labelText: 'Kredit',
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            MediaQuery.of(context).viewInsets.bottom == 0
                ? TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Batal'),
                  )
                : Container(),
            MediaQuery.of(context).viewInsets.bottom == 0
                ? TextButton(
                    onPressed: () {
                      if (dateController.text.isNotEmpty &&
                              descriptionController.text.isNotEmpty &&
                              selectedCodeAccount != null &&
                              debitController.text.isNotEmpty ||
                          creditController.text.isNotEmpty) {
                        if (jurnalUmum == null) {
                          db
                              .addJurnalUmum(
                            dateController.text,
                            selectedCodeAccount!,
                            selectedNameAccount!,
                            int.parse(creditController.text),
                            int.parse(debitController.text),
                            descriptionController.text,
                          )
                              .then((value) {
                            Navigator.pop(context);
                            dateController.clear();
                            descriptionController.clear();
                            debitController.clear();
                            creditController.clear();
                          });
                        } else {
                          db
                              .updateJurnalUmum(
                            dateController.text,
                            selectedCodeAccount!,
                            selectedNameAccount!,
                            int.parse(creditController.text),
                            int.parse(debitController.text),
                            descriptionController.text,
                          )
                              .then((value) {
                            Navigator.pop(context);
                            dateController.clear();
                            descriptionController.clear();
                            debitController.clear();
                            creditController.clear();
                          });
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Data tidak boleh kosong'),
                          ),
                        );
                      }
                    },
                    child: const Text('Simpan'),
                  )
                : Container(),
          ],
        );
      },
    );
  }
}
