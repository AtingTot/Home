// import 'dart:ui';

import 'package:flutter/material.dart';

class SMSLoginPage extends StatefulWidget {
  @override
  _SMSLoginPageState createState() => _SMSLoginPageState();
}

class _SMSLoginPageState extends State<SMSLoginPage> {

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _codeFocus = FocusNode();
  bool _canClearPhone = false;
  bool _canClearCode = false;
  bool _isClickGetCode = false;

  // @override
  // Map<ChangeNotifier, List<VoidCallback>> changeNotifier() {
  //   final List<VoidCallback> callbacks = <VoidCallback>[_verify];
  //   return <ChangeNotifier, List<VoidCallback>>{
  //     _phoneController: callbacks,
  //     _codeController: callbacks,
  //     _nodeText1: null,
  //     _nodeText2: null,
  //   };
  // }
 
  // void _verify() {
  //   final String name = _phoneController.text;
  //   final String vCode = _codeController.text;
  //   bool clickable = true;
  //   if (name.isEmpty || name.length < 11) {
  //     clickable = false;
  //   }
  //   if (vCode.isEmpty || vCode.length < 6) {
  //     clickable = false;
  //   }
  //   if (clickable != _clickable) {
  //     setState(() {
  //       _clickable = clickable;
  //     });
  //   }
  // }

  // void _login() {
  //   Toast.show('去登录......');
  // }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        // backgroundColor: Colors.yellowAccent[700],
        centerTitle: true,//标题居中
        leading: null,
        title: Text("欢迎登录智慧家"),
      ),
      body: Container(
        padding: EdgeInsets.only(left:20, right: 20, top: 60),
        child: Column(
          children: <Widget> [
            TextField(
              maxLength: 11,
              focusNode: _phoneFocus,
              keyboardType: TextInputType.phone,
              controller: _phoneController,
              onChanged: (text) {
                setState(() {
                  _canClearPhone = text.isNotEmpty;
                });
              },
              obscureText: false,
              decoration: InputDecoration(
                // hintText: '请输入11位手机号',
                labelText: '请输入11位手机号',
                icon: Icon(Icons.phone),
                // contentPadding: EdgeInsetsGeometry.infinity,
                suffixIcon: !_canClearPhone ? null : IconButton(
                  icon: Icon(Icons.cancel),
                  onPressed: () {
                    _phoneController.clear();
                    setState(() {
                      _canClearPhone = false;
                    });
                  },
                )
              ),
            ),
            Stack(
              alignment: const Alignment(1.0, 0.0),
              children: [
                TextField(
                  focusNode: _codeFocus,
                  keyboardType: TextInputType.number,
                  controller: _codeController,
                  onChanged: (text) {
                    setState(() {
                      _canClearCode = text.isNotEmpty;
                    });
                  },
                  obscureText: false,
                  decoration: InputDecoration(
                    // hintText: '请输入验证码',
                    labelText: '请输入验证码',
                    icon: Icon(Icons.sms),
                    // prefix: null,
                    // suffix: null,
                    // prefixIcon: Icon(Icons.sms),
                    // border: null,
                    suffixIcon: !_canClearCode ? null : IconButton(
                      padding: EdgeInsets.only(right: 120),
                      icon: Icon(Icons.cancel),
                      onPressed: () {
                        _codeController.clear();
                        setState(() {
                          _canClearCode = false;
                        });
                      },
                    )
                  ),
                ),
                ElevatedButton(
                  child: Text('获取验证码', style: TextStyle(fontSize: 12,),),
                  onPressed: null,
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(StadiumBorder()),
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                ),
                // TextButton(
                //   onPressed: null,
                //   child: Text('获取验证码'),
                // ),
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 20)),
            // Padding(
            //   padding: EdgeInsets.only(top: 10, bottom: 10, right: 10, left: 10),
            //   child: ElevatedButton(
            //     onPressed: null,
            //     child: Padding(padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
            //       child: Text("注册/登录", style: TextStyle(fontSize: 18,),),
            //     ),
            //     style: ButtonStyle(
            //       // alignment: const Alignment(10.0, 10.0),
            //       // padding: MaterialStateProperty.all(EdgeInsets.only(top: 30, bottom: 30)),
            //       // side: MaterialStateProperty.all(BorderSide(color: Colors.grey, width: 1)),
            //       //外边框装饰 会覆盖 side 配置的样式
            //       shape: MaterialStateProperty.all(StadiumBorder()),
            //       // minimumSize: MaterialStateProperty.all(Size()),
            //       // tapTargetSize: MaterialTapTargetSize.padded,
            //       backgroundColor: MaterialStateProperty.all(Colors.blue),
            //       foregroundColor: MaterialStateProperty.all(Colors.white),
            //     ),
            //   ),
            // ),
            // ElevatedButton(
            //   onPressed: null,
            //   child: Text("注册/登录", style: TextStyle(fontSize: 18,),),
            //   style: ButtonStyle(
            //     // alignment: const Alignment(10.0, 10.0),
            //     // padding: MaterialStateProperty.all(EdgeInsets.only(top: 30, bottom: 30)),
            //     // side: MaterialStateProperty.all(BorderSide(color: Colors.grey, width: 1)),
            //     //外边框装饰 会覆盖 side 配置的样式
            //     shape: MaterialStateProperty.all(StadiumBorder()),
            //     // minimumSize: MaterialStateProperty.all(Size()),
            //     // tapTargetSize: MaterialTapTargetSize.padded,
            //     backgroundColor: MaterialStateProperty.all(Colors.blue),
            //     foregroundColor: MaterialStateProperty.all(Colors.white),
            //   ),
            // ),
            Row(children: <Widget> [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    print("我点击了");
                  },
                  //通过控制Text的边距来控制控件的高度
                  child: Padding(padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
                    child: Text("注册/登录", style: TextStyle(fontSize: 18,),),
                  ),
                  style: ButtonStyle(
                    // alignment: const Alignment(10.0, 10.0),
                    // padding: MaterialStateProperty.all(EdgeInsets.only(top: 30, bottom: 30)),
                    // side: MaterialStateProperty.all(BorderSide(color: Colors.grey, width: 1)),
                    //外边框装饰 会覆盖 side 配置的样式
                    shape: MaterialStateProperty.all(StadiumBorder()),
                    // minimumSize: MaterialStateProperty.all(Size()),
                    // tapTargetSize: MaterialTapTargetSize.padded,
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                ),
              ),
            ],),
          //   Padding(padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 20.0),
          //     child: Row(
          //       children: <Widget> [
          //         Expanded(
          //           child: ElevatedButton(
          //             onPressed: () {
          //               print("我点击了");
          //             },
          //             //通过控制Text的边距来控制控件的高度
          //             child: Padding(padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
          //               child: Text("注册/登录", style: TextStyle(fontSize: 18,),),
          //             ),
          //             style: ButtonStyle(
          //               // alignment: const Alignment(10.0, 10.0),
          //               // padding: MaterialStateProperty.all(EdgeInsets.only(top: 30, bottom: 30)),
          //               // side: MaterialStateProperty.all(BorderSide(color: Colors.grey, width: 1)),
          //               //外边框装饰 会覆盖 side 配置的样式
          //               shape: MaterialStateProperty.all(StadiumBorder()),
          //               // minimumSize: MaterialStateProperty.all(Size()),
          //               // tapTargetSize: MaterialTapTargetSize.padded,
          //               backgroundColor: MaterialStateProperty.all(Colors.blue),
          //               foregroundColor: MaterialStateProperty.all(Colors.white),
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          ],
        ),
      ),
    );
  }
}