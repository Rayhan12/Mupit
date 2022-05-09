import 'package:clay_containers/widgets/clay_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mupit/Helper_Functions/Shared_Preference_Helper.dart';
import 'package:mupit/Services/Database.dart';
import 'package:mupit/Services/auth.dart';
import 'package:random_string/random_string.dart';

import '../Color_Ex.dart';
import 'Sign_In.dart';

class ChatScreen extends StatefulWidget {

  final String name , email , profileurl , username;
  ChatScreen({@required this.name ,@required this.username , @required this.email , @required this.profileurl });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String chatRoomId , messageID="";
  Stream messageStream;
  String myName , myUserName , myProfilePic , myEmail;
  TextEditingController messageBox = TextEditingController();

  getMyInfo() async {
    myName = await SharedPreferenceHelper().getUserDisplayName();
    myProfilePic = await SharedPreferenceHelper().getUserProfileImage();
    myEmail = await SharedPreferenceHelper().getUserEmail();
    myUserName = await SharedPreferenceHelper().getUserName();

    chatRoomId =getCahtRoomID(myUserName , widget.username);
  }

  getCahtRoomID(String a , String b)
  {
    if(a.substring(0,1).codeUnitAt(0)>b.substring(0,1).codeUnitAt(0))
      {
        return "$b\_$a";
      }
    else
      {
        return "$a\_$b";
      }
  }

  addMassage(bool onClick)
  {
    if(messageBox.text.isNotEmpty) {
      String message = messageBox.text;
      var time = DateTime.now();

      Map<String, dynamic> messageInfo = {
        "message": message,
        "sender" : myUserName,
        "time" : time,
        "profileurl" : myProfilePic
      };

      if(messageID=="")
        {
          messageID = randomAlphaNumeric(12);
        }
      Database().addMessage(chatRoomId, messageID, messageInfo).
      then((value) {

        Map<String, dynamic> lastMessageInfo = {
          "lastMessage": message,
          "time" : time,
          "sender" : myUserName,
        };

        Database().UpdateLastMessageSend(chatRoomId, lastMessageInfo);
        if(onClick)
        {
          //Clearing massage box
          messageBox.text = "";
          //clearing message id
          messageID = "";
        }
      });


    }
  }

  getAndSetMessage() async {
      messageStream = await Database().GetChatRoomMessages(chatRoomId);
      setState(() {

      });
  }

  Widget messagesDecoration(String message , bool sendByMe)
  {
    return Row(
      mainAxisAlignment:sendByMe? MainAxisAlignment.end : MainAxisAlignment.start,
      children:[
        Padding(
          padding: EdgeInsets.symmetric(vertical: 5 , horizontal: 12),
          child: ClayContainer(
            depth: sendByMe? 25 : 15,
            borderRadius: 20,
            child: Container(
              key: Key(messageID),
              width: message.length>35 ? MediaQuery.of(context).size.width*0.7 : null,
              padding: EdgeInsets.symmetric(horizontal: 20 ,vertical: 10),
              //margin: EdgeInsets.symmetric(vertical: 5 , horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                  bottomLeft: sendByMe ? Radius.circular(20): Radius.circular(20),
                  bottomRight:sendByMe? Radius.circular(20) :Radius.circular(20)
                ),
                color: sendByMe? Ex_Color.secondary : Ex_Color.background
              ),
            child: Text(message ,
            overflow: TextOverflow.ellipsis,
            maxLines: 100,
            style: TextStyle(
              fontFamily: "Roboto",
              fontSize: 17,
              fontWeight: FontWeight.w400,
              color: sendByMe ? Colors.white : Ex_Color.primary
            ),
            ),
      ),
          ),
        ),
      ]
    );
  }



  Widget OurChat()
  {
    return StreamBuilder(
        stream: messageStream,
        builder: (context , snapShot)
    {
      return snapShot.hasData?
          ListView.builder(
            padding: EdgeInsets.only(bottom: 80 , top: 20),
            reverse: true,
            itemCount: snapShot.data.docs.length,
            itemBuilder: (context , index)
            {
              DocumentSnapshot ds = snapShot.data.docs[index];
              return messagesDecoration(ds["message"] , myUserName == ds["sender"]);
            },
          )
          : Text("No chats To Show..... \nStart Now");
    });
  }


  doThisWhenLunch() async
  {
    await getMyInfo();
    getAndSetMessage();
    setState(() {

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    doThisWhenLunch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Ex_Color.primary),
          title: Text(
            widget.name,
            style: TextStyle(
                fontFamily: "Roboto",
                color: Ex_Color.primary,
                fontWeight: FontWeight.w500,
                fontSize: 20),
          ),
          //centerTitle: true,
          backgroundColor: Ex_Color.background,
          leading:
            Padding(
              padding: const EdgeInsets.all(10),
              child: CircleAvatar(
                backgroundImage: NetworkImage(widget.profileurl),
              ),
            ),
          elevation: 5,
          automaticallyImplyLeading: false,
        ),
        backgroundColor: Ex_Color.background,
        // drawer: Drawer(
        //   child: Column(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     crossAxisAlignment: CrossAxisAlignment.center,
        //     children: [
        //       ClayContainer(
        //         width: 200,
        //         depth: 20,
        //         child: FlatButton.icon(
        //           label: Text(
        //             "Log Out",
        //             style: TextStyle(color: Colors.black45, fontSize: 17),
        //           ),
        //           icon: Icon(
        //             Icons.logout,
        //             color: Ex_Color.primary,
        //             size: 30,
        //           ),
        //           onPressed: () {
        //             AuthMethod().SingOut().then((value) {
        //               Navigator.pushReplacement(context,
        //                   MaterialPageRoute(builder: (context) {
        //                     return SignIn();
        //                   }));
        //             });
        //           },
        //         ),
        //       ),
        //     ],
        //   ),
        //   elevation: 4,
        // ),

        body: Container(
          child: Stack(
            //mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // ClayContainer(
              //   depth: 5,
              //   spread: 2,
              //   child: Container(
              //     color: Colors.white,
              //     child: ListTile(
              //       leading: CircleAvatar(backgroundImage: NetworkImage(widget.profileurl),),
              //       title: Text(widget.name ,
              //         style: TextStyle(
              //           color: Ex_Color.primary,
              //             fontSize: 17,
              //             fontWeight: FontWeight.w500),
              //       ),
              //       subtitle: Text(widget.email),
              //     ),
              //   ),
              // ),



              OurChat(),



              Container(
                //height: MediaQuery.of(context).size.height*.1,
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: size.height*0.09,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black12,
                            spreadRadius: 1,
                            blurRadius: 3,
                        )
                      ]
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15 ,vertical: 10),
                            child: ClayContainer(
                              depth: 20,
                              borderRadius: 15,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white30 , width: 2 , style: BorderStyle.solid),
                                  borderRadius: BorderRadius.circular(15)
                                ),
                                child: TextField(
                                  onSubmitted: (value){
                                    setState(() {
                                      addMassage(true);
                                    });
                                  },
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 20,
                                  controller: messageBox,
                                  style: TextStyle(
                                    fontSize: 20
                                  ),
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Aa",
                                      hintStyle: TextStyle(
                                        fontSize: 17,
                                        color: Colors.black45,
                                      ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            addMassage(true);
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClayContainer(
                            depth: 20,
                            borderRadius: 15,
                            child: Container(
                              height: 50,
                              width: 60,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white30 , style: BorderStyle.solid , width: 2 ),
                                borderRadius: BorderRadius.circular(15),
                                color: Ex_Color.background
                              ),
                              child: Icon(
                                Icons.send,
                                color: Ex_Color.primary,
                                size: 30,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),

      ),
    );
  }
}
