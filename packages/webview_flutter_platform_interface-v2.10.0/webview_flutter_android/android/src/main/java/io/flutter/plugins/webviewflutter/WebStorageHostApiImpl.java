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

import android.webkit.WebStorage;
import androidx.annotation.NonNull;
import io.flutter.plugins.webviewflutter.GeneratedAndroidWebView.WebStorageHostApi;
import java.util.Objects;

/**
 * Host api implementation for {@link WebStorage}.
 *
 * <p>Handles creating {@link WebStorage}s that intercommunicate with a paired Dart object.
 */
public class WebStorageHostApiImpl implements WebStorageHostApi {
  private final InstanceManager instanceManager;
  private final WebStorageCreator webStorageCreator;

  /** Handles creating {@link WebStorage} for a {@link WebStorageHostApiImpl}. */
  public static class WebStorageCreator {
    /**
     * Creates a {@link WebStorage}.
     *
     * @return the created {@link WebStorage}. Defaults to {@link WebStorage#getInstance}
     */
    @NonNull
    public WebStorage createWebStorage() {
      return WebStorage.getInstance();
    }
  }

  /**
   * Creates a host API that handles creating {@link WebStorage} and invoke its methods.
   *
   * @param instanceManager maintains instances stored to communicate with Dart objects
   * @param webStorageCreator handles creating {@link WebStorage}s
   */
  public WebStorageHostApiImpl(
      @NonNull InstanceManager instanceManager, @NonNull WebStorageCreator webStorageCreator) {
    this.instanceManager = instanceManager;
    this.webStorageCreator = webStorageCreator;
  }

  @Override
  public void create(@NonNull Long instanceId) {
    instanceManager.addDartCreatedInstance(webStorageCreator.createWebStorage(), instanceId);
  }

  @Override
  public void deleteAllData(@NonNull Long instanceId) {
    final WebStorage webStorage = Objects.requireNonNull(instanceManager.getInstance(instanceId));
    webStorage.deleteAllData();
  }
}
