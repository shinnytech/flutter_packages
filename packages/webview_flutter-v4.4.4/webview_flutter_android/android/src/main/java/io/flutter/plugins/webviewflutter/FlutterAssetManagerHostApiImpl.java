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

import android.webkit.WebView;
import androidx.annotation.NonNull;
import io.flutter.plugins.webviewflutter.GeneratedAndroidWebView.FlutterAssetManagerHostApi;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

/**
 * Host api implementation for {@link WebView}.
 *
 * <p>Handles creating {@link WebView}s that intercommunicate with a paired Dart object.
 */
public class FlutterAssetManagerHostApiImpl implements FlutterAssetManagerHostApi {
  final FlutterAssetManager flutterAssetManager;

  /** Constructs a new instance of {@link FlutterAssetManagerHostApiImpl}. */
  public FlutterAssetManagerHostApiImpl(@NonNull FlutterAssetManager flutterAssetManager) {
    this.flutterAssetManager = flutterAssetManager;
  }

  @NonNull
  @Override
  public List<String> list(@NonNull String path) {
    try {
      String[] paths = flutterAssetManager.list(path);

      if (paths == null) {
        return new ArrayList<>();
      }

      return Arrays.asList(paths);
    } catch (IOException ex) {
      throw new RuntimeException(ex.getMessage());
    }
  }

  @NonNull
  @Override
  public String getAssetFilePathByName(@NonNull String name) {
    return flutterAssetManager.getAssetFilePathByName(name);
  }
}
