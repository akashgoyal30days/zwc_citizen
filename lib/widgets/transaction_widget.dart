import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../controllers/rewards_controller.dart.dart';

class TransactionWidget extends StatelessWidget {
  const TransactionWidget(this.transactionModel, {super.key});
  final TransactionModel transactionModel;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transactionModel.remark,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    transactionModel.branchName,
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
              )),
              const SizedBox(width: 12),
              RichText(
                  text: TextSpan(
                      style: GoogleFonts.roboto(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: transactionModel.amount > 0
                            ? Colors.green
                            : Colors.red,
                      ),
                      children: [
                    TextSpan(
                      text:
                          "${transactionModel.amount < 0 ? "- " : "+"}${transactionModel.amount.abs()}",
                    ),
                    TextSpan(
                      text: " Pts",
                      style: GoogleFonts.roboto(
                        fontSize: 10,
                        color: transactionModel.amount > 0
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ])),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                  child: Text(
                "Tx id:${transactionModel.id}",
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              )),
              Text(
                DateFormat("d MMM yyyy").format(DateTime(
                  int.parse(transactionModel.lct.substring(0, 4)),
                  int.parse(transactionModel.lct.substring(5, 7)),
                  int.parse(transactionModel.lct.substring(8, 10)),
                )),
                style: const TextStyle(
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey
                ),
              ),
              // Text(
              //   transactionModel.lct,
              // style: const TextStyle(
              //   fontSize: 13,
              //   fontStyle: FontStyle.italic,
              // ),
              // )
            ],
          ),
          const Divider(indent: 6, endIndent: 6),
        ],
      ),
    );
  }
}
