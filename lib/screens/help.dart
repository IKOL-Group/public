import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:public_app/Customs/CustomTextFormField.dart';
import 'package:public_app/colors/colors.dart';
import 'package:public_app/colors/text.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpPage extends StatefulWidget {
  HelpPage({Key key}) : super(key: key);

  static final route = "/help";

  @override
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Help",
          style: kPoppinsTextStyle,
        ),
        // https://stackoverflow.com/a/50461263/8608146
        titleSpacing: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        children: [
          SizedBox(height: 30.0),
          Align(
            alignment: Alignment.center,
            child: Link(
              content: 'Request For a call back',
              url:
                  'https://stackoverflow.com/questions/43583411/how-to-create-a-hyperlink-in-flutter-widget',
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ElevatedButton(
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                          vertical: 2.0, horizontal: 30.0)),
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> state) {
                        return kGreenColor;
                      }),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                      )),
                  onPressed: () {
                    buildCallBackPopUp();
                  },
                  child: Text('Click Here', style: kPoppinsTextStyle3)),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Paragraph(content: 'Or'),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              height: 150.0,
              width: width / 1.5,
              padding: EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(color: Colors.black, width: 2.0)),
              child: CustomTextFormFeild(
                hintName: 'Write your Queries here...',
                readOnly: false,
                obscureText: false,
                maxLines: 5,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ElevatedButton(
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                          vertical: 2.0, horizontal: 30.0)),
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> state) {
                        return kGreenColor;
                      }),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                      )),
                  onPressed: () {
                    buildQueryPopUp();
                  },
                  child: Text('Submit', style: kPoppinsTextStyle3)),
            ),
          ),
        ],
      ),
    );
  }

  buildCallBackPopUp() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            content: Text('Will Get Back To you Soon',
                textAlign: TextAlign.center, style: kPoppinsTextStyle),
            actions: [
              Row(
                children: [
                  ElevatedButton(
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(
                                  vertical: 2.0, horizontal: 30.0)),
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> state) {
                            return kGreenColor;
                          }),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                          )),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Back', style: kPoppinsTextStyle3)),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 4.5,
                  ),
                ],
              ),
            ],
          );
        });
  }

  buildQueryPopUp() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            content: Text('Query Submitted Successfully',
                textAlign: TextAlign.center, style: kPoppinsTextStyle),
            actions: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(
                                  vertical: 2.0, horizontal: 30.0)),
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> state) {
                            return kGreenColor;
                          }),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                          )),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Back', style: kPoppinsTextStyle3)),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 4,
                  ),
                ],
              ),
            ],
          );
        });
  }
}

class Paragraph extends StatelessWidget {
  const Paragraph({
    Key key,
    @required this.content,
    this.fontSize = 24,
  }) : super(key: key);

  final double fontSize;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 20),
      child: Text(
        content,
        style: kPoppinsTextStyleSize(fontSize: fontSize),
      ),
    );
  }
}

class Link extends StatelessWidget {
  const Link({
    Key key,
    @required this.content,
    @required this.url,
    this.fontSize = 17,
  }) : super(key: key);

  final double fontSize;
  final String content;
  final String url;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 18.0, top: 0),
        child: RichText(
          text: TextSpan(
            text: content,
            style: kPoppinsTextStyleSize(fontSize: fontSize)
                .copyWith(color: kLinkColor),
            recognizer: TapGestureRecognizer()..onTap = () => launch(url),
          ),
        ));
  }
}

        // style: kPoppinsTextStyleSize(fontSize: fontSize),