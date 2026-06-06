package com.example.audio_player

import android.media.MediaMetadataRetriever
import io.flutter.embedding.engine.FlutterEngine
import com.ryanheise.audioservice.AudioServiceActivity
import io.flutter.plugin.common.MethodChannel

class MainActivity : AudioServiceActivity() {

    private val CHANNEL = "audio_meta"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->

                if (call.method == "getMeta") {

                    val path = call.arguments as String

                    val retriever = MediaMetadataRetriever()
                    retriever.setDataSource(path)

                    val title = retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_TITLE)
                    val artist = retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_ARTIST)
                    val album = retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_ALBUM)

                    // 专辑封面
                    val albumArt: ByteArray? = retriever.embeddedPicture

                    retriever.release()

                    result.success(
                        mapOf(
                            "title" to title,
                            "artist" to artist,
                            "album" to album,
                            "albumArt" to albumArt
                        )
                    )
                } else {
                    result.notImplemented()
                }
            }
    }
}