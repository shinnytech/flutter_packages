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
import web_webview from '@ohos.web.webview';
import router from '@ohos.router';
import { ValueType } from '@kit.ArkData';

@Entry
@Component
export struct InAppBrowser {
  webviewController: web_webview.WebviewController = new web_webview.WebviewController()

  private url?: string;
  private enableJavaScript: boolean = true;
  private enableDomStorage: boolean = true;

  aboutToAppear(){
    let params = router.getParams() as Map<string, ValueType>
    this.url = params['url'] as string;
    let options = params['options'] as Map<string, ValueType>;
    this.enableJavaScript = options['enableJavaScript'] as boolean;
    this.enableDomStorage = options['enableDomStorage'] as boolean;
  }

  build() {
    Row() {
      Web({ src: this.url, controller: this.webviewController })
        .javaScriptAccess(this.enableJavaScript)
        .domStorageAccess(this.enableDomStorage)
    }.width('100%').height('100%')
  }
}
