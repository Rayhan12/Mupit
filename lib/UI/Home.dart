import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:clay_containers/clay_containers.dart';
import 'package:mupit/Color_Ex.dart';
import 'package:mupit/Helper_Functions/Shared_Preference_Helper.dart';
import 'package:mupit/Services/Database.dart';
import 'package:mupit/Services/auth.dart';
import 'package:mupit/UI/ChatScreen.dart';
import 'package:mupit/UI/Sign_In.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Stream userInfo, chatRooms;
  bool state = false;
  TextEditingController searchBox = TextEditingController();

  SearchButtonOnClick() async {
    state = true;
    setState(() {});
    // if (searchBox.text.isNotEmpty) {
    //   userInfo2 = await Database().GetUserByName(searchBox.text);
    // }

    if (searchBox.text.isNotEmpty) {
      userInfo = await Database().GetUserByuserName(searchBox.text);
    }
    setState(() {});
  }

  String myName = "", myProfilePic = "", myEmail = "", myUserName = "";

  getMyInfo() async {
    myName = await SharedPreferenceHelper().getUserDisplayName();
    myProfilePic = await SharedPreferenceHelper().getUserProfileImage();
    myEmail = await SharedPreferenceHelper().getUserEmail();
    myUserName = await SharedPreferenceHelper().getUserName();
  }

  getCahtRoomID(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  // ignore: non_constant_identifier_names

  GetChatRooms() async {
    chatRooms = await Database().GetChatRooms();
    setState(() {});
  }

  GetInfo() async {
    await getMyInfo();
    GetChatRooms();
  }

  @override
  void initState() {
    // TODO: implement initState
    GetInfo();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // GetChatRooms();
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        //Implementing AppBar-----------------------------------------------------_----------------
        appBar: AppBar(
          iconTheme: IconThemeData(color: Ex_Color.primary),
          title: Text(
            "Mupit",
            style: TextStyle(
                fontFamily: "Niconne",
                color: Ex_Color.primary,
                fontWeight: FontWeight.w400,
                fontSize: 40),
          ),
          centerTitle: true,
          backgroundColor: Ex_Color.background,
          elevation: 0,
        ),

        //Background Color=---------------------------------------------------------------------------
        backgroundColor: Ex_Color.background,

        // Implementing Drawer -------------------------------------------------------------------------
        drawer: Drawer(
          child: SafeArea(
            child: Container(
              color: Ex_Color.background,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * .55,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClayContainer(
                          depth: 20,
                          borderRadius: 80,
                          spread: 10,
                          surfaceColor: Ex_Color.background,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              clipBehavior: Clip.hardEdge,
                              height: 110,
                              width: 110,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(70),
                              ),
                              child: Image(
                                image: myProfilePic != null
                                    ? NetworkImage(myProfilePic)
                                    : AssetImage("Assets/Images/google.png"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            myName,
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: 23,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        FittedBox(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(Icons.email,
                                    color: Ex_Color.secondary, size: 25),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  myEmail != null ? myEmail : "Loading....",
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        FittedBox(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(Icons.person,
                                    color: Ex_Color.secondary, size: 25),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  myEmail != null
                                      ? myEmail.replaceAll("@gmail.com", "")
                                      : "Loading.....",
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  ClayContainer(
                    width: 200,
                    depth: 20,
                    child: FlatButton.icon(
                      label: Text(
                        "Log Out",
                        style: TextStyle(color: Colors.black45, fontSize: 17),
                      ),
                      icon: Icon(
                        Icons.logout,
                        color: Ex_Color.primary,
                        size: 30,
                      ),
                      onPressed: () {
                        AuthMethod().SingOut().then((value) {
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) {
                            return SignIn();
                          }));
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          elevation: 4,
        ),

        //Main Body Of the app-------------------------------------------------------------------------------------

        body: ListView(
          scrollDirection: Axis.vertical,
          children: [
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (searchBox.text != "")
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        state = false;
                        searchBox.text = "";
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: ClayContainer(
                        depth: 20,
                        height: 50,
                        width: 50,
                        borderRadius: 25,
                        child: Icon(
                          Icons.arrow_back,
                          color: Ex_Color.primary,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: ClayContainer(
                      surfaceColor: Color(0xfff7f7f7),
                      height: size.height * 0.07,
                      depth: 20,
                      borderRadius: 25,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Container(
                          height: size.height * 0.07,
                          width: size.width * 0.8,
                          decoration: BoxDecoration(
                              color: Ex_Color.background,
                              border: Border.all(
                                  color: Color(0xfff7f7f7),
                                  style: BorderStyle.solid,
                                  width: 2),
                              borderRadius: BorderRadius.circular(25)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: TextField(
                                  onChanged: (value) {
                                    SearchButtonOnClick();
                                  },
                                  controller: searchBox,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Search by Name",
                                      hintStyle: TextStyle(
                                        fontSize: 17,
                                        color: Colors.black45,
                                      )),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  if (searchBox.text.isNotEmpty) {
                                    SearchButtonOnClick();
                                  }
                                },
                                child: Icon(
                                  Icons.search,
                                  color: Ex_Color.primary,
                                  size: 30,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            if (searchBox.text != "")
              StreamBuilder(
                  stream: userInfo,
                  builder: (context, snapshot) {
                    return snapshot.hasData
                        ? Container(
                            height: MediaQuery.of(context).size.height * 0.70,
                            child: ListView.builder(
                              //reverse: true,
                              key: Key(snapshot.data.docs.length.toString()),
                                itemCount: snapshot.data.docs.length,
                                itemBuilder: (context, index) {
                                  DocumentSnapshot ds =
                                      snapshot.data.docs[index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 15 , vertical: 5),
                                    child: ClayContainer(
                                      surfaceColor: Color(0xfff7f7f7),
                                      depth: 20,
                                      borderRadius: 25,
                                      child: Container(
                                        margin: EdgeInsets.symmetric(horizontal: 5),
                                        child: ListTile(
                                          leading: CircleAvatar(
                                            backgroundImage:
                                                NetworkImage(ds["profileurl"]),
                                          ),
                                          title: Text(
                                            ds["name"],
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          subtitle: Text(ds["email"]),
                                          onTap: () {
                                            //Importent Action------------------------
                                            //Importent Action------------------------
                                            //Importent Action------------------------
                                            var chatRoomID = getCahtRoomID(
                                                myUserName, ds["username"]);
                                            Map<String, dynamic>
                                                chatRoomInfoMap = {
                                              "users": [
                                                myUserName,
                                                ds["username"]
                                              ]
                                            };

                                            Database().createChatRoom(
                                                chatRoomID, chatRoomInfoMap);

                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return ChatScreen(
                                                name: ds["name"],
                                                username: ds["username"],
                                                email: ds["email"],
                                                profileurl: ds["profileurl"],
                                              );
                                            }));
                                          },
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          )
                        : Center(child: Container(
                          child: Text("Sorry, This user doesn't exist" ,
                          style: TextStyle(
                            color: Colors.black26,
                            fontWeight: FontWeight.w300,
                            fontSize: 18
                          ),),
                    ));
                  }),


            if (searchBox.text == "")
              StreamBuilder(
                stream: chatRooms,
                builder: (context, snapshot) {
                  return snapshot.hasData
                      ? Container(
                          height: MediaQuery.of(context).size.height * 0.70,
                          child: ListView.builder(
                            key: Key(snapshot.data.docs.length.toString()),
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot ds = snapshot.data.docs[index];
                              return ChatRoomListView(
                                  chatRoomID: ds.id,
                                  lastMessage: ds["lastMessage"],
                                  myUserName: myUserName);
                            },
                          ),
                        )
                      : Center(child: CircularProgressIndicator());
                },
              ),
          ],
        ),
      ),
    );
  }
}

class ChatRoomListView extends StatefulWidget {
  final String chatRoomID, lastMessage, myUserName;

  ChatRoomListView(
      {@required this.chatRoomID,
      @required this.lastMessage,
      @required this.myUserName});

  @override
  _ChatRoomListViewState createState() => _ChatRoomListViewState();
}

class _ChatRoomListViewState extends State<ChatRoomListView> {
  String name = "", profileurl="", userName="";

  getThisUserInfo() async {
    userName = widget.chatRoomID.replaceAll(widget.myUserName, "").replaceAll("_", "");
    QuerySnapshot snapshot = await Database().GetUserSingle(userName);
    name = "${snapshot.docs[0]["name"]}";
    profileurl = "${snapshot.docs[0]["profileurl"]}";
    setState(() {});
  }

  starter()async
  {
     await getThisUserInfo();
  }

  @override
  void initState() {
    starter();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
            child: ClayContainer(
            surfaceColor: Color(0xfff7f7f7),
            depth: 20,
            borderRadius: 15,
            child: Container(
            margin: EdgeInsets.symmetric(horizontal: 5),
            child: ListTile(
              key: Key(name+widget.lastMessage),
              leading: CircleAvatar(
                backgroundImage:profileurl!="" ? NetworkImage(profileurl) : AssetImage("Assets/Images/google.png"),
              ),
              title: name !="" ? Text(name) : Text("Loading...."),
              subtitle:widget.lastMessage!=null ? Text(widget.lastMessage) : Text("Loading...."),

              onTap: ()
              {
                Navigator.push(context, MaterialPageRoute(
                    builder:(context)=> ChatScreen(name: name, username: userName, email: "", profileurl: profileurl)
                ));
              },

            )
    )
    )
      );
  }
}
