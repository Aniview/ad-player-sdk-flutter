package com.adservrs.adplayer.flutter

import android.util.Log
import com.adservrs.adplayer.flutter.channels.AdPlayerChannel
import com.adservrs.adplayer.flutter.channels.AdPlayerTagChannel
import com.adservrs.adplayer.flutter.views.AdPlayerPlacementViewFactory
import io.flutter.embedding.engine.plugins.FlutterPlugin

class AdPlayerPlugin : FlutterPlugin {
    companion object {
        private val TAG = "${AdPlayerPlugin::class.simpleName}"
    }

    private lateinit var adPlayerChannel: AdPlayerChannel
    private lateinit var adPlayerTagChannel: AdPlayerTagChannel

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        Log.d(TAG, "onAttachedToEngine")

        adPlayerChannel = AdPlayerChannel(flutterPluginBinding)
        adPlayerTagChannel = AdPlayerTagChannel(flutterPluginBinding)

        flutterPluginBinding.platformViewRegistry.registerViewFactory(
            "AdPlayerPlacementView",
            AdPlayerPlacementViewFactory(flutterPluginBinding),
        )
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        Log.d(TAG, "onDetachedFromEngine")

        adPlayerChannel.release()
        adPlayerTagChannel.release()
    }
}
