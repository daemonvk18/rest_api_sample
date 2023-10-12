import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rest_api/model/team_model.dart';

// ignore: must_be_immutable
class HomePage extends StatelessWidget {
  //lets create a list of teams
  List<Teammodel> teams = [];

  //get teams method
  Future getTeams() async {
    var response = await http.get(Uri.https("balldontlie.io", "api/v1/teams"));
    //we will use jsondata to decode it
    var jsonData = jsonDecode(response.body);
    //a quick for loop
    for (var eachteam in jsonData['data']) {
      final team = Teammodel(
          abbreviation: eachteam["abbreviation"], city: eachteam["city"]);
      teams.add(team);
    }
    print(teams.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: getTeams(), //the future that we are waiting for
          builder: (context, snapshot) {
            //here we can create two different scenarioes
            //1) if it is downloading,then lets just show team data
            if (snapshot.connectionState == ConnectionState.done) {
              return ListView.builder(
                  itemCount: teams.length,
                  itemBuilder: ((context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 25.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(21)),
                        child: ListTile(
                          title: Text(
                            teams[index].abbreviation,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 21.0,
                                fontWeight: FontWeight.w800),
                          ),
                          subtitle: Text(
                            teams[index].city,
                            style: TextStyle(
                                color: Colors.grey[800],
                                fontSize: 15.0,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    );
                  }));
            }
            //if it is still loading then show the loading page
            else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
