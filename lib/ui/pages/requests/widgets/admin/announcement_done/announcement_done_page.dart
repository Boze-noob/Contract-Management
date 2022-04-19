import 'dart:ui';
import 'package:contract_management/_all.dart';
import 'package:flutter/material.dart';

class AnnouncementDonePage extends StatefulWidget {
  final AnnouncementModel announcementModel;
  final Function(String declineComment) announcementDeclineOnTap;
  const AnnouncementDonePage({
    Key? key,
    required this.announcementModel,
    required this.announcementDeclineOnTap,
  }) : super(key: key);

  @override
  _AnnouncementDonePageState createState() => _AnnouncementDonePageState();
}

class _AnnouncementDonePageState extends State<AnnouncementDonePage> {
  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          dragDevices: {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
          },
        ),
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal: 20),
          children: [
            Align(
              alignment: Alignment.center,
              child: CustomText(
                text: 'Announcement inspect',
                color: Colors.black,
                size: context.textSizeXXL,
                weight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            AnnouncementDataWidget(
              isEmpty: false,
              announcementModel: widget.announcementModel,
            ),
            BillDataWidget(
              isEmpty: false,
              announcementId: widget.announcementModel.id,
            ),
            WorkDiaryDataWidget(
              isEmpty: false,
              announcementId: widget.announcementModel.id,
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Button(
                  text: 'Decline',
                  shrinkWrap: true,
                  onTap: () => showDialog(
                    context: context,
                    builder: (context) => CustomDialog(
                      buttonText: 'Send',
                      onButtonPressed: () => widget.announcementDeclineOnTap(textEditingController.text.value),
                      message: 'Enter comment',
                      child: TextFormField(
                        controller: textEditingController,
                        style: TextFormFieldStyle.inputFieldTextStyle(),
                        decoration: TextFormFieldStyle.inputDecoration('Start typing...'),
                      ),
                    ),
                  ),
                  color: Colors.red,
                ),
                SizedBox(
                  width: 20,
                ),
                //TODO add logic
                Button(
                  text: 'Approve',
                  shrinkWrap: true,
                  onTap: () => showDialog(
                      context: context,
                      builder: (context) => CustomDialog(
                            message: 'Enter profit',
                            child: TextFormField(
                              style: TextFormFieldStyle.inputFieldTextStyle(),
                              decoration: TextFormFieldStyle.inputDecoration('Start typing'),
                            ),
                          )),
                  color: active,
                ),
              ],
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
