/*
* Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*     http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

import PlatformView from '@ohos/flutter_ohos/src/main/ets/plugin/platform/PlatformView'
import { DVModel, DVModelParameters } from '@ohos/flutter_ohos/src/main/ets/view/DynamicView/dynamicView'
import { Result, WebViewHostApi, WebViewPoint } from './GeneratedOhosWebView'
import web_webview from '@ohos.web.webview'
import { buildOhosWebView, OhosWebView } from './OhosWebView'
import { createDVModelFromJson } from '@ohos/flutter_ohos/src/main/ets/view/DynamicView/dynamicViewJson'
import { DVModelJson } from "./DynamicUtils"
import { InstanceManager } from './InstanceManager'
import { BinaryMessenger } from '@ohos/flutter_ohos/src/main/ets/plugin/common/BinaryMessenger';
import common from '@ohos.app.ability.common'
import { WebChromeClient } from './WebChromeClientHostApiImpl'
import { WebViewClient } from './WebViewClientHostApiImpl'
import { WebSettings } from './WebSettingsHostApiImpl'
import { DynamicUtils } from "./DynamicUtils"
import { DownloadListener } from './DownloadListenerFlutterApiImpl'
import { DisplayListenerProxy } from './DisplayListenerProxy'
import { JavaScriptChannel } from './JavaScriptChannel'
import Log from '@ohos/flutter_ohos/src/main/ets/util/Log';

const TAG: string = "WebViewHostApiImpl";

export class WebViewHostApiImpl extends WebViewHostApi {
  private instanceManager: InstanceManager;

  private webViewProxy: WebViewProxy;

  private binaryMessenger: BinaryMessenger;

  private context: common.Context;

  constructor(
    instanceManager: InstanceManager,
    webViewProxy: WebViewProxy,
    binaryMessenger: BinaryMessenger,
    context: common.Context
  ) {
    super();
    this.instanceManager = instanceManager;
    this.webViewProxy = webViewProxy;
    this.binaryMessenger = binaryMessenger;
    this.context = context;
  }

  setContext(context: common.Context): void {
    this.context = context;
  }

  create(instanceId: number): void {
    let displayProxy: DisplayListenerProxy = new DisplayListenerProxy();
    displayProxy.onPreWebViewInitialization();
    const webView: WebViewPlatformView = this.webViewProxy.createWebView();
    displayProxy.onPostWebViewInitialization();
    this.instanceManager.addDartCreatedInstance(webView, instanceId);
  }

  loadData(instanceId: number, data: string, mimeType: string, encoding: string): void {
    const webView: WebViewPlatformView = this.instanceManager.getInstance(instanceId);
    webView.getController().loadData(data, mimeType, encoding);
  }

  loadDataWithBaseUrl(
    instanceId: number, baseUrl: string, data: string, mimeType: string, encoding: string, historyUrl: string
  ): void {
    const webView: WebViewPlatformView = this.instanceManager.getInstance(instanceId);
    try {
      webView.getController().loadData(data, mimeType, encoding, baseUrl == null ? "" : baseUrl , historyUrl == null ? "" : historyUrl);
    } catch (err) {
      Log.e(TAG, "loadDataWithBaseUrl err = " + err);
      setTimeout(
        () => {
          this.loadDataWithBaseUrl(instanceId, baseUrl, data, mimeType, encoding, historyUrl);
        }, 500
      )
    }
  }

  loadUrl(instanceId: number, url: string, headers: Map<string, string>): void {
    const webView: WebViewPlatformView = this.instanceManager.getInstance(instanceId);
    try {
      if (url.startsWith("resources/rawfile/")) {
        webView.getController().loadUrl($rawfile(url.replace("resources/rawfile/","")), this.toWebHeaders(headers));
      }else {
        webView.getController().loadUrl(url, this.toWebHeaders(headers));
      }
    } catch (err) {
      Log.e(TAG, "loadUrl err = " + err);
      setTimeout(
        () => {
          this.loadUrl(instanceId, url, headers);
        }, 500
      )
    }
  }

  toWebHeaders(headers: Map<string, string>): Array<web_webview.WebHeader> {
    let result: Array<web_webview.WebHeader> = new Array;
    if (headers == null || headers.size == 0) {
      return result;
    }
    for (let arr of headers) {
      let key = arr[0];
      let value = arr[1];
      let header: web_webview.WebHeader = { headerKey: key, headerValue: value };
      result.push(header);
    }
    return result;
  }

  postUrl(instanceId: number, url: string, data: Uint8Array): void {
    // TODO:确认实现方式
    const webView: WebViewPlatformView = this.instanceManager.getInstance(instanceId);
  }

  getUrl(instanceId: number): string {
    const webView: WebViewPlatformView = this.instanceManager.getInstance(instanceId);
    return webView.getController().getUrl();
  }

  canGoBack(instanceId: number): boolean {
    const webView: WebViewPlatformView = this.instanceManager.getInstance(instanceId);
    return webView.getController().accessBackward();
  }

  canGoForward(instanceId: number): boolean {
    const webView: WebViewPlatformView = this.instanceManager.getInstance(instanceId);
    return webView.getController().accessForward();
  }

  goBack(instanceId: number): void {
    const webView: WebViewPlatformView = this.instanceManager.getInstance(instanceId);
    webView.getController().backward();
  }

  goForward(instanceId: number): void {
    const webView: WebViewPlatformView = this.instanceManager.getInstance(instanceId);
    webView.getController().forward();
  }

  reload(instanceId: number): void {
    const webView: WebViewPlatformView = this.instanceManager.getInstance(instanceId);
    webView.getController().refresh();
  }

  clearCache(instanceId: number, includeDiskFiles: boolean): void {
    const webView: WebViewPlatformView = this.instanceManager.getInstance(instanceId);
    webView.getController().removeCache(includeDiskFiles);
  }

  evaluateJavascript(instanceId: number, javascriptString: string, result: Result<string>): void {
    const webView: WebViewPlatformView = this.instanceManager.getInstance(instanceId);
    webView.getController().runJavaScript(javascriptString)
      .then(
        scriptResult => {
          result.success(scriptResult);
        }
      )
      .catch(
        (error: ESObject) => {
          result.error(error);
        }
      )
  }

  getTitle(instanceId: number): string {
    const webView: WebViewPlatformView = this.instanceManager.getInstance(instanceId);
    return webView.getController().getTitle();
  }

  scrollTo(instanceId: number, x: number, y: number): void {
    const webView: WebViewPlatformView = this.instanceManager.getInstance(instanceId);
    webView.getController().scrollTo(x, y);
  }

  scrollBy(instanceId: number, x: number, y: number): void {
    const webView: WebViewPlatformView = this.instanceManager.getInstance(instanceId);
    webView.getController().scrollBy(x, y);
  }

  getScrollX(instanceId: number): number {
    const webView: WebViewPlatformView = this.instanceManager.getInstance(instanceId);
    return webView.getScrollX();
  }

  getScrollY(instanceId: number): number {
    const webView: WebViewPlatformView = this.instanceManager.getInstance(instanceId);
    return webView.getScrollY()
  }

  getScrollPosition(instanceId: number): WebViewPoint {
    const webView: WebViewPlatformView = this.instanceManager.getInstance(instanceId);
    return WebViewPoint.Builder()
      .setX(webView.getScrollY())
      .setY(webView.getScrollY())
      .build();
  }

  setWebContentsDebuggingEnabled(enabled: boolean): void {
    this.webViewProxy.setWebContentsDebuggingEnabled(enabled);
  }

  setWebViewClient(instanceId: number, webViewClientInstanceId: number) {
    const webView: WebViewPlatformView = this.instanceManager.getInstance(instanceId);
    webView.setWebViewClient(this.instanceManager.getInstance(webViewClientInstanceId));
  }

  addJavaScriptChannel(instanceId: number, javaScriptChannelInstanceId: number): void {
    const webView: WebViewPlatformView = this.instanceManager.getInstance(instanceId);
    const javaScriptChannel: JavaScriptChannel = this.instanceManager.getInstance(javaScriptChannelInstanceId);
    try {
      webView.getController().registerJavaScriptProxy(
        {
          postMessage: (message: string) => {
            javaScriptChannel.postMessage(message)
          },
        },
        javaScriptChannel.getJavaScriptChannelName(),
        ["postMessage"]
      )
    } catch (err) {
      Log.e(TAG, "addJavaScriptChannel err = " + err);
      setTimeout(
        () => {
          this.addJavaScriptChannel(instanceId, javaScriptChannelInstanceId)
        }, 500
      )
    }
  }

  removeJavaScriptChannel(instanceId: number, javaScriptChannelInstanceId: number): void {
    const webView: WebViewPlatformView = this.instanceManager.getInstance(instanceId);
    const javaScriptChannel: JavaScriptChannel = this.instanceManager.getInstance(javaScriptChannelInstanceId);
    webView.getController().deleteJavaScriptRegister(javaScriptChannel.getJavaScriptChannelName());
  }

  setDownloadListener(instanceId: number, listenerInstanceId: number) {
    const webView: WebViewPlatformView = this.instanceManager.getInstance(instanceId);
    webView.setDownloadListener(this.instanceManager.getInstance(listenerInstanceId));
  }

  setWebChromeClient(instanceId: number, clientInstanceId: number) {
    const webView: WebViewPlatformView = this.instanceManager.getInstance(instanceId);
    webView.setWebChromeClient(this.instanceManager.getInstance(clientInstanceId));
  }

  setBackgroundColor(instanceId: number, color: number) {
    //TODO:Web ground
  }

  getInstanceManager(): InstanceManager {
    return this.instanceManager;
  }
}

export class WebViewPlatformView extends PlatformView {
  private WebCookieManager: web_webview.WebCookieManager = new web_webview.WebCookieManager();

  private controller: web_webview.WebviewController = new web_webview.WebviewController();

  private downloadListener: DownloadListener = {} as ESObject;

  private webChromeClient: WebChromeClient | null = null;

  private webViewClint: WebViewClient | null = null;

  private webSettings: WebSettings | null = null;

  private dialogController: CustomDialogController | null = null;

  private scrollX: number = 0;

  private scrollY: number = 0;

  private returnValueForShouldOverrideUrlLoading: boolean = false;

  private onDownloadStart = (event: ESObject) => {
    if (this.downloadListener) {
      this.downloadListener.onDownloadStart(
        event.url,
        event.userAgent,
        event.contentDisposition,
        event.mimetype,
        event.contentLength
      )
    }
  }

  private onPageBegin = (event: ESObject) => {
    if (this.webViewClint) {
      this.webViewClint.onPageStarted(this, event.url);
    }
  }

  private onPageEnd = (event: ESObject) => {
    if (this.webViewClint) {
      this.webViewClint.onPageFinished(this, event.url);
    }
  }

  private onErrorReceive = (event: ESObject) => {
    if (this.webViewClint) {
      this.webViewClint.onReceivedError(this, event.request, event.error);
    }
  }

  private onLoadIntercept = (event: ESObject) => {
    Log.i(TAG, "onLoadIntercept event = " + JSON.stringify(event))
    if (this.webViewClint) {
      // this.webViewClint.shouldOverrideUrlLoading(this, event.data);
      return this.returnValueForShouldOverrideUrlLoading;
    }
    return false;
  }

  private onRefreshAccessedHistory = (event: ESObject) => {
    if (this.webViewClint) {
      this.webViewClint.doUpdateVisitedHistory(this, event.url, event.isRefreshed);
    }
  }

  private onProgressChange = (event: ESObject) => {
    if (this.webChromeClient) {
      this.webChromeClient.onProgressChanged(this, event.newProgress)
    }
  }

  private onGeolocationShow = (event: ESObject) => {
    if (this.webChromeClient) {
      this.webChromeClient.onGeolocationPermissionsShowPrompt(event.origin, event.geolocation)
    }
  }

  private onGeolocationHide = () => {
    if (this.webChromeClient) {
      this.webChromeClient.onGeolocationPermissionsHidePrompt();
    }
  }

  private onShowFileSelector = (event: ESObject) => {
    if (this.webChromeClient) {
      return this.webChromeClient.onShowFileChooser(this, event.result, event.fileSelector)
    }
    return false;
  }

  private onPermissionRequest = (event: ESObject) => {
    if (this.webChromeClient) {
      this.webChromeClient.onPermissionRequest(event.request);
    }
  }

  private onWindowNew = (event: ESObject) => {
    if (this.webChromeClient) {
      this.webChromeClient.onCreateWindow(this, event.isAlert, event.isUserTrigger, event.handler)
    }
  }

  private onWindowExit = () => {
    if (this.dialogController) {
      this.dialogController.close();
    }
  }

  private onScroll = (event: ESObject) => {
    this.scrollX = event.xOffset;
    this.scrollY = event.yOffset;
  }

  ohosWebView: DVModelJson = new DVModelJson(
    "other",
    [],
    {
      src: "",
      controller: this.controller,
      onDownloadStart: this.onDownloadStart,
      onPageBegin: this.onPageBegin,
      onPageEnd: this.onPageEnd,
      onErrorReceive: this.onErrorReceive,
      onLoadIntercept: this.onLoadIntercept,
      onRefreshAccessedHistory: this.onRefreshAccessedHistory,
      onProgressChange: this.onProgressChange,
      onGeolocationShow: this.onGeolocationShow,
      onGeolocationHide: this.onGeolocationHide,
      onShowFileSelector: this.onShowFileSelector,
      onPermissionRequest: this.onPermissionRequest,
      onWindowNew: this.onWindowNew,
      onWindowExit: this.onWindowExit,
      onScroll: this.onScroll
    },
    {},
    buildOhosWebView
  )

  private ohosWebViewModel = createDVModelFromJson(this.ohosWebView);

  getView(): DVModel {
    return this.ohosWebViewModel;
  }

  dispose(): void {
  }

  getController(): web_webview.WebviewController {
    return this.controller;
  }

  getWebCookieManager(): web_webview.WebCookieManager {
    return this.WebCookieManager
  }

  setDownloadListener(listener: DownloadListener) {
    this.downloadListener = listener;
  }

  setWebViewClient(webViewClient: WebViewClient) {
    this.webViewClint = webViewClient;
  }

  setWebChromeClient(webChromeClient: WebChromeClient) {
    this.webChromeClient = webChromeClient;
  }

  setDialogController(dialogController: CustomDialogController) {
    this.dialogController = dialogController;
  }

  getDialogController(): CustomDialogController | null {
    return this.dialogController;
  }

  getWebSettings(): WebSettings {
    if (this.webSettings == null) {
      this.webSettings = new WebSettingsImpl(this);
    }
    return this.webSettings;
  }

  getScrollX(): number {
    return this.scrollX;
  }

  getScrollY(): number {
    return this.scrollY;
  }

  setReturnValueForShouldOverrideUrlLoading(value: boolean) {
    this.returnValueForShouldOverrideUrlLoading = value;
  }
}

export class WebViewProxy {
  createWebView(): WebViewPlatformView {
    return new WebViewPlatformView();
  }

  setWebContentsDebuggingEnabled(enabled: boolean): void {
    web_webview.WebviewController.setWebDebuggingAccess(enabled);
  }
}

class WebSettingsImpl implements WebSettings {
  private webView: WebViewPlatformView;
  private params: DVModelParameters;

  constructor(webView: WebViewPlatformView) {
    this.webView = webView;
    this.params = webView.getView().params;
  }

  setDomStorageEnabled(flag: boolean) {
    DynamicUtils.setParams(this.params, "domStorageAccess", flag);
  }

  setJavaScriptCanOpenWindowsAutomatically(flag: boolean) {
    DynamicUtils.setParams(this.params, "allowWindowOpenMethod", flag);
  }

  setSupportMultipleWindows(support: boolean) {
    DynamicUtils.setParams(this.params, "multiWindowAccess", support);
  }

  setJavaScriptEnabled(flag: boolean) {
    DynamicUtils.setParams(this.params, "javaScriptAccess", flag);
  }

  setUserAgentString(userAgentString: string) {
    this.webView.getController().setCustomUserAgent(userAgentString);
  }

  setMediaPlaybackRequiresUserGesture(require: boolean) {
    DynamicUtils.setParams(this.params, "mediaPlayGestureAccess", require);
  }

  setSupportZoom(support: boolean) {
    DynamicUtils.setParams(this.params, "zoomAccess", support);
  }

  setLoadWithOverviewMode(overview: boolean) {
    DynamicUtils.setParams(this.params, "overviewModeAccess", overview);
  }

  setUseWideViewPort(use: boolean) {
    DynamicUtils.setParams(this.params, "wideViewModeAccess", use);
  }

  setDisplayZoomControls(enabled: boolean) {
    //TODO:确认是否支持
  }

  setBuiltInZoomControls(enabled: boolean) {
    //TODO:确认是否支持
  }

  setAllowFileAccess(enabled: boolean) {
    DynamicUtils.setParams(this.params, "fileAccess", enabled);
  }

  setTextZoom(textZoom: number) {
    DynamicUtils.setParams(this.params, "textZoomRatio", textZoom);
  }
}