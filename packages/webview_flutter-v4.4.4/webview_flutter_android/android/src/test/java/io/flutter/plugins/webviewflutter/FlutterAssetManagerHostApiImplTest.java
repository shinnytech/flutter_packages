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

import static org.junit.Assert.assertArrayEquals;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.fail;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.io.IOException;
import java.util.List;
import org.junit.Before;
import org.junit.Test;
import org.mockito.Mock;

public class FlutterAssetManagerHostApiImplTest {
  @Mock FlutterAssetManager mockFlutterAssetManager;

  FlutterAssetManagerHostApiImpl testFlutterAssetManagerHostApiImpl;

  @Before
  public void setUp() {
    mockFlutterAssetManager = mock(FlutterAssetManager.class);

    testFlutterAssetManagerHostApiImpl =
        new FlutterAssetManagerHostApiImpl(mockFlutterAssetManager);
  }

  @Test
  public void list() {
    try {
      when(mockFlutterAssetManager.list("test/path"))
          .thenReturn(new String[] {"index.html", "styles.css"});
      List<String> actualFilePaths = testFlutterAssetManagerHostApiImpl.list("test/path");
      verify(mockFlutterAssetManager).list("test/path");
      assertArrayEquals(new String[] {"index.html", "styles.css"}, actualFilePaths.toArray());
    } catch (IOException ex) {
      fail();
    }
  }

  @Test
  public void list_returns_empty_list_when_no_results() {
    try {
      when(mockFlutterAssetManager.list("test/path")).thenReturn(null);
      List<String> actualFilePaths = testFlutterAssetManagerHostApiImpl.list("test/path");
      verify(mockFlutterAssetManager).list("test/path");
      assertArrayEquals(new String[] {}, actualFilePaths.toArray());
    } catch (IOException ex) {
      fail();
    }
  }

  @Test(expected = RuntimeException.class)
  public void list_should_convert_io_exception_to_runtime_exception() {
    try {
      when(mockFlutterAssetManager.list("test/path")).thenThrow(new IOException());
      testFlutterAssetManagerHostApiImpl.list("test/path");
    } catch (IOException ex) {
      fail();
    }
  }

  @Test
  public void getAssetFilePathByName() {
    when(mockFlutterAssetManager.getAssetFilePathByName("index.html"))
        .thenReturn("flutter_assets/index.html");
    String filePath = testFlutterAssetManagerHostApiImpl.getAssetFilePathByName("index.html");
    verify(mockFlutterAssetManager).getAssetFilePathByName("index.html");
    assertEquals("flutter_assets/index.html", filePath);
  }
}
