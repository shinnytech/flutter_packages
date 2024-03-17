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

package io.flutter.plugins.webviewflutterexample;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNull;

import androidx.test.ext.junit.runners.AndroidJUnit4;
import io.flutter.plugins.webviewflutter.InstanceManager;
import org.junit.Test;
import org.junit.runner.RunWith;

@RunWith(AndroidJUnit4.class)
public class InstanceManagerTest {
  @Test
  public void managerDoesNotTriggerFinalizationListenerWhenStopped() throws InterruptedException {
    final boolean[] callbackTriggered = {false};
    final InstanceManager instanceManager =
        InstanceManager.create(identifier -> callbackTriggered[0] = true);
    instanceManager.stopFinalizationListener();

    Object object = new Object();
    instanceManager.addDartCreatedInstance(object, 0);

    assertEquals(object, instanceManager.remove(0));

    // To allow for object to be garbage collected.
    //noinspection UnusedAssignment
    object = null;

    Runtime.getRuntime().gc();

    // Wait for the interval after finalized callbacks are made for garbage collected objects.
    // See InstanceManager.CLEAR_FINALIZED_WEAK_REFERENCES_INTERVAL.
    Thread.sleep(30000);

    assertNull(instanceManager.getInstance(0));
    assertFalse(callbackTriggered[0]);
  }
}
