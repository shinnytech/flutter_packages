import {
  FlutterPlugin,
  FlutterPluginBinding
} from '@ohos/flutter_ohos/src/main/ets/embedding/engine/plugins/FlutterPlugin';
import { ExampleHostApi, MessageData, Result } from './Messages';

class HostApiImp extends ExampleHostApi {
  getHostLanguage(): string {
    return 'ArkTS';
  }

  add(a: number, b: number): number {
    return a + b;
  }

  sendMessage(message: MessageData, result: Result<boolean>) {
    console.log("收到消息：" + message.getName());
  }
}

export default class MessagePlugin implements FlutterPlugin {

  constructor() {
  }

  getUniqueClassName(): string {
    return 'MessagePlugin';
  }

  onAttachedToEngine(binding: FlutterPluginBinding) {
    ExampleHostApi.setup(binding.getBinaryMessenger(), new HostApiImp());
  }

  onDetachedFromEngine(binding: FlutterPluginBinding) {
    //ExampleHostApi.setup(binding.getBinaryMessenger(), null);
  }
}