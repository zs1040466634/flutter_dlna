import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dlna/dlna_android.dart';
import 'package:flutter_dlna/dlna_interface.dart';
import 'package:flutter_dlna/dlna_ios.dart';

class FlutterDlna {
  DlnaService dlnaService;
  Timer _timer;
  bool isPlay = false;

  Future<void> init() async{
    if (Platform.isIOS) {
      dlnaService = DlnaIosService();
    } else if (Platform.isAndroid) {
      dlnaService = DlnaAndroidService();
    }

    await dlnaService.init();
  }

  void setSearchCallback(Function searchCallback) {
    dlnaService.setSearchCallback(searchCallback);
  }

  void setPositionCallback(ValueChanged positionCallback) {
    dlnaService.setPositionCallback(positionCallback);
  }

  //搜索设备
  Future<void> search() async{
    await dlnaService.search();
  }

  //设置视频地址、视频名称
  Future<void> setVideoUrlAndName(String url,String name) async{
    await dlnaService.setVideoUrlAndName(url,name);
  }


  //设置设备
  Future<void> setDevice(String uuid) async{
    await dlnaService.setDevice(uuid);
  }

  //启动和播放
  Future<void> startAndPlay() async{
    isPlay = true;
    await dlnaService.startAndPlay();
  }

  //停止
  Future<void> stop() async{
    isPlay = false;
    await dlnaService.stop();
  }

  // 获取播放进度
  Future<void> getPositionInfo() async {
    if (Platform.isIOS) {
      _timer = Timer.periodic(Duration(milliseconds: 1000), (timer) async {
        await dlnaService.getPositionInfo();
      });
    }
  }

  // 暂停
  Future<void> pause() async {
    isPlay = false;
    await dlnaService.pause();
  }

  void dispose() {
    _timer?.cancel();
  }
}
