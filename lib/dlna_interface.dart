import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

abstract class DlnaService{
  Function searchCallback;
  ValueChanged positionCallback;

  @protected
  Future<void> init();

  void setSearchCallback(Function searchCallback) {
    this.searchCallback = searchCallback;
  }

  void setPositionCallback(ValueChanged positionCallback) {
    this.positionCallback = positionCallback;
  }


  //搜索设备
  @protected
  Future<void> search();

  //设置视频地址和名称
  @protected
  Future<void> setVideoUrlAndName(String url,String name);

  //设置设备
  @protected
  Future<void> setDevice(String uuid);

  //启动和播放
  @protected
  Future<void> startAndPlay() ;

  //启动和播放
  @protected
  Future<void> pause() ;

  //停止
  @protected
  Future<void> stop();

  // 获取播放进度
  @protected
  Future<void> getPositionInfo();

 // 设置播放进度
  @protected
  Future<void> setSeek(int time);

}