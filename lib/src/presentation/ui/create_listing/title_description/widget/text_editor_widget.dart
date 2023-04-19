import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';

abstract class TextEditorListener {
  void onSave(String content);
}

class TextEditorWidget extends StatefulWidget {
  late String title;
  late String content;
  late int limitCount;

  // late int currentCount;

  final TextEditorListener? listener;

  // String? _rawContent;

  TextEditorWidget({Key? key, String? title, String? content, this.listener, int? limitCount})
      : super(key: key) {
    this.title = title ?? "";
    this.content = content ?? "";
    this.limitCount = limitCount ?? 2000;
  }

  @override
  State<TextEditorWidget> createState() => _TextEditorWidgetState();
}

class _TextEditorWidgetState extends State<TextEditorWidget> {
  final HtmlEditorController controller = HtmlEditorController();
  late int currentCount;
  late String currentContent;
  bool justPasted = false;

  @override
  void initState() {
    super.initState();
    currentCount = _removeAllHtml(widget.content).length;
    currentContent = widget.content;
  }

  String _removeAllHtml(String strHtml) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return strHtml.replaceAll(exp, '');
  }

  String _formatCharacterCount() {
    return "$currentCount/${widget.limitCount}";
  }

  void updateCurrentCharacterCount(int count) {
    setState(() {
      currentCount = count;
    });
  }

  String _removeLink(String strHtml) {
    // Regex for anchor tags
    final regex = RegExp(r"<a[^>]*>([^<]+)<\/a>");
    // Remove all of them
    String noUrls = strHtml;
    while (true) {
      final match = regex.firstMatch(noUrls);
      if (match == null) {
        break;
      }
      // wLog(match.groupCount.toString());
      // wLog(match.group(0).toString()); // All string
      // wLog(match.group(1).toString());
      String replace = match.group(1).toString();
      noUrls = noUrls.replaceFirst(regex, replace);
    }
    return noUrls;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          widget.title + "   " + _formatCharacterCount(),
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.save, color: Colors.black),
            onPressed: () {
              controller.getText().then((value) {
                // wLog(value);
                if (value.isNotEmpty) {
                  widget.listener?.onSave(_removeLink(value));
                }
                Navigator.pop(context);
              });
              // Clear text editor
              // controller.editorController?.reload();
            },
          ),
          IconButton(
            icon: const Icon(Icons.cancel, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     controller.toggleCodeView();
      //   },
      //   child: const Text(r'<\>', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      // ),
      body: HtmlEditor(
        controller: controller,
        htmlEditorOptions: const HtmlEditorOptions(
          hint: 'Nhập mô tả chung về bất động sản của bạn',
          shouldEnsureVisible: true,
          // characterLimit: 30, khong su dung dc
          // initialText: "<p>text content initial, if any</p>",
        ),
        htmlToolbarOptions: HtmlToolbarOptions(
          toolbarPosition: ToolbarPosition.aboveEditor,
          //by default
          toolbarType: ToolbarType.nativeScrollable,
          defaultToolbarButtons: [
            const OtherButtons(
                fullscreen: false, codeview: false, help: false, copy: false, paste: false),
            const FontButtons(
                clearAll: false, strikethrough: false, superscript: false, subscript: false),
            const ListButtons(listStyles: false),
          ],
          customToolbarButtons: [],
          customToolbarInsertionIndices: [],
          onButtonPressed: (ButtonType type, bool? status, Function? updateStatus) {
            // wLog("button '${describeEnum(type)}' pressed, the current selected status is $status");
            return true;
          },
        ),
        otherOptions: OtherOptions(height: MediaQuery.of(context).size.height - 105),
        callbacks: Callbacks(
          onBeforeCommand: (String? currentHtml) {
            // eLog("onBeforeCommand");
          },
          onChangeContent: (String? changed) {
            // eLog('content changed to $changed');
            // Cho nay characterCount run cung ko dung
            // eLog('onChangeContent count: ${controller.characterCount}');
            if (currentContent == (changed ?? '')) {
              return;
            }
            if (justPasted) {
              justPasted = false;
              currentCount = _removeAllHtml(changed ?? "").length;
              updateCurrentCharacterCount(currentCount);
              return;
            }
            // Khi nhap qua so luong ky tu, se nhap lai gia tri cu
            if (currentCount >= widget.limitCount &&
                ((changed ?? '').length >= widget.limitCount)) {
              // Set lai gia tri cu
              controller.setText(currentContent);
            } else {
              currentContent = changed ?? "";
              updateCurrentCharacterCount(_removeAllHtml(currentContent).length);
            }
          },
          onPaste: () {
            // eLog('pasted into editor');
            // eLog('onPaste: ${controller.characterCount}');
            justPasted = true;
          },
          // onKeyDown: (int? keyCode) {
          //   updateCurrentCharacterCount(controller.characterCount);
          // },
          onInit: () {
            // Clear text editor
            controller.setText(currentContent);
            // O day khong tinh dc characterCount
            // eLog('start count: ${controller.characterCount}');
          },
        ),
      ),
    );
  }
}
