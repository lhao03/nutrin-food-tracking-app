import 'package:custom_navigator/custom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:mobileapp/model/tracked_food.dart';
import 'package:mobileapp/model/tracker.dart';
import 'package:mobileapp/model/user.dart';
import 'package:mobileapp/screens/main/bottomnav.dart';
import 'package:mobileapp/screens/search/createnewfood.dart';
import 'package:mobileapp/screens/search/foodpage.dart';
import 'package:mobileapp/services/client.dart';
import 'package:mobileapp/services/database.dart';
import 'package:provider/provider.dart';

class Search extends StatefulWidget {
  final String mealName;
  const Search(this.mealName);
  @override
  _SearchTestState createState() => _SearchTestState();
}

class _SearchTestState extends State<Search> {
  List<TrackedFood> searchedFoods = new List();
  var searchQueary = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var tracker = Provider.of<Tracker>(context);
    if (tracker == null) {
      return CircularProgressIndicator();
    }
    return searchPage();
  }

  Widget searchPage() {
    var tracker = Provider.of<Tracker>(context);
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateNewFoodPage(widget.mealName,
                      tracker.directory == null ? [] : tracker.directory),
                ),
              );
            },
            backgroundColor: Theme.of(context).primaryColor,
            child: Icon(
              Icons.add,
              size: 35,
            ),
          ),
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Expanded(
                  child: TabBarView(
                    children: [
                      searchView(),
                      myFoodsView(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          appBar: myAppBar(),
        ),
      ),
    );
  }

  Widget myAppBar() {
    var user = Provider.of<User>(context);
    var tracker = Provider.of<Tracker>(context);
    return AppBar(
      centerTitle: true,
      title: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return StreamProvider<Tracker>.value(
                      value: DatabaseService(uid: user.uid).tracker,
                      child: CustomNavigator(
                        home: NavigationBar(),
                        pageRoute: PageRoutes.materialPageRoute,
                      ),
                    );
                  },
                ),
              );
            },
          ),
          Text(
            widget.mealName.substring(0, 1).toUpperCase() +
                widget.mealName.substring(1, widget.mealName.length),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 100,
              height: 50,
              child: TextFormField(
                controller: searchQueary,
              ),
              // RaisedButton(
              //   onPressed: () {
              //     // var food = FoodClient();
              //     // print('pressed');
              //     // food.foodQueryForId('cake');
              //     // food.foodQueryWithId(174943);
              //   },
              // ),
            ),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).primaryColor,
      bottom: TabBar(tabs: <Widget>[
        Tab(
          text: 'SEARCH',
        ),
        Tab(
          text: "MY FOODS",
        ),
      ]),
    );
  }

  Widget buttons() {
    return Row(
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.camera_alt),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget myFoodsView() {
    var tracker = Provider.of<Tracker>(context);
    List<TrackedFood> userFoods = tracker.directory
        .where((food) =>
            food.name.toLowerCase().contains(searchQueary.text.toLowerCase()))
        .toList();
    return ListView.builder(
        itemCount: userFoods.length,
        itemBuilder: (BuildContext context, int index) {
          TrackedFood food = userFoods[index];
          return Card(
            child: ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        FoodPage(widget.mealName, food, tracker.mealsList),
                  ),
                );
              },
              title: Text(food.name),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(food.serving + " " + food.unit),
                ],
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(food.carbohydrates +
                      "C " +
                      food.protein +
                      "P " +
                      food.fat +
                      "F "),
                  Text(food.calculateCalories() + " CAL"),
                ],
              ),
            ),
          );
        });
  }

  Widget searchView() {
    return ListView.builder(itemBuilder: (BuildContext context, int index) {});
  }
}
