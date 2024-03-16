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

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

import android.content.Context;
import android.webkit.WebView;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.PluginRegistry;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.platform.PlatformViewRegistry;
import org.junit.Rule;
import org.junit.Test;
import org.mockito.Mock;
import org.mockito.junit.MockitoJUnit;
import org.mockito.junit.MockitoRule;

public class WebViewFlutterAndroidExternalApiTest {
  @Rule public MockitoRule mockitoRule = MockitoJUnit.rule();

  @Mock Context mockContext;

  @Mock BinaryMessenger mockBinaryMessenger;

  @Mock PlatformViewRegistry mockViewRegistry;

  @Mock FlutterPlugin.FlutterPluginBinding mockPluginBinding;

  @Test
  public void getWebView() {
    final WebViewFlutterPlugin webViewFlutterPlugin = new WebViewFlutterPlugin();

    when(mockPluginBinding.getApplicationContext()).thenReturn(mockContext);
    when(mockPluginBinding.getPlatformViewRegistry()).thenReturn(mockViewRegistry);
    when(mockPluginBinding.getBinaryMessenger()).thenReturn(mockBinaryMessenger);

    webViewFlutterPlugin.onAttachedToEngine(mockPluginBinding);

    final InstanceManager instanceManager = webViewFlutterPlugin.getInstanceManager();
    assertNotNull(instanceManager);

    final WebView mockWebView = mock(WebView.class);
    instanceManager.addDartCreatedInstance(mockWebView, 0);

    final PluginRegistry mockPluginRegistry = mock(PluginRegistry.class);
    when(mockPluginRegistry.get(WebViewFlutterPlugin.class)).thenReturn(webViewFlutterPlugin);

    final FlutterEngine mockFlutterEngine = mock(FlutterEngine.class);
    when(mockFlutterEngine.getPlugins()).thenReturn(mockPluginRegistry);

    assertEquals(WebViewFlutterAndroidExternalApi.getWebView(mockFlutterEngine, 0), mockWebView);

    webViewFlutterPlugin.onDetachedFromEngine(mockPluginBinding);
  }
}
