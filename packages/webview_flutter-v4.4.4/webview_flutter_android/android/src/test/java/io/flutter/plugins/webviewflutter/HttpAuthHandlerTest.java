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

import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.verify;

import android.webkit.HttpAuthHandler;
import io.flutter.plugin.common.BinaryMessenger;
import org.junit.After;
import org.junit.Before;
import org.junit.Rule;
import org.junit.Test;
import org.mockito.Mock;
import org.mockito.junit.MockitoJUnit;
import org.mockito.junit.MockitoRule;

public class HttpAuthHandlerTest {
  @Rule public MockitoRule mockitoRule = MockitoJUnit.rule();

  @Mock HttpAuthHandler mockAuthHandler;

  @Mock BinaryMessenger mockBinaryMessenger;

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
  public void proceed() {
    final HttpAuthHandlerHostApiImpl hostApi =
        new HttpAuthHandlerHostApiImpl(mockBinaryMessenger, instanceManager);
    final long instanceIdentifier = 65L;
    final String username = "username";
    final String password = "password";
    instanceManager.addDartCreatedInstance(mockAuthHandler, instanceIdentifier);

    hostApi.proceed(instanceIdentifier, username, password);

    verify(mockAuthHandler).proceed(eq(username), eq(password));
  }

  @Test
  public void cancel() {
    final HttpAuthHandlerHostApiImpl hostApi =
        new HttpAuthHandlerHostApiImpl(mockBinaryMessenger, instanceManager);
    final long instanceIdentifier = 65L;
    instanceManager.addDartCreatedInstance(mockAuthHandler, instanceIdentifier);

    hostApi.cancel(instanceIdentifier);

    verify(mockAuthHandler).cancel();
  }

  @Test
  public void useHttpAuthUsernamePassword() {
    final HttpAuthHandlerHostApiImpl hostApi =
        new HttpAuthHandlerHostApiImpl(mockBinaryMessenger, instanceManager);
    final long instanceIdentifier = 65L;
    instanceManager.addDartCreatedInstance(mockAuthHandler, instanceIdentifier);

    hostApi.useHttpAuthUsernamePassword(instanceIdentifier);

    verify(mockAuthHandler).useHttpAuthUsernamePassword();
  }
}
