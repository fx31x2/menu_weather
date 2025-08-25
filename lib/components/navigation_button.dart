import 'package:flutter/material.dart';

Widget navigationButton(Icon icon, Function func) {
  return Container(
    alignment: Alignment(-0.96, -1),
    decoration: BoxDecoration(
      // color: Colors.red
    ),
    height: 50,
    margin: EdgeInsets.only(top: 20),
    child: IconButton(
      onPressed: () {
        // isOpenMenu.value = !isOpenMenu.value;
        // ref.read(isOpenMenuProvider.notifier).state = isOpenMenu.value;
        // debugPrint('onclicked!\n ${isOpenMenu.value}');
        func();
      },
      // icon: Icon(
      //   isOpenMenu.value ? Icons.close : Icons.menu,
      //   size: 30, 
      //   color: isOpenMenu.value ? Colors.white : Colors.black
      // )
      icon: icon
    ),
  );
}

class NavigationButton extends StatelessWidget {
  const NavigationButton({
    super.key,
    required this.func,
    required this.icon
  });

  final Function func;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment(-0.95, -1),
      child: Container(
        decoration: BoxDecoration(
          // color: Colors.red
        ),
        height: 50,
        width: 50,
        margin: EdgeInsets.only(top: 20),
        child: IconButton(
          onPressed: () {
            // isOpenMenu.value = !isOpenMenu.value;
            // ref.read(isOpenMenuProvider.notifier).state = isOpenMenu.value;
            // debugPrint('onclicked!\n ${isOpenMenu.value}');
            func();
          },
          // icon: Icon(
          //   isOpenMenu.value ? Icons.close : Icons.menu,
          //   size: 30, 
          //   color: isOpenMenu.value ? Colors.white : Colors.black
          // )
          icon: icon
        ),
      ),
    );
  }
}