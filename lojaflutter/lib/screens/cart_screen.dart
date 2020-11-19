import 'package:flutter/material.dart';
import 'package:lojaflutter/models/cart_model.dart';
import 'package:lojaflutter/models/user_model.dart';
import 'package:lojaflutter/screens/login_screen.dart';
import 'package:lojaflutter/screens/order_screen.dart';
import 'package:lojaflutter/tiles/cart_tile.dart';
import 'package:lojaflutter/widgets/cart_price.dart';
import 'package:lojaflutter/widgets/discount_cart.dart';
import 'package:lojaflutter/widgets/ship_cart.dart';

import 'package:scoped_model/scoped_model.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Meu Carrinho"),
          actions: [
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(right: 8.0),
              child: ScopedModelDescendant<CartModel>(
                builder: (context, child, model) {
                  int p = model.products.length;
                  return Text("${p ?? 0} ${p == 1 ? "Item" : "Itens"}",
                      style: TextStyle(fontSize: 17.0));
                },
              ),
            )
          ],
        ),
        body:
            ScopedModelDescendant<CartModel>(builder: (context, child, model) {
          if (model.isLoading && UserModel.of(context).isLoggedIn()) {
            return Center(child: CircularProgressIndicator());
          } else if (!UserModel.of(context).isLoggedIn()) {
            return Container(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.remove_shopping_cart,
                        size: 80.0, color: Theme.of(context).primaryColor),
                    SizedBox(
                      height: 16.0,
                    ),
                    Text(
                      "Faça o login para adicionar produtos!",
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16.0),
                    RaisedButton(
                      child: Text("Entrar", style: TextStyle(fontSize: 18.0)),
                      textColor: Theme.of(context).primaryColor,
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => LoginScreen()));
                      },
                    ),
                  ],
                ));
          } else if (model.products == null || model.products.length == 0) {
            return Center(
              child: Text(
                "Nenhum produto no carrinho!",
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            );
          } else {
            return ListView(children: <Widget>[
              Column(
                  children: model.products.map((p) {
                return CartTile(p);
              }).toList()),
              DiscountCart(),
              ShipCart(),
              CartPrice(() async {
                String orderId = await model.finishOrder();
                if (orderId != null)
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => OrderScreen(orderId)));
              })
            ]);
          }
        }));
  }
}