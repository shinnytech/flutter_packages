// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
// Autogenerated from Pigeon (v11.0.1), do not edit directly.
// See also: https://pub.dev/packages/pigeon


import android.util.Log
import io.flutter.plugin.common.BasicMessageChannel
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MessageCodec
import io.flutter.plugin.common.StandardMessageCodec
import java.io.ByteArrayOutputStream
import java.nio.ByteBuffer

private fun wrapResult(result: Any?): List<Any?> {
  return listOf(result)
}

private fun wrapError(exception: Throwable): List<Any?> {
  if (exception is FlutterError) {
    return listOf(
      exception.code,
      exception.message,
      exception.details
    )
  } else {
    return listOf(
      exception.javaClass.simpleName,
      exception.toString(),
      "Cause: " + exception.cause + ", Stacktrace: " + Log.getStackTraceString(exception)
    )
  }
}

/**
 * Error class for passing custom error details to Flutter via a thrown PlatformException.
 * @property code The error code.
 * @property message The error message.
 * @property details The error details. Must be a datatype supported by the api codec.
 */
class FlutterError (
  val code: String,
  override val message: String? = null,
  val details: Any? = null
) : Throwable()

enum class Code(val raw: Int) {
  ONE(0),
  TWO(1);

  companion object {
    fun ofRaw(raw: Int): Code? {
      return values().firstOrNull { it.raw == raw }
    }
  }
}

/** Generated class from Pigeon that represents data sent in messages. */
data class MessageData (
  val name: String? = null,
  val description: String? = null,
  val code: Code,
  val data: Map<String?, String?>

) {
  companion object {
    @Suppress("UNCHECKED_CAST")
    fun fromList(list: List<Any?>): MessageData {
      val name = list[0] as String?
      val description = list[1] as String?
      val code = Code.ofRaw(list[2] as Int)!!
      val data = list[3] as Map<String?, String?>
      return MessageData(name, description, code, data)
    }
  }
  fun toList(): List<Any?> {
    return listOf<Any?>(
      name,
      description,
      code.raw,
      data,
    )
  }
}

@Suppress("UNCHECKED_CAST")
private object ExampleHostApiCodec : StandardMessageCodec() {
  override fun readValueOfType(type: Byte, buffer: ByteBuffer): Any? {
    return when (type) {
      128.toByte() -> {
        return (readValue(buffer) as? List<Any?>)?.let {
          MessageData.fromList(it)
        }
      }
      else -> super.readValueOfType(type, buffer)
    }
  }
  override fun writeValue(stream: ByteArrayOutputStream, value: Any?)   {
    when (value) {
      is MessageData -> {
        stream.write(128)
        writeValue(stream, value.toList())
      }
      else -> super.writeValue(stream, value)
    }
  }
}

/** Generated interface from Pigeon that represents a handler of messages from Flutter. */
interface ExampleHostApi {
  fun getHostLanguage(): String
  fun add(a: Long, b: Long): Long
  fun sendMessage(message: MessageData, callback: (Result<Boolean>) -> Unit)

  companion object {
    /** The codec used by ExampleHostApi. */
    val codec: MessageCodec<Any?> by lazy {
      ExampleHostApiCodec
    }
    /** Sets up an instance of `ExampleHostApi` to handle messages through the `binaryMessenger`. */
    @Suppress("UNCHECKED_CAST")
    fun setUp(binaryMessenger: BinaryMessenger, api: ExampleHostApi?) {
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.pigeon_example_package.ExampleHostApi.getHostLanguage", codec)
        if (api != null) {
          channel.setMessageHandler { _, reply ->
            var wrapped: List<Any?>
            try {
              wrapped = listOf<Any?>(api.getHostLanguage())
            } catch (exception: Throwable) {
              wrapped = wrapError(exception)
            }
            reply.reply(wrapped)
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.pigeon_example_package.ExampleHostApi.add", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val aArg = args[0].let { if (it is Int) it.toLong() else it as Long }
            val bArg = args[1].let { if (it is Int) it.toLong() else it as Long }
            var wrapped: List<Any?>
            try {
              wrapped = listOf<Any?>(api.add(aArg, bArg))
            } catch (exception: Throwable) {
              wrapped = wrapError(exception)
            }
            reply.reply(wrapped)
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.pigeon_example_package.ExampleHostApi.sendMessage", codec)
        if (api != null) {
          channel.setMessageHandler { message, reply ->
            val args = message as List<Any?>
            val messageArg = args[0] as MessageData
            api.sendMessage(messageArg) { result: Result<Boolean> ->
              val error = result.exceptionOrNull()
              if (error != null) {
                reply.reply(wrapError(error))
              } else {
                val data = result.getOrNull()
                reply.reply(wrapResult(data))
              }
            }
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
    }
  }
}
/** Generated class from Pigeon that represents Flutter messages that can be called from Kotlin. */
@Suppress("UNCHECKED_CAST")
class MessageFlutterApi(private val binaryMessenger: BinaryMessenger) {
  companion object {
    /** The codec used by MessageFlutterApi. */
    val codec: MessageCodec<Any?> by lazy {
      StandardMessageCodec()
    }
  }
  fun flutterMethod(aStringArg: String?, callback: (String) -> Unit) {
    val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.pigeon_example_package.MessageFlutterApi.flutterMethod", codec)
    channel.send(listOf(aStringArg)) {
      val result = it as String
      callback(result)
    }
  }
}
