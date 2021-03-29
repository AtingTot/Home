// import 'dart:ui';

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'dart:ui' as ui show window;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

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

  Duration _time;
  var _seconds = 60;
  Timer _countdownTimer = null;
  String codeBtnTip = "获取验证码";

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
  void dispose() {
    _countdownTimer?.cancel();
    _countdownTimer = null;
    super.dispose();
  }

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
        // height: 360,
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
                  child: Text(codeBtnTip, style: TextStyle(fontSize: 12,),),
                  onPressed: () {
                    Fluttertoast.showToast(msg: '短信验证码已发送，请注意查收');
                    getVerificationCode();
                    print("begin get code");
                    if (_countdownTimer != null) {
                      return;
                    }
                    _isClickGetCode = true;
                    _seconds = 60;
                    setState(() {
                      codeBtnTip = "$_seconds秒";
                      _seconds--;
                    });
                    _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
                      setState(() {
                        codeBtnTip = "$_seconds秒";
                        if (_seconds > 0) {
                          _seconds--;
                        } else {
                          _countdownTimer.cancel();
                          _countdownTimer = null;
                          codeBtnTip = "重新获取";
                        }
                      });
                    });
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(StadiumBorder()),
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                ),
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 20)),
            ElevatedButton(
              onPressed: () {
                print("我点击了");
              },
              //通过控制Text的边距来控制控件的高度
              child: Padding(padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
                child: Text("注册/登录", style: TextStyle(fontSize: 18,),),
              ),
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(Size(MediaQuery.of(context).size.width, 48)),
                // tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: MaterialStateProperty.all(StadiumBorder()),
                backgroundColor: MaterialStateProperty.all(Colors.blue),
                foregroundColor: MaterialStateProperty.all(Colors.white),
              ),
            ),
            // Row(children: <Widget> [
            //   Expanded(
            //     child: ElevatedButton(
            //       onPressed: () {
            //         print("我点击了");
            //       },
            //       //通过控制Text的边距来控制控件的高度
            //       child: Padding(padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
            //         child: Text("注册/登录", style: TextStyle(fontSize: 18,),),
            //       ),
            //       style: ButtonStyle(
            //         shape: MaterialStateProperty.all(StadiumBorder()),
            //         backgroundColor: MaterialStateProperty.all(Colors.blue),
            //         foregroundColor: MaterialStateProperty.all(Colors.white),
            //       ),
            //     ),
            //   ),
            // ],),
            // ConstrainedBox(
            //   constraints: BoxConstraints(
            //     // maxHeight: 60,
            //     maxHeight: MediaQuery.of(context).size.width,
            //     maxWidth: double.maxFinite,
            //   ),
            //   child: ElevatedButton(
            //     child: Padding(
            //       padding: EdgeInsets.only(top:12,bottom:12),
            //       child: Text("注册/登录1", style: TextStyle(fontSize: 18,),),
            //     ),
            //     onPressed: () => print("width = ${MediaQuery.of(context).size.width}"),
            //     style: ButtonStyle(
            //       minimumSize: MaterialStateProperty.all(Size(MediaQuery.of(context).size.width,60)),
            //       // tapTargetSize: ,
            //       // backgroundColor: MaterialStateProperty.all(Colors.black),
            //       // padding: MaterialStateProperty.all(EdgeInsets.only(left: MediaQuery.of(context).size.width/2, right: MediaQuery.of(context).size.width/2)),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  //重新发送验证码
  getVerificationCode() async {
    // setState(() {
    //   this.sendCodeBtn = false;
    //   this.seconds = 10;
    //   this._showTimer();
    // });
    // Dio().post("***"
    //   "username":"***",
    //   "password":"***",
    //   "grant_type":"password"
    //   options: Options(
    //   headers: {"Authorization":basicAuth},
    //   contentType: ContentType.parse("application/x-www-form-urlencoded"),
    // )).then((response){
    //   print(response.data);
    // });
    // String var1 = await getAccessTokenLocal();
    // print(var1);
    var api = 'https://taccount.haier.com/v2/sms-verification-code/send';
    await Dio().post(api,
      data: {
        "phone_number": "13717993069",
        "scenario": "login",
        // "captcha_token":"8d505749-3c26-49a1-b344-6def60164948",
        // "captcha_answer":"3p5wg"
      },
      options: Options(
        headers: {"Authorization": "Bearer 063d10fc5b32434faa9761a0196bd6a0"},
        contentType: "application/json"
      ),
    ).then((value) => print(value.data));
    // Options option = Options(method:'post');
    // // option.contentType
    // Dio().
    
    // var response = await Dio().post(api, data: {"tel": this.tel});
    // if (response.data["success"]) {
    //   print(response); //演示期间服务器直接返回  给手机发送的验证码
    // }
  }

  // //验证验证码
  // validateCode() async {
  //   var api = '${Config.domain}api/validateCode';
  //   var response =
  //   await Dio().post(api, data: {"tel": this.tel, "code": this.code});
  //   if (response.data["success"]) {
  //     Navigator.pushNamed(context, '/registerThird',arguments: {
  //       "tel":this.tel,
  //       "code":this.code
  //     });
  //   } else {
  //     Fluttertoast.showToast(
  //       msg: '${response.data["message"]}',
  //       toastLength: Toast.LENGTH_SHORT,
  //       gravity: ToastGravity.CENTER,
  //     );
  //   }
  // }



  Future<String> getAccessTokenLocal() async{

  Map<String, dynamic> body = Map();//body
  body["client_id"] = "upluszhushou";
  body["client_secret"] = "VsUzcjyUDAEMaV";
  body["grant_type"] = "client_credentials";

  Dio dio = Dio();
  Response response;
  try{
    response = await dio.post(
      "https://taccount.haier.com/" + "/oauth/token",
      data: body,
      options: Options(
        contentType: "application/x-www-form-urlencoded"
      )
    );
    var  resp = json.encode(response.data);
    return resp;
  }on DioError catch (e){
    if(e.response != null) {
      return json.encode(e.response.data);
    } else{
      // Something happened in setting up or sending the request that triggered an Error
      String estr = e.message;
      String excetionstr = '{"error": "$estr"}';
      return excetionstr;
    }
  }
}

}