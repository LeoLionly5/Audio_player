import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audio_player/presentation/widgets/play_pause_replay_button.dart';
import 'package:audio_player/presentation/pages/audio_player_bottom_sheet.dart';
import 'package:audio_player/presentation/widgets/album_cover.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

/// The bottom player bar, which contains the album img, name, play or pause button
class BottomPlayer extends StatefulWidget {
  /// The bottom player bar, which contains the album img, name, play or pause button
  const BottomPlayer({super.key});

  @override
  BottomPlayerState createState() => BottomPlayerState();
}

class BottomPlayerState extends State<BottomPlayer> {
  final audioPlayer = GetIt.instance<AssetsAudioPlayer>();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Playing?>(
      stream: audioPlayer.current,
      builder: (context, snapshot) {
        final state = snapshot.data;
        late bool hasSelectedAudio;
        if (state?.audio.assetAudioPath.isEmpty ?? true) {
          hasSelectedAudio = false;
        } else {
          hasSelectedAudio = true;
        }
        final mediaItem = hasSelectedAudio ? state!.audio.audio.metas : Metas();
        final audioName = mediaItem.title ?? 'Please select an audio';
        return GestureDetector(
          onTap: hasSelectedAudio
              ? () {
                  // Click the bottom play bar to open the player bottom sheet
                  showModalBottomSheet(
                      // Unlock height limit of the bottom sheet
                      isScrollControlled: true,
                      // Re-limit height
                      constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height / 1.3),
                      context: context,
                      builder: (_) {
                        return const AudioPlayerBottomSheet();
                      });
                }
              : null,
          child: Container(
            // TODO Better size control
            height: 60, // Adjust the height of the floating player
            decoration: BoxDecoration(
              color: Colors.grey,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 20,
                ),
                // TODO Better size control
                AlbumCover(
                  size: 40,
                  albumArt: mediaItem.extra?['albumArt'],
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(child: Text(audioName)),
                if (hasSelectedAudio)
                  // 播放/暂停/重播按钮
                  // TODO Better size control
                  const PlayPauseReplayButton(
                    iconSize: 40,
                  ),
                const SizedBox(
                  width: 20,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
