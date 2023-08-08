import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:http/http.dart' as http;
import '../src/global_functions.dart';
import '../src/globals.dart';

class VideoPlaying extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return VideoPlayingState();
  }

}

class VideoPlayingState extends State<VideoPlaying> {

  late YoutubePlayerController _controller;
  late TextEditingController _idController;
  late TextEditingController _seekToController;

  late PlayerState _playerState;
  late YoutubeMetaData _videoMetaData;
  double _volume = 100;
  bool _muted = false;
  bool _isPlayerReady = false;
  var jsonResponse;
  String? accessToken;

  List<String> _ids = [];
  int index = 0;

  @override
  initState() {
    _getListVideo();
    super.initState();
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
      });
    }
  }

  @override
  void deactivate() {
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    _idController.dispose();
    _seekToController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: appBar(context, 'Videos'),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: floatActionButton(context),
      bottomNavigationBar: bottomApp(context),
      drawer: menuLateral(context),
      body: _ids.isNotEmpty ? YoutubePlayerBuilder(
        player: YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
          progressIndicatorColor: Colors.blueAccent,
          topActions: <Widget>[
            const SizedBox(width: 8.0),
            Expanded(
              child: Text(
                _controller.metadata.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.settings,
                color: Colors.white,
                size: 25.0,
              ),
              onPressed: () {
                // log('Settings Tapped!');
              },
            ),
          ],
          onReady: () {
            _isPlayerReady = true;
          },
          onEnded: (data) {
            _controller.load(_ids[(_ids.indexOf(data.videoId) + 1) % _ids.length]);
            _showSnackBar('Iniciando segundo video');
          },
        ),
        builder: (context, player) =>
          ListView(
            children: [ player, Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(child: Text(_videoMetaData.title,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold),)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.skip_previous),
                        onPressed: _isPlayerReady ? () {

                          if(_ids.length < index){
                            _controller.load(_ids[(_ids.indexOf(_controller.metadata.videoId) - 1) % _ids.length]);
                            index = index - 1;
                          } else {
                            index = 0;
                          }

                        } : null,
                      ),
                      IconButton(
                        icon: Icon(
                          _controller.value.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                        ),
                        onPressed: _isPlayerReady
                            ? () {
                          _controller.value.isPlaying
                              ? _controller.pause()
                              : _controller.play();
                          setState(() {});
                        }
                            : null,
                      ),
                      IconButton(
                        icon: Icon(_muted ? Icons.volume_off : Icons
                            .volume_up),
                        onPressed: _isPlayerReady
                            ? () {
                          _muted
                              ? _controller.unMute()
                              : _controller.mute();
                          setState(() {
                            _muted = !_muted;
                          });
                        }
                            : null,
                      ),
                      FullScreenButton(
                        controller: _controller,
                        color: Colors.blueAccent,
                      ),
                      IconButton(
                        icon: const Icon(Icons.skip_next),
                        onPressed: _isPlayerReady ? () {
                          try{
                            if(_ids.length >= index){
                              _controller.load(_ids[(_ids.indexOf(_controller.metadata.videoId) + 1) % _ids.length]);
                              index = index + 1;
                            } else {
                              index = 0;
                            }
                          }catch(onerror){
                            print('index: $index error: ' + onerror.toString());
                          }
                        } : null,
                      ),
                    ],
                  ),
                  _space,
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 800),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: _getStateColor(_playerState),
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      loadStatus(_playerState),
                      style: const TextStyle(
                        fontWeight: FontWeight.w300,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  _space,
                  Text('Descripción: $index', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(jsonResponse['data'][index]['description']),
                  ),
                ],
              ),
            ),
          ],)
      ) : const Center(child: CircularProgressIndicator(),),
    );
  }

  _getListVideo() async {
    try{

      accessToken = await prefs?.getString('lastaccesstoken');

      final response = await http.get(Uri.parse('http://143.198.128.13/api/videos/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken'
        },
      );

      jsonResponse = jsonDecode(response.body);
      await jsonResponse['data'].forEach((element) {
        _ids.add(element['youtube_id'].toString()
        );
      });

      if(_ids.isNotEmpty){
        _controller = YoutubePlayerController(
          initialVideoId: _ids.first,
          flags: const YoutubePlayerFlags(
            mute: false,
            autoPlay: true,
            disableDragSeek: false,
            loop: false,
            isLive: false,
            forceHD: false,
            enableCaption: true,
          ),
        )..addListener(listener);
        _videoMetaData = const YoutubeMetaData();
        _playerState = PlayerState.unknown;
        setState(() {
          _ids;
        });
      }

    } catch(onerror){
      print('error: ' +  onerror.toString());
    }
  }

  Color _getStateColor(PlayerState state) {
    switch (state) {
      case PlayerState.unknown:
        return Colors.grey[700]!;
      case PlayerState.unStarted:
        return Colors.pink;
      case PlayerState.ended:
        return Colors.red;
      case PlayerState.playing:
        return Colors.blueAccent;
      case PlayerState.paused:
        return Colors.orange;
      case PlayerState.buffering:
        return Colors.yellow;
      case PlayerState.cued:
        return Colors.blue[900]!;
      default:
        return Colors.blue;
    }
  }

  Widget get _space => const SizedBox(height: 10);

  String loadStatus(pstate){
    switch(pstate){
      case PlayerState.paused:
        return 'En pausa';
      case PlayerState.playing:
        return 'Reproduciendo';
    case PlayerState.buffering:
      return 'Cargando...';
      case PlayerState.ended:
        return 'Cargando siguiente video...';
    default:
        return 'Cargando';
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 16.0,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        behavior: SnackBarBehavior.floating,
        elevation: 1.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
      ),
    );
  }

}
