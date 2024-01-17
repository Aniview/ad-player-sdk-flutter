package com.adservrs.adplayer.flutter.views

import android.content.Context
import android.util.Log
import android.view.View
import android.view.ViewGroup
import com.adservrs.adplayer.flutter.BuildConfig
import com.adservrs.adplayer.placements.AdPlayerPlacementView
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView

class AdPlayerPlacementViewWrapper(
    context: Context,
    viewId: Int,
    creationParams: Map<String?, Any?>,
    binding: FlutterPlugin.FlutterPluginBinding,
) : PlatformView {
    companion object {
        private const val TAG = "AdPlayerPlacementView"
    }

    private val placement: AdPlayerPlacementView
    private val placementWrapper: InfiniteView

    private val tagId = creationParams["tagId"] as String
    private val placementId = creationParams["placementId"] as Int
    private val channelName = "AdPlayerPlacementView/$placementId"
    private val channel = MethodChannel(binding.binaryMessenger, channelName)

    init {
        Log.d(TAG, "init: channelName = $channelName")

        channel.setMethodCallHandler(::onChannelMessage)

        placement = InternalView(context)
        placement.attachPlayerTag(tagId)
        placement.id = viewId
        placement.extendedLogging = BuildConfig.DEBUG

        placementWrapper = InfiniteView(context)
    }

    override fun getView(): View {
        return placementWrapper
    }

    override fun dispose() {
        Log.d(TAG, "dispose")

        channel.setMethodCallHandler(null)
    }

    private fun onChannelMessage(call: MethodCall, result: MethodChannel.Result) {
        Log.d(TAG, "onChannelMessage: method = ${call.method}")
        result.notImplemented()
    }

    private inner class InfiniteView(context: Context) : ViewGroup(context) {
        init {
            addView(placement)
        }

        override fun onMeasure(widthMeasureSpec: Int, heightMeasureSpec: Int) {
            placement.measure(widthMeasureSpec, 0)
            super.onMeasure(widthMeasureSpec, heightMeasureSpec)
        }

        override fun onLayout(changed: Boolean, l: Int, t: Int, r: Int, b: Int) {
            placement.layout(0, 0, placement.measuredWidth, placement.layoutParams.height)
        }
    }

    private inner class InternalView(context: Context) : AdPlayerPlacementView(context) {
        override fun onSizeChanged(w: Int, h: Int, oldw: Int, oldh: Int) {
            super.onSizeChanged(w, h, oldw, oldh)
            channel.invokeMethod("onHeightChanged", h.toFloat())
        }
    }
}
