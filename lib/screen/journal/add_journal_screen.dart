import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:minikasi/model/account_code.dart';
import 'package:minikasi/screen/journal/journal_screen.dart';
import 'package:minikasi/services/firebase_db.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/constant.dart';

class AddJournalScreen extends StatefulWidget {
  static const String routeName = 'add-jurnal-umum';
  const AddJournalScreen({super.key});

  @override
  State<AddJournalScreen> createState() => _AddJournalScreenState();
}

class _AddJournalScreenState extends State<AddJournalScreen> {
  final tanggalControler = TextEditingController();
  final keteranganControler = TextEditingController();
  final db = FirebaseDbServices();
  late List<TextEditingController> akunControllers;
  late Future<String> uid;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  List<Map<String, dynamic>> detailTransaksi = [
    {'kodeAkun': '', 'namaAkun': '', 'debit': 0, 'kredit': 0},
    {'kodeAkun': '', 'namaAkun': '', 'debit': 0, 'kredit': 0},
  ];

  @override
  void initState() {
    super.initState();
    uid = _prefs.then((SharedPreferences prefs) {
      return prefs.getString(uidPrefKey) ?? '';
    });
    akunControllers = List.generate(
      detailTransaksi.length,
      (_) => TextEditingController(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacementNamed(JournalScreen.routeName);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tambah Jurnal Umum'),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  detailTransaksi[0]['kodeAkun'] = '111';
                });
              },
              icon: Icon(Icons.save),
            ),
          ],
        ),
        body: Container(
          margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                TextField(
                  controller: tanggalControler,
                  readOnly: true,
                  onTap: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2015, 8),
                      lastDate: DateTime(2101),
                    ).then((value) {
                      tanggalControler.text = value.toString();
                      tanggalControler.text = value.toString().substring(0, 10);
                      tanggalControler.text =
                          '${value.toString().substring(8, 10)}/${value.toString().substring(5, 7)}/${value.toString().substring(0, 4)}';
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Tanggal',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 1,
                      ),
                    ),
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: keteranganControler,
                  decoration: const InputDecoration(
                    labelText: 'Keterangan',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 1,
                      ),
                    ),
                    prefixIcon: Icon(Icons.description),
                  ),
                ),
                const Divider(),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: detailTransaksi.length,
                  itemBuilder: (context, index) {
                    return Dismissible(
                      key: UniqueKey(),
                      direction: DismissDirection.endToStart,
                      confirmDismiss: (direction) async {
                        if (detailTransaksi.length == 2) {
                          return false; // prevent dismissal and show a message
                        } else {
                          return true; // allow dismissal
                        }
                      },
                      onDismissed: (direction) {
                        setState(() {
                          detailTransaksi.removeAt(index);
                        });
                      },
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 10),
                        color: Colors.red,
                        child: const Icon(Icons.delete),
                      ),
                      child: Column(
                        children: [
                          buildDropDownAkun(index),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  key: UniqueKey(),
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    setState(() {
                                      try {
                                        detailTransaksi[index]['debit'] =
                                            int.parse(value);
                                      } catch (e) {
                                        print('Invalid input: $value');
                                      }
                                    });
                                  },
                                  decoration: const InputDecoration(
                                    labelText: 'Debit',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10.0),
                                      ),
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                        width: 1,
                                      ),
                                    ),
                                    prefixIcon: Icon(Icons.money),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextField(
                                  key: UniqueKey(),
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: 'Kredit',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10.0),
                                      ),
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                        width: 1,
                                      ),
                                    ),
                                    prefixIcon: Icon(Icons.money),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Divider(),
                        ],
                      ),
                    );
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      detailTransaksi.add({
                        'kodeAkun': '',
                        'namaAkun': '',
                        'debit': 0,
                        'kredit': 0
                      });
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 102,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Tambah detail transaksi'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 150,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    print(
                      {
                        'tanggal': tanggalControler.text,
                        'keterangan': keteranganControler.text,
                        'detailTransaksi': detailTransaksi,
                      },
                    );
                  },
                  child: const Text('Simpan'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildDropDownAkun(
    int indexAkun,
  ) {
    return FutureBuilder(
      future: uid,
      builder: (context, futureSnapshot) {
        return futureSnapshot.hasData
            ? StreamBuilder(
                stream: db.getAccountCode(futureSnapshot.data!),
                builder: (context, streamSnapshot) {
                  return TextField(
                    key: UniqueKey(),
                    readOnly: true,
                    controller: akunControllers[indexAkun],
                    onChanged: (value) {
                      setState(() {
                        detailTransaksi[indexAkun]['kodeAkun'] =
                            akunControllers[indexAkun].text;
                      });
                    },
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                            ),
                            height: 300,
                            child: listAccountCode(streamSnapshot, indexAkun),
                          );
                        },
                      );
                    },
                    decoration: const InputDecoration(
                      suffixIcon: Icon(Icons.arrow_drop_down),
                      labelText: 'Kode Akun',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 1,
                        ),
                      ),
                      prefixIcon: Icon(Icons.account_balance_wallet),
                    ),
                  );
                },
              )
            : const TextField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Loading...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                    borderSide: BorderSide(
                      color: Colors.black,
                      width: 1,
                    ),
                  ),
                  prefixIcon: Icon(Icons.account_balance_wallet),
                ),
              );
      },
    );
  }

  ListView listAccountCode(
    AsyncSnapshot<List<AccountCode>> streamSnapshot,
    int indexAkun,
  ) {
    return ListView.builder(
      itemCount: streamSnapshot.data!.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            streamSnapshot.data![index].code.toString(),
          ),
          subtitle: Text(
            streamSnapshot.data![index].name,
          ),
          onTap: () {
            akunControllers[indexAkun].text =
                '${streamSnapshot.data![index].code} - ${streamSnapshot.data![index].name}';
            Navigator.of(context).pop();
          },
        );
      },
    );
  }
}
