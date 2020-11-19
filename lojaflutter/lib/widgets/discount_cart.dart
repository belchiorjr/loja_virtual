import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lojaflutter/models/cart_model.dart';

class DiscountCart extends StatefulWidget {
  DiscountCart({Key key}) : super(key: key);

  @override
  _DiscountCartState createState() => _DiscountCartState();
}

class _DiscountCartState extends State<DiscountCart> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ExpansionTile(
        title: Text("Cupom de Desconto",
            textAlign: TextAlign.start,
            style: TextStyle(
                fontWeight: FontWeight.w500, color: Colors.grey[700])),
        leading: Icon(Icons.card_giftcard),
        trailing: Icon(
          Icons.add,
        ),
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: "Digite seu cupon"),
              initialValue: CartModel.of(context).couponCode ?? "",
              onFieldSubmitted: (text) {
                CartModel.of(context).checkDiscount(text);

                if (CartModel.of(context).discountPercentage > 0) {
                  Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text(
                          "Desconto de ${CartModel.of(context).discountPercentage}% aplicado."),
                      backgroundColor: Theme.of(context).primaryColor));
                } else {
                  Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text("Cupom não existente!"),
                      backgroundColor: Colors.redAccent));
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
