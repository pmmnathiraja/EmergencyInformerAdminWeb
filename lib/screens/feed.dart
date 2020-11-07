import 'package:firebase_auth/firebase_auth.dart';
import 'package:Emergency_Web/api/food_api.dart';
import 'package:Emergency_Web/notifier/food_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Feed extends StatefulWidget {
  Feed(this._userName) : super();
  final _userName;
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  @override
  void initState() {
    FoodNotifier foodNotifier =
        Provider.of<FoodNotifier>(context, listen: false);
    getFoods(foodNotifier, widget._userName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //  AuthNotifier authNotifier = Provider.of<AuthNotifier>(context);
    User _firebaseUser = FirebaseAuth.instance.currentUser;
    FoodNotifier foodNotifier = Provider.of<FoodNotifier>(context);

    Future<void> _refreshList() async {
      getFoods(foodNotifier, _firebaseUser.displayName);
    }

    print("building Feed");
    return Scaffold(
      body: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: RefreshIndicator(
              child: ListView.separated(
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: Image.network(
                      foodNotifier.foodList[index].image != null
                          ? foodNotifier.foodList[index].image
                          : 'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg',
                      height: 1080,
                      fit: BoxFit.fitWidth,
                      scale: 1,
                    ),
                    title: Text(foodNotifier.foodList[index].name),
                    subtitle: Text(foodNotifier.foodList[index].category),
                    onTap: () {
                      foodNotifier.currentFood = foodNotifier.foodList[index];
                    },
                  );
                },
                itemCount: foodNotifier.foodList.length,
                separatorBuilder: (BuildContext context, int index) {
                  return Divider(
                    color: Colors.black,
                  );
                },
              ),
              onRefresh: _refreshList,
            ),
          ),
          Expanded(
            flex: 8,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  foodNotifier.currentFood != null
                      ? SingleChildScrollView(
                          child: Center(
                            child: Container(
                              child: Column(
                                children: <Widget>[
                                  Image.network(
                                    foodNotifier.currentFood.image != null
                                        ? foodNotifier.currentFood.image
                                        : 'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg',
                                    width: MediaQuery.of(context).size.width,
                                    fit: BoxFit.fitWidth,
                                  ),
                                  SizedBox(height: 24),
                                  Text(
                                    foodNotifier.currentFood.name,
                                    style: TextStyle(
                                      fontSize: 35,
                                    ),
                                  ),
                                  SizedBox(height: 24),
                                  Text(
                                    'Description  :  ${foodNotifier.currentFood.category}',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontStyle: FontStyle.italic),
                                  ),
                                  SizedBox(height: 50),
                                ],
                              ),
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
