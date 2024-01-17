package com.adservrs.adplayer.flutter.channels

import com.adservrs.adplayer.AdPlayer
import com.adservrs.adplayer.AdPlayerError
import com.adservrs.adplayer.tags.AdPlayerTag
import com.adservrs.adplayer.tags.AdPlayerTagInitCallback
import com.adservrs.adplayer.flutter.utils.failWithAdPlayerError
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class AdPlayerChannel(binding: FlutterPlugin.FlutterPluginBinding) : MethodChannel.MethodCallHandler {
    private val context = binding.applicationContext
    private val channel = MethodChannel(binding.binaryMessenger, "AdPlayer")

    init {
        channel.setMethodCallHandler(this)
    }

    fun release() {
        channel.setMethodCallHandler(null)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "getVersion" -> getVersion(result)
            "initialize" -> initialize(call, result)
            "initializePublisher" -> initializePublisher(call, result)
            "reportLayoutChange" -> reportLayoutChange(result)
            "getTagWhenReady" -> getTagWhenReady(call, result)
            else -> result.notImplemented()
        }
    }

    private fun getVersion(result: MethodChannel.Result) {
        result.success(AdPlayer.version)
    }

    private fun initialize(call: MethodCall, result: MethodChannel.Result) {
        AdPlayer.initialize(context) {
            applicationUserIdentifier = call.argument("applicationUserIdentifier")
            enableFullscreen = false
        }
        result.success(true)
    }

    private fun initializePublisher(call: MethodCall, result: MethodChannel.Result) {
        val tagId = call.argument<String>("tagId")
            ?: return result.error("tagId_missing", "tagId was not provided", null)

        val publisherId = call.argument<String>("publisherId")
            ?: return result.error("publisherId_missing", "publisherId was not provided", null)

        AdPlayer.initializePublisher(publisherId) {
            addTag(tagId)
        }
        result.success(true)
    }

    private fun reportLayoutChange(result: MethodChannel.Result) {
        AdPlayer.reportLayoutChange()
        result.success(true)
    }

    private fun getTagWhenReady(call: MethodCall, result: MethodChannel.Result) {
        val tagId = call.argument<String>("tagId")
            ?: return result.error("tagId_missing", "tagId was not provided", null)

        AdPlayer.getTagWhenReady(tagId, object : AdPlayerTagInitCallback {
            override fun onTagReady(tag: AdPlayerTag) {
                result.success(tagId)
            }

            override fun onError(error: AdPlayerError, tagId: String?) {
                result.failWithAdPlayerError(error)
            }
        })
    }
}
