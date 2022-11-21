import 'package:codeshareclone/utils/color.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/extensions.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuple/tuple.dart';

class CodeEditorWidget extends ConsumerWidget {
  final QuillController quillController;
  final FocusNode _focusNode = FocusNode();
  CodeEditorWidget({super.key, required this.quillController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (kIsWeb) {
      return Container(
        color: kEditorColor,
        width: double.infinity,
        height: double.infinity,
        child: MouseRegion(
          cursor: SystemMouseCursors.text,
          child: QuillEditor(
            controller: quillController,
            scrollController: ScrollController(),
            scrollable: true,
            focusNode: _focusNode,
            autoFocus: true,
            readOnly: false,
            placeholder:
                'Write or paste code here then share. Anyone you share with will see code as it is typed!',
            expands: false,

            padding: const EdgeInsets.only(left: 16),
            // onTapUp: (details, p1) {
            //   return _onTripleClickSelection();
            // },
            customStyles: DefaultStyles(
              placeHolder: DefaultTextBlockStyle(
                  const TextStyle(
                    fontSize: 12,
                    color: kGreyColor,
                    wordSpacing: 3.5,
                    height: 1.3,
                    fontWeight: FontWeight.w100,
                  ),
                  const Tuple2(16, 0),
                  const Tuple2(0, 0),
                  null),
              h1: DefaultTextBlockStyle(
                  const TextStyle(
                    fontSize: 32,
                    color: kWhiteColor,
                    height: 1.15,
                    fontWeight: FontWeight.w300,
                  ),
                  const Tuple2(16, 0),
                  const Tuple2(0, 0),
                  null),
              paragraph: DefaultTextBlockStyle(
                  const TextStyle(
                    fontSize: 14,
                    color: kWhiteColor,
                    height: 1.15,
                    fontWeight: FontWeight.w300,
                  ),
                  const Tuple2(16, 0),
                  const Tuple2(0, 0),
                  null),
              sizeSmall: const TextStyle(fontSize: 9),
            ),
          ),
        ),
      );
    }
    return MouseRegion(
      cursor: SystemMouseCursors.text,
      child: QuillEditor(
        controller: quillController,
        scrollController: ScrollController(),
        scrollable: true,
        focusNode: _focusNode,
        autoFocus: true,
        readOnly: false,
        placeholder:
            'Write or paste code here then share. Anyone you share with will see code as it is typed!',

        enableSelectionToolbar: isMobile(),
        expands: false,
        padding: EdgeInsets.zero,

        // onTapUp: (details, p1) {
        //   return _onTripleClickSelection();
        // },
        customStyles: DefaultStyles(
          placeHolder: DefaultTextBlockStyle(
              const TextStyle(
                fontSize: 12,
                color: kGreyColor,
                wordSpacing: 3.5,
                height: 2.2,
                fontWeight: FontWeight.w100,
              ),
              const Tuple2(16, 0),
              const Tuple2(0, 0),
              null),
          paragraph: DefaultTextBlockStyle(
              const TextStyle(
                fontSize: 14,
                color: kWhiteColor,
                height: 1.15,
                fontWeight: FontWeight.w300,
              ),
              const Tuple2(16, 0),
              const Tuple2(0, 0),
              null),
          h1: DefaultTextBlockStyle(
              const TextStyle(
                fontSize: 32,
                color: kWhiteColor,
                height: 1.15,
                fontWeight: FontWeight.w300,
              ),
              const Tuple2(16, 0),
              const Tuple2(0, 0),
              null),
          sizeSmall: const TextStyle(fontSize: 9),
        ),
        embedBuilders: [
          ...FlutterQuillEmbeds.builders(),
        ],
      ),
    );
  }
}
