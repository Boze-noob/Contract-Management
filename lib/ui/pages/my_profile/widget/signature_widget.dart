import 'package:contract_management/_all.dart';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class SignaturePad extends StatefulWidget {
  final double? width;
  final double? height;
  final double penStrokeWidth;
  final Color penColor;
  final Color backgroundColor;
  final void Function()? onClear;
  final void Function(ui.Image)? onChange;

  SignaturePad({
    Key? key,
    this.width,
    this.height,
    this.penStrokeWidth = 3,
    this.penColor = Colors.black,
    this.backgroundColor = Colors.white,
    this.onClear,
    this.onChange,
  }) : super(key: key);

  @override
  State<SignaturePad> createState() => _SignaturePadState();
}

class _SignaturePadState extends State<SignaturePad> {
  late SignatureController _controller;
  bool autoGenerated = false;

  @override
  void initState() {
    super.initState();
    _controller = SignatureController(
      penStrokeWidth: widget.penStrokeWidth,
      penColor: widget.penColor,
      exportBackgroundColor: widget.backgroundColor,
      onDrawEnd: () async {
        final image = await _controller.toImage();

        if (image != null) {
          widget.onChange?.call(image);
        }
      },
    );
  }

  void _clear() {
    _controller.clear();
    setState(() => autoGenerated = false);
    widget.onClear?.call();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 25,
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.black38, width: 2.0),
                ),
              ),
              width: widget.width ?? context.screenWidth,
              height: widget.height ?? context.screenHeight,
              child: Signature(
                controller: _controller,
                width: widget.width ?? context.screenWidth,
                height: widget.height ?? context.screenHeight,
                backgroundColor: widget.backgroundColor,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            InkWell(
              onTap: _clear,
              child: Text(
                'Clear',
                style: TextStyle(color: Color(0xFFC42A03).withOpacity(0.7), fontWeight: FontWeight.w600, fontSize: 14),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        CustomText(
          text: 'Your signature',
          size: context.textSizeM,
          color: Colors.black,
          weight: FontWeight.normal,
        ),
      ],
    );
  }
}
