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

import android.os.Build;
import android.webkit.CookieManager;
import androidx.annotation.ChecksSdkIntAtLeast;
import androidx.annotation.NonNull;
import androidx.annotation.VisibleForTesting;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugins.webviewflutter.GeneratedAndroidWebView.CookieManagerHostApi;
import java.util.Objects;

/**
 * Host API implementation for `CookieManager`.
 *
 * <p>This class may handle instantiating and adding native object instances that are attached to a
 * Dart instance or handle method calls on the associated native class or an instance of the class.
 */
public class CookieManagerHostApiImpl implements CookieManagerHostApi {
  // To ease adding additional methods, this value is added prematurely.
  @SuppressWarnings({"unused", "FieldCanBeLocal"})
  private final BinaryMessenger binaryMessenger;

  private final InstanceManager instanceManager;
  private final CookieManagerProxy proxy;
  private final @NonNull AndroidSdkChecker sdkChecker;

  // Interface for an injectable SDK version checker.
  @VisibleForTesting
  interface AndroidSdkChecker {
    @ChecksSdkIntAtLeast(parameter = 0)
    boolean sdkIsAtLeast(int version);
  }

  /** Proxy for constructors and static method of `CookieManager`. */
  @VisibleForTesting
  static class CookieManagerProxy {
    /** Handles the Dart static method `MyClass.myStaticMethod`. */
    @NonNull
    public CookieManager getInstance() {
      return CookieManager.getInstance();
    }
  }

  /**
   * Constructs a {@link CookieManagerHostApiImpl}.
   *
   * @param binaryMessenger used to communicate with Dart over asynchronous messages
   * @param instanceManager maintains instances stored to communicate with attached Dart objects
   */
  public CookieManagerHostApiImpl(
      @NonNull BinaryMessenger binaryMessenger, @NonNull InstanceManager instanceManager) {
    this(binaryMessenger, instanceManager, new CookieManagerProxy());
  }

  @VisibleForTesting
  CookieManagerHostApiImpl(
      @NonNull BinaryMessenger binaryMessenger,
      @NonNull InstanceManager instanceManager,
      @NonNull CookieManagerProxy proxy) {
    this(
        binaryMessenger, instanceManager, proxy, (int version) -> Build.VERSION.SDK_INT >= version);
  }

  @VisibleForTesting
  CookieManagerHostApiImpl(
      @NonNull BinaryMessenger binaryMessenger,
      @NonNull InstanceManager instanceManager,
      @NonNull CookieManagerProxy proxy,
      @NonNull AndroidSdkChecker sdkChecker) {
    this.binaryMessenger = binaryMessenger;
    this.instanceManager = instanceManager;
    this.proxy = proxy;
    this.sdkChecker = sdkChecker;
  }

  @Override
  public void attachInstance(@NonNull Long instanceIdentifier) {
    instanceManager.addDartCreatedInstance(proxy.getInstance(), instanceIdentifier);
  }

  @Override
  public void setCookie(@NonNull Long identifier, @NonNull String url, @NonNull String value) {
    getCookieManagerInstance(identifier).setCookie(url, value);
  }

  @Override
  public void removeAllCookies(
      @NonNull Long identifier, @NonNull GeneratedAndroidWebView.Result<Boolean> result) {
    if (sdkChecker.sdkIsAtLeast(Build.VERSION_CODES.LOLLIPOP)) {
      getCookieManagerInstance(identifier).removeAllCookies(result::success);
    } else {
      result.success(removeCookiesPreL(getCookieManagerInstance(identifier)));
    }
  }

  @Override
  public void setAcceptThirdPartyCookies(
      @NonNull Long identifier, @NonNull Long webViewIdentifier, @NonNull Boolean accept) {
    if (sdkChecker.sdkIsAtLeast(Build.VERSION_CODES.LOLLIPOP)) {
      getCookieManagerInstance(identifier)
          .setAcceptThirdPartyCookies(
              Objects.requireNonNull(instanceManager.getInstance(webViewIdentifier)), accept);
    } else {
      throw new UnsupportedOperationException(
          "`setAcceptThirdPartyCookies` is unsupported on versions below `Build.VERSION_CODES.LOLLIPOP`.");
    }
  }

  /**
   * Removes all cookies from the given cookie manager, using the deprecated (pre-Lollipop)
   * implementation.
   *
   * @param cookieManager The cookie manager to clear all cookies from.
   * @return Whether any cookies were removed.
   */
  @SuppressWarnings("deprecation")
  private boolean removeCookiesPreL(CookieManager cookieManager) {
    final boolean hasCookies = cookieManager.hasCookies();
    if (hasCookies) {
      cookieManager.removeAllCookie();
    }
    return hasCookies;
  }

  @NonNull
  private CookieManager getCookieManagerInstance(@NonNull Long identifier) {
    return Objects.requireNonNull(instanceManager.getInstance(identifier));
  }
}
