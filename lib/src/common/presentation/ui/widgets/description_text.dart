import 'package:flutter/material.dart';
import 'package:flutter_ebook_app/src/common/common.dart';

class DescriptionTextWidget extends StatefulWidget {
  final String text;

  const DescriptionTextWidget({super.key, required this.text});

  @override
  _DescriptionTextWidgetState createState() => _DescriptionTextWidgetState();
}

class _DescriptionTextWidgetState extends State<DescriptionTextWidget> {
  late String firstHalf;
  late String secondHalf;

  bool flag = true;

  @override
  void initState() {
    super.initState();
    _splitText(); // Phân chia đoạn văn bản thành hai phần khi widget được khởi tạo
  }

  void _splitText() {
    if (widget.text.length > 300) { // Nếu đoạn văn bản dài hơn 300 ký tự
      firstHalf = widget.text.substring(0, 300); // Lấy 300 ký tự đầu tiên
      secondHalf = widget.text.substring(300, widget.text.length); // Lấy phần còn lại
    } else {
      firstHalf = widget.text; // Nếu đoạn văn bản không quá dài, sử dụng toàn bộ nội dung
      secondHalf = ''; // Không có phần thứ hai
    }
  }

  @override
  void didUpdateWidget(covariant DescriptionTextWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) { // Nếu nội dung văn bản thay đổi
      _splitText(); // Phân chia lại đoạn văn bản
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: secondHalf.isEmpty
          ? Text(
              (flag ? firstHalf : (firstHalf + secondHalf))
                  .replaceAll(r'\n', '\n')
                  .replaceAll(r'\r', '')
                  .replaceAll(r"\'", "'"),
              style: TextStyle(
                fontSize: 16.0,
                color: context.theme.textTheme.bodySmall!.color,
              ),
            )
          : Column(
              children: <Widget>[
                Text(
                  (flag ? ('$firstHalf...') : (firstHalf + secondHalf))
                      .replaceAll(r'\n', '\n\n')
                      .replaceAll(r'\r', '')
                      .replaceAll(r"\'", "'"),
                  style: TextStyle(
                    fontSize: 16.0,
                    color: context.theme.textTheme.bodySmall!.color,
                  ),
                ),
                GestureDetector(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        flag ? 'show more' : 'show less',
                        style: const TextStyle(color: Colors.blue),
                      ),
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      flag = !flag; // Khi nhấn vào nút, đảo ngược trạng thái để hiển thị hoặc ẩn phần còn lại của văn bản
                    });
                  },
                ),
              ],
            ),
    );
  }
}
