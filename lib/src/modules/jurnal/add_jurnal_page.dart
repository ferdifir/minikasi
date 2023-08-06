import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/app_routes.dart';
import 'jurnal_controller.dart';

class AddJurnalPage extends StatelessWidget {
  const AddJurnalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.offNamed(AppRoutes.journal);
        return true;
      },
      child: GetBuilder<JurnalController>(
        init: JurnalController(),
        initState: (_) {},
        builder: (_) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Tambah Transaksi'),
              centerTitle: true,
            ),
            body: Container(
              margin: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 10,
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Form(
                  key: _.formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      dateField(_, context),
                      const SizedBox(height: 20),
                      descField(_),
                      const SizedBox(height: 10),
                      const Divider(),
                      const SizedBox(height: 10),
                      detailTransaksiField(context),
                      const SizedBox(height: 10),
                      const Divider(),
                      OutlinedButton(
                        onPressed: () {
                          _.addDetailTransaksi();
                        },
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 50,
                            vertical: 16,
                          ),
                        ),
                        child: const Text('Tambah Akun Transaksi'),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (_.formKey.currentState!.validate()) {
                            _.saveJurnal();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(10), // <-- Radius
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 100,
                            vertical: 16,
                          ),
                        ),
                        child: const Text('Simpan'),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  detailTransaksiField(BuildContext context) {
    return GetBuilder<JurnalController>(
      init: JurnalController(),
      initState: (_) {},
      builder: (_) {
        return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: _.detailTransaksi.length,
          itemBuilder: (context, index) {
            return Dismissible(
              key: UniqueKey(),
              onDismissed: (direction) {
                _.removeDetailTransaksi(index);
              },
              direction: DismissDirection.endToStart,
              background: Container(
                color: Colors.red,
                child: const Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              confirmDismiss: (direction) {
                if (_.detailTransaksi.length == 2) {
                  return Future.value(false);
                } else {
                  return Get.defaultDialog(
                    title: 'Hapus Akun Transaksi',
                    middleText:
                        'Apakah anda yakin ingin menghapus akun transaksi ini?',
                    textConfirm: 'Ya',
                    confirmTextColor: Colors.white,
                    textCancel: 'Tidak',
                    onConfirm: () {
                      _.removeDetailTransaksi(index);
                      Get.back();
                    },
                    onCancel: () {},
                  );
                }
              },
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  akunField(_, index),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: debitField(index),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: kreditField(index),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            );
          },
        );
      },
    );
  }

  kreditField(int index) {
    return GetBuilder<JurnalController>(
      init: JurnalController(),
      initState: (_) {},
      builder: (_) {
        return TextField(
          controller: _.kreditControllers[index],
          keyboardType: TextInputType.number,
          onChanged: (value) {
            // if (value.isEmpty) {
            //   _.kreditControllers[index].text = '0';
            // }
            _.detailTransaksi[index]['kredit'] = int.parse(value);
          },
          decoration: const InputDecoration(
            labelText: 'Kredit',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            prefixIcon: Icon(Icons.arrow_upward),
          ),
        );
      },
    );
  }

  debitField(int index) {
    return GetBuilder<JurnalController>(
      init: JurnalController(),
      initState: (_) {},
      builder: (_) {
        return TextField(
          controller: _.debitControllers[index],
          keyboardType: TextInputType.number,
          onChanged: (value) {
            // if (value.isEmpty) {
            //   _.debitControllers[index].text = '0';
            // }
            _.detailTransaksi[index]['debit'] = int.parse(value);
          },
          decoration: const InputDecoration(
            labelText: 'Debit',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            prefixIcon: Icon(Icons.arrow_downward),
          ),
        );
      },
    );
  }

  akunField(JurnalController _, int index) {
    return DropdownButtonFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return 'Akun tidak boleh kosong';
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: 'Akun',
        hintText: 'Akun',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        prefixIcon: Icon(Icons.account_balance_wallet),
      ),
      value: _.selectedAkun[index],
      items: _.accountCode.map((value) {
        return DropdownMenuItem(
          value: '${value.code} - ${value.name}',
          child: Text('${value.code} - ${value.name}'),
        );
      }).toList(),
      onChanged: (value) {
        _.selectedAkun[index] = value!;
        _.updateDetailTransaksi(
          index,
          int.parse(value.substring(0, 4).trim()),
          'kodeAkun',
        );
      },
    );
  }

  descField(JurnalController _) {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return 'Keterangan tidak boleh kosong';
        }
        return null;
      },
      controller: _.keteranganController,
      decoration: const InputDecoration(
        labelText: 'Keterangan',
        hintText: 'Keterangan',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        prefixIcon: Icon(Icons.description),
      ),
    );
  }

  dateField(JurnalController _, BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return 'Tanggal tidak boleh kosong';
        }
        return null;
      },
      controller: _.tanggalController,
      readOnly: true,
      onTap: () {
        showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        ).then((value) {
          _.tanggalController.text =
              '${value!.day}-${value.month}-${value.year}';
        });
      },
      decoration: const InputDecoration(
        labelText: 'Tanggal',
        hintText: 'Tanggal',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        prefixIcon: Icon(Icons.calendar_today),
        suffixIcon: Icon(Icons.arrow_drop_down),
      ),
    );
  }
}
