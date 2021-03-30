import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SMSLoginPage extends StatefulWidget {
  @override
  _SMSLoginPageState createState() => _SMSLoginPageState();
}

class _SMSLoginPageState extends State<SMSLoginPage> {

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

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
                // suffixIconConstraints: BoxConstraints(maxHeight: 32),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    !_canClearCode ? Text("") : IconButton(
                      icon: Icon(Icons.cancel),
                      onPressed: () {
                        _codeController.clear();
                        setState(() {
                          _canClearCode = false;
                        });
                      },
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Fluttertoast.showToast(msg: '短信验证码已发送，请注意查收');
                        getAccessTokenLocal();
                        // getVerificationCode();
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
                      child: Text(codeBtnTip, style: TextStyle(fontSize: 12,),),
                      style: ButtonStyle(
                        // padding: MaterialStateProperty.all(EdgeInsets.only(top:8,bottom:8)),
                        // minimumSize: MaterialStateProperty.all(Size(120, 24)),
                        shape: MaterialStateProperty.all(StadiumBorder()),
                        backgroundColor: MaterialStateProperty.all(Colors.blue),
                        foregroundColor: MaterialStateProperty.all(Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 20)),
            MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              shape: StadiumBorder(),
              // padding: EdgeInsets.only(top:6, bottom:6),
              height: 48,
              minWidth: MediaQuery.of(context).size.width,
              child: Text("注册/登录", style: TextStyle(fontSize: 18,),),
              onPressed: () {
                print("object");
              },
            ),
            Padding(padding: EdgeInsets.only(top: 20)),
            ElevatedButton(
              onPressed: () {
                print("我点击了");
              },
              child: Text("注册/登录", style: TextStyle(fontSize: 18,),),
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(Size(MediaQuery.of(context).size.width, 48)),
                shape: MaterialStateProperty.all(StadiumBorder()),
                backgroundColor: MaterialStateProperty.all(Colors.blue),
                foregroundColor: MaterialStateProperty.all(Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //重新发送验证码
  getVerificationCode() async {
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



  Future<String> getAccessTokenLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("accessToken") ?? "";
    if (token.isNotEmpty) return token;
    
    // await Dio().post(
    //   "https://taccount.haier.com/" + "/oauth/token",
    //   data: {
    //     "client_id":"upluszhushou",
    //     "client_secret": "VsUzcjyUDAEMaV",
    //     "grant_type": "client_credentials"
    //   },
    //   options: Options(
    //     contentType: "application/x-www-form-urlencoded"
    //   )
    // ).then((value) {
    //   int now = Timeline.now;
    //   json.encode(value.data);
    // }).onError((error, stackTrace) {
    //   print("error: $error\nstackTrace: $stackTrace");
    // }).catchError((error) {
    //   print("onError: $error");
    // });

    Dio dio = Dio();
    Response response;
    try {
      response = await dio.post(
        "https://taccount.haier.com/" + "/oauth/token",
        data: {
          "client_id":"upluszhushou",
          "client_secret": "VsUzcjyUDAEMaV",
          "grant_type": "client_credentials"
        },
        options: Options(
          contentType: "application/x-www-form-urlencoded"
        )
      );
      var resp = json.encode(response.data);
      return resp;
    } on DioError catch (e) {
      if (e.response != null) {
        return json.encode(e.response.data);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        String estr = e.message;
        String excetionstr = '{"error": "$estr"}';
        return excetionstr;
      }
    }
  }

}