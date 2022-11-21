import 'dart:js' as js;

import 'package:codeshareclone/helper/helper_function.dart';
import 'package:codeshareclone/repository/auth-repository.dart';
import 'package:codeshareclone/repository/document-repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:codeshareclone/models/document.dart';
import 'package:codeshareclone/utils/color.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class SavedCodesTable extends ConsumerStatefulWidget {
  const SavedCodesTable({Key? key, required this.documents}) : super(key: key);
  final List<Document> documents;

  @override
  ConsumerState<SavedCodesTable> createState() => _SavedCodesTableState();
}

class _SavedCodesTableState extends ConsumerState<SavedCodesTable> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Material(
        // color: Colors.transparent,
        child: DataTable(
          // dataRowColor: MaterialStateProperty.all(kWhiteColor),

          headingTextStyle:
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          showCheckboxColumn: false,
          columnSpacing: isMobile(context) ? 10 : 115,

          columns: [
            const DataColumn(
                label: Text(
              'URL',
            )),
            const DataColumn(
                label: Text(
              'TITLE',
            )),
            const DataColumn(
                label: Text(
              'SYNTAX',
            )),
            DataColumn(
              label: Row(
                children: const [
                  Text(
                    'MODIFIED',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    color: kBlackColor,
                  )
                ],
              ),
            ),
            const DataColumn(
                label: Text(
              'CREATED',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            )),
            const DataColumn(
                label: Text(
              'ACTIONS',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            )),
          ],
          rows: widget.documents.map((e) {
            // bool selected = false;
            return DataRow(
              cells: <DataCell>[
                DataCell(
                  Text(
                    '/${e.id}',
                    style: const TextStyle(
                        color: kDarkBlueTextColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 16),
                  ),
                  onTap: () {
                    kIsWeb
                        ? js.context.callMethod(
                            'open', ['https://codeurl.web.app/${e.id}'])
                        : debugPrint('left to assgin');
                  },
                ),
                DataCell(
                  Text(
                    formatDateTitle(timeStamp: e.createdAt),
                    style: const TextStyle(
                        color: kDarkBlueTextColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 16),
                  ),
                  onTap: () {
                    js.context.callMethod(
                        'open', ['https://codeurl.web.app/${e.id}']);
                  },
                ),
                const DataCell(Text(
                  'Plain Text',
                  style: TextStyle(
                    fontSize: 17,
                    color: kBlackColor,
                  ),
                )),
                DataCell(Text(
                  findDifferenceTime(timeStamp: e.updatedAt),
                  style: const TextStyle(color: kBlackColor, fontSize: 17),
                )),
                DataCell(Text(
                  findDifferenceTime(timeStamp: e.createdAt),
                  style: const TextStyle(fontSize: 17, color: kBlackColor),
                )),
                DataCell(
                    const Icon(
                      Icons.delete,
                      color: kGreyColor,
                    ),
                    onTap: () => _deleteCode(
                        context: context, documentId: e.id, ref: ref)),
              ],
              // selected: selected,
              onSelectChanged: (value) {
                if (value != null) {
                  // selected = value;
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _deleteCode(
      {required BuildContext context,
      required String documentId,
      required WidgetRef ref}) async {
    String token = ref.read(userStateProvider)!.token;
    // final scaffoldMessager = ScaffoldMessenger.of(context);

    final data = await ref
        .read(documentRepositoryProvider)
        .deleteDocumentForAuthUser(token: token, documentId: documentId);

    if (data.responseData != null) {
      setState(() {
        widget.documents.removeWhere((element) => element.id == documentId);
      });
    }
  }
}
