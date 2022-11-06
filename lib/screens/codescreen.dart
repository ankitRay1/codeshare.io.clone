import 'dart:async';

import 'dart:io';
import 'dart:ui';

import 'package:codeshareclone/common/function.dart';
import 'package:codeshareclone/models/user.dart';
import 'package:codeshareclone/repository/socket-repository.dart';
import 'package:codeshareclone/widgets/code_editor_widget.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/extensions.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import 'package:routemaster/routemaster.dart';
import 'package:tuple/tuple.dart';

import '../repository/auth-repository.dart';
import '../repository/document-repository.dart';
import '../utils/color.dart';

enum _SelectionType {
  none,
  word,
  // line,
}

class CodeScreen extends ConsumerStatefulWidget {
  final String documentId;
  const CodeScreen({super.key, required this.documentId});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CodeScreenState();
}

class _CodeScreenState extends ConsumerState<CodeScreen> {
  QuillController? _controller;

  final TextEditingController _documentTitleEditor = TextEditingController();
  SocketRepository socketRepository = SocketRepository();
  User? userState;

  Timer? _selectAllTimer;
  _SelectionType _selectionType = _SelectionType.none;

  // SocketRepository socketRepository = SocketRepository();

  @override
  void dispose() {
    _selectAllTimer?.cancel();
    super.dispose();
    _documentTitleEditor.dispose();
  }

  @override
  void initState() {
    super.initState();
    socketRepository.joinRoom(documentId: widget.documentId);
    socketRepository.testSocket();

    // _loadFromAssets();
    _fetchDocumentData();

    socketRepository.changeListener((dataChanges) {
      _controller?.compose(
          Delta.fromJson(dataChanges['delta']),
          _controller?.selection ?? const TextSelection.collapsed(offset: 0),
          ChangeSource.REMOTE);
    });

    Timer.periodic(const Duration(seconds: 2), (timer) {
      Map<String, dynamic> dataToSave = {
        'delta': _controller?.document.toDelta(),
        'room': widget.documentId
      };
      socketRepository.autoSave(data: dataToSave);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      return const Scaffold(body: Center(child: Text('Loading...')));
    }
    userState = ref.watch(userStateProvider);

    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: screenSize.width <= 600
          ? null
          : AppBar(
              elevation: 0,
              backgroundColor: kDartBlue,
              leadingWidth: 180,
              leading: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: InkWell(
                  onTap: () {
                    final navigator = Routemaster.of(context);

                    navigator.push('/');
                  },
                  child: SvgPicture.asset(
                    'assets/images/codeshare-logo.svg',
                    semanticsLabel: 'Codeshare.io logo',
                  ),
                ),
              ),
              actions: [
                Padding(
                  padding:
                      const EdgeInsets.only(top: 10, bottom: 07, right: 12),
                  child: TextButton.icon(
                      style: TextButton.styleFrom(
                          padding: const EdgeInsets.all(14),
                          backgroundColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(06),
                              side: const BorderSide(
                                color: kWhiteColor,
                              ))),
                      onPressed: () => _shareDocsUrl(context: context),
                      icon: const Icon(
                        Icons.lock,
                        size: 16,
                        color: kWhiteColor,
                      ),
                      label: const Text(
                        'Share',
                        style: TextStyle(color: kWhiteColor),
                      )),
                ),
                userState?.token != null
                    ? const SizedBox.shrink()
                    : Padding(
                        padding: const EdgeInsets.only(
                            top: 10, bottom: 07, right: 10),
                        child: TextButton.icon(
                            style: TextButton.styleFrom(
                                padding: const EdgeInsets.all(14),
                                backgroundColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(06),
                                    side: const BorderSide(
                                      color: kWhiteColor,
                                    ))),
                            onPressed: () =>
                                signInWithGoogle(ref: ref, context: context),
                            icon: SvgPicture.asset(
                              'assets/images/google.svg',
                              height: 27,
                            ),
                            label: const Text(
                              'Login',
                              style: TextStyle(color: kWhiteColor),
                            )),
                      ),
                userState?.token != null
                    ? Padding(
                        padding: const EdgeInsets.only(
                            top: 10, bottom: 07, right: 10),
                        child: TextButton.icon(
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.all(14),
                              backgroundColor: Colors.transparent,
                            ),
                            onPressed: () {},
                            icon: CircleAvatar(
                                backgroundImage: NetworkImage(userState
                                        ?.profilePic ??
                                    'https://gravatar.com/avatar/cbab9be1cf0a386588838721ffaf9857')),
                            label: Text(
                              userState?.name ?? '',
                              style: const TextStyle(color: kWhiteColor),
                            )),
                      )
                    : const SizedBox.shrink()
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(1),
                child: Container(
                  decoration: BoxDecoration(
                      color: kGreyColor, border: Border.all(width: 0.1)),
                ),
              ),
            ),
      // body: _buildWritingEditor(context),
      body: Container(
        child: Row(children: [
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerLeft,
              child: CodeEditorWidget(quillController: _controller!),
            ),
          ),
          Container(
            width: 60.0,
            decoration: const BoxDecoration(color: kDartBlue),
            // padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                IconButton(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    onPressed: () {},
                    icon: const Icon(
                      Icons.settings,
                      color: kGreyColor,
                    )),
                const Divider(
                  color: kBorderBottom,
                  thickness: 1.3,
                ),
                IconButton(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    onPressed: () {},
                    icon: const Icon(
                      Icons.save_alt,
                      color: kGreyColor,
                    )),
                const Divider(
                  color: kBorderBottom,
                  thickness: 1.3,
                ),
                IconButton(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    onPressed: () {},
                    icon: const Icon(
                      Icons.add,
                      size: 25,
                      color: kGreyColor,
                    )),
                const Divider(
                  color: kBorderBottom,
                  thickness: 1.3,
                ),
                const Spacer(),
                IconButton(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    onPressed: () {},
                    icon: const Icon(
                      Icons.info,
                      color: kGreyColor,
                    )),
              ],
            ),
          )
        ]),
      ),
    );
  }

  void _fetchDocumentData() async {
    // String token = ref.read(userStateProvider)!.token;
    var apiResponseData = await ref
        .read(documentRepositoryProvider)
        .fetchDocumentById(documentId: widget.documentId);

    if (apiResponseData.responseData != null) {
      _controller = QuillController(
          document: apiResponseData.responseData.content.isEmpty
              ? Document()
              : Document.fromDelta(
                  Delta.fromJson(apiResponseData.responseData.content)),
          selection: const TextSelection.collapsed(offset: 0));
      _documentTitleEditor.text = apiResponseData.responseData.title;

      setState(() {});
    }
    _controller?.document.changes.listen((event) {
      if (event.item3 == ChangeSource.LOCAL) {
        Map<String, dynamic> map = {
          'delta': event.item2,
          'room': widget.documentId
        };
        socketRepository.typing(typedData: map);
      }
    });
  }

  void _shareDocsUrl({required BuildContext context}) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            // contentPadding: const EdgeInsets.symmetric(vertical: 300),
            scrollable: true,
            content: ListTile(
              title: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Share Code',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                      'Anyone with access to this URL will see your code in real time. ',
                      style: TextStyle(color: Colors.black, fontSize: 18)),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text(
                    'Share this URL',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(
                    height: 22,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          initialValue:
                              'http://localhost:4000/#/document/${widget.documentId}',
                          style: const TextStyle(
                              color: kBlackColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 15),
                          readOnly: true,
                          decoration: InputDecoration(
                              fillColor: kBlueColor,
                              hoverColor: kBlueColor,
                              focusColor: kBlueColor,
                              border: InputBorder.none,
                              focusedBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: kBlueColor, width: 2.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: kBlueColor.withOpacity(0.5)),
                              ),
                              contentPadding: const EdgeInsets.only(
                                left: 10,
                              )),
                        ),
                      ),
                      IconButton(
                          splashRadius: 30.0,
                          splashColor: kBlueColor.withOpacity(0.5),
                          onPressed: () {
                            Clipboard.setData(ClipboardData(
                                    text:
                                        'https://localhost:4000/#/document/${widget.documentId}'))
                                .then((value) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Link copied!',
                                    style: TextStyle(
                                      color: kBlueColor,
                                    ),
                                  ),
                                ),
                              );
                            });
                          },
                          icon: const Icon(Icons.content_copy))
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "OK",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ))
            ],
          );
        });
  }

  bool _isDesktop() => !kIsWeb && !Platform.isAndroid && !Platform.isIOS;
}
