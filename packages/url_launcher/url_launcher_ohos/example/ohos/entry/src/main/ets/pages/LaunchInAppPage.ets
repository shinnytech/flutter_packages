import { InAppBrowser } from 'url_launcher_ohos/src/main/ets/components/plugin/InAppBrowser';

@Entry
@Component
struct LaunchInAppPage {

  build() {
    Row() {
      InAppBrowser()
    }
  }
}
