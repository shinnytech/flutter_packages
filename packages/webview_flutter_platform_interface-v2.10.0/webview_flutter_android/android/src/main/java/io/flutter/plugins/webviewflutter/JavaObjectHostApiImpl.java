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

/**
 * A pigeon Host API implementation that handles creating {@link Object}s and invoking its static
 * and instance methods.
 *
 * <p>{@link Object} instances created by {@link JavaObjectHostApiImpl} are used to intercommunicate
 * with a paired Dart object.
 */
public class JavaObjectHostApiImpl implements GeneratedAndroidWebView.JavaObjectHostApi {
  private final InstanceManager instanceManager;

  /**
   * Constructs a {@link JavaObjectHostApiImpl}.
   *
   * @param instanceManager maintains instances stored to communicate with Dart objects
   */
  public JavaObjectHostApiImpl(@NonNull InstanceManager instanceManager) {
    this.instanceManager = instanceManager;
  }

  @Override
  public void dispose(@NonNull Long identifier) {
    final Object instance = instanceManager.getInstance(identifier);
    if (instance instanceof WebViewHostApiImpl.WebViewPlatformView) {
      ((WebViewHostApiImpl.WebViewPlatformView) instance).destroy();
    }
    instanceManager.remove(identifier);
  }
}
