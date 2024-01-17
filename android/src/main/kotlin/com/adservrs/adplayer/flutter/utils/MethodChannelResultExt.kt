package com.adservrs.adplayer.flutter.utils

import com.adservrs.adplayer.AdPlayerError
import io.flutter.plugin.common.MethodChannel

fun MethodChannel.Result.failWithAdPlayerError(error: AdPlayerError) {
    error(error.type.name, error.message, null)
}
