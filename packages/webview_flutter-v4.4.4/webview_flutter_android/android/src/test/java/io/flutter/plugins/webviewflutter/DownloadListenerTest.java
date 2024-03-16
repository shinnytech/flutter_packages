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

import io.flutter.plugins.webviewflutter.DownloadListenerHostApiImpl.DownloadListenerCreator;
import io.flutter.plugins.webviewflutter.DownloadListenerHostApiImpl.DownloadListenerImpl;
import org.junit.After;
import org.junit.Before;
import org.junit.Rule;
import org.junit.Test;
import org.mockito.Mock;
import org.mockito.junit.MockitoJUnit;
import org.mockito.junit.MockitoRule;

public class DownloadListenerTest {
  @Rule public MockitoRule mockitoRule = MockitoJUnit.rule();

  @Mock public DownloadListenerFlutterApiImpl mockFlutterApi;

  InstanceManager instanceManager;
  DownloadListenerHostApiImpl hostApiImpl;
  DownloadListenerImpl downloadListener;

  @Before
  public void setUp() {
    instanceManager = InstanceManager.create(identifier -> {});

    final DownloadListenerCreator downloadListenerCreator =
        new DownloadListenerCreator() {
          @Override
          public DownloadListenerImpl createDownloadListener(
              DownloadListenerFlutterApiImpl flutterApi) {
            downloadListener = super.createDownloadListener(flutterApi);
            return downloadListener;
          }
        };

    hostApiImpl =
        new DownloadListenerHostApiImpl(instanceManager, downloadListenerCreator, mockFlutterApi);
    hostApiImpl.create(0L);
  }

  @After
  public void tearDown() {
    instanceManager.stopFinalizationListener();
  }

  @Test
  public void postMessage() {
    downloadListener.onDownloadStart(
        "https://www.google.com", "userAgent", "contentDisposition", "mimetype", 54);
    verify(mockFlutterApi)
        .onDownloadStart(
            eq(downloadListener),
            eq("https://www.google.com"),
            eq("userAgent"),
            eq("contentDisposition"),
            eq("mimetype"),
            eq(54L),
            any());
  }
}
