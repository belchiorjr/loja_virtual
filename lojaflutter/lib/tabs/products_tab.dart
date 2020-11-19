import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lojaflutter/tiles/category_tile.dart';

class ProductsTab extends StatelessWidget {
  ProductsTab();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection("products").get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            var divideTiles = ListTile.divideTiles(
                    tiles: snapshot.data.docs.map((doc) {
                      return CategoryTile(doc);
                    }).toList(),
                    color: Colors.grey[500])
                .toList();

            return ListView(
              children: divideTiles,
            );

            // return Container(
            //   color: Colors.greenAccent,
            //   child: Center(
            //       child: Text("Dados carregados!",
            //           textAlign: TextAlign.center,
            //           style: TextStyle(color: Colors.white, fontSize: 50.0))),
            //);
          }
        });
  }
}
