// lib/services/webrtc_service.dart
import 'dart:convert';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'signal_service.dart';

typedef DataHandler = void Function(Map<String, dynamic> data);

class WebRTCService {
  final SignalService signal;
  RTCPeerConnection? _pc;
  RTCDataChannel? _dc;
  DataHandler? onData;

  WebRTCService(this.signal) {
    signal.onSignal = _onSignal;
  }

  Future<void> initAsCaller() async {
    final config = {
      "iceServers": [
        {"urls": "stun:stun.l.google.com:19302"}
      ]
    };
    _pc = await createPeerConnection(config);

    _pc!.onIceCandidate = (c) {
      if (c.candidate != null) {
        signal.sendSignal({
          "type": "signal",
          "candidate": {
            "candidate": c.candidate,
            "sdpMid": c.sdpMid,
            "sdpMLineIndex": c.sdpMLineIndex
          }
        });
      }
    };

    _dc = await _pc!.createDataChannel("family", RTCDataChannelInit());
    _setupDataChannel();

    final offer = await _pc!.createOffer();
    await _pc!.setLocalDescription(offer);

    signal.sendSignal({
      "type": "signal",
      "sdp": offer.toMap(),
    });
  }

  Future<void> initAsCallee() async {
    final config = {
      "iceServers": [
        {"urls": "stun:stun.l.google.com:19302"}
      ]
    };
    _pc = await createPeerConnection(config);

    _pc!.onIceCandidate = (c) {
      if (c.candidate != null) {
        signal.sendSignal({
          "type": "signal",
          "candidate": {
            "candidate": c.candidate,
            "sdpMid": c.sdpMid,
            "sdpMLineIndex": c.sdpMLineIndex
          }
        });
      }
    };

    _pc!.onDataChannel = (dc) {
      _dc = dc;
      _setupDataChannel();
    };
  }

  void _setupDataChannel() {
    _dc?.onMessage = (msg) {
      try {
        final data = jsonDecode(msg.text);
        if (onData != null) onData!(data);
      } catch (_) {}
    };
  }

  Future<void> _onSignal(Map<String, dynamic> data) async {
    if (_pc == null) return;

    if (data["sdp"] != null) {
      final desc = RTCSessionDescription(
        data["sdp"]["sdp"],
        data["sdp"]["type"],
      );
      await _pc!.setRemoteDescription(desc);

      if (desc.type == "offer") {
        final answer = await _pc!.createAnswer();
        await _pc!.setLocalDescription(answer);
        signal.sendSignal({
          "type": "signal",
          "sdp": answer.toMap(),
        });
      }
    }

    if (data["candidate"] != null) {
      final c = data["candidate"];
      await _pc!.addCandidate(RTCIceCandidate(
        c["candidate"],
        c["sdpMid"],
        c["sdpMLineIndex"],
      ));
    }
  }

  void sendData(Map<String, dynamic> data) {
    if (_dc == null) return;
    _dc!.send(RTCDataChannelMessage(jsonEncode(data)));
  }
}
