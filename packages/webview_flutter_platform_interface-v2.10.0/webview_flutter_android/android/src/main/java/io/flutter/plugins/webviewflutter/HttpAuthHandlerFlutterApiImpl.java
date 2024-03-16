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

import android.webkit.HttpAuthHandler;
import androidx.annotation.NonNull;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugins.webviewflutter.GeneratedAndroidWebView.HttpAuthHandlerFlutterApi;

/**
 * Flutter API implementation for {@link HttpAuthHandler}.
 *
 * <p>This class may handle adding native instances that are attached to a Dart instance or passing
 * arguments of callbacks methods to a Dart instance.
 */
public class HttpAuthHandlerFlutterApiImpl {
  // To ease adding additional methods, this value is added prematurely.
  @SuppressWarnings({"unused", "FieldCanBeLocal"})
  private final BinaryMessenger binaryMessenger;

  private final InstanceManager instanceManager;

  private final HttpAuthHandlerFlutterApi api;

  /**
   * Constructs a {@link HttpAuthHandlerFlutterApiImpl}.
   *
   * @param binaryMessenger used to communicate with Dart over asynchronous messages
   * @param instanceManager maintains instances stored to communicate with attached Dart objects
   */
  public HttpAuthHandlerFlutterApiImpl(
      @NonNull BinaryMessenger binaryMessenger, @NonNull InstanceManager instanceManager) {
    this.binaryMessenger = binaryMessenger;
    this.instanceManager = instanceManager;
    api = new HttpAuthHandlerFlutterApi(binaryMessenger);
  }

  /**
   * Stores the `HttpAuthHandler` instance and notifies Dart to create and store a new
   * `HttpAuthHandler` instance that is attached to this one. If `instance` has already been added,
   * this method does nothing.
   */
  public void create(
      @NonNull HttpAuthHandler instance, @NonNull HttpAuthHandlerFlutterApi.Reply<Void> callback) {
    if (!instanceManager.containsInstance(instance)) {
      api.create(instanceManager.addHostCreatedInstance(instance), callback);
    }
  }
}
