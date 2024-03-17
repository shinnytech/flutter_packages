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

package android.util;

import java.util.HashMap;

// Creates an implementation of LongSparseArray that can be used with unittests and the JVM.
// Typically android.util.LongSparseArray does nothing when not used with an Android environment.
public class LongSparseArray<E> {
  private final HashMap<Long, E> mHashMap;

  public LongSparseArray() {
    mHashMap = new HashMap<>();
  }

  public void append(long key, E value) {
    mHashMap.put(key, value);
  }

  public E get(long key) {
    return mHashMap.get(key);
  }

  public void remove(long key) {
    mHashMap.remove(key);
  }
}
