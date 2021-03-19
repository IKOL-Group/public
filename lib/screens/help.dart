import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Help",
          style: kPoppinsTextStyle,
        ),
        // https://stackoverflow.com/a/50461263/8608146
        titleSpacing: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        child: Align(
          alignment: Alignment.topLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 29),
              ),
              Link(
                content: 'How to use Our App (Videos)',
                url:
                    'https://stackoverflow.com/questions/43583411/how-to-create-a-hyperlink-in-flutter-widget',
              ),
              Paragraph(content: 'FAQ\'s'),
              Link(
                content: 'Read These Questions',
                url:
                    'https://stackoverflow.com/questions/43583411/how-to-create-a-hyperlink-in-flutter-widget',
              ),
              Paragraph(content: 'Support Request'),
              Link(
                content: 'Report An Issue',
                url:
                    'https://stackoverflow.com/questions/43583411/how-to-create-a-hyperlink-in-flutter-widget',
              ),
              Padding(padding: EdgeInsets.only(top: 20)),
              Paragraph(
                  fontSize: 22, content: 'Voice Support (MON-FRI 9AM-6PM)'),
            ],
          ),
        ),
      ),
    );
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