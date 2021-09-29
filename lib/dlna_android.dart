import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dlna/dlna_interface.dart';

import 'dlna/didl.dart';
import 'dlna/dlna_action_result.dart';
import 'dlna/dlna_device.dart';
import 'dlna/dlna_manager.dart';
import 'dlna/soap/position_info.dart';

class DlnaAndroidService extends DlnaService {
  DLNAManager dlnaManager = DLNAManager();
  Timer searchTimer;

  Function searchCallback;
  ValueChanged positionCallback;

  List devices = List();
  List<DLNADevice> deviceList = List();

  @override
  Future<void> init() async {}

  @override
  void setSearchCallback(Function searchCallback) {
    this.searchCallback = searchCallback;
    dlnaManager.setRefresher(DeviceRefresher(
        onDeviceUpdate: (DLNADevice device) {
          searchCallback(this.devices);
        },
        onDeviceAdd: (DLNADevice device) {
          if (deviceList.contains(device)) {
            searchCallback(this.devices);
            return;
          }
          Map map = Map();
          map["name"] = device.deviceName;
          map["id"] = device.uuid;
          devices.add(map);
          deviceList.add(device);
          searchCallback(this.devices);
        },
        onDeviceRemove: (DLNADevice device) {
          this.devices =
              devices.where((element) => element["id"] != device.uuid).toList();
          this.deviceList = deviceList
              .where((element) => element.uuid != device.uuid)
              .toList();
          searchCallback(this.devices);
        },
        onPlayProgress: (PositionInfo positionInfo) {
          if (this.positionCallback != null) {
            this.positionCallback(positionInfo);
          }
        }
    ));
  }

  //搜索设备
  @override
  Future<void> search() async {
    dlnaManager.forceSearch();
    searchTimer?.cancel();
    searchTimer = Timer(Duration(milliseconds: 5000), () {
      dlnaManager.stopSearch();
    });
  }

  //设置视频地址
  @override
  Future<void> setVideoUrlAndName(String url, String name) async {
    var videoObject = VideoObject(name, url, "http-get:*:video/*");
    DLNAActionResult<String> result =
        await dlnaManager.actSetVideoUrl(videoObject);
    print(result.result);
  }

  //设置设备
  @override
  Future<void> setDevice(String uuid) async {
    DLNADevice device =
        deviceList.firstWhere((element) => element.uuid == uuid);
    print(device);
    dlnaManager.setDevice(device);
  }

  //启动和播放
  @override
  Future<void> startAndPlay() async {
    print("you should use actSetVideoUrl");
    await dlnaManager.actPlay();
  }

  //停止
  @override
  Future<void> stop() async {
    DLNAActionResult<String> result = await dlnaManager.actStop();
    print(result.result);
  }

  @override
  Future<void> getPositionInfo() {

  }



  @override
  Future<void> pause() async {
    await dlnaManager.actPause();
  }

  @override
  Future<void> setSeek(int time) async {
    // TODO: implement setSeek
    await dlnaManager.actSeek(time);
  }

  @override
  Future<void> play() async {
    // TODO: implement play
    await dlnaManager.actPlay();
  }
}
