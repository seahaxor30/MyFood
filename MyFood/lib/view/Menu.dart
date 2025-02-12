import 'dart:developer';
import 'package:path/path.dart' as Path;
import 'package:myfood/view/MainPage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myfood/models/recipe.dart';
import 'package:intl/intl.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:myfood/view/MenuDetail.dart';
import 'package:myfood/app/services/api_keys.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Menu extends StatefulWidget {
  Menu({Key? key}) : super(key: key);

  @override
  MenuState createState() => MenuState();
}

FirebaseAuth auth = FirebaseAuth.instance;
////TextEditingController _textController = TextEditingController();
////TextEditingController _amountController = TextEditingController();
//Future getPosts() async {
//  var db = FirebaseFirestore.instance;
//  final User? user = auth.currentUser;
//  final uid = user?.uid;

//  //var ref = db.collection("Users").doc(uid).collection("Drawer");
//  //var querySnapshot = await ref.get();
//  //var totalE = querySnapshot.docs.length;
//  QuerySnapshot qn =
//      await db.collection("Users").doc(uid).collection("Drawer").get();

//  return qn.docs;
//}

//class ListBuilder extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    final List<String> searchTerms = [];
//    getPosts();

//return FutureBuilder(
//  future: getPosts(),
//  builder: (_, snapshot) {
//    if (snapshot.connectionState == ConnectionState.waiting) {
//      return
//    } else {
//      return ListView.builder(
//          itemCount: snapshot.hasData ? snapshot.data.length : 0,
//          itemBuilder: (_, index) {});
//    }
//  },
//);
//Future<List<dynamic>> getGallery() async {
//  var db = FirebaseFirestore.instance;
//  final User? user = auth.currentUser;
//  final uid = user?.uid;
//  //QuerySnapshot qn  = db.collection("Users").doc(uid).collection("Drawer").get() as QuerySnapshot<Object?>;
//  QuerySnapshot qn =
//      await db.collection("Users").doc(uid).collection("Drawer").get();

//  return qn.docs;
//}

class MenuState extends State<Menu> {
  //late Future<FindRecipes> _recipeModel;

  //@override
  //void initState() {
  //  _recipeModel = APIManager().getRecipes();
  //  super.initState();
  //  //// docList = getDoc();
  //  //FutureBuilder(
  //  //  future: getDoc(),
  //  //  builder: (context, snapshot) {
  //  //    if (snapshot.hasData) {
  //  //      //List<QueryDocumentSnapshot> data =
  //  //      //    snapshot.data as List<QueryDocumentSnapshot>;
  //  //      docList = snapshot.data;
  //  //      return docList;
  //  //    }
  //  //  },
  //  //);
  //}
  //List ids = [];
  //    for (var j in recipeModel) {
  //      ids.add(j.id);
  //    }
  //print(ids);
  //String iD = ids.join(",");

  Future<List<QueryDocumentSnapshot>> getDoc() async {
    List<QueryDocumentSnapshot> docList = [];
    var db = FirebaseFirestore.instance;
    final User? user = auth.currentUser;
    final uid = user?.uid;

    await db
        .collection("Users")
        .doc(uid)
        .collection("Drawer")
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        docList.add(doc);
      });
    });
    print(docList);
    return docList;
  }

  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          width: deviceWidth,
          //height: deviceHeight,
          color: Colors.teal[50],
          child: Column(children: <Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              new Container(
                //margin: const EdgeInsets.only(bottom: 0),
                child: InkWell(
                    onTap: () {
                      //print("hi");
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => MainPage()));
                    },
                    child: Container(
                        padding: const EdgeInsets.all(0),
                        decoration: BoxDecoration(
                            color: Colors.black,
                            border: Border.all(width: 3),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        margin: EdgeInsets.only(
                            left: deviceWidth * .05,
                            right: deviceWidth * .15,
                            top: deviceHeight * .03),
                        width: deviceWidth * .15,
                        height: deviceHeight * .045,
                        //padding: EdgeInsets.only(left: 100),
                        child: Center(
                          child: Text(
                            "Back",
                            textAlign: TextAlign.center,
                            style: new TextStyle(
                                //fontSize: deviceWidth * .03,
                                //fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ))),
              ),
              Center(
                  child: new Container(
                height: 60,
                width: 100,
                margin: EdgeInsets.only(
                    left: deviceWidth * .0005, top: deviceWidth * .06),
                child: Image(
                  image: AssetImage("assets/images/logo_MyFood.png"),
                ),
              )),
            ]),
            new Expanded(child: RecipeCard()),
          ]),
        ));
  }
}

class RecipeCard extends StatelessWidget {
  //const MyStatelessWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    //Future<List<FindRecipes>> _findRecipes = APIManager().getRecipes();
    return Container(
        //margin: const EdgeInsets.all(0),

        child: FutureBuilder<List<FindRecipes>>(
            future: APIManager().getRecipes(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                //final FindRecipes = snapshot.data[index];

                //print(findRecipes);

                return ListView.builder(
                    itemCount: snapshot.data?.length,
                    itemBuilder: (BuildContext context, int index) => InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MenuDetail(
                                      findRecipes: snapshot.data![index])));
                        },
                        child: Container(
                          height: 300,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 0),
                          //decoration: BoxDecoration(
                          //  borderRadius: BorderRadius.circular(15),
                          //  image: DecorationImage(
                          //      image: NetworkImage(
                          //          "https://images.unsplash.com/photo-1579202673506-ca3ce28943ef"),
                          //      fit: BoxFit.fitWidth),
                          //),
                          child: Stack(children: <Widget>[
                            Align(
                              alignment: Alignment.topCenter,
                              child: Hero(
                                tag: snapshot.data![index].id,
                                child: Container(
                                  height: 220,
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              snapshot.data![index].image),
                                          fit: BoxFit.cover)),
                                ),
                                //child: Hero(
                                //  tag: RecipeModel.uri,
                                //  child: Image(
                                //      image: NetworkImage(RecipeModel.uri), fit: BoxFit.fill),
                                //),
                              ),
                            ),

                            //borderRadius: BorderRadius.all(Radius.circular(20),

                            //height: 220,
                            //decoration: BoxDecoration(
                            //    //color: Colors.red,
                            //image: DecorationImage(
                            //    image: NetworkImage(RecipeModel.uri),
                            //    fit: BoxFit.fill),

                            Positioned(
                                top: 130,
                                right: 10,
                                left: 10,
                                height: 140,
                                child: Card(
                                  color: Color.fromRGBO(255, 255, 255, 0.8),
                                  clipBehavior: Clip.antiAlias,
                                  //margin: const EdgeInsets.only(top: 100),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24)),
                                  child: //Stack(
                                      //  alignment: Alignment.center,
                                      //  children: [
                                      //    Ink.image(
                                      //      image: NetworkImage(Recipe.uri),
                                      //      fit: BoxFit.cover,
                                      //    ),
                                      Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10,
                                            bottom: 4.0,
                                            right: 10,
                                            left: 5),
                                        child: Row(children: <Widget>[
                                          Container(
                                              width: deviceWidth * .73,
                                              child: Flexible(
                                                  //color: Colors.amber,
                                                  //width: deviceWidth,
                                                  child: Text(
                                                snapshot.data![index].title,
                                                maxLines: 2,
                                                //softWrap: true,
                                                overflow: TextOverflow.ellipsis,
                                                style: new TextStyle(
                                                  fontSize: 22,
                                                  //color: Color.fromRGBO(229, 115, 44, 1.0),
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ))),
                                          Spacer(),
                                        ]),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 4.0,
                                        ),
                                        child: Row(children: <Widget>[
                                          RatingBar.builder(
                                            initialRating:
                                                snapshot.data![index].likes / 5,
                                            minRating: 1,
                                            itemSize: 25,
                                            direction: Axis.horizontal,
                                            allowHalfRating: true,
                                            itemCount: 5,
                                            itemPadding: EdgeInsets.symmetric(
                                                horizontal: 3.0),
                                            itemBuilder: (context, _) => Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                            onRatingUpdate: (rating) {
                                              print(rating);
                                            },
                                          ),
                                          //Spacer(),
                                        ]),
                                      ),
                                      //      Padding(
                                      //        padding: const EdgeInsets.only(
                                      //            top: 10,
                                      //            bottom: 4.0,
                                      //            right: 10,
                                      //            left: 5),
                                      //        child: Row(
                                      //          children: <Widget>[
                                      //            Text(
                                      //              "${snapshot.data?[index].id.toStringAsFixed(0)} Calories",
                                      //              //"100 Calories",
                                      //              style: new TextStyle(
                                      //                fontSize: 16,
                                      //                fontWeight: FontWeight.bold,
                                      //                //color: Color.fromRGBO(229, 115, 44, 1.0),
                                      //                color: Colors.black,
                                      //              ),
                                      //            ),
                                      //          ],
                                      //        ),
                                      //      ),
                                      //    ],
                                      //  ),
                                      //),
                                    ]),
                                  ),
                                ))
                          ]),
                        )));
              }
              if (snapshot.hasError) {
                print('Error: ${snapshot.error}');
                return Text('Error: ${snapshot.error}');
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }));
  }
}

//  Widget buildRecipeCard(BuildContext context, int index) {
//    final findRecipes = findRecipesFromJson(snapshot.data);

//    double deviceWidth = MediaQuery.of(context).size.width;
//    double deviceHeight = MediaQuery.of(context).size.height;
//    //if () {}
//    return
//        //new InkWell(
//        //    onTap: () {
//        //      //print(docList)
//        //      Navigator.push(
//        //          context,
//        //          MaterialPageRoute(
//        //              builder: (context) => MenuDetail(recipeModel: RecipeModel)));
//        //    },child:
//        Container(
//      height: 300,
//      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
//      //decoration: BoxDecoration(
//      //  borderRadius: BorderRadius.circular(15),
//      //  image: DecorationImage(
//      //      image: NetworkImage(
//      //          "https://images.unsplash.com/photo-1579202673506-ca3ce28943ef"),
//      //      fit: BoxFit.fitWidth),
//      //),
//      child: Stack(children: <Widget>[
//        Align(
//          alignment: Alignment.topCenter,
//          child: Hero(
//            tag: findRecipes.image,
//            child: Container(
//              height: 220,
//              decoration: BoxDecoration(
//                  borderRadius: BorderRadius.all(Radius.circular(20)),
//                  image: DecorationImage(
//                      image: NetworkImage(RecipeModel.uri), fit: BoxFit.cover)),
//            ),
//            //child: Hero(
//            //  tag: RecipeModel.uri,
//            //  child: Image(
//            //      image: NetworkImage(RecipeModel.uri), fit: BoxFit.fill),
//            //),
//          ),
//        ),

//        //borderRadius: BorderRadius.all(Radius.circular(20),

//        //height: 220,
//        //decoration: BoxDecoration(
//        //    //color: Colors.red,
//        //image: DecorationImage(
//        //    image: NetworkImage(RecipeModel.uri),
//        //    fit: BoxFit.fill),

//        Positioned(
//          top: 130,
//          right: 10,
//          left: 10,
//          height: 158,
//          child: Card(
//            color: Color.fromRGBO(255, 255, 255, 0.8),
//            clipBehavior: Clip.antiAlias,
//            //margin: const EdgeInsets.only(top: 100),
//            shape:
//                RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
//            child: //Stack(
//                //  alignment: Alignment.center,
//                //  children: [
//                //    Ink.image(
//                //      image: NetworkImage(Recipe.uri),
//                //      fit: BoxFit.cover,
//                //    ),
//                Padding(
//              padding: const EdgeInsets.all(10),
//              child: Column(
//                children: <Widget>[
//                  Padding(
//                    padding: const EdgeInsets.only(
//                        top: 10, bottom: 4.0, right: 10, left: 5),
//                    child: Row(children: <Widget>[
//                      Container(
//                          width: deviceWidth * .73,
//                          child: Flexible(
//                              //color: Colors.amber,
//                              //width: deviceWidth,
//                              child: Text(
//                            RecipeModel.title,
//                            maxLines: 2,
//                            //softWrap: true,
//                            overflow: TextOverflow.ellipsis,
//                            style: new TextStyle(
//                              fontSize: 22,
//                              //color: Color.fromRGBO(229, 115, 44, 1.0),
//                              color: Colors.black,
//                              fontWeight: FontWeight.bold,
//                            ),
//                          ))),
//                      Spacer(),
//                    ]),
//                  ),
//                  Padding(
//                    padding: const EdgeInsets.only(
//                      top: 4.0,
//                    ),
//                    child: Row(children: <Widget>[
//                      RatingBar.builder(
//                        initialRating: RecipeModel.rating,
//                        minRating: 1,
//                        itemSize: 25,
//                        direction: Axis.horizontal,
//                        allowHalfRating: true,
//                        itemCount: 5,
//                        itemPadding: EdgeInsets.symmetric(horizontal: 3.0),
//                        itemBuilder: (context, _) => Icon(
//                          Icons.star,
//                          color: Colors.amber,
//                        ),
//                        onRatingUpdate: (rating) {
//                          print(rating);
//                        },
//                      ),
//                      //Spacer(),
//                    ]),
//                  ),
//                  Padding(
//                    padding: const EdgeInsets.only(
//                        top: 10, bottom: 4.0, right: 10, left: 5),
//                    child: Row(
//                      children: <Widget>[
//                        Text(
//                          "${RecipeModel.calories.toStringAsFixed(0)} Calories",
//                          style: new TextStyle(
//                            fontSize: 16,
//                            fontWeight: FontWeight.bold,
//                            //color: Color.fromRGBO(229, 115, 44, 1.0),
//                            color: Colors.black,
//                          ),
//                        ),
//                      ],
//                    ),
//                  ),
//                ],
//              ),
//            ),
//          ),
//        ),
//      ]),
//    );
//  }
//}
