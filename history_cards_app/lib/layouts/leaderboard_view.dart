import 'package:flutter/material.dart';
import 'package:history_cards_app/globals.dart' as globals;
import 'package:history_cards_app/models/User.dart';

class LeaderBoardView extends StatefulWidget {
  @override
  _LeaderBoardViewState createState() => _LeaderBoardViewState();
}

class _LeaderBoardViewState extends State<LeaderBoardView> {
  int i = 0;
  Color my = Colors.brown, CheckMyColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    var r = TextStyle(color: Colors.blue, fontSize: 34);
    return Stack(
      children: <Widget>[
        Scaffold(
            body: Container(
          margin: EdgeInsets.only(top: 65.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 15.0, top: 55.0),
                child: RichText(
                    text: TextSpan(
                        text: "LESTVICA IGRALCEV",
                        style: TextStyle(color: Colors.red, fontSize: 30.0, fontWeight: FontWeight.bold))),
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Text(
                  'Razvrstitev igralcev po točkah: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Flexible(
                  child: FutureBuilder<List<User>>(
                      future: globals.dataStorage.getUsersForLeaderboard(),
                      builder: (context, userList) {
                        if (userList.hasData) {
                          i = 0;
                          return ListView.builder(
                              itemCount: userList.data.length,
                              itemBuilder: (context, index) {
                                if (index >= 1) {
                                  if (userList.data[index].points == userList.data[index - 1].points) {
                                  } else {
                                    i++;
                                  }
                                }
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                                  child: InkWell(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: i == 0
                                                  ? Colors.amber
                                                  : i == 1
                                                      ? Colors.grey
                                                      : i == 2
                                                          ? Colors.brown
                                                          : Colors.white,
                                              width: 3.0,
                                              style: BorderStyle.solid),
                                          borderRadius: BorderRadius.circular(5.0)),
                                      width: MediaQuery.of(context).size.width,
                                      child: Column(
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(top: 10.0, left: 15.0),
                                                child: Row(
                                                  children: <Widget>[
                                                    CircleAvatar(
                                                        child: Container(
                                                            decoration: BoxDecoration(
                                                                shape: BoxShape.circle,
                                                                image: DecorationImage(
                                                                    image: Image.asset(
                                                                        'assets/images/userImage.png').image,
                                                                    fit: BoxFit.fill)))),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(left: 10.0, top: 10.0, bottom: 10.0),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Container(
                                                        alignment: Alignment.centerLeft,
                                                        child: Text(
                                                          userList.data[index].username,
                                                          style: TextStyle(
                                                              color: Colors.blue, fontWeight: FontWeight.w500),
                                                          maxLines: 6,
                                                        )),
                                                    Text("Točke: " + userList.data[index].points.toString()),
                                                  ],
                                                ),
                                              ),
                                              Flexible(child: Container()),
                                              i == 0
                                                  ? Text("🥇", style: r)
                                                  : i == 1
                                                      ? Text(
                                                          "🥈",
                                                          style: r,
                                                        )
                                                      : i == 2
                                                          ? Text(
                                                              "🥉",
                                                              style: r,
                                                            )
                                                          : Text(''),
                                              // Padding(
                                              //   padding: EdgeInsets.only(left: 20.0, top: 13.0, right: 20.0),
                                              //   child: RaisedButton(
                                              //     onPressed: () {},
                                              //     child: Text(
                                              //       "Challenge",
                                              //       style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                              //     ),
                                              //     color: Colors.deepPurple,
                                              //   ),
                                              // ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              });
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      }))
            ],
          ),
        )),
      ],
    );
  }
}
