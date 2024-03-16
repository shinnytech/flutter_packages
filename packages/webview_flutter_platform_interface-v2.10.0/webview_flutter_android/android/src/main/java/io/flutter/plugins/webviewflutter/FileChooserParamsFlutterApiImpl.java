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

import android.os.Build;
import android.webkit.WebChromeClient;
import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;
import io.flutter.plugin.common.BinaryMessenger;
import java.util.Arrays;

/**
 * Flutter Api implementation for {@link android.webkit.WebChromeClient.FileChooserParams}.
 *
 * <p>Passes arguments of callbacks methods from a {@link
 * android.webkit.WebChromeClient.FileChooserParams} to Dart.
 */
@RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
public class FileChooserParamsFlutterApiImpl
    extends GeneratedAndroidWebView.FileChooserParamsFlutterApi {
  private final InstanceManager instanceManager;

  /**
   * Creates a Flutter api that sends messages to Dart.
   *
   * @param binaryMessenger handles sending messages to Dart
   * @param instanceManager maintains instances stored to communicate with Dart objects
   */
  public FileChooserParamsFlutterApiImpl(
      @NonNull BinaryMessenger binaryMessenger, @NonNull InstanceManager instanceManager) {
    super(binaryMessenger);
    this.instanceManager = instanceManager;
  }

  private static GeneratedAndroidWebView.FileChooserMode toFileChooserEnumData(int mode) {

    switch (mode) {
      case WebChromeClient.FileChooserParams.MODE_OPEN:
        return GeneratedAndroidWebView.FileChooserMode.OPEN;

      case WebChromeClient.FileChooserParams.MODE_OPEN_MULTIPLE:
        return GeneratedAndroidWebView.FileChooserMode.OPEN_MULTIPLE;

      case WebChromeClient.FileChooserParams.MODE_SAVE:
        return GeneratedAndroidWebView.FileChooserMode.SAVE;

      default:
        throw new IllegalArgumentException(String.format("Unsupported FileChooserMode: %d", mode));
    }
  }

  /**
   * Stores the FileChooserParams instance and notifies Dart to create a new FileChooserParams
   * instance that is attached to this one.
   */
  public void create(
      @NonNull WebChromeClient.FileChooserParams instance, @NonNull Reply<Void> callback) {
    if (!instanceManager.containsInstance(instance)) {
      create(
          instanceManager.addHostCreatedInstance(instance),
          instance.isCaptureEnabled(),
          Arrays.asList(instance.getAcceptTypes()),
          toFileChooserEnumData(instance.getMode()),
          instance.getFilenameHint(),
          callback);
    }
  }
}
