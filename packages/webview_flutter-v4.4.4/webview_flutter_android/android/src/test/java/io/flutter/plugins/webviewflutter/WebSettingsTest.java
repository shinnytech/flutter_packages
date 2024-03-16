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
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import android.webkit.WebSettings;
import android.webkit.WebView;
import io.flutter.plugins.webviewflutter.WebSettingsHostApiImpl.WebSettingsCreator;
import org.junit.After;
import org.junit.Before;
import org.junit.Rule;
import org.junit.Test;
import org.mockito.Mock;
import org.mockito.junit.MockitoJUnit;
import org.mockito.junit.MockitoRule;

public class WebSettingsTest {
  @Rule public MockitoRule mockitoRule = MockitoJUnit.rule();

  @Mock public WebSettings mockWebSettings;

  @Mock WebSettingsCreator mockWebSettingsCreator;

  InstanceManager testInstanceManager;
  WebSettingsHostApiImpl testHostApiImpl;

  @Before
  public void setUp() {
    testInstanceManager = InstanceManager.create(identifier -> {});

    when(mockWebSettingsCreator.createWebSettings(any())).thenReturn(mockWebSettings);
    testHostApiImpl = new WebSettingsHostApiImpl(testInstanceManager, mockWebSettingsCreator);

    testInstanceManager.addDartCreatedInstance(mock(WebView.class), 1);
    testHostApiImpl.create(0L, 1L);
  }

  @After
  public void tearDown() {
    testInstanceManager.stopFinalizationListener();
  }

  @Test
  public void setDomStorageEnabled() {
    testHostApiImpl.setDomStorageEnabled(0L, true);
    verify(mockWebSettings).setDomStorageEnabled(true);
  }

  @Test
  public void setJavaScriptCanOpenWindowsAutomatically() {
    testHostApiImpl.setJavaScriptCanOpenWindowsAutomatically(0L, false);
    verify(mockWebSettings).setJavaScriptCanOpenWindowsAutomatically(false);
  }

  @Test
  public void setSupportMultipleWindows() {
    testHostApiImpl.setSupportMultipleWindows(0L, true);
    verify(mockWebSettings).setSupportMultipleWindows(true);
  }

  @Test
  public void setJavaScriptEnabled() {
    testHostApiImpl.setJavaScriptEnabled(0L, false);
    verify(mockWebSettings).setJavaScriptEnabled(false);
  }

  @Test
  public void setUserAgentString() {
    testHostApiImpl.setUserAgentString(0L, "hello");
    verify(mockWebSettings).setUserAgentString("hello");
  }

  @Test
  public void setMediaPlaybackRequiresUserGesture() {
    testHostApiImpl.setMediaPlaybackRequiresUserGesture(0L, false);
    verify(mockWebSettings).setMediaPlaybackRequiresUserGesture(false);
  }

  @Test
  public void setSupportZoom() {
    testHostApiImpl.setSupportZoom(0L, true);
    verify(mockWebSettings).setSupportZoom(true);
  }

  @Test
  public void setLoadWithOverviewMode() {
    testHostApiImpl.setLoadWithOverviewMode(0L, false);
    verify(mockWebSettings).setLoadWithOverviewMode(false);
  }

  @Test
  public void setUseWideViewPort() {
    testHostApiImpl.setUseWideViewPort(0L, true);
    verify(mockWebSettings).setUseWideViewPort(true);
  }

  @Test
  public void setDisplayZoomControls() {
    testHostApiImpl.setDisplayZoomControls(0L, false);
    verify(mockWebSettings).setDisplayZoomControls(false);
  }

  @Test
  public void setBuiltInZoomControls() {
    testHostApiImpl.setBuiltInZoomControls(0L, true);
    verify(mockWebSettings).setBuiltInZoomControls(true);
  }

  @Test
  public void setTextZoom() {
    testHostApiImpl.setTextZoom(0L, 100L);
    verify(mockWebSettings).setTextZoom(100);
  }

  @Test
  public void getUserAgentString() {
    final String userAgent = "str";
    when(mockWebSettings.getUserAgentString()).thenReturn(userAgent);
    assertEquals(testHostApiImpl.getUserAgentString(0L), userAgent);
  }
}
