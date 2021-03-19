import 'package:flutter/material.dart';
import 'package:public_app/colors/colors.dart';
import 'package:public_app/colors/text.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key}) : super(key: key);

  static final route = "/profile";

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.greenAccent,
      appBar: AppBar(
        title: Text(
          "My Account",
          style: TextStyle(
              color: Theme.of(context).appBarTheme.titleTextStyle.color),
        ),
        // https://stackoverflow.com/a/50461263/8608146
        titleSpacing: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (v) {
              if (v == "Logout") {
                // TODO logout
              }
              print("Selected $v");
            },
            icon: Icon(Icons.more_vert, color: Colors.black),
            itemBuilder: (BuildContext context) {
              return {'Logout'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(
                    choice,
                    style: kPoppinsTextStyleSize(fontSize: 16),
                  ),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Container(
        child: Center(
          child: ListView(
            padding: EdgeInsets.only(top: 13),
            children: [
              ProfileCard(
                icon: Icons.phone_android_rounded,
                title: 'Mobile Number',
                subtitle: '+91 9191919191',
                mono: true,
              ),
              ProfileCard(
                icon: Icons.email,
                title: 'Email',
                subtitle: 'something@email.com',
              ),
              ProfileCard(
                icon: Icons.vpn_key_rounded,
                title: 'Password',
                subtitle: 'Tap To Change Password',
              ),
              ProfileCard(
                icon: Icons.business,
                title: 'Company Name',
                subtitle: 'BleuDrat',
              ),
              ProfileCard(
                icon: Icons.contacts_rounded,
                title: 'EmployeeID',
                subtitle: '1931920320',
                mono: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    Key key,
    @required this.icon,
    @required this.title,
    @required this.subtitle,
    this.mono: false,
  }) : super(key: key);

  final double cardHeight = 90;
  final IconData icon;
  final String title;
  final String subtitle;
  final bool mono;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 0,
        left: 10,
        right: 10,
        top: 10,
      ),
      child: SizedBox(
        height: cardHeight,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 11,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 14, right: 14),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Icon(
                    icon,
                    size: 40,
                    color: kGreyIconColor,
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: kPoppinsTextStyleSize(fontSize: 24),
                  ),
                  Text(
                    subtitle,
                    style: kSubtitleTextStyleSize(fontSize: 14, mono: mono)
                        .copyWith(
                      color: Colors.black87,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
