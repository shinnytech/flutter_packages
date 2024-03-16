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

import androidx.annotation.NonNull;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugins.webviewflutter.GeneratedAndroidWebView.JavaScriptChannelFlutterApi;

/**
 * Flutter Api implementation for {@link JavaScriptChannel}.
 *
 * <p>Passes arguments of callbacks methods from a {@link JavaScriptChannel} to Dart.
 */
public class JavaScriptChannelFlutterApiImpl extends JavaScriptChannelFlutterApi {
  private final InstanceManager instanceManager;

  /**
   * Creates a Flutter api that sends messages to Dart.
   *
   * @param binaryMessenger Handles sending messages to Dart.
   * @param instanceManager Maintains instances stored to communicate with Dart objects.
   */
  public JavaScriptChannelFlutterApiImpl(
      @NonNull BinaryMessenger binaryMessenger, @NonNull InstanceManager instanceManager) {
    super(binaryMessenger);
    this.instanceManager = instanceManager;
  }

  /** Passes arguments from {@link JavaScriptChannel#postMessage} to Dart. */
  public void postMessage(
      @NonNull JavaScriptChannel javaScriptChannel,
      @NonNull String messageArg,
      @NonNull Reply<Void> callback) {
    super.postMessage(getIdentifierForJavaScriptChannel(javaScriptChannel), messageArg, callback);
  }

  private long getIdentifierForJavaScriptChannel(JavaScriptChannel javaScriptChannel) {
    final Long identifier = instanceManager.getIdentifierForStrongReference(javaScriptChannel);
    if (identifier == null) {
      throw new IllegalStateException("Could not find identifier for JavaScriptChannel.");
    }
    return identifier;
  }
}
