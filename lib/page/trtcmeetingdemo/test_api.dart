import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:trtc_demo/models/meeting.dart';
import 'package:tencent_trtc_cloud/trtc_cloud.dart';
import 'package:tencent_trtc_cloud/tx_beauty_manager.dart';
import 'package:tencent_trtc_cloud/tx_device_manager.dart';
import 'package:tencent_trtc_cloud/tx_audio_effect_manager.dart';
import 'package:tencent_trtc_cloud/trtc_cloud_def.dart';
import 'package:path_provider/path_provider.dart';

/// 视频页面
class TestPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TestPageState();
}

class TestPageState extends State<TestPage> {
  var userInfo;
  var meetModel;

  late TRTCCloud trtcCloud;
  late TXDeviceManager txDeviceManager;
  late TXBeautyManager txBeautyManager;
  late TXAudioEffectManager txAudioManager;

  @override
  initState() {
    super.initState();
    initRoom();
    meetModel = context.read<MeetingModel>();
    userInfo = meetModel.getUserInfo();
  }

  initRoom() async {
    trtcCloud = (await TRTCCloud.sharedInstance())!;
    txDeviceManager = trtcCloud.getDeviceManager();
    txBeautyManager = trtcCloud.getBeautyManager();
    txAudioManager = trtcCloud.getAudioEffectManager();
  }

  showToast(text) {
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
    );
  }

  // 设置混流
  setMixConfig() {
    trtcCloud.setMixTranscodingConfig(TRTCTranscodingConfig(
      appId: 1252463788,
      bizId: 3891,
      videoWidth: 360,
      mode: TRTCCloudDef.TRTC_VIDEO_RESOLUTION_MODE_PORTRAIT,
      videoHeight: 640,
      videoFramerate: 15,
      videoGOP: 2,
      videoBitrate: 1000,
      audioBitrate: 64,
      audioSampleRate: 48000,
      audioChannels: 2,
      streamId: null,
      mixUsers: [
        TRTCMixUser(
            userId: userInfo['userId'],
            roomId: '256',
            zOrder: 1,
            x: 0,
            y: 0,
            streamType: 0,
            width: 300,
            height: 400),
        TRTCMixUser(
            userId: '345',
            roomId: '256',
            zOrder: 3,
            x: 100,
            y: 100,
            streamType: 0,
            width: 160,
            height: 200)
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('测试API'),
          centerTitle: true,
          elevation: 0,
        ),
        body: Container(
            child: MaterialApp(
          home: DefaultTabController(
            length: 4,
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: PreferredSize(
                preferredSize:
                    Size.fromHeight(MediaQuery.of(context).size.height * 0.08),
                child: AppBar(
                  bottom: TabBar(tabs: [
                    Tab(text: '视频接口'),
                    Tab(text: '主要接口'),
                    Tab(
                      text: '音乐人生',
                    ),
                    Tab(
                      text: '美颜&设备',
                    )
                  ]),
                ),
              ),
              body: TabBarView(children: [
                ListView(children: [
                  TextButton(
                    onPressed: () async {
                      var object = new Map();
                      object['roomId'] = 155;
                      object['userId'] = '12';
                      trtcCloud.connectOtherRoom(jsonEncode(object));
                    },
                    child: Text('connectOtherRoom-room-155-user-12'),
                  ),
                  TextButton(
                    onPressed: () async {
                      trtcCloud.disconnectOtherRoom();
                    },
                    child: Text('disconnectOtherRoom'),
                  ),
                  TextButton(
                    onPressed: () async {
                      trtcCloud.switchRoom(TRTCSwitchRoomConfig(roomId: 1546));
                    },
                    child: Text('switchRoom-1546'),
                  ),
                  TextButton(
                    onPressed: () async {
                      trtcCloud.stopRemoteView(
                          '345', TRTCCloudDef.TRTC_VIDEO_STREAM_TYPE_SMALL);
                    },
                    child: Text('stopRemoteView-远端id=345的视频'),
                  ),
                  TextButton(
                    onPressed: () async {
                      trtcCloud.stopRemoteView(
                          '345', TRTCCloudDef.TRTC_VIDEO_STREAM_TYPE_SUB);
                    },
                    child: Text('stopRemoteView-远端id=345的辅流'),
                  ),
                  TextButton(
                    onPressed: () async {
                      setMixConfig();
                    },
                    child: Text('setMixTranscodingConfig-房间id=256，远端用户id=345'),
                  ),
                  TextButton(
                    onPressed: () async {
                      trtcCloud.muteLocalVideo(true);
                    },
                    child: Text('muteLocalVideo-true'),
                  ),
                  TextButton(
                    onPressed: () async {
                      trtcCloud.muteLocalVideo(false);
                    },
                    child: Text('muteLocalVideo-false'),
                  ),
                  TextButton(
                    onPressed: () async {
                      trtcCloud.setVideoMuteImage(
                          'images/watermark_img.png', 10);
                    },
                    child: Text('setVideoMuteImage-watermark_img'),
                  ),
                  TextButton(
                    onPressed: () async {
                      trtcCloud.setVideoMuteImage(null, 10);
                    },
                    child: Text('setVideoMuteImage-null'),
                  ),
                  TextButton(
                    onPressed: () async {
                      trtcCloud.muteRemoteVideoStream('345', true);
                    },
                    child: Text('muteRemoteVideoStream-true-远端用户id345'),
                  ),
                  TextButton(
                    onPressed: () async {
                      trtcCloud.muteRemoteVideoStream('345', false);
                    },
                    child: Text('muteRemoteVideoStream-false-远端用户id345'),
                  ),
                  TextButton(
                    onPressed: () async {
                      trtcCloud.muteAllRemoteVideoStreams(true);
                    },
                    child: Text('muteAllRemoteVideoStreams-true'),
                  ),
                  TextButton(
                    onPressed: () async {
                      trtcCloud.muteAllRemoteVideoStreams(false);
                    },
                    child: Text('muteAllRemoteVideoStreams-false'),
                  ),
                  TextButton(
                    onPressed: () async {
                      trtcCloud.setNetworkQosParam(
                          TRTCNetworkQosParam(preference: 1));
                    },
                    child: Text('setNetworkQosParam-保清晰'),
                  ),
                  TextButton(
                    onPressed: () async {
                      trtcCloud.setNetworkQosParam(
                          TRTCNetworkQosParam(preference: 2));
                    },
                    child: Text('setNetworkQosParam-保流畅'),
                  ),
                  TextButton(
                    onPressed: () async {
                      trtcCloud.setLocalRenderParams(TRTCRenderParams(
                          rotation: TRTCCloudDef.TRTC_VIDEO_ROTATION_90,
                          fillMode: TRTCCloudDef.TRTC_VIDEO_RENDER_MODE_FIT,
                          mirrorType:
                              TRTCCloudDef.TRTC_VIDEO_MIRROR_TYPE_ENABLE));
                    },
                    child: Text('setLocalRenderParams-90度旋转'),
                  ),
                  TextButton(
                    onPressed: () async {
                      trtcCloud.setLocalRenderParams(TRTCRenderParams(
                          rotation: TRTCCloudDef.TRTC_VIDEO_ROTATION_0,
                          fillMode: TRTCCloudDef.TRTC_VIDEO_RENDER_MODE_FILL,
                          mirrorType:
                              TRTCCloudDef.TRTC_VIDEO_MIRROR_TYPE_AUTO));
                    },
                    child: Text('setLocalRenderParams-恢复'),
                  ),
                  TextButton(
                    onPressed: () async {
                      trtcCloud.setRemoteRenderParams(
                          '345',
                          TRTCCloudDef.TRTC_VIDEO_STREAM_TYPE_SMALL,
                          TRTCRenderParams(
                              rotation: TRTCCloudDef.TRTC_VIDEO_ROTATION_90,
                              fillMode: TRTCCloudDef.TRTC_VIDEO_RENDER_MODE_FIT,
                              mirrorType:
                                  TRTCCloudDef.TRTC_VIDEO_MIRROR_TYPE_ENABLE));
                    },
                    child: Text('setRemoteRenderParams-小画面90度-远端用户id345'),
                  ),
                  TextButton(
                    onPressed: () async {
                      trtcCloud.setRemoteRenderParams(
                          '345',
                          TRTCCloudDef.TRTC_VIDEO_STREAM_TYPE_SMALL,
                          TRTCRenderParams(
                              rotation: TRTCCloudDef.TRTC_VIDEO_ROTATION_180,
                              fillMode: TRTCCloudDef.TRTC_VIDEO_RENDER_MODE_FIT,
                              mirrorType:
                                  TRTCCloudDef.TRTC_VIDEO_MIRROR_TYPE_ENABLE));
                    },
                    child: Text('setRemoteRenderParams-小画面180度-远端用户id345'),
                  ),
                  TextButton(
                    onPressed: () async {
                      trtcCloud.setRemoteRenderParams(
                          '345',
                          TRTCCloudDef.TRTC_VIDEO_STREAM_TYPE_SMALL,
                          TRTCRenderParams(
                              rotation: TRTCCloudDef.TRTC_VIDEO_ROTATION_270,
                              fillMode: TRTCCloudDef.TRTC_VIDEO_RENDER_MODE_FIT,
                              mirrorType:
                                  TRTCCloudDef.TRTC_VIDEO_MIRROR_TYPE_ENABLE));
                    },
                    child: Text('setRemoteRenderParams-小画面270度-远端用户id345'),
                  ),
                  TextButton(
                    onPressed: () async {
                      trtcCloud.setRemoteRenderParams(
                          '345',
                          TRTCCloudDef.TRTC_VIDEO_STREAM_TYPE_SMALL,
                          TRTCRenderParams(
                              rotation: TRTCCloudDef.TRTC_VIDEO_ROTATION_0,
                              fillMode: TRTCCloudDef.TRTC_VIDEO_RENDER_MODE_FIT,
                              mirrorType:
                                  TRTCCloudDef.TRTC_VIDEO_MIRROR_TYPE_ENABLE));
                    },
                    child: Text('setRemoteRenderParams-小画面恢复-远端用户id345'),
                  ),
                  TextButton(
                    onPressed: () async {
                      trtcCloud.setRemoteRenderParams(
                          '345',
                          TRTCCloudDef.TRTC_VIDEO_STREAM_TYPE_SUB,
                          TRTCRenderParams(
                              rotation: TRTCCloudDef.TRTC_VIDEO_ROTATION_90,
                              fillMode:
                                  TRTCCloudDef.TRTC_VIDEO_RENDER_MODE_FILL,
                              mirrorType:
                                  TRTCCloudDef.TRTC_VIDEO_MIRROR_TYPE_AUTO));
                    },
                    child: Text('setRemoteRenderParams-辅流90度-远端用户id345'),
                  ),
                  TextButton(
                    onPressed: () async {
                      trtcCloud.setVideoEncoderRotation(
                          TRTCCloudDef.TRTC_VIDEO_ROTATION_180);
                    },
                    child: Text('setVideoEncoderRotation-180'),
                  ),
                  TextButton(
                    onPressed: () async {
                      trtcCloud.setVideoEncoderRotation(
                          TRTCCloudDef.TRTC_VIDEO_ROTATION_0);
                    },
                    child: Text('setVideoEncoderRotation-0'),
                  ),
                  TextButton(
                    onPressed: () async {
                      trtcCloud.setVideoEncoderMirror(true);
                    },
                    child: Text('setVideoEncoderMirror-true'),
                  ),
                  TextButton(
                    onPressed: () async {
                      trtcCloud.setVideoEncoderMirror(false);
                    },
                    child: Text('setVideoEncoderMirror-false'),
                  ),
                  TextButton(
                    onPressed: () async {
                      trtcCloud.setGSensorMode(
                          TRTCCloudDef.TRTC_GSENSOR_MODE_UIAUTOLAYOUT);
                    },
                    child: Text('setGSensorMode-开启重力感应'),
                  ),
                  TextButton(
                    onPressed: () async {
                      trtcCloud.setGSensorMode(
                          TRTCCloudDef.TRTC_GSENSOR_MODE_DISABLE);
                    },
                    child: Text('setGSensorMode-关闭重力感应'),
                  ),
                  TextButton(
                    onPressed: () async {
                      int? value = await trtcCloud.enableEncSmallVideoStream(
                          true, TRTCVideoEncParam(videoFps: 5));
                      print('==trtc value' + value.toString());
                      showToast(value.toString());
                    },
                    child: Text('enableEncSmallVideoStream-开启双路编码'),
                  ),
                  TextButton(
                    onPressed: () async {
                      int? value = await trtcCloud.enableEncSmallVideoStream(
                          false, TRTCVideoEncParam(videoFps: 5));
                      print('==trtc value' + value.toString());
                      showToast(value.toString());
                    },
                    child: Text('enableEncSmallVideoStream-关闭双路编码'),
                  ),
                  TextButton(
                    onPressed: () async {
                      trtcCloud.setRemoteVideoStreamType(
                          '345', TRTCCloudDef.TRTC_VIDEO_STREAM_TYPE_SMALL);
                    },
                    child: Text('setRemoteVideoStreamType-观看345的小画面'),
                  ),
                  TextButton(
                    onPressed: () async {
                      trtcCloud.setRemoteVideoStreamType(
                          '345', TRTCCloudDef.TRTC_VIDEO_STREAM_TYPE_BIG);
                    },
                    child: Text('setRemoteVideoStreamType-观看345的大画面'),
                  ),
                ]),
                ListView(
                  children: [
                    TextButton(
                      onPressed: () async {
                        trtcCloud.startPublishCDNStream(TRTCPublishCDNParam(
                            appId: 112,
                            bizId: 233,
                            url: 'https://www.baidu.com'));
                      },
                      child: Text('startPublishCDNStream'),
                    ),
                    TextButton(
                      onPressed: () async {
                        trtcCloud.stopPublishCDNStream();
                      },
                      child: Text('stopPublishCDNStream'),
                    ),
                    TextButton(
                      onPressed: () async {
                        bool? value = await trtcCloud.sendCustomCmdMsg(
                            1, 'hello', true, true);
                        showToast(value.toString());
                      },
                      child: Text('sendCustomCmdMsg'),
                    ),
                    TextButton(
                      onPressed: () async {
                        bool? value = await trtcCloud.sendSEIMsg('clavie嗯', 2);
                        showToast(value.toString());
                      },
                      child: Text('sendSEIMsg'),
                    ),
                    TextButton(
                      onPressed: () async {
                        trtcCloud.setLogCompressEnabled(false);
                      },
                      child: Text('setLogCompressEnabled-false'),
                    ),
                    TextButton(
                      onPressed: () async {
                        trtcCloud.setLogCompressEnabled(true);
                      },
                      child: Text('setLogCompressEnabled-true'),
                    ),
                    TextButton(
                      onPressed: () async {
                        trtcCloud.setLogDirPath(
                            '/sdcard/Android/data/com.tencent.trtc_demo/files/log/tencent/clavietest');
                      },
                      child: Text('setLogDirPath-android-clavietest'),
                    ),
                    TextButton(
                      onPressed: () async {
                        Directory appDocDir =
                            await getApplicationDocumentsDirectory();
                        trtcCloud.setLogDirPath(appDocDir.path + '/clavietest');
                      },
                      child: Text('setLogDirPath-ios-clavietest'),
                    ),
                    TextButton(
                      onPressed: () async {
                        trtcCloud.startPublishing('clavie_stream_001',
                            TRTCCloudDef.TRTC_VIDEO_STREAM_TYPE_BIG);
                      },
                      child: Text('startPublishing-clavie_stream_001'),
                    ),
                    TextButton(
                      onPressed: () async {
                        trtcCloud.stopPublishing();
                      },
                      child: Text('stopPublishing'),
                    ),
                    TextButton(
                      onPressed: () async {
                        trtcCloud.setAudioCaptureVolume(70);
                      },
                      child: Text('setAudioCaptureVolume-70'),
                    ),
                    TextButton(
                      onPressed: () async {
                        int? volume = await trtcCloud.getAudioCaptureVolume();
                        showToast(volume.toString());
                      },
                      child: Text('getAudioCaptureVolume'),
                    ),
                    TextButton(
                      onPressed: () async {
                        trtcCloud.setAudioPlayoutVolume(80);
                      },
                      child: Text('setAudioPlayoutVolume-80'),
                    ),
                    TextButton(
                      onPressed: () async {
                        int? volume = await trtcCloud.getAudioPlayoutVolume();
                        showToast(volume.toString());
                      },
                      child: Text('getAudioPlayoutVolume'),
                    ),
                    TextButton(
                      onPressed: () async {
                        trtcCloud.snapshotVideo(
                            null,
                            TRTCCloudDef.TRTC_VIDEO_STREAM_TYPE_BIG,
                            '/sdcard/Android/data/com.tencent.trtc_demo/files/asw.jpg');
                      },
                      child: Text('snapshotVideo-安卓'),
                    ),
                    TextButton(
                      onPressed: () async {
                        Directory appDocDir =
                            await getApplicationDocumentsDirectory();
                        trtcCloud.snapshotVideo(
                            null,
                            TRTCCloudDef.TRTC_VIDEO_STREAM_TYPE_BIG,
                            appDocDir.path + '/test10.jpg');
                      },
                      child: Text('snapshotVideo-ios'),
                    ),
                    TextButton(
                      onPressed: () async {
                        trtcCloud.enableAudioVolumeEvaluation(2000);
                      },
                      child: Text('enableAudioVolumeEvaluation-每2s提示音量'),
                    ),
                    TextButton(
                      onPressed: () async {
                        trtcCloud.enableAudioVolumeEvaluation(0);
                      },
                      child: Text('enableAudioVolumeEvaluation-0'),
                    ),
                    TextButton(
                      onPressed: () async {
                        int? result = await trtcCloud.startAudioRecording(
                            TRTCAudioRecordingParams(
                                filePath:
                                    '/sdcard/Android/data/com.tencent.trtc_demo/files/audio.wav'));
                        showToast(result.toString());
                      },
                      child: Text('startAudioRecording-安卓'),
                    ),
                    TextButton(
                      onPressed: () async {
                        Directory appDocDir =
                            await getApplicationDocumentsDirectory();
                        int? result = await trtcCloud.startAudioRecording(
                            TRTCAudioRecordingParams(
                                filePath: appDocDir.path + '/audio.aac'));
                        showToast(result.toString());
                      },
                      child: Text('startAudioRecording-ios'),
                    ),
                    TextButton(
                      onPressed: () async {
                        trtcCloud.stopAudioRecording();
                      },
                      child: Text('stopAudioRecording'),
                    ),
                    TextButton(
                      onPressed: () async {
                        trtcCloud.setWatermark(
                            'images/watermark_img.png',
                            TRTCCloudDef.TRTC_VIDEO_STREAM_TYPE_BIG,
                            0.1,
                            0.3,
                            0.2);
                      },
                      child: Text('setWatermark-本地图片'),
                    ),
                    TextButton(
                      onPressed: () async {
                        trtcCloud.setWatermark(
                            '/sdcard/Android/data/com.tencent.trtc_demo/files/asw.jpg',
                            TRTCCloudDef.TRTC_VIDEO_STREAM_TYPE_BIG,
                            0.1,
                            0.3,
                            0.2);
                      },
                      child: Text('setWatermark-绝对路径'),
                    ),
                    TextButton(
                      onPressed: () async {
                        trtcCloud.setWatermark(
                            'https://main.qcloudimg.com/raw/3f9146cacab4a019b0cc44b8b22b6a38.png',
                            TRTCCloudDef.TRTC_VIDEO_STREAM_TYPE_BIG,
                            0.1,
                            0.3,
                            0.2);
                      },
                      child: Text('setWatermark-网络图片'),
                    ),
                    TextButton(
                      onPressed: () async {
                        String? version = await trtcCloud.getSDKVersion();
                        showToast(version);
                      },
                      child: Text('getSDKVersion'),
                    ),
                    TextButton(
                      onPressed: () async {
                        trtcCloud.showDebugView(2);
                      },
                      child: Text('showDebugView-show'),
                    ),
                    TextButton(
                      onPressed: () async {
                        trtcCloud.showDebugView(0);
                      },
                      child: Text('showDebugView-close'),
                    ),
                  ],
                ),
                ListView(
                  children: [
                    TextButton(
                      onPressed: () async {
                        txAudioManager.enableVoiceEarMonitor(true);
                      },
                      child: Text('enableVoiceEarMonitor-true'),
                    ),
                    TextButton(
                      onPressed: () async {
                        txAudioManager.enableVoiceEarMonitor(false);
                      },
                      child: Text('enableVoiceEarMonitor-flase'),
                    ),
                    TextButton(
                      onPressed: () async {
                        txAudioManager.setVoiceEarMonitorVolume(0);
                      },
                      child: Text('setVoiceEarMonitorVolume-0'),
                    ),
                    TextButton(
                      onPressed: () async {
                        txAudioManager.setVoiceEarMonitorVolume(100);
                      },
                      child: Text('setVoiceEarMonitorVolume-100'),
                    ),
                    TextButton(
                      onPressed: () async {
                        txAudioManager.setVoiceReverbType(
                            TXVoiceReverbType.TXLiveVoiceReverbType_4);
                      },
                      child: Text('setVoiceReverbType-低沉'),
                    ),
                    TextButton(
                      onPressed: () async {
                        txAudioManager.setVoiceReverbType(
                            TXVoiceReverbType.TXLiveVoiceReverbType_7);
                      },
                      child: Text('setVoiceReverbType-磁性'),
                    ),
                    TextButton(
                      onPressed: () async {
                        txAudioManager.setVoiceChangerType(
                            TXVoiceChangerType.TXLiveVoiceChangerType_2);
                      },
                      child: Text('setVoiceChangerType-萝莉'),
                    ),
                    TextButton(
                      onPressed: () async {
                        txAudioManager.setVoiceChangerType(
                            TXVoiceChangerType.TXLiveVoiceChangerType_4);
                      },
                      child: Text('setVoiceChangerType-重金属'),
                    ),
                    TextButton(
                      onPressed: () async {
                        txAudioManager.setVoiceChangerType(
                            TXVoiceChangerType.TXLiveVoiceChangerType_0);
                      },
                      child: Text('setVoiceChangerType-关闭变声'),
                    ),
                    TextButton(
                      onPressed: () async {
                        txAudioManager.setVoiceCaptureVolume(0);
                      },
                      child: Text('setVoiceCaptureVolume-0'),
                    ),
                    TextButton(
                      onPressed: () async {
                        txAudioManager.setVoiceCaptureVolume(100);
                      },
                      child: Text('setVoiceCaptureVolume-100'),
                    ),
                    TextButton(
                      onPressed: () async {
                        bool? musidTrue = await txAudioManager.startPlayMusic(
                            AudioMusicParam(
                                id: 223,
                                publish: true,
                                path:
                                    'https://imgcache.qq.com/operation/dianshi/other/daoxiang.72c46ee085f15dc72603b0ba154409879cbeb15e.mp3'));
                        showToast(musidTrue.toString());
                      },
                      child: Text('startPlayMusic-需要等10s'),
                    ),
                    TextButton(
                      onPressed: () async {
                        txAudioManager.pausePlayMusic(223);
                      },
                      child: Text('pausePlayMusic'),
                    ),
                    TextButton(
                      onPressed: () async {
                        txAudioManager.resumePlayMusic(223);
                      },
                      child: Text('resumePlayMusic'),
                    ),
                    TextButton(
                      onPressed: () async {
                        txAudioManager.setMusicPlayoutVolume(223, 0);
                      },
                      child: Text('setMusicPlayoutVolume-0'),
                    ),
                    TextButton(
                      onPressed: () async {
                        txAudioManager.setMusicPlayoutVolume(223, 100);
                      },
                      child: Text('setMusicPlayoutVolume-100'),
                    ),
                    TextButton(
                      onPressed: () async {
                        txAudioManager.setMusicPublishVolume(223, 0);
                      },
                      child: Text('setMusicPublishVolume-0'),
                    ),
                    TextButton(
                      onPressed: () async {
                        txAudioManager.setMusicPublishVolume(223, 100);
                      },
                      child: Text('setMusicPublishVolume-100'),
                    ),
                    TextButton(
                      onPressed: () async {
                        txAudioManager.setAllMusicVolume(0);
                      },
                      child: Text('setAllMusicVolume-0'),
                    ),
                    TextButton(
                      onPressed: () async {
                        txAudioManager.setAllMusicVolume(100);
                      },
                      child: Text('setAllMusicVolume-100'),
                    ),
                    TextButton(
                      onPressed: () async {
                        txAudioManager.setMusicPitch(223, -1);
                      },
                      child: Text('setMusicPitch- (-1)'),
                    ),
                    TextButton(
                      onPressed: () async {
                        txAudioManager.setMusicPitch(223, 1);
                      },
                      child: Text('setMusicPitch- 1'),
                    ),
                    TextButton(
                      onPressed: () async {
                        txAudioManager.setMusicSpeedRate(223, 0.5);
                      },
                      child: Text('setMusicSpeedRate- 0.5'),
                    ),
                    TextButton(
                      onPressed: () async {
                        txAudioManager.setMusicSpeedRate(223, 2);
                      },
                      child: Text('setMusicSpeedRate- 2'),
                    ),
                    TextButton(
                      onPressed: () async {
                        int? time =
                            await txAudioManager.getMusicCurrentPosInMS(223);
                        showToast(time.toString());
                      },
                      child: Text('getMusicCurrentPosInMS'),
                    ),
                    TextButton(
                      onPressed: () async {
                        txAudioManager.seekMusicToPosInMS(223, 220000);
                      },
                      child: Text('seekMusicToPosInMS-220000'),
                    ),
                    TextButton(
                      onPressed: () async {
                        int? time = await txAudioManager.getMusicDurationInMS(
                            'https://imgcache.qq.com/operation/dianshi/other/daoxiang.72c46ee085f15dc72603b0ba154409879cbeb15e.mp3');
                        print('==time=' + time.toString());
                        showToast(time.toString());
                      },
                      child: Text('getMusicDurationInMS-获取时间比较久'),
                    ),
                    TextButton(
                      onPressed: () async {
                        txAudioManager.stopPlayMusic(223);
                      },
                      child: Text('stopPlayMusic'),
                    ),
                  ],
                ),
                ListView(
                  children: [
                    TextButton(
                      onPressed: () async {
                        txBeautyManager.setFilter('images/watermark_img.png');
                      },
                      child: Text('setFilter-本地图片'),
                    ),
                    TextButton(
                      onPressed: () async {
                        txBeautyManager.setFilter(
                            'https://main.qcloudimg.com/raw/3f9146cacab4a019b0cc44b8b22b6a38.png');
                      },
                      child: Text('setFilter-网络图片'),
                    ),
                    TextButton(
                      onPressed: () async {
                        txBeautyManager.setFilterStrength(0);
                      },
                      child: Text('setFilterStrength - 0'),
                    ),
                    TextButton(
                      onPressed: () async {
                        txBeautyManager.setFilterStrength(1);
                      },
                      child: Text('setFilterStrength - 1'),
                    ),
                    TextButton(
                      onPressed: () async {
                        txBeautyManager.enableSharpnessEnhancement(true);
                      },
                      child: Text('enableSharpnessEnhancement - true'),
                    ),
                    TextButton(
                      onPressed: () async {
                        txBeautyManager.enableSharpnessEnhancement(false);
                      },
                      child: Text('enableSharpnessEnhancement - false'),
                    ),
                    TextButton(
                      onPressed: () async {
                        bool? isFront = await txDeviceManager.isFrontCamera();
                        showToast(isFront.toString());
                      },
                      child: Text('isFrontCamera'),
                    ),
                    TextButton(
                      onPressed: () async {
                        txDeviceManager.switchCamera(false);
                      },
                      child: Text('switchCamera-false'),
                    ),
                    TextButton(
                      onPressed: () async {
                        txDeviceManager.switchCamera(true);
                      },
                      child: Text('switchCamera-true'),
                    ),
                    TextButton(
                      onPressed: () async {
                        double? isFront =
                            await txDeviceManager.getCameraZoomMaxRatio();
                        showToast(isFront.toString());
                      },
                      child: Text('getCameraZoomMaxRatio'),
                    ),
                    TextButton(
                      onPressed: () async {
                        int? value =
                            await txDeviceManager.setCameraZoomRatio(1.1);
                        showToast(value.toString());
                      },
                      child: Text('setCameraZoomRatio-1'),
                    ),
                    TextButton(
                      onPressed: () async {
                        int? value =
                            await txDeviceManager.setCameraZoomRatio(5.1);
                        showToast(value.toString());
                      },
                      child: Text('setCameraZoomRatio-5'),
                    ),
                    TextButton(
                      onPressed: () async {
                        bool? isFront =
                            await txDeviceManager.enableCameraTorch(true);
                        showToast(isFront.toString());
                      },
                      child: Text('enableCameraTorch-true'),
                    ),
                    TextButton(
                      onPressed: () async {
                        bool? isFront =
                            await txDeviceManager.enableCameraTorch(false);
                        showToast(isFront.toString());
                      },
                      child: Text('enableCameraTorch-false'),
                    ),
                    TextButton(
                      onPressed: () async {
                        txDeviceManager.setCameraFocusPosition(0, 0);
                      },
                      child: Text('setCameraFocusPosition-0,0'),
                    ),
                    TextButton(
                      onPressed: () async {
                        txDeviceManager.setCameraFocusPosition(100, 100);
                      },
                      child: Text('setCameraFocusPosition-100,100'),
                    ),
                    TextButton(
                      onPressed: () async {
                        int? value =
                            await txDeviceManager.enableCameraAutoFocus(true);
                        showToast(value.toString());
                      },
                      child: Text('enableCameraAutoFocus-true'),
                    ),
                    TextButton(
                      onPressed: () async {
                        bool? value =
                            await txDeviceManager.isAutoFocusEnabled();
                        showToast(value.toString());
                      },
                      child: Text('isAutoFocusEnabled'),
                    ),
                  ],
                ),
              ]),
            ),
          ),
        )));
  }
}