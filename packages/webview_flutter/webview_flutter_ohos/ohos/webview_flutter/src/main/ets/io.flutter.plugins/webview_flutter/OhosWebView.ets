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

import web_webview from '@ohos.web.webview'
import { DynamicUtils } from "@ohos/flutter_ohos/src/main/ets/view/DynamicView/DynamicUtils"

import { BuilderParams, DVModelParameters } from '@ohos/flutter_ohos/src/main/ets/view/DynamicView/dynamicView'

@Component
export struct OhosWebView {
  @Prop params: DVModelParameters = new DVModelParameters();
  controller: web_webview.WebviewController = new web_webview.WebviewController()

  build() {
    Column() {
      Web(
        {
          src: DynamicUtils.getParams(this.params, "src"),
          controller: this.controller
        })
        .onDownloadStart(DynamicUtils.getParams(this.params, "onDownloadStart"))
        .onPageBegin(DynamicUtils.getParams(this.params, "onPageBegin"))
        .onPageEnd(DynamicUtils.getParams(this.params, "onPageEnd"))
        .onErrorReceive(DynamicUtils.getParams(this.params, "onErrorReceive"))
        .onLoadIntercept(DynamicUtils.getParams(this.params, "onLoadIntercept"))
        .onRefreshAccessedHistory(DynamicUtils.getParams(this.params, "onRefreshAccessedHistory"))
        .onProgressChange(DynamicUtils.getParams(this.params, "onProgressChange"))
        .onGeolocationShow(DynamicUtils.getParams(this.params, "onGeolocationShow"))
        .onGeolocationHide(DynamicUtils.getParams(this.params, "onGeolocationHide"))
        .onShowFileSelector(DynamicUtils.getParams(this.params, "onShowFileSelector"))
        .onPermissionRequest(DynamicUtils.getParams(this.params, "onPermissionRequest"))
        // .onWindowNew(DynamicUtils.getParams(this.params, "onWindowNew"))
        .onWindowExit(DynamicUtils.getParams(this.params, "onWindowExit"))
        .domStorageAccess(DynamicUtils.getParams(this.params, "domStorageAccess"))
        .allowWindowOpenMethod(DynamicUtils.getParams(this.params, "allowWindowOpenMethod"))
        .multiWindowAccess(DynamicUtils.getParams(this.params, "multiWindowAccess"))
        .javaScriptAccess(DynamicUtils.getParams(this.params, "javaScriptAccess"))
        .mediaPlayGestureAccess(DynamicUtils.getParams(this.params, "mediaPlayGestureAccess"))
        .zoomAccess(DynamicUtils.getParams(this.params, "zoomAccess"))
        .overviewModeAccess(DynamicUtils.getParams(this.params, "overviewModeAccess"))
        .wideViewModeAccess(DynamicUtils.getParams(this.params, "wideViewModeAccess"))
        .fileAccess(DynamicUtils.getParams(this.params, "fileAccess"))
        .textZoomRatio(DynamicUtils.getParams(this.params, "textZoomRatio"))
        .onScroll(DynamicUtils.getParams(this.params, "onScroll"))
        .onWindowNew((event) => {
          let newWebViewController: web_webview.WebviewController = new web_webview.WebviewController();
          let dialogController: CustomDialogController = new CustomDialogController({
            builder: NewWebView({ webViewController: newWebViewController })
          })
          dialogController.open();
          event.handler.setWebController(newWebViewController);
        })
    }
  }
}

@Builder
export function buildOhosWebView(param: BuilderParams) {
  OhosWebView({ params: param.params, controller: DynamicUtils.getParams(param.params, "controller") })
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