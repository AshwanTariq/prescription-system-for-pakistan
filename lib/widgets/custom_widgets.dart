import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';

class Mywidgets
{
  static PreferredSizeWidget getAppBar(String data)
  {
    return AppBar(
      title: Text(data),
    );
  }
  static getLottie({required String path,double? width,double? height})
  {

    return Lottie.asset(path,
        width: width, height: height);
  }
}
class Incrementor extends StatefulWidget {
  Incrementor({Key? key,required this.onchangedCallback,required this.time}) : super(key: key);

  final Function(int) onchangedCallback;
  final String time;
  @override
  _IncrementorState createState() => _IncrementorState();
}

class _IncrementorState extends State<Incrementor> {
  int value = 0;


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(

          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.blue,width: 2)

      ),

      height: 43,
      child: Row(

        children: [
          Expanded(child: Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text(widget.time,style: TextStyle(fontSize: 18,),),
          )),
          IconButton(
              onPressed: () {
                setState(() {
                  if (value != 0) {
                    value--;
                    widget.onchangedCallback.call(value);
                  }
                });
              },
              icon: FaIcon(FontAwesomeIcons.minus)),

          Text(value.toString()),
          IconButton(
              onPressed: () {

                setState(() {
                  value++;
                  widget.onchangedCallback.call(value);
                });
              },
              icon: Icon(Icons.add)),

        ],
      ),
    );
  }
}