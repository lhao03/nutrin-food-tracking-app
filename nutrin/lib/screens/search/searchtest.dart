import 'package:flutter/material.dart';
import 'package:mobileapp/model/tracked_food.dart';
import 'package:mobileapp/model/tracker.dart';
import 'package:mobileapp/screens/search/createnewfood.dart';
import 'package:mobileapp/screens/search/foodpage.dart';
import 'package:provider/provider.dart';

class Search extends StatefulWidget {
  final String mealName;
  const Search(this.mealName);
  @override
  _SearchTestState createState() => _SearchTestState();
}

class _SearchTestState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    var tracker = Provider.of<Tracker>(context);
    if (tracker == null) {
      return CircularProgressIndicator();
    }
    return searchPage();
  }

  Widget searchPage() {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateNewFoodPage(widget.mealName),
                ),
              );
            },
            backgroundColor: Theme.of(context).primaryColor,
            child: Icon(
              Icons.add,
              size: 35,
            ),
          ),
          body: TabBarView(
            children: [
              searchView(),
              myFoodsView(),
            ],
          ),
          appBar: myAppBar(),
        ),
      ),
    );
  }

  Widget myAppBar() {
    final _searchFormkey = GlobalKey<FormState>();
    var _searchQuery = TextEditingController();
    return AppBar(
      titleSpacing: 0,
      backgroundColor: Theme.of(context).primaryColor,
      bottom: TabBar(tabs: <Widget>[
        Tab(
          text: 'SEARCH',
        ),
        Tab(
          text: "MY FOODS",
        ),
      ]),
      title: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Container(
                child: Text(widget.mealName.substring(0, 1).toUpperCase() +
                    widget.mealName.substring(1, widget.mealName.length))),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: <Widget>[
                  Form(
                    key: _searchFormkey,
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 10.0),
                          child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: new BorderRadius.circular(5.0),
                              ),
                              width: MediaQuery.of(context).size.width * .65,
                              height: 25,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: TextField(
                                  autofocus: true,
                                  controller: _searchQuery,
                                  onChanged: (value) {
                                    print(_searchQuery.text);
                                  },
                                  decoration:
                                      InputDecoration(border: InputBorder.none),
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                  buttons(),
                ],
              ),
            ),
          ),
        ],
      ),
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
    List<TrackedFood> userFoods = tracker.directory.foods;
    return ListView.builder(
        itemCount: userFoods == null ? 1 : userFoods.length,
        itemBuilder: (BuildContext context, int index) {
          var tracker = Provider.of<Tracker>(context);
          userFoods = tracker.directory.foods;
          TrackedFood food = userFoods[index];
          return Card(
            child: ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FoodPage(widget.mealName, food),
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