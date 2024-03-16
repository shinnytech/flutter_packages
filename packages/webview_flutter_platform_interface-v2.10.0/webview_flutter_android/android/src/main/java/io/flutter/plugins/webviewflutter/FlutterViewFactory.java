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

import android.content.Context;
import android.view.View;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

class FlutterViewFactory extends PlatformViewFactory {
  private final InstanceManager instanceManager;

  FlutterViewFactory(InstanceManager instanceManager) {
    super(StandardMessageCodec.INSTANCE);
    this.instanceManager = instanceManager;
  }

  @NonNull
  @Override
  public PlatformView create(Context context, int viewId, @Nullable Object args) {
    final Integer identifier = (Integer) args;
    if (identifier == null) {
      throw new IllegalStateException("An identifier is required to retrieve a View instance.");
    }

    final Object instance = instanceManager.getInstance(identifier);

    if (instance instanceof PlatformView) {
      return (PlatformView) instance;
    } else if (instance instanceof View) {
      return new PlatformView() {
        @Override
        public View getView() {
          return (View) instance;
        }

        @Override
        public void dispose() {}
      };
    }

    throw new IllegalStateException(
        "Unable to find a PlatformView or View instance: " + args + ", " + instance);
  }
}
