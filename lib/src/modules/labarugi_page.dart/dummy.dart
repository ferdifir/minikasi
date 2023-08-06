import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:minikasi/src/modules/neraca/neraca_controller.dart';

class Dummy extends StatelessWidget {
  Dummy({
    super.key,
  });

  final data = Get.arguments;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final columnWidth = (width - 20) * 0.2;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: SizedBox(
            width: width,
            child: Column(
              children: [
                Text(
                  'NERACA',
                  style: Theme.of(context).textTheme.headline4,
                ),
                Text(
                  'Periode April 2021',
                  style: Theme.of(context).textTheme.headline6,
                ),
                const SizedBox(height: 20),
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'ASSET',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 20,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: columnWidth,
                        child: const Text(
                          'Current Asset',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        width: columnWidth,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: data['Current Asset'].length,
                          itemBuilder: (context, index) {
                            return Text(
                              data['Current Asset']
                                  .keys
                                  .elementAt(index)
                                  .split('-')[1]
                                  .trim(),
                              textAlign: TextAlign.start,
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        width: columnWidth,
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: data['Current Asset'].length,
                            itemBuilder: (context, index) {
                              return Text(
                                calculateSaldo(
                                  data['Current Asset']
                                      .values
                                      .elementAt(index)['debit'],
                                  data['Current Asset']
                                      .values
                                      .elementAt(index)['kredit'],
                                ),
                                textAlign: TextAlign.end,
                              );
                            }),
                      ),
                      SizedBox(
                        width: columnWidth,
                        child: Column(
                          children: [
                            ListView.builder(
                                shrinkWrap: true,
                                itemCount: data['Current Asset'].length,
                                itemBuilder: (context, index) {
                                  return const Text(
                                    '',
                                    textAlign: TextAlign.end,
                                  );
                                }),
                            Text('${calculateCurrentAsset()}'),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: columnWidth,
                        child: const Text(
                          '',
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: columnWidth,
                        child: const Text(
                          'Fixed Asset',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        width: columnWidth,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: data['Fixed Asset'].length,
                          itemBuilder: (context, index) {
                            return Text(
                              data['Fixed Asset']
                                  .keys
                                  .elementAt(index)
                                  .split('-')[1]
                                  .trim(),
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.start,
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        width: columnWidth,
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: data['Fixed Asset'].length,
                            itemBuilder: (context, index) {
                              return Text(
                                calculateSaldo(
                                  data['Fixed Asset']
                                      .values
                                      .elementAt(index)['debit'],
                                  data['Fixed Asset']
                                      .values
                                      .elementAt(index)['kredit'],
                                ),
                                textAlign: TextAlign.end,
                              );
                            }),
                      ),
                      SizedBox(
                        width: columnWidth,
                        child: Column(
                          children: [
                            ListView.builder(
                                shrinkWrap: true,
                                itemCount: data['Fixed Asset'].length,
                                itemBuilder: (context, index) {
                                  return const Text(
                                    '',
                                    textAlign: TextAlign.end,
                                  );
                                }),
                            Text('${calculateFixedAsset()}'),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: columnWidth,
                        child: const Text(
                          '',
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: columnWidth,
                        child: const Text(
                          '',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        width: columnWidth,
                        child: const Text(
                          '',
                          textAlign: TextAlign.start,
                        ),
                      ),
                      SizedBox(
                        width: columnWidth,
                        child: const Text(
                          'Total Asset',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                      SizedBox(
                        width: columnWidth,
                        child: const Text(
                          '',
                          textAlign: TextAlign.end,
                        ),
                      ),
                      SizedBox(
                        width: columnWidth,
                        child: Text(
                          '${calculateCurrentAsset() + calculateFixedAsset()}',
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'HUTANG DAN LIABILITAS',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 20,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: columnWidth,
                        child: const Text(
                          'Short Term Liability',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        width: columnWidth,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: data['Short Term Liability'].length,
                          itemBuilder: (context, index) {
                            return Text(
                              data['Short Term Liability']
                                  .keys
                                  .elementAt(index)
                                  .split('-')[1]
                                  .trim(),
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.start,
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        width: columnWidth,
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: data['Short Term Liability'].length,
                            itemBuilder: (context, index) {
                              return Text(
                                calculateSaldo(
                                  data['Short Term Liability']
                                      .values
                                      .elementAt(index)['debit'],
                                  data['Short Term Liability']
                                      .values
                                      .elementAt(index)['kredit'],
                                ),
                                textAlign: TextAlign.end,
                              );
                            }),
                      ),
                      SizedBox(
                        width: columnWidth,
                        child: Column(
                          children: [
                            ListView.builder(
                                shrinkWrap: true,
                                itemCount: data['Short Term Liability'].length,
                                itemBuilder: (context, index) {
                                  return const Text(
                                    '',
                                    textAlign: TextAlign.end,
                                  );
                                }),
                            Text('${calculateCurrentLiability()}'),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: columnWidth,
                        child: const Text(
                          '',
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: columnWidth,
                        child: const Text(
                          'Equity',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        width: columnWidth,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: data['Equity'].length,
                          itemBuilder: (context, index) {
                            return Text(
                              data['Equity']
                                  .keys
                                  .elementAt(index)
                                  .split('-')[1]
                                  .trim(),
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.start,
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        width: columnWidth,
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: data['Equity'].length,
                            itemBuilder: (context, index) {
                              return Text(
                                calculateSaldo(
                                  data['Equity']
                                      .values
                                      .elementAt(index)['debit'],
                                  data['Equity']
                                      .values
                                      .elementAt(index)['kredit'],
                                ),
                                textAlign: TextAlign.end,
                              );
                            }),
                      ),
                      SizedBox(
                        width: columnWidth,
                        child: Column(
                          children: [
                            ListView.builder(
                                shrinkWrap: true,
                                itemCount: data['Equity'].length,
                                itemBuilder: (context, index) {
                                  return const Text(
                                    '',
                                    textAlign: TextAlign.end,
                                  );
                                }),
                            Text('${calculateEquity()}'),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: columnWidth,
                        child: const Text(
                          '',
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: columnWidth,
                        child: const Text(
                          '',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        width: columnWidth,
                        child: const Text(
                          '',
                          textAlign: TextAlign.start,
                        ),
                      ),
                      SizedBox(
                        width: columnWidth,
                        child: const Text(
                          'Total Hutang dan Ekuitas',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                      SizedBox(
                        width: columnWidth,
                        child: const Text(
                          '',
                          textAlign: TextAlign.end,
                        ),
                      ),
                      SizedBox(
                        width: columnWidth,
                        child: Text(
                          '${calculateCurrentLiability() + calculateEquity()}',
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  calculateEquity() {
    var total = 0;
    data['Equity'].forEach((key, value) {
      total += value['debit'] - value['kredit'] as int;
    });
    return total;
  }

  calculateCurrentLiability() {
    var total = 0;
    data['Short Term Liability'].forEach((key, value) {
      total += value['debit'] - value['kredit'] as int;
    });
    return total;
  }

  calculateCurrentAsset() {
    var total = 0;
    data['Current Asset'].forEach((key, value) {
      total += value['debit'] - value['kredit'] as int;
    });
    return total;
  }

  calculateFixedAsset() {
    var total = 0;
    data['Fixed Asset'].forEach((key, value) {
      total += value['debit'] - value['kredit'] as int;
    });
    return total;
  }

  String calculateSaldo(int debit, int kredit) {
    var saldo = debit - kredit;
    return saldo.toString();
  }
}
