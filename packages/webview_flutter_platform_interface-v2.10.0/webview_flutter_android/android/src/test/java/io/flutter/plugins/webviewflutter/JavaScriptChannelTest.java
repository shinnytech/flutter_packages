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

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.verify;

import android.os.Handler;
import android.os.Looper;
import io.flutter.plugins.webviewflutter.JavaScriptChannelHostApiImpl.JavaScriptChannelCreator;
import org.junit.After;
import org.junit.Before;
import org.junit.Rule;
import org.junit.Test;
import org.mockito.Mock;
import org.mockito.junit.MockitoJUnit;
import org.mockito.junit.MockitoRule;

public class JavaScriptChannelTest {
  @Rule public MockitoRule mockitoRule = MockitoJUnit.rule();

  @Mock public JavaScriptChannelFlutterApiImpl mockFlutterApi;

  InstanceManager instanceManager;
  JavaScriptChannelHostApiImpl hostApiImpl;
  JavaScriptChannel javaScriptChannel;

  @Before
  public void setUp() {
    instanceManager = InstanceManager.create(identifier -> {});

    final JavaScriptChannelCreator javaScriptChannelCreator =
        new JavaScriptChannelCreator() {
          @Override
          public JavaScriptChannel createJavaScriptChannel(
              JavaScriptChannelFlutterApiImpl javaScriptChannelFlutterApi,
              String channelName,
              Handler platformThreadHandler) {
            javaScriptChannel =
                super.createJavaScriptChannel(
                    javaScriptChannelFlutterApi, channelName, platformThreadHandler);
            return javaScriptChannel;
          }
        };

    hostApiImpl =
        new JavaScriptChannelHostApiImpl(
            instanceManager,
            javaScriptChannelCreator,
            mockFlutterApi,
            new Handler(Looper.myLooper()));
    hostApiImpl.create(0L, "aChannelName");
  }

  @After
  public void tearDown() {
    instanceManager.stopFinalizationListener();
  }

  @Test
  public void postMessage() {
    javaScriptChannel.postMessage("A message post.");
    verify(mockFlutterApi).postMessage(eq(javaScriptChannel), eq("A message post."), any());
  }
}
