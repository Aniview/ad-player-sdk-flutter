package com.adservrs.adplayer.flutter.channels

import com.adservrs.adplayer.AdPlayer
import com.adservrs.adplayer.flutter.utils.MethodCallException
import com.adservrs.adplayer.tags.AdPlayerTag
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

class AdPlayerTagChannel(binding: FlutterPlugin.FlutterPluginBinding) : MethodChannel.MethodCallHandler {
    private val scope = CoroutineScope(Dispatchers.Main)
    private val channel = MethodChannel(binding.binaryMessenger, "AdPlayerTag")

    init {
        channel.setMethodCallHandler(this)
    }

    fun release() {
        channel.setMethodCallHandler(null)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        val tagId = call.argument<String>("tagId")
            ?: return result.error("tagId_missing", "tagId was not provided", null)

        val tag = AdPlayer.getTagNowOrNull(tagId)
            ?: return result.error("tagId_not_found", "tag with $tagId id is missing", null)

        scope.launch {
            try {
                val value = when (call.method) {
                    "preloadVideo" -> preloadVideo(tag)
                    else -> return@launch result.notImplemented()
                }
                result.success(value)
            } catch (e: MethodCallException) {
                result.error(e.code, e.message, null)
            } catch (e: Throwable) {
                result.error("unknown", e.message, null)
            }
        }
    }

    private suspend fun preloadVideo(tag: AdPlayerTag): Boolean {
        tag.preloadVideoAsync()
        return true
    }
}
