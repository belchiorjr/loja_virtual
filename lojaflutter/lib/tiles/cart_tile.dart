import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:lojaflutter/datas/cart_product.dart';
import 'package:lojaflutter/datas/product_data.dart';
import 'package:lojaflutter/models/cart_model.dart';

class CartTile extends StatelessWidget {
  final CartProduct cartProduct;

  CartTile(this.cartProduct);

  @override
  Widget build(BuildContext context) {
    // Monta o tile dos itens
    Widget _buildContent() {
      CartModel.of(context).updatePrices();

      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8.0),
            width: 120.0,
            child: Image.network(cartProduct.productData.images[0],
                fit: BoxFit.cover),
          ),
          Expanded(
              child: Container(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(cartProduct.productData.title,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
                Text("Tamanho: ${cartProduct.size}",
                    style: TextStyle(fontWeight: FontWeight.w300)),
                Text(
                  "\$ ${cartProduct.productData.price.toStringAsFixed(2)}",
                  style: TextStyle(
                      fontSize: 18.0,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          if (cartProduct.quantity > 1) {
                            return CartModel.of(context)
                                .decProduct(cartProduct);
                          }
                          return null;
                        },
                        color: Theme.of(context).primaryColor),
                    Text(cartProduct.quantity.toString()),
                    IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          CartModel.of(context).incProduct(cartProduct);
                        },
                        color: Theme.of(context).primaryColor),
                    FlatButton(
                      child: Text("Remover"),
                      textColor: Colors.grey[500],
                      onPressed: () {
                        CartModel.of(context).removeCartItem(cartProduct);
                      },
                    )
                  ],
                )
              ],
            ),
          ))
        ],
      );
    }

    return Card(
        margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: cartProduct.productData == null
            ? FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection("products")
                    .doc(cartProduct.category)
                    .collection("items")
                    .doc(cartProduct.pid)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    cartProduct.productData =
                        ProductData.fromDocument(snapshot.data);
                    return _buildContent();
                  } else {
                    return Container(
                        height: 70.0,
                        child: CircularProgressIndicator(),
                        alignment: Alignment.center);
                  }
                })
            : _buildContent());
  }
}
