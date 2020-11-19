import "package:flutter/material.dart";
import 'package:lojaflutter/tabs/home_tab.dart';
import 'package:lojaflutter/tabs/orders_tab.dart';
import 'package:lojaflutter/tabs/places_tab.dart';
import 'package:lojaflutter/tabs/products_tab.dart';
import 'package:lojaflutter/widgets/cart_button.dart';
import 'package:lojaflutter/widgets/custom_drawer.dart';

class HomeScreen extends StatelessWidget {
  //const name({Key key}) : super(key: key);
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        Scaffold(
          body: HomeTab(),
          drawer: CustomDrawer(_pageController),
          floatingActionButton: CartButton(),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text("Produtos"),
            centerTitle: true,
          ),
          body: ProductsTab(),
          drawer: CustomDrawer(_pageController),
          floatingActionButton: CartButton(),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text("Lojas"),
            centerTitle: true,
          ),
          body: PlacesTab(),
          drawer: CustomDrawer(_pageController),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text("Meus Pedidos"),
            centerTitle: true,
          ),
          body: OrdersTab(),
          drawer: CustomDrawer(_pageController),
        )
      ],
    );
  }
}
