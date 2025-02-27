// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Mocks generated by Mockito 5.4.4 from annotations
// in webview_flutter_android/test/legacy/webview_android_widget_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i5;
import 'dart:typed_data' as _i7;
import 'dart:ui' as _i3;

import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i6;
import 'package:webview_flutter_android/src/android_webview.dart' as _i2;
import 'package:webview_flutter_android/src/legacy/webview_android_widget.dart'
    as _i8;
import 'package:webview_flutter_platform_interface/src/webview_flutter_platform_interface_legacy.dart'
    as _i4;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeWebSettings_0 extends _i1.SmartFake implements _i2.WebSettings {
  _FakeWebSettings_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeWebStorage_1 extends _i1.SmartFake implements _i2.WebStorage {
  _FakeWebStorage_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeOffset_2 extends _i1.SmartFake implements _i3.Offset {
  _FakeOffset_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeWebView_3 extends _i1.SmartFake implements _i2.WebView {
  _FakeWebView_3(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeDownloadListener_4 extends _i1.SmartFake
    implements _i2.DownloadListener {
  _FakeDownloadListener_4(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeJavascriptChannelRegistry_5 extends _i1.SmartFake
    implements _i4.JavascriptChannelRegistry {
  _FakeJavascriptChannelRegistry_5(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeJavaScriptChannel_6 extends _i1.SmartFake
    implements _i2.JavaScriptChannel {
  _FakeJavaScriptChannel_6(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeWebChromeClient_7 extends _i1.SmartFake
    implements _i2.WebChromeClient {
  _FakeWebChromeClient_7(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeWebViewClient_8 extends _i1.SmartFake implements _i2.WebViewClient {
  _FakeWebViewClient_8(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [FlutterAssetManager].
///
/// See the documentation for Mockito's code generation for more information.
class MockFlutterAssetManager extends _i1.Mock
    implements _i2.FlutterAssetManager {
  MockFlutterAssetManager() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i5.Future<List<String?>> list(String? path) => (super.noSuchMethod(
        Invocation.method(
          #list,
          [path],
        ),
        returnValue: _i5.Future<List<String?>>.value(<String?>[]),
      ) as _i5.Future<List<String?>>);

  @override
  _i5.Future<String> getAssetFilePathByName(String? name) =>
      (super.noSuchMethod(
        Invocation.method(
          #getAssetFilePathByName,
          [name],
        ),
        returnValue: _i5.Future<String>.value(_i6.dummyValue<String>(
          this,
          Invocation.method(
            #getAssetFilePathByName,
            [name],
          ),
        )),
      ) as _i5.Future<String>);
}

/// A class which mocks [WebSettings].
///
/// See the documentation for Mockito's code generation for more information.
class MockWebSettings extends _i1.Mock implements _i2.WebSettings {
  MockWebSettings() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i5.Future<void> setDomStorageEnabled(bool? flag) => (super.noSuchMethod(
        Invocation.method(
          #setDomStorageEnabled,
          [flag],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<void> setJavaScriptCanOpenWindowsAutomatically(bool? flag) =>
      (super.noSuchMethod(
        Invocation.method(
          #setJavaScriptCanOpenWindowsAutomatically,
          [flag],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<void> setSupportMultipleWindows(bool? support) =>
      (super.noSuchMethod(
        Invocation.method(
          #setSupportMultipleWindows,
          [support],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<void> setJavaScriptEnabled(bool? flag) => (super.noSuchMethod(
        Invocation.method(
          #setJavaScriptEnabled,
          [flag],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<void> setUserAgentString(String? userAgentString) =>
      (super.noSuchMethod(
        Invocation.method(
          #setUserAgentString,
          [userAgentString],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<void> setMediaPlaybackRequiresUserGesture(bool? require) =>
      (super.noSuchMethod(
        Invocation.method(
          #setMediaPlaybackRequiresUserGesture,
          [require],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<void> setSupportZoom(bool? support) => (super.noSuchMethod(
        Invocation.method(
          #setSupportZoom,
          [support],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<void> setLoadWithOverviewMode(bool? overview) =>
      (super.noSuchMethod(
        Invocation.method(
          #setLoadWithOverviewMode,
          [overview],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<void> setUseWideViewPort(bool? use) => (super.noSuchMethod(
        Invocation.method(
          #setUseWideViewPort,
          [use],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<void> setDisplayZoomControls(bool? enabled) => (super.noSuchMethod(
        Invocation.method(
          #setDisplayZoomControls,
          [enabled],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<void> setBuiltInZoomControls(bool? enabled) => (super.noSuchMethod(
        Invocation.method(
          #setBuiltInZoomControls,
          [enabled],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<void> setAllowFileAccess(bool? enabled) => (super.noSuchMethod(
        Invocation.method(
          #setAllowFileAccess,
          [enabled],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<void> setTextZoom(int? textZoom) => (super.noSuchMethod(
        Invocation.method(
          #setTextZoom,
          [textZoom],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<String> getUserAgentString() => (super.noSuchMethod(
        Invocation.method(
          #getUserAgentString,
          [],
        ),
        returnValue: _i5.Future<String>.value(_i6.dummyValue<String>(
          this,
          Invocation.method(
            #getUserAgentString,
            [],
          ),
        )),
      ) as _i5.Future<String>);

  @override
  _i2.WebSettings copy() => (super.noSuchMethod(
        Invocation.method(
          #copy,
          [],
        ),
        returnValue: _FakeWebSettings_0(
          this,
          Invocation.method(
            #copy,
            [],
          ),
        ),
      ) as _i2.WebSettings);
}

/// A class which mocks [WebStorage].
///
/// See the documentation for Mockito's code generation for more information.
class MockWebStorage extends _i1.Mock implements _i2.WebStorage {
  MockWebStorage() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i5.Future<void> deleteAllData() => (super.noSuchMethod(
        Invocation.method(
          #deleteAllData,
          [],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i2.WebStorage copy() => (super.noSuchMethod(
        Invocation.method(
          #copy,
          [],
        ),
        returnValue: _FakeWebStorage_1(
          this,
          Invocation.method(
            #copy,
            [],
          ),
        ),
      ) as _i2.WebStorage);
}

/// A class which mocks [WebView].
///
/// See the documentation for Mockito's code generation for more information.
class MockWebView extends _i1.Mock implements _i2.WebView {
  MockWebView() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.WebSettings get settings => (super.noSuchMethod(
        Invocation.getter(#settings),
        returnValue: _FakeWebSettings_0(
          this,
          Invocation.getter(#settings),
        ),
      ) as _i2.WebSettings);

  @override
  _i5.Future<void> loadData({
    required String? data,
    String? mimeType,
    String? encoding,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #loadData,
          [],
          {
            #data: data,
            #mimeType: mimeType,
            #encoding: encoding,
          },
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<void> loadDataWithBaseUrl({
    String? baseUrl,
    required String? data,
    String? mimeType,
    String? encoding,
    String? historyUrl,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #loadDataWithBaseUrl,
          [],
          {
            #baseUrl: baseUrl,
            #data: data,
            #mimeType: mimeType,
            #encoding: encoding,
            #historyUrl: historyUrl,
          },
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<void> loadUrl(
    String? url,
    Map<String, String>? headers,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #loadUrl,
          [
            url,
            headers,
          ],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<void> postUrl(
    String? url,
    _i7.Uint8List? data,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #postUrl,
          [
            url,
            data,
          ],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<String?> getUrl() => (super.noSuchMethod(
        Invocation.method(
          #getUrl,
          [],
        ),
        returnValue: _i5.Future<String?>.value(),
      ) as _i5.Future<String?>);

  @override
  _i5.Future<bool> canGoBack() => (super.noSuchMethod(
        Invocation.method(
          #canGoBack,
          [],
        ),
        returnValue: _i5.Future<bool>.value(false),
      ) as _i5.Future<bool>);

  @override
  _i5.Future<bool> canGoForward() => (super.noSuchMethod(
        Invocation.method(
          #canGoForward,
          [],
        ),
        returnValue: _i5.Future<bool>.value(false),
      ) as _i5.Future<bool>);

  @override
  _i5.Future<void> goBack() => (super.noSuchMethod(
        Invocation.method(
          #goBack,
          [],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<void> goForward() => (super.noSuchMethod(
        Invocation.method(
          #goForward,
          [],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<void> reload() => (super.noSuchMethod(
        Invocation.method(
          #reload,
          [],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<void> clearCache(bool? includeDiskFiles) => (super.noSuchMethod(
        Invocation.method(
          #clearCache,
          [includeDiskFiles],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<String?> evaluateJavascript(String? javascriptString) =>
      (super.noSuchMethod(
        Invocation.method(
          #evaluateJavascript,
          [javascriptString],
        ),
        returnValue: _i5.Future<String?>.value(),
      ) as _i5.Future<String?>);

  @override
  _i5.Future<String?> getTitle() => (super.noSuchMethod(
        Invocation.method(
          #getTitle,
          [],
        ),
        returnValue: _i5.Future<String?>.value(),
      ) as _i5.Future<String?>);

  @override
  _i5.Future<void> scrollTo(
    int? x,
    int? y,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #scrollTo,
          [
            x,
            y,
          ],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<void> scrollBy(
    int? x,
    int? y,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #scrollBy,
          [
            x,
            y,
          ],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<int> getScrollX() => (super.noSuchMethod(
        Invocation.method(
          #getScrollX,
          [],
        ),
        returnValue: _i5.Future<int>.value(0),
      ) as _i5.Future<int>);

  @override
  _i5.Future<int> getScrollY() => (super.noSuchMethod(
        Invocation.method(
          #getScrollY,
          [],
        ),
        returnValue: _i5.Future<int>.value(0),
      ) as _i5.Future<int>);

  @override
  _i5.Future<_i3.Offset> getScrollPosition() => (super.noSuchMethod(
        Invocation.method(
          #getScrollPosition,
          [],
        ),
        returnValue: _i5.Future<_i3.Offset>.value(_FakeOffset_2(
          this,
          Invocation.method(
            #getScrollPosition,
            [],
          ),
        )),
      ) as _i5.Future<_i3.Offset>);

  @override
  _i5.Future<void> setWebViewClient(_i2.WebViewClient? webViewClient) =>
      (super.noSuchMethod(
        Invocation.method(
          #setWebViewClient,
          [webViewClient],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<void> addJavaScriptChannel(
          _i2.JavaScriptChannel? javaScriptChannel) =>
      (super.noSuchMethod(
        Invocation.method(
          #addJavaScriptChannel,
          [javaScriptChannel],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<void> removeJavaScriptChannel(
          _i2.JavaScriptChannel? javaScriptChannel) =>
      (super.noSuchMethod(
        Invocation.method(
          #removeJavaScriptChannel,
          [javaScriptChannel],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<void> setDownloadListener(_i2.DownloadListener? listener) =>
      (super.noSuchMethod(
        Invocation.method(
          #setDownloadListener,
          [listener],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<void> setWebChromeClient(_i2.WebChromeClient? client) =>
      (super.noSuchMethod(
        Invocation.method(
          #setWebChromeClient,
          [client],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<void> setBackgroundColor(_i3.Color? color) => (super.noSuchMethod(
        Invocation.method(
          #setBackgroundColor,
          [color],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i2.WebView copy() => (super.noSuchMethod(
        Invocation.method(
          #copy,
          [],
        ),
        returnValue: _FakeWebView_3(
          this,
          Invocation.method(
            #copy,
            [],
          ),
        ),
      ) as _i2.WebView);
}

/// A class which mocks [WebResourceRequest].
///
/// See the documentation for Mockito's code generation for more information.
class MockWebResourceRequest extends _i1.Mock
    implements _i2.WebResourceRequest {
  MockWebResourceRequest() {
    _i1.throwOnMissingStub(this);
  }

  @override
  String get url => (super.noSuchMethod(
        Invocation.getter(#url),
        returnValue: _i6.dummyValue<String>(
          this,
          Invocation.getter(#url),
        ),
      ) as String);

  @override
  bool get isForMainFrame => (super.noSuchMethod(
        Invocation.getter(#isForMainFrame),
        returnValue: false,
      ) as bool);

  @override
  bool get hasGesture => (super.noSuchMethod(
        Invocation.getter(#hasGesture),
        returnValue: false,
      ) as bool);

  @override
  String get method => (super.noSuchMethod(
        Invocation.getter(#method),
        returnValue: _i6.dummyValue<String>(
          this,
          Invocation.getter(#method),
        ),
      ) as String);

  @override
  Map<String, String> get requestHeaders => (super.noSuchMethod(
        Invocation.getter(#requestHeaders),
        returnValue: <String, String>{},
      ) as Map<String, String>);
}

/// A class which mocks [DownloadListener].
///
/// See the documentation for Mockito's code generation for more information.
class MockDownloadListener extends _i1.Mock implements _i2.DownloadListener {
  MockDownloadListener() {
    _i1.throwOnMissingStub(this);
  }

  @override
  void Function(
    String,
    String,
    String,
    String,
    int,
  ) get onDownloadStart => (super.noSuchMethod(
        Invocation.getter(#onDownloadStart),
        returnValue: (
          String url,
          String userAgent,
          String contentDisposition,
          String mimetype,
          int contentLength,
        ) {},
      ) as void Function(
        String,
        String,
        String,
        String,
        int,
      ));

  @override
  _i2.DownloadListener copy() => (super.noSuchMethod(
        Invocation.method(
          #copy,
          [],
        ),
        returnValue: _FakeDownloadListener_4(
          this,
          Invocation.method(
            #copy,
            [],
          ),
        ),
      ) as _i2.DownloadListener);
}

/// A class which mocks [WebViewAndroidJavaScriptChannel].
///
/// See the documentation for Mockito's code generation for more information.
class MockWebViewAndroidJavaScriptChannel extends _i1.Mock
    implements _i8.WebViewAndroidJavaScriptChannel {
  MockWebViewAndroidJavaScriptChannel() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.JavascriptChannelRegistry get javascriptChannelRegistry =>
      (super.noSuchMethod(
        Invocation.getter(#javascriptChannelRegistry),
        returnValue: _FakeJavascriptChannelRegistry_5(
          this,
          Invocation.getter(#javascriptChannelRegistry),
        ),
      ) as _i4.JavascriptChannelRegistry);

  @override
  String get channelName => (super.noSuchMethod(
        Invocation.getter(#channelName),
        returnValue: _i6.dummyValue<String>(
          this,
          Invocation.getter(#channelName),
        ),
      ) as String);

  @override
  void Function(String) get postMessage => (super.noSuchMethod(
        Invocation.getter(#postMessage),
        returnValue: (String message) {},
      ) as void Function(String));

  @override
  _i2.JavaScriptChannel copy() => (super.noSuchMethod(
        Invocation.method(
          #copy,
          [],
        ),
        returnValue: _FakeJavaScriptChannel_6(
          this,
          Invocation.method(
            #copy,
            [],
          ),
        ),
      ) as _i2.JavaScriptChannel);
}

/// A class which mocks [WebChromeClient].
///
/// See the documentation for Mockito's code generation for more information.
class MockWebChromeClient extends _i1.Mock implements _i2.WebChromeClient {
  MockWebChromeClient() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i5.Future<void> setSynchronousReturnValueForOnShowFileChooser(bool? value) =>
      (super.noSuchMethod(
        Invocation.method(
          #setSynchronousReturnValueForOnShowFileChooser,
          [value],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<void> setSynchronousReturnValueForOnConsoleMessage(bool? value) =>
      (super.noSuchMethod(
        Invocation.method(
          #setSynchronousReturnValueForOnConsoleMessage,
          [value],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i2.WebChromeClient copy() => (super.noSuchMethod(
        Invocation.method(
          #copy,
          [],
        ),
        returnValue: _FakeWebChromeClient_7(
          this,
          Invocation.method(
            #copy,
            [],
          ),
        ),
      ) as _i2.WebChromeClient);
}

/// A class which mocks [WebViewClient].
///
/// See the documentation for Mockito's code generation for more information.
class MockWebViewClient extends _i1.Mock implements _i2.WebViewClient {
  MockWebViewClient() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i5.Future<void> setSynchronousReturnValueForShouldOverrideUrlLoading(
          bool? value) =>
      (super.noSuchMethod(
        Invocation.method(
          #setSynchronousReturnValueForShouldOverrideUrlLoading,
          [value],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i2.WebViewClient copy() => (super.noSuchMethod(
        Invocation.method(
          #copy,
          [],
        ),
        returnValue: _FakeWebViewClient_8(
          this,
          Invocation.method(
            #copy,
            [],
          ),
        ),
      ) as _i2.WebViewClient);
}

/// A class which mocks [JavascriptChannelRegistry].
///
/// See the documentation for Mockito's code generation for more information.
class MockJavascriptChannelRegistry extends _i1.Mock
    implements _i4.JavascriptChannelRegistry {
  MockJavascriptChannelRegistry() {
    _i1.throwOnMissingStub(this);
  }

  @override
  Map<String, _i4.JavascriptChannel> get channels => (super.noSuchMethod(
        Invocation.getter(#channels),
        returnValue: <String, _i4.JavascriptChannel>{},
      ) as Map<String, _i4.JavascriptChannel>);

  @override
  void onJavascriptChannelMessage(
    String? channel,
    String? message,
  ) =>
      super.noSuchMethod(
        Invocation.method(
          #onJavascriptChannelMessage,
          [
            channel,
            message,
          ],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void updateJavascriptChannelsFromSet(Set<_i4.JavascriptChannel>? channels) =>
      super.noSuchMethod(
        Invocation.method(
          #updateJavascriptChannelsFromSet,
          [channels],
        ),
        returnValueForMissingStub: null,
      );
}

/// A class which mocks [WebViewPlatformCallbacksHandler].
///
/// See the documentation for Mockito's code generation for more information.
class MockWebViewPlatformCallbacksHandler extends _i1.Mock
    implements _i4.WebViewPlatformCallbacksHandler {
  MockWebViewPlatformCallbacksHandler() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i5.FutureOr<bool> onNavigationRequest({
    required String? url,
    required bool? isForMainFrame,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #onNavigationRequest,
          [],
          {
            #url: url,
            #isForMainFrame: isForMainFrame,
          },
        ),
        returnValue: _i5.Future<bool>.value(false),
      ) as _i5.FutureOr<bool>);

  @override
  void onPageStarted(String? url) => super.noSuchMethod(
        Invocation.method(
          #onPageStarted,
          [url],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void onPageFinished(String? url) => super.noSuchMethod(
        Invocation.method(
          #onPageFinished,
          [url],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void onProgress(int? progress) => super.noSuchMethod(
        Invocation.method(
          #onProgress,
          [progress],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void onWebResourceError(_i4.WebResourceError? error) => super.noSuchMethod(
        Invocation.method(
          #onWebResourceError,
          [error],
        ),
        returnValueForMissingStub: null,
      );
}

/// A class which mocks [WebViewProxy].
///
/// See the documentation for Mockito's code generation for more information.
class MockWebViewProxy extends _i1.Mock implements _i8.WebViewProxy {
  MockWebViewProxy() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.WebView createWebView() => (super.noSuchMethod(
        Invocation.method(
          #createWebView,
          [],
        ),
        returnValue: _FakeWebView_3(
          this,
          Invocation.method(
            #createWebView,
            [],
          ),
        ),
      ) as _i2.WebView);

  @override
  _i2.WebViewClient createWebViewClient({
    void Function(
      _i2.WebView,
      String,
    )? onPageStarted,
    void Function(
      _i2.WebView,
      String,
    )? onPageFinished,
    void Function(
      _i2.WebView,
      _i2.WebResourceRequest,
      _i2.WebResourceError,
    )? onReceivedRequestError,
    void Function(
      _i2.WebView,
      int,
      String,
      String,
    )? onReceivedError,
    void Function(
      _i2.WebView,
      _i2.WebResourceRequest,
    )? requestLoading,
    void Function(
      _i2.WebView,
      String,
    )? urlLoading,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #createWebViewClient,
          [],
          {
            #onPageStarted: onPageStarted,
            #onPageFinished: onPageFinished,
            #onReceivedRequestError: onReceivedRequestError,
            #onReceivedError: onReceivedError,
            #requestLoading: requestLoading,
            #urlLoading: urlLoading,
          },
        ),
        returnValue: _FakeWebViewClient_8(
          this,
          Invocation.method(
            #createWebViewClient,
            [],
            {
              #onPageStarted: onPageStarted,
              #onPageFinished: onPageFinished,
              #onReceivedRequestError: onReceivedRequestError,
              #onReceivedError: onReceivedError,
              #requestLoading: requestLoading,
              #urlLoading: urlLoading,
            },
          ),
        ),
      ) as _i2.WebViewClient);

  @override
  _i5.Future<void> setWebContentsDebuggingEnabled(bool? enabled) =>
      (super.noSuchMethod(
        Invocation.method(
          #setWebContentsDebuggingEnabled,
          [enabled],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);
}
