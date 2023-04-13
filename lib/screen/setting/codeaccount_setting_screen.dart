import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:minikasi/model/account_code.dart';
import 'package:minikasi/services/firebase_db.dart';
import 'package:minikasi/utils/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widget/text_input.dart';

class CodeAccountSettingScreen extends StatefulWidget {
  static const routeName = '/codeaccount-setting-screen';
  const CodeAccountSettingScreen({super.key});

  @override
  State<CodeAccountSettingScreen> createState() =>
      _CodeAccountSettingScreenState();
}

class _CodeAccountSettingScreenState extends State<CodeAccountSettingScreen> {
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
        title: const Text('Pengaturan Kode Akun'),
        elevation: 0,
      ),
      body: Column(
        children: [
          ListTile(
            style: ListTileStyle.drawer,
            tileColor: Colors.blue[100],
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 50,
                  child: Text(
                    'Kode',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
              ],
            ),
            title: Text(
              'Nama Akun',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: uid,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return showListBalance(snapshot);
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddAccountCodeDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  StreamBuilder<List<AccountCode>> showListBalance(
      AsyncSnapshot<String> snapshot) {
    return StreamBuilder(
      stream: db.getAccountCode(snapshot.data.toString()),
      builder: (context, snapshot) {
        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: snapshot.data?.length,
          itemBuilder: (context, index) {
            if (snapshot.hasData) {
              List<AccountCode> accountCode =
                  snapshot.data as List<AccountCode>;
              accountCode.sort((a, b) => a.code.compareTo(b.code));
              return ListTile(
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 50,
                      child: Text(
                        accountCode[index].code.toString(),
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        accountCode[index].name,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      splashRadius: 20,
                      iconSize: 20,
                      onPressed: () {
                        showEditAccountCodeDialog(
                          context,
                          snapshot,
                          index,
                        );
                      },
                      icon: const Icon(Icons.edit),
                    ),
                    IconButton(
                      splashRadius: 20,
                      iconSize: 20,
                      onPressed: () {
                        showDeleteAccountDialog(
                          context,
                          snapshot,
                          index,
                        );
                      },
                      icon: const Icon(Icons.delete),
                    ),
                  ],
                ),
              );
            } else {
              return const ListTile(
                leading: Icon(Icons.alarm),
                title: Text('Loading...'),
              );
            }
          },
        );
      },
    );
  }

  Future<dynamic> showDeleteAccountDialog(BuildContext context,
      AsyncSnapshot<List<AccountCode>> snapshot, int index) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hapus Kode Akun'),
          content:
              const Text('Apakah anda yakin ingin menghapus kode akun ini?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                db
                    .deleteAccountCode(snapshot.data![index].code)
                    .then((value) => Navigator.of(context).pop());
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  Future<dynamic> showEditAccountCodeDialog(
    BuildContext context,
    AsyncSnapshot<List<AccountCode>> snapshot,
    int index,
  ) {
    final nameController = TextEditingController();
    final codeController = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Ubah Kode Akun',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                TextInput(
                  txtController: nameController
                    ..text = snapshot.data![index].name,
                  label: 'Nama Akun',
                  icon: Icons.account_balance,
                ),
                const SizedBox(height: 16),
                TextInput(
                  txtController: codeController
                    ..text = snapshot.data![index].code.toString(),
                  label: 'Kode Akun',
                  icon: Icons.account_balance,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Batal'),
                    ),
                    TextButton(
                      onPressed: () {
                        db
                            .updateAccountCode(
                              nameController.text,
                              int.parse(codeController.text),
                            )
                            .then((value) => Navigator.of(context).pop());
                      },
                      child: const Text('Simpan'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showAddAccountCodeDialog(BuildContext context) {
    final nameController = TextEditingController();
    final codeController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Tambah Kode Akun',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                TextInput(
                  txtController: nameController,
                  label: 'Nama Akun',
                  icon: Icons.account_balance,
                ),
                const SizedBox(height: 16),
                TextInput(
                  txtController: codeController,
                  label: 'Kode Akun',
                  icon: Icons.account_balance,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Batal'),
                    ),
                    TextButton(
                      onPressed: () {
                        db
                            .addAccountCode(
                              nameController.text,
                              int.parse(codeController.text),
                            )
                            .then((value) => Navigator.of(context).pop());
                      },
                      child: const Text('Simpan'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
