import "package:flutter/material.dart";

class DrawerTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final PageController pageController;
  final int page;

  DrawerTile(this.icon, this.text, this.pageController, this.page);

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.of(context).pop();
            pageController.jumpToPage(page);
          },
          child: Container(
              padding: EdgeInsets.only(left: 10.0),
              height: 60.0,
              child: Row(
                children: [
                  Icon(
                    icon,
                    size: 32.0,
                    color: pageController.page.round() == page ? Theme.of(context).primaryColor : Colors.grey,
                  ),
                  SizedBox(
                    width: 32.0,
                  ),
                  Text(text,
                      style: TextStyle(fontSize: 16.0, 
                      color: pageController.page.round() == page ? Theme.of(context).primaryColor : Colors.grey,
                      )
                    )
                ],
              )),
        ));
  }
}
