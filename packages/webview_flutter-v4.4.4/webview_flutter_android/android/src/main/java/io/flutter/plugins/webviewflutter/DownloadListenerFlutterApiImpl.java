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

import android.webkit.DownloadListener;
import androidx.annotation.NonNull;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugins.webviewflutter.GeneratedAndroidWebView.DownloadListenerFlutterApi;

/**
 * Flutter Api implementation for {@link DownloadListener}.
 *
 * <p>Passes arguments of callbacks methods from a {@link DownloadListener} to Dart.
 */
public class DownloadListenerFlutterApiImpl extends DownloadListenerFlutterApi {
  private final InstanceManager instanceManager;

  /**
   * Creates a Flutter api that sends messages to Dart.
   *
   * @param binaryMessenger handles sending messages to Dart
   * @param instanceManager maintains instances stored to communicate with Dart objects
   */
  public DownloadListenerFlutterApiImpl(
      @NonNull BinaryMessenger binaryMessenger, @NonNull InstanceManager instanceManager) {
    super(binaryMessenger);
    this.instanceManager = instanceManager;
  }

  /** Passes arguments from {@link DownloadListener#onDownloadStart} to Dart. */
  public void onDownloadStart(
      @NonNull DownloadListener downloadListener,
      @NonNull String url,
      @NonNull String userAgent,
      @NonNull String contentDisposition,
      @NonNull String mimetype,
      long contentLength,
      @NonNull Reply<Void> callback) {
    onDownloadStart(
        getIdentifierForListener(downloadListener),
        url,
        userAgent,
        contentDisposition,
        mimetype,
        contentLength,
        callback);
  }

  private long getIdentifierForListener(DownloadListener listener) {
    final Long identifier = instanceManager.getIdentifierForStrongReference(listener);
    if (identifier == null) {
      throw new IllegalStateException("Could not find identifier for DownloadListener.");
    }
    return identifier;
  }
}
