# Copyright (c) 2024 Hunan OpenValley Digital Industry Development Co., Ltd.
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

package io.flutter.plugins.webviewflutter;

import android.os.Handler;
import androidx.annotation.NonNull;
import io.flutter.plugins.webviewflutter.GeneratedAndroidWebView.JavaScriptChannelHostApi;

/**
 * Host api implementation for {@link JavaScriptChannel}.
 *
 * <p>Handles creating {@link JavaScriptChannel}s that intercommunicate with a paired Dart object.
 */
public class JavaScriptChannelHostApiImpl implements JavaScriptChannelHostApi {
  private final InstanceManager instanceManager;
  private final JavaScriptChannelCreator javaScriptChannelCreator;
  private final JavaScriptChannelFlutterApiImpl flutterApi;

  private Handler platformThreadHandler;

  /** Handles creating {@link JavaScriptChannel}s for a {@link JavaScriptChannelHostApiImpl}. */
  public static class JavaScriptChannelCreator {
    /**
     * Creates a {@link JavaScriptChannel}.
     *
     * @param flutterApi handles sending messages to Dart
     * @param channelName JavaScript channel the message should be sent through
     * @param platformThreadHandler handles making callbacks on the desired thread
     * @return the created {@link JavaScriptChannel}
     */
    @NonNull
    public JavaScriptChannel createJavaScriptChannel(
        @NonNull JavaScriptChannelFlutterApiImpl flutterApi,
        @NonNull String channelName,
        @NonNull Handler platformThreadHandler) {
      return new JavaScriptChannel(flutterApi, channelName, platformThreadHandler);
    }
  }

  /**
   * Creates a host API that handles creating {@link JavaScriptChannel}s.
   *
   * @param instanceManager maintains instances stored to communicate with Dart objects
   * @param javaScriptChannelCreator handles creating {@link JavaScriptChannel}s
   * @param flutterApi handles sending messages to Dart
   * @param platformThreadHandler handles making callbacks on the desired thread
   */
  public JavaScriptChannelHostApiImpl(
      @NonNull InstanceManager instanceManager,
      @NonNull JavaScriptChannelCreator javaScriptChannelCreator,
      @NonNull JavaScriptChannelFlutterApiImpl flutterApi,
      @NonNull Handler platformThreadHandler) {
    this.instanceManager = instanceManager;
    this.javaScriptChannelCreator = javaScriptChannelCreator;
    this.flutterApi = flutterApi;
    this.platformThreadHandler = platformThreadHandler;
  }

  /**
   * Sets the platformThreadHandler to make callbacks
   *
   * @param platformThreadHandler the new thread handler
   */
  public void setPlatformThreadHandler(@NonNull Handler platformThreadHandler) {
    this.platformThreadHandler = platformThreadHandler;
  }

  @Override
  public void create(@NonNull Long instanceId, @NonNull String channelName) {
    final JavaScriptChannel javaScriptChannel =
        javaScriptChannelCreator.createJavaScriptChannel(
            flutterApi, channelName, platformThreadHandler);
    instanceManager.addDartCreatedInstance(javaScriptChannel, instanceId);
  }
}
