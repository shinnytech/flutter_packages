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

import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import android.webkit.WebStorage;
import org.junit.After;
import org.junit.Before;
import org.junit.Rule;
import org.junit.Test;
import org.mockito.Mock;
import org.mockito.junit.MockitoJUnit;
import org.mockito.junit.MockitoRule;

public class WebStorageHostApiImplTest {
  @Rule public MockitoRule mockitoRule = MockitoJUnit.rule();

  @Mock public WebStorage mockWebStorage;

  @Mock WebStorageHostApiImpl.WebStorageCreator mockWebStorageCreator;

  InstanceManager testInstanceManager;
  WebStorageHostApiImpl testHostApiImpl;

  @Before
  public void setUp() {
    testInstanceManager = InstanceManager.create(identifier -> {});

    when(mockWebStorageCreator.createWebStorage()).thenReturn(mockWebStorage);
    testHostApiImpl = new WebStorageHostApiImpl(testInstanceManager, mockWebStorageCreator);
    testHostApiImpl.create(0L);
  }

  @After
  public void tearDown() {
    testInstanceManager.stopFinalizationListener();
  }

  @Test
  public void deleteAllData() {
    testHostApiImpl.deleteAllData(0L);
    verify(mockWebStorage).deleteAllData();
  }
}
