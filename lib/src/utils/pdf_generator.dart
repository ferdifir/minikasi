import 'dart:io';

import 'package:minikasi/src/utils/helper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class PDFGenerator {
  static Future<File> saveDoc({
    required String fileName,
    required Document doc,
  }) async {
    final bytes = await doc.save();
    final dir = await getExternalStorageDirectory();
    final pdfDiretory = Directory('${dir!.path}/Laporan Minikasi');
    if (!pdfDiretory.existsSync()) pdfDiretory.createSync();
    final file = File('${pdfDiretory.path}/$fileName.pdf');
    await file.writeAsBytes(bytes);
    return file;
  }

  static Future<File> generateNeraca(
      Map data, String periode, String companyName) async {
    var currentAsetList = data['Current Asset'];
    var fixedAsetList = data['Fixed Asset'];
    var shortTermLiabilityList = data['Short Term Liability'];
    var longTermLiabilityList = data['Long Term Liability'];
    var equityList = data['Equity'];

    final pdf = Document();

    pdf.addPage(
      MultiPage(
        pageFormat: PdfPageFormat.a4,
        orientation: PageOrientation.portrait,
        build: (context) {
          return [
            buildHeader('Neraca', periode, companyName),
            SizedBox(height: 10),
            Divider(thickness: 2),
            SizedBox(height: 20),
            Text(
              'ASET',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Aset Lancar',
              style: const TextStyle(
                fontSize: 18,
                decoration: TextDecoration.underline,
              ),
            ),
            SizedBox(height: 10),
            buildListNeraca(currentAsetList),
            SizedBox(height: 10),
            Text(
              'Aset Tetap',
              style: const TextStyle(
                fontSize: 18,
                decoration: TextDecoration.underline,
              ),
            ),
            SizedBox(height: 10),
            buildListNeraca(fixedAsetList),
            SizedBox(height: 10),
            buildTotalNeraca(currentAsetList, fixedAsetList, 'Aset'),
            SizedBox(height: 10),
            Divider(),
            SizedBox(height: 10),
            Text(
              'LIABILITAS',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Liabilitas Jangka Pendek',
              style: const TextStyle(
                fontSize: 18,
                decoration: TextDecoration.underline,
              ),
            ),
            SizedBox(height: 10),
            buildListNeraca(shortTermLiabilityList),
            SizedBox(height: 10),
            Text(
              'Liabilitas Jangka Panjang',
              style: const TextStyle(
                fontSize: 18,
                decoration: TextDecoration.underline,
              ),
            ),
            SizedBox(height: 10),
            buildListNeraca(longTermLiabilityList),
            SizedBox(height: 10),
            buildTotalNeraca(
              shortTermLiabilityList,
              longTermLiabilityList,
              'Liabilitas',
            ),
            SizedBox(height: 10),
            Divider(),
            SizedBox(height: 10),
            Text(
              'EKUITAS',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 10),
            buildListNeraca(equityList),
            SizedBox(height: 10),
            buildTotalNeraca(equityList, [], 'Ekuitas')
          ];
        },
      ),
    );

    return saveDoc(fileName: 'Neraca', doc: pdf);
  }

  static Table buildTotalNeraca(firstList, secondList, String title) {
    return Table(
      children: [
        TableRow(
          children: [
            Container(
              padding: const EdgeInsets.only(
                left: 40,
                right: 10,
              ),
              child: Text(
                'Total $title',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                left: 80,
              ),
              alignment: Alignment.centerRight,
              child: Text(
                Helper.rupiahFormat(
                  title == 'Ekuitas'
                      ? totalSaldo(firstList)
                      : totalSaldo(firstList) + totalSaldo(secondList),
                ),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  static totalSaldo(Map list) {
    var total = 0;
    for (var i = 0; i < list.length; i++) {
      total += calculateSaldo(
        list.values.elementAt(i)['debit'],
        list.values.elementAt(i)['kredit'],
      );
    }
    return total;
  }

  static Widget buildListNeraca(Map list) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        return Table(
          columnWidths: {
            0: const FlexColumnWidth(1),
            1: const FlexColumnWidth(1)
          },
          children: [
            TableRow(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Text(list.keys.elementAt(index).split('-')[1].trim(),
                      style: const TextStyle(
                        fontSize: 18,
                      )),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(
                    top: 10,
                    bottom: 10,
                    left: 50,
                  ),
                  child: Text(
                      Helper.rupiahFormat(calculateSaldo(
                        list.values.elementAt(index)['debit'],
                        list.values.elementAt(index)['kredit'],
                      )),
                      style: const TextStyle(
                        fontSize: 18,
                      )),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  static int calculateSaldo(int debit, int kredit) {
    var saldo = debit - kredit;
    return saldo;
  }

  static Future<File> generateLabaRugi(
      Map data, String periode, String companyName) async {
    final pdf = Document();
    final pendapatanOperasional = data['pendapatanOperasional'];
    final pendapatanNonOperasional = data['pendapatanNonOperasional'];
    final bebanOperasional = data['bebanOperasional'];
    final bebanNonOperasional = data['bebanNonOperasional'];
    final labaRugi = data['labaRugi'];

    pdf.addPage(MultiPage(
      pageFormat: PdfPageFormat.a4,
      orientation: PageOrientation.portrait,
      build: (context) {
        return [
          buildHeader('Laporan Laba Rugi', periode, companyName),
          SizedBox(height: 10),
          Divider(thickness: 2),
          SizedBox(height: 20),
          Text(
            'PENDAPATAN OPERASIONAL',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          listLabaRugi(pendapatanOperasional),
          SizedBox(height: 20),
          Text(
            'PENDAPATAN NON OPERASIONAL',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          listLabaRugi(pendapatanNonOperasional),
          buildTotalLabaRugi(
              'Total Pendapatan',
              totalLabaRugi(pendapatanOperasional) +
                  totalLabaRugi(pendapatanNonOperasional)),
          SizedBox(height: 20),
          Divider(thickness: 2),
          SizedBox(height: 20),
          Text(
            'BEBAN OPERASIONAL',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          listLabaRugi(bebanOperasional),
          SizedBox(height: 20),
          listbebanNonOperasional(bebanNonOperasional),
          buildTotalLabaRugi(
              'Total Beban',
              totalLabaRugi(bebanOperasional) +
                  totalLabaRugi(bebanNonOperasional)),
          SizedBox(height: 20),
          Divider(thickness: 2),
          SizedBox(height: 20),
          buildTotalLabaRugi('LABA RUGI', labaRugi),
        ];
      },
    ));

    return saveDoc(fileName: 'Laporan Laba Rugi', doc: pdf);
  }

  static Row buildTotalLabaRugi(String title, int totalSaldo) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          Helper.rupiahFormat(totalSaldo),
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  static Column listbebanNonOperasional(List bebanNonOperasional) {
    if (bebanNonOperasional.isNotEmpty) {
      return Column(
        children: [
          Text(
            'BEBAN NON OPERASIONAL',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          listLabaRugi(bebanNonOperasional),
        ],
      );
    } else {
      return Column();
    }
  }

  static totalLabaRugi(List data) {
    var total = 0;
    for (var i = 0; i < data.length; i++) {
      total += data[i]['saldo'] as int;
    }
    return total;
  }

  static listLabaRugi(data) {
    var total = 0;
    for (var i = 0; i < data.length; i++) {
      total += data[i]['saldo'] as int;
    }
    Map<int, TableColumnWidth> columnWidths = {
      0: const FixedColumnWidth(3),
      1: const FixedColumnWidth(2),
    };
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        if (index == data.length) {
          return Table(
            columnWidths: columnWidths,
            children: [
              TableRow(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      'Total',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      total.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        } else {
          var nama = data[index]['nama'];
          var namaSub = nama.toString().substring(0, nama.indexOf('-'));
          return Table(columnWidths: columnWidths, children: [
            TableRow(children: [
              Container(
                padding: const EdgeInsets.all(10),
                child: Text(
                  namaSub,
                ),
              ),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: Text(
                  Helper.rupiahFormat(data[index]['saldo'] as int),
                ),
              ),
            ])
          ]);
        }
      },
    );
  }

  static calculateIncome(Map data, type) {
    var total = 0;

    data.forEach((key, value) {
      if (key.contains(type)) {
        total += value['debit'] + value['kredit'] as int;
      }
    });

    return total;
  }

  static filterData(Map data, String type) {
    final Map filteredData = {};

    data.forEach((key, value) {
      if (key.contains(type)) {
        filteredData.addAll({key: value});
      }
    });

    return filteredData;
  }

  static Future<File> generateNeracaSaldo(
      Map data, String periode, String companyName) async {
    final pdf = Document();

    pdf.addPage(
      MultiPage(
        pageFormat: PdfPageFormat.a4,
        orientation: PageOrientation.portrait,
        build: (context) {
          return [
            buildHeader('Laporan Neraca Saldo', periode, companyName),
            SizedBox(height: 10),
            Divider(thickness: 2),
            SizedBox(height: 20),
            Table(
              border: TableBorder.all(),
              columnWidths: const {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(3),
                2: FlexColumnWidth(1),
                3: FlexColumnWidth(1),
              },
              children: [
                TableRow(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: Text('Kode Akun'),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: Text('Nama Akun'),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: Text('Debit'),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: Text('Kredit'),
                    ),
                  ],
                ),
              ],
            ),
            ListView.builder(
              itemBuilder: (context, index) {
                return Table(
                  border: TableBorder.all(),
                  columnWidths: const {
                    0: FlexColumnWidth(1),
                    1: FlexColumnWidth(3),
                    2: FlexColumnWidth(1),
                    3: FlexColumnWidth(1),
                  },
                  children: [
                    TableRow(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          child:
                              Text(data.keys.elementAt(index).substring(0, 4)),
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          child: Text(data.keys.elementAt(index).substring(7)),
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          child: Text(data[data.keys.elementAt(index)]['debit']
                              .toString()),
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          child: Text(data[data.keys.elementAt(index)]['kredit']
                              .toString()),
                        ),
                      ],
                    ),
                  ],
                );
              },
              itemCount: data.length,
            ),
            Table(
              border: TableBorder.symmetric(
                inside: const BorderSide(width: 1),
                outside: const BorderSide(width: 1),
              ),
              columnWidths: const {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(3),
                2: FlexColumnWidth(1),
                3: FlexColumnWidth(1),
              },
              children: [
                TableRow(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: Text(''),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: Text('Total'),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child:
                          Text(calculateTotalDebitKredit(data)[0].toString()),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child:
                          Text(calculateTotalDebitKredit(data)[1].toString()),
                    ),
                  ],
                ),
              ],
            ),
          ];
        },
      ),
    );

    return saveDoc(fileName: 'Neraca Saldo', doc: pdf);
  }

  static calculateTotalDebitKredit(Map data) {
    double totalDebit = 0;
    double totalKredit = 0;
    for (var account in data.values) {
      totalDebit += account['debit'];
      totalKredit += account['kredit'];
    }
    return [totalDebit, totalKredit];
  }

  static buildHeader(String title, String periode, String company) {
    if (company.isEmpty) {
      company = 'Nama Perusahaan';
    }
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            company,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Periode $periode',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
