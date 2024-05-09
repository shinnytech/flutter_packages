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

import Log from '@ohos/flutter_ohos/src/main/ets/util/Log';
import { Reply, WebChromeClientHostApi } from './GeneratedOhosWebView';
import { InstanceManager } from './InstanceManager';
import { OhosWebView } from './OhosWebView';
import { WebChromeClientFlutterApiImpl } from './WebChromeClientFlutterApiImpl';
import { WebViewPlatformView } from './WebViewHostApiImpl'
import { WebViewClient } from './WebViewClientHostApiImpl';
import { BuilderParams, DVModel, DVModelParameters } from '@ohos/flutter_ohos/src/main/ets/view/DynamicView/dynamicView'
import web_webview from '@ohos.web.webview'
import { CustomViewCallback } from './CustomViewCallbackFlutterApiImpl';

const TAG: string = "WebChromeClientHostApiImpl";

export interface WebChromeClient {
  onProgressChanged(view: WebViewPlatformView, progress: number) : void;

  onGeolocationPermissionsShowPrompt(origin: string, callback: JsGeolocation) : void;

  onGeolocationPermissionsHidePrompt() : void;

  onShowFileChooser(
    webView: WebViewPlatformView, filePathCallback: FileSelectorResult, fileChooserParams: FileSelectorParam
  ): boolean;

  onPermissionRequest(request: PermissionRequest) : void;

  onConsoleMessage(message: ConsoleMessage) : boolean;

  onCreateWindow(webView: WebViewPlatformView, isDialog: boolean, isUserGesture: boolean, handler: ControllerHandler) : void;
}

export class WebChromeClientHostApiImpl extends WebChromeClientHostApi {

  private instanceManager: InstanceManager;

  private webChromeClientCreator: WebChromeClientCreator;

  private flutterApi: WebChromeClientFlutterApiImpl;

  constructor(
    instanceManager: InstanceManager,
    webChromeClientCreator: WebChromeClientCreator,
    flutterApi: WebChromeClientFlutterApiImpl
  ) {
    super();
    this.instanceManager = instanceManager;
    this.webChromeClientCreator = webChromeClientCreator;
    this.flutterApi = flutterApi;
  }

  create(instanceId: number) {
    const webChromeClient: WebChromeClient = this.webChromeClientCreator.createWebChromeClient(this.flutterApi);
    this.instanceManager.addDartCreatedInstance(webChromeClient, instanceId);
  }

  setSynchronousReturnValueForOnShowFileChooser(instanceId: number, value: boolean) {
    const webChromeClient: WebChromeClientImpl = this.instanceManager.getInstance(instanceId);
    webChromeClient.setReturnValueForOnShowFileChooser(value);
  }

  setSynchronousReturnValueForOnConsoleMessage(instanceId: number, value: boolean): void {
    const webChromeClient: WebChromeClientImpl = this.instanceManager.getInstance(instanceId);
    webChromeClient.setReturnValueForOnConsoleMessage(value);
  }

}

export class WebChromeClientCreator {
  createWebChromeClient(flutterApi: WebChromeClientFlutterApiImpl): WebChromeClientImpl {
    return new WebChromeClientImpl(flutterApi);
  }
}

class SecureWebChromeClient implements WebChromeClient {
  onProgressChanged(view: WebViewPlatformView, progress: number) {
    Log.i(TAG, "onProgressChanged");
  }

  onGeolocationPermissionsShowPrompt(origin: string, callback: JsGeolocation) {
    Log.i(TAG, "onGeolocationPermissionsShowPrompt");
  }

  onGeolocationPermissionsHidePrompt() {
    Log.i(TAG, "onGeolocationPermissionsHidePrompt");
  }

  onShowFileChooser(
    webView: WebViewPlatformView, filePathCallback: FileSelectorResult, fileChooserParams: FileSelectorParam
  ) {
    return true;
  }

  onPermissionRequest(request: PermissionRequest) {
    Log.i(TAG, "onPermissionRequest");
  }

  onConsoleMessage(message: ConsoleMessage) {
    Log.i(TAG, "onConsoleMessage");
    return true;
  }

  onCreateWindow(webView: WebViewPlatformView, isDialog: boolean, isUserGesture: boolean, handler: ControllerHandler) {
    if (webView.getDialogController() != null) {
      webView.getDialogController()?.close();
    }
    let newWebViewController: web_webview.WebviewController = new web_webview.WebviewController();
    let dialogController: CustomDialogController = new CustomDialogController({
      builder: NewWebView({ webViewController: newWebViewController })
    })
    dialogController.open();
    handler.setWebController(newWebViewController);
  }
}

@CustomDialog
struct NewWebView {
  controller?: CustomDialogController
  webViewController: web_webview.WebviewController = new web_webview.WebviewController();

  build() {
    Web({ src: "", controller: this.webViewController })
      .javaScriptAccess(true)
      .multiWindowAccess(false)
      .onWindowExit(
        () => {
          if (this.controller) {
            this.controller.close();
          }
        }
      )
  }
}

class WebChromeClientImpl extends SecureWebChromeClient {
  private flutterApi: WebChromeClientFlutterApiImpl;
  private returnValueForOnShowFileChooser: boolean = false;
  private returnValueForOnConsoleMessage: boolean = false;

  constructor(flutterApi: WebChromeClientFlutterApiImpl) {
    super();
    this.flutterApi = flutterApi;
  }

  private emptyReply: Reply<void> = {
    reply: (reply) => {
    }
  }

  onProgressChanged(view: WebViewPlatformView, progress: number) {
    this.flutterApi.onProgressChangedImpl(
      this, view, progress, this.emptyReply
    )
  }

  onShowCustomView(view: DVModel, callback: CustomViewCallback) {
    this.flutterApi.onShowCustomViewImpl(this, view, callback, this.emptyReply);
  }

  onHideCustomView() {
    this.flutterApi.onHideCustomViewImpl(this, this.emptyReply);
  }


  onGeolocationPermissionsShowPrompt(origin: string, callback: JsGeolocation) {
    this.flutterApi.onGeolocationPermissionsShowPromptImpl(this, origin, callback, this.emptyReply);
  }

  onGeolocationPermissionsHidePrompt() {
    this.flutterApi.onGeolocationPermissionsHidePromptImpl(this, this.emptyReply);
  }

  onShowFileChooser(
    webView: WebViewPlatformView, filePathCallback: FileSelectorResult, fileChooserParams: FileSelectorParam
  ) {
    let currentReturnValueForOnShowFileChooser: boolean = this.returnValueForOnShowFileChooser;
    this.flutterApi.onShowFileChooserImpl(
      this, webView, fileChooserParams, {
      reply: (reply: Array<string> | null) => {
        if (currentReturnValueForOnShowFileChooser) {
          filePathCallback.handleFileList(reply);
        }
      }
    }
    );
    return currentReturnValueForOnShowFileChooser;
  }

  onPermissionRequest(request: PermissionRequest) {
    this.flutterApi.onPermissionRequestImpl(this, request, this.emptyReply);
  }

  onConsoleMessage(consoleMessage: ConsoleMessage){
    this.flutterApi.onConsoleMessageImpl(this, consoleMessage, this.emptyReply);
    return this.returnValueForOnConsoleMessage
  }

  setReturnValueForOnShowFileChooser(value: boolean) {
    this.returnValueForOnShowFileChooser = value;
  }

  setReturnValueForOnConsoleMessage(value: boolean) {
    this.returnValueForOnConsoleMessage = value;
  }
}

class newWindowWebViewClient implements WebViewClient {
  onPageStarted(view: WebViewPlatformView, url: string) {
    Log.i(TAG, "onPageStarted");
  }

  onPageFinished(view: WebViewPlatformView, url: string) {
    Log.i(TAG, "onPageFinished");
  }

  onReceivedError(view: WebViewPlatformView, request: WebResourceRequest, error: WebResourceError) {
    Log.i(TAG, "onReceivedError");
  }

  doUpdateVisitedHistory(view: WebViewPlatformView, url: string, isReload: boolean) {
    Log.i(TAG, "doUpdateVisitedHistory");
  }

  shouldOverrideUrlLoading(view: WebViewPlatformView, request: WebResourceRequest): boolean {
    view.getController().loadUrl(request.getRequestUrl());
    return true;
  }
}