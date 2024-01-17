package com.adservrs.adplayer.flutter.views

import android.content.Context
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class AdPlayerPlacementViewFactory(
    private val flutterPluginBinding: FlutterPlugin.FlutterPluginBinding,
) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        @Suppress("UNCHECKED_CAST")
        return AdPlayerPlacementViewWrapper(
            context = context,
            viewId = viewId,
            creationParams = args as Map<String?, Any?>,
            binding = flutterPluginBinding,
        )
    }
}
