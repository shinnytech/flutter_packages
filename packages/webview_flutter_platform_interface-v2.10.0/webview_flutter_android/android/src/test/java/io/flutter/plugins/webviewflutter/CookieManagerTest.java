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
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import android.os.Build;
import android.webkit.CookieManager;
import android.webkit.ValueCallback;
import android.webkit.WebView;
import androidx.annotation.NonNull;
import io.flutter.plugin.common.BinaryMessenger;
import org.junit.After;
import org.junit.Before;
import org.junit.Rule;
import org.junit.Test;
import org.mockito.ArgumentCaptor;
import org.mockito.Mock;
import org.mockito.junit.MockitoJUnit;
import org.mockito.junit.MockitoRule;

public class CookieManagerTest {
  @Rule public MockitoRule mockitoRule = MockitoJUnit.rule();
  @Mock public CookieManager mockCookieManager;
  @Mock public BinaryMessenger mockBinaryMessenger;
  @Mock public CookieManagerHostApiImpl.CookieManagerProxy mockProxy;
  InstanceManager instanceManager;

  @Before
  public void setUp() {
    instanceManager = InstanceManager.create(identifier -> {});
  }

  @After
  public void tearDown() {
    instanceManager.stopFinalizationListener();
  }

  @Test
  public void getInstance() {
    final CookieManager mockCookieManager = mock(CookieManager.class);
    final long instanceIdentifier = 1;

    when(mockProxy.getInstance()).thenReturn(mockCookieManager);

    final CookieManagerHostApiImpl hostApi =
        new CookieManagerHostApiImpl(mockBinaryMessenger, instanceManager, mockProxy);
    hostApi.attachInstance(instanceIdentifier);

    assertEquals(instanceManager.getInstance(instanceIdentifier), mockCookieManager);
  }

  @Test
  public void setCookie() {
    final String url = "testString";
    final String value = "testString2";

    final long instanceIdentifier = 0;
    instanceManager.addDartCreatedInstance(mockCookieManager, instanceIdentifier);

    final CookieManagerHostApiImpl hostApi =
        new CookieManagerHostApiImpl(mockBinaryMessenger, instanceManager);

    hostApi.setCookie(instanceIdentifier, url, value);

    verify(mockCookieManager).setCookie(url, value);
  }

  @SuppressWarnings({"rawtypes", "unchecked"})
  @Test
  public void clearCookies() {
    final long instanceIdentifier = 0;
    instanceManager.addDartCreatedInstance(mockCookieManager, instanceIdentifier);

    final CookieManagerHostApiImpl hostApi =
        new CookieManagerHostApiImpl(
            mockBinaryMessenger,
            instanceManager,
            new CookieManagerHostApiImpl.CookieManagerProxy(),
            (int version) -> version <= Build.VERSION_CODES.LOLLIPOP);

    final Boolean[] successResult = new Boolean[1];
    hostApi.removeAllCookies(
        instanceIdentifier,
        new GeneratedAndroidWebView.Result<Boolean>() {
          @Override
          public void success(Boolean result) {
            successResult[0] = result;
          }

          @Override
          public void error(@NonNull Throwable error) {}
        });

    final ArgumentCaptor<ValueCallback> valueCallbackArgumentCaptor =
        ArgumentCaptor.forClass(ValueCallback.class);
    verify(mockCookieManager).removeAllCookies(valueCallbackArgumentCaptor.capture());

    final Boolean returnValue = true;
    valueCallbackArgumentCaptor.getValue().onReceiveValue(returnValue);

    assertEquals(successResult[0], returnValue);
  }

  @Test
  public void setAcceptThirdPartyCookies() {
    final WebView mockWebView = mock(WebView.class);
    final long webViewIdentifier = 4;
    instanceManager.addDartCreatedInstance(mockWebView, webViewIdentifier);

    final boolean accept = true;

    final long instanceIdentifier = 0;
    instanceManager.addDartCreatedInstance(mockCookieManager, instanceIdentifier);

    final CookieManagerHostApiImpl hostApi =
        new CookieManagerHostApiImpl(
            mockBinaryMessenger,
            instanceManager,
            new CookieManagerHostApiImpl.CookieManagerProxy(),
            (int version) -> version <= Build.VERSION_CODES.LOLLIPOP);

    hostApi.setAcceptThirdPartyCookies(instanceIdentifier, webViewIdentifier, accept);

    verify(mockCookieManager).setAcceptThirdPartyCookies(mockWebView, accept);
  }
}
