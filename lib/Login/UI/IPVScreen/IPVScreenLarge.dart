import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:e_kyc/Login/UI/EsignScreen/repository/EsignRepository.dart';
import 'package:e_kyc/Login/UI/IPVScreen/bloc/IpvScreenBlock.dart';
import 'package:e_kyc/Login/UI/Login/repository/LoginRepository.dart';
import 'package:e_kyc/Login/UI/PanDetailsScreen/repository/PanDetailRepository.dart';
import 'package:e_kyc/Login/UI/Configuration/AppConfig.dart';
import 'package:e_kyc/Login/UI/HomeScreen/HomeScreenLarge.dart';
import 'package:e_kyc/Login/UI/Login/View/LoginUI.dart';
import 'package:e_kyc/Login/UI/ThemeColors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rxdart/rxdart.dart';
import 'package:video_player/video_player.dart';
import 'dart:ui' as ui;
import 'dart:html' as html;
import 'dart:js' as js;
import 'package:http/http.dart' as http;
import 'package:web_browser_detect/web_browser_detect.dart';
import 'package:e_kyc/Login/UI/IPVScreen/platformspec/mobiledevice.dart'
    if (dart.library.html) "package:e_kyc/Login/UI/IPVScreen/platformspec/webdevice.dart"
    as newWindow;

class IPVScreenLarge extends StatefulWidget {
  @override
  _IPVScreenLargeState createState() => _IPVScreenLargeState();
}

class _IPVScreenLargeState extends State<IPVScreenLarge> {
  IpvScreenBlock ipcBloc = new IpvScreenBlock();
  var globalRespObj = LoginRepository.loginDetailsResObjGlobal;
  Uint8List fileBytes;
  FilePickerResult result;
  var validfullname = "",
      validemail = "",
      validmobile = "",
      validclientcode = "";
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;

  int selectedCameraIdx;
  XFile rawVideo;
  var cameraViewFlag = true;
  var playerViewFlag = false;
  var videoPath;
  var panName;
  var fullName;
  static var isvideouploaded = false;

  String url;
  static html.VideoElement _webcamVideoElement = html.VideoElement();
  html.MediaStream streamHandle;
  html.MediaRecorder _mediaRecorder;
  final browser = Browser();
  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.

    print("CAMERA dispose ");
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    HomeScreenLarge.percentageFlagLarge.add("0.905");

    _controller = null;

    if (globalRespObj != null) {
      print('Data already is in global object');
      if (globalRespObj.response.errorCode == "0") {
        videoPath = globalRespObj.response.data.message[0].ipv;
        panName = globalRespObj.response.data.message[0].pan;
        fullName = globalRespObj.response.data.message[0].fullName;

        if (videoPath != "") {
          print("INTI method call ");
          playerViewFlag = true;
          url = AppConfig().url.toString() +
              'images/' +
              videoPath.toString() +
              '.mp4';
        } else {}
      }
    } else {
      panName = PanDetailRepository.userPanNumber;
      fullName = LoginRepository.loginFullName;
      // Get the listonNewCameraSelected of available cameras.
      // Then set the first camera as selected.
    }
    if (EsignRepository.timerObj != null) {
      EsignRepository.timerObj.cancel();
      EsignRepository.timerObj = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
                child: Container(
      child: Column(
        children: [
          header(context),
          iPVDetailsForm(context),
          // videoTimer(context),
          //btn(context),
          btnprocess(context),
        ],
      ),
    ))));
  }

  header(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.only(top: 5),
            width: 100,
            height: 60,
            child: Image.asset(
              'asset/images/ipvheader.png',
            ),
          ),
          Expanded(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "ONLINE ACCOUNT OPENING E - KYC",
                    style: TextStyle(
                        color: Color(0xFF0066CC),
                        fontSize: 15,
                        fontFamily: 'century_gothic',
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "IPV | IN PERSONE VERIFICATION",
                    style: TextStyle(
                      color: Color(0xFFFAB804),
                      fontFamily: 'century_gothic',
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              LoginRepository.Esignflag = 0;
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginUI()),
              );
            },
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 50,
                    height: 20,
                    child: SvgPicture.asset(
                      'asset/svg/signout.svg',
                      color: Colors.blue,
                      height: 25,
                      width: 25,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 15),
                    child: Text(
                      "SIGN OUT",
                      style: TextStyle(
                          color: Color(0xFF0066CC),
                          fontFamily: 'century_gothic',
                          fontSize: 11,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  iPVDetailsForm(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20, top: 75),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 15),
                  child: Text(
                    "In order to continue with IPV, You must allow this webpage access to your Camera and Microphone. Kindly allow browser to access your Camera and Microphone.",
                    style: TextStyle(
                      color: Color(0xFFFAB804),
                      fontFamily: 'century_gothic',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 15),
                  child: Text(
                    "Read aloud the following script while recording the video",
                    style: TextStyle(
                        color: Color(0xFF000000),
                        fontFamily: 'century_gothic',
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 15),
                  child: Text(
                    "MY NAME IS " + fullName + " AND MY PAN IS " + panName,
                    style: TextStyle(
                        color: Color(0xFF0066CC),
                        fontFamily: 'century_gothic',
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ),
          ipvVideoPlayer(context),
        ],
      ),
    );
  }

  btn(BuildContext context) {
    return Container(
      width: 285,
      margin: EdgeInsets.only(top: 40, left: 20, bottom: 4, right: 4), //
      child: Container(
        child: Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 125,
                height: 35,
                margin: EdgeInsets.only(right: 0),
                child: TextButton(
                  child: Text(
                    "RECORD AGAIN",
                    style: TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontFamily: 'century_gothic',
                        fontSize: 12,
                        fontWeight: FontWeight.w600),
                  ),
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        EdgeInsets.all(1)),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: BorderSide(color: Color(0xFF0074C4)))),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Color(0xFF0074C4)),
                  ),
                  onPressed: () {
                    setState(() {
                      cameraViewFlag = true;
                      playerViewFlag = false;
                    });
                    // Get the listonNewCameraSelected of available cameras.
                    // Then set the first camera as selected.
                    // _onRecordButtonPressed();
                    //startWebFilePicker(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  btnprocess(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            alignment: Alignment.centerRight,
            margin: EdgeInsets.only(right: 15, top: 0),
            child: Container(
              height: 45,
              width: 125,
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.only(top: 4, left: 4, bottom: 4, right: 4),
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.blue[200],
                  ),
                  borderRadius: BorderRadius.circular(
                      20) // use instead of BorderRadius.all(Radius.circular(20))
                  ),
              child: TextButton(
                child: Text(
                  "PROCEED",
                  style: TextStyle(
                      color: Color(0xFFFFFFFF),
                      fontFamily: 'century_gothic',
                      fontSize: 12,
                      fontWeight: FontWeight.w600),
                ),
                style: ButtonStyle(
                  padding:
                      MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(1)),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: BorderSide(color: Colors.blue[200]))),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Color(0xFF0074C4)),
                ),
                // onPressed: () =>
                //     HomeScreenLarge.screensStreamLarge.sink.add(Pandetails()),
                onPressed: () {
                  if (isvideouploaded) {
                    HomeScreenLarge.screensStreamLarge.sink
                        .add(Ekycscreenamelarge.esigndetailscreen);
                  } else {
                    showAlert(context, "Please record video to proceed");
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  startWebFilePicker(BuildContext context) async {
    result = await FilePicker.platform.pickFiles();
  }

  static Future<void> saveIPVVideo(
      BuildContext context, Uint8List bytes) async {
    IpvScreenBlock ipcBloc = new IpvScreenBlock();
    var getuserdetailsobj =
        await ipcBloc.saveIPVDocument(context, "large", bytes, "");
    if (getuserdetailsobj) {
      isvideouploaded = true;
    } else {
      isvideouploaded = false;
    }
  }
}

showAlert(BuildContext ctx, String msg) {
  return showDialog(
    context: ctx,
    builder: (ctx) => AlertDialog(
      title: Text("E-KYC"),
      content: Text(msg),
      actions: <Widget>[
        // FlatButton(
        //   onPressed: () {
        //     Navigator.of(ctx).pop();
        //   },
        //   child: Text("OK"),
        // ),
      ],
    ),
  );
}

ipvVideoPlayer(BuildContext context) {
  return Container(
    child: Column(
      children: [
        Container(
          width: 300,
          height: 390,
          child: WebCam(),
        ),
      ],
    ),
  );
}

class WebCam extends StatefulWidget {
  @override
  _WebCamState createState() => _WebCamState();
}

class _WebCamState extends State<WebCam> {
  static BuildContext _videoContext;
  static html.VideoElement _webcamVideoElement = html.VideoElement();
  html.MediaStream streamHandle;
  static html.MediaRecorder _mediaRecorder;
  final browser = Browser();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Timer _timer;
  bool recordbtnflag = false;
  int _start = null;
  String time = "00m : 00s";

  var timer = "00m : 00s";
  bool isPressed = true;
  String pathFile;
  final BehaviorSubject<String> timersubject = BehaviorSubject<String>();
  Stream<String> get timerstream => this.timersubject.stream;

  final BehaviorSubject<String> recoicon = BehaviorSubject<String>();
  Stream<String> get recoiconstream => this.recoicon.stream;

  @override
  void initState() {
    super.initState();
    print("i am inti ipv SCREEN LARGE");
    // Register a webcam
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory('webcamVideoElement',
        (int viewId) {
      getMedia();
      return _webcamVideoElement;
    });
  }

  getMedia() {
    html.window.navigator.mediaDevices
        ?.getUserMedia({"video": true, "audio": true}).then(
      (streamHandle) {
        _webcamVideoElement
          ..srcObject = streamHandle
          ..autoplay = true;
        _webcamVideoElement.volume;
        print('${browser.browser} ${browser.version}');
        String browserType = browser.browser;
        String mimeType = '';
        if (browserType.toLowerCase() == "chrome") {
          mimeType = 'video/webm';
        } else if (browserType.toLowerCase() == 'safari') {
          mimeType = 'video/mp4';
        } else {
          mimeType = 'video/webm';
        }
        _mediaRecorder =
            new html.MediaRecorder(streamHandle, {'mimeType': mimeType});

        _mediaRecorder.addEventListener(
          'dataavailable',
          (html.Event event) async {
            final chunks = <html.Blob>[];
            Completer<String> _completer = Completer<String>();
            final html.Blob blob = js.JsObject.fromBrowserObject(event)['data'];

            if (blob.size > 0) {
              chunks.add(blob);
            }

            print('chunks :: ${chunks}');
// send this project on mial
            if (_mediaRecorder.state == 'inactive') {
              final blob = html.Blob(chunks, mimeType);
              _completer.complete(html.Url.createObjectUrlFromBlob(blob));

              pathFile = await _completer.future;
              final imgBase64Str = await networkImageToBase64(pathFile);
              Uint8List bytes = base64.decode(imgBase64Str);
              // print(bytes);
              _IPVScreenLargeState.saveIPVVideo(_videoContext, bytes);

              print('url of video :: ${pathFile}');
              //switchCameraOff();
              //  showAlertMessage(_videoContext, "video done");

              // html.window.open(pathFile, '');
            }
          },
        );
      },
    ).catchError(
      (onError) {
        print('camera error Large');
        print(onError);
      },
    );
  }

  Future<String> networkImageToBase64(String imageUrl) async {
    Uri myUri = Uri.parse(imageUrl);
    http.Response response = await http.get(myUri);
    final bytes = response?.bodyBytes;
    return (bytes != null ? base64Encode(bytes) : null);
  }

  switchCameraOff() {
    bool val = _webcamVideoElement.srcObject?.active;
    if (_webcamVideoElement.srcObject != null && val) {
      var tracks = _webcamVideoElement.srcObject?.getTracks();

      //stopping tracks and setting srcObject to null to switch camera off
      _webcamVideoElement.srcObject = null;

      tracks?.forEach((track) {
        track.stop();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    print("i am dispose");
    // _mediaRecorder.stop();
    // _mediaRecorder = null;
    switchCameraOff();
  }

  @override
  Widget build(BuildContext context) {
    _videoContext = context;
    return Container(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              child: HtmlElementView(
                key: _scaffoldKey,
                viewType: 'webcamVideoElement',
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 290),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    child: StreamBuilder<String>(
                        stream: recoiconstream,
                        builder: (context, snapshot) {
                          if (snapshot.data == "true") {
                            return FloatingActionButton(
                              child: new IconTheme(
                                data: new IconThemeData(
                                    color: Colors.blueGrey[400]),
                                child: new Icon(Icons.videocam_rounded),
                              ),
                              onPressed: () {
                                if (recordbtnflag == false) {
                                  recordbtnflag = true;
                                  recoicon.sink.add("true");
                                  videoRecordTimer();
                                  _mediaRecorder.start();
                                }
                              },
                            );
                          } else {
                            return FloatingActionButton(
                              child: new IconTheme(
                                data: new IconThemeData(color: Colors.white),
                                child: new Icon(
                                  Icons.videocam_rounded,
                                ),
                              ),
                              onPressed: () {
                                if (recordbtnflag == false) {
                                  recordbtnflag = true;
                                  recoicon.sink.add("true");
                                  videoRecordTimer();
                                  _mediaRecorder.start();
                                }
                              },
                            );
                          }
                        }),
                  ),
                  Container(
                    width: 15,
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    child: FloatingActionButton(
                      child: new IconTheme(
                        data: new IconThemeData(color: Colors.red),
                        child: new Icon(
                          Icons.stop_circle,
                        ),
                      ),
                      onPressed: () {
                        recordbtnflag = false;
                        recoicon.sink.add("false");
                        _mediaRecorder.stop();
                        switchCameraOff();
                        _timer.cancel();
                        _timer = null;
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 300,
              height: 15,
              margin: EdgeInsets.only(top: 370),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    color: Colors.white,
                    child: Text("Time : ",
                        style: TextStyle(
                          color: Color(0xFF000000),
                          fontFamily: 'century_gothic',
                          fontSize: 14,
                        )),
                  ),
                  Container(
                    color: Colors.white,
                    child: StreamBuilder<String>(
                        stream: timerstream,
                        builder: (context, snapshot) {
                          if (true) {}
                          return Text(snapshot.data ?? '00m : 00s',
                              style: TextStyle(
                                color: Color(0XFFff0000),
                                fontFamily: 'century_gothic',
                                fontSize: 14,
                              ));
                        }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  videoRecordTimer() {
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
    _start = 10;
    time = "00m : 00s";
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          timersubject.sink.add("00m : 00s");
          timer.cancel();
          _mediaRecorder.stop();
        } else {
          _start--;
          print(_start);

          time = "00m : 0" + _start.toString() + "s";

          timersubject.sink.add(time);
        }
      },
    );
  }

  void showAlertMessage(BuildContext ctxx, String s) {
    showDialog(
      context: ctxx,
      builder: (ctx) => AlertDialog(
        title: Text("E-KYC"),
        content: Text(s),
        actions: <Widget>[
          // FlatButton(
          //   onPressed: () async {
          //     Navigator.of(ctx).pop();
          //   },
          //   child: Text("OK"),
          // ),
        ],
      ),
    );
  }

  void saveIPVVideo() {}
}
