/*
* Copyright 2013 The Flutter Authors. All rights reserved.
* Use of this source code is governed by a BSD-style license that can be
* found in the LICENSE file.
*/
import StandardMessageCodec from '@ohos/flutter_ohos/src/main/ets/plugin/common/StandardMessageCodec';
import BasicMessageChannel from '@ohos/flutter_ohos/src/main/ets/plugin/common/BasicMessageChannel';
import { BinaryMessenger } from '@ohos/flutter_ohos/src/main/ets/plugin/common/BinaryMessenger';
import MessageCodec from '@ohos/flutter_ohos/src/main/ets/plugin/common/MessageCodec';
import { ByteBuffer } from '@ohos/flutter_ohos/src/main/ets/util/ByteBuffer';


enum Code {
  ONE,
  TWO
}

/* Generated class from Pigeon that represents data sent in messages.*/
export class MessageData {
  private name: string;

  getName(): string {
    return this.name;
  }

  private description: string;

  getDescription(): string {
    return this.description;
  }

  private code: Code;

  getCode(): Code {
    return this.code;
  }

  private data: Map<string, string>;

  getData(): Map<string, string> {
    return this.data;
  }

  constructor(name: string, description: string, code: Code, data: Map<string, string>) {
    this.name = name;
    this.description = description;
    this.code = code;
    this.data = data;
  }

  toList(): Object[] {
    let arr: Object[] = new Array();
    arr.push(this.name);
    arr.push(this.description);
    arr.push(this.code);
    arr.push(this.data);
    return arr;
  }

  static fromList(arr: Object[]): MessageData {
    let instance: MessageData = new MessageData(arr[0] as string, arr[1] as string, arr[2] as Code, arr[3] as Map<string, string>);
    return instance;
  }
}

export interface Result<T> {
  success( result: T ): void;

  error( error: Error): void;
}

class ExampleHostApiCodec extends StandardMessageCodec {
  static INSTANCE: ExampleHostApiCodec = new ExampleHostApiCodec();

  readValueOfType(type: number, buffer: ByteBuffer): ESObject {
    switch (type) {
      case 128:
        return MessageData.fromList(super.readValue(buffer));
      default:
        return super.readValueOfType(type, buffer);
    }
  }

  writeValue(stream: ByteBuffer, value: ESObject): ESObject {
    if (value instanceof MessageData) {
      stream.writeInt8(128);
      this.writeSize(stream, this.encodeMessage(value).byteLength);
      this.writeValue(stream, value);
    } else {
      super.writeValue(stream, value);
    }
  }
}

/* Generated abstract class from Pigeon that represents a handler of messages from Flutter.*/
export abstract class ExampleHostApi {

  abstract getHostLanguage(): string;

  abstract add(a: number , b: number ): number;

  abstract sendMessage(message: MessageData , result: Result<boolean>): void;
  /** The codec used by ExampleHostApi. */
  static getCodec(): MessageCodec<Object>{
    return ExampleHostApiCodec.INSTANCE;
  }
  /*Sets up an instance of `ExampleHostApi` to handle messages through the `binaryMessenger`.*/
  static setup(binaryMessenger: BinaryMessenger, api: ExampleHostApi): void {
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.pigeon_example_package.ExampleHostApi.getHostLanguage", ExampleHostApi.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let res: Array<Object> = [];
              let output: string = api.getHostLanguage();
              res[0] = output;
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.pigeon_example_package.ExampleHostApi.add", ExampleHostApi.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let args: Array<Object> = message as Array<Object>;
              let res: Array<Object> = [];
              let output: number = api.add(args[0] as number, args[1] as number);
              res[0] = output;
              reply.reply(res);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
    {
      let channel: BasicMessageChannel<Object> =
          new BasicMessageChannel(
              binaryMessenger, "dev.flutter.pigeon.pigeon_example_package.ExampleHostApi.sendMessage", ExampleHostApi.getCodec());
      if (api != null) {
        channel.setMessageHandler({
            onMessage(message: Object ,reply: Reply<Object> ) {
              let args: Array<Object> = message as Array<Object>;
              class ResultImp implements Result<boolean>{
                    success(result: boolean): void {
                      reply.reply(result);
                    }

                    error(error: Error): void {
                      reply.reply(error);
                    }
              }
              let resultCallback: Result<boolean> = new ResultImp();

              api.sendMessage(args[0] as MessageData, resultCallback);
            } });
      } else {
        channel.setMessageHandler(null);
      }
    }
  }
}
/** Public interface for sending reply. */ 
interface Reply<T> {
  reply(reply: T): void;
}

/* Generated class from Pigeon that represents Flutter messages that can be called from ArkTS.*/
abstract class MessageFlutterApi {
  binaryMessenger: BinaryMessenger;

  constructor(binaryMessenger: BinaryMessenger) {
    this.binaryMessenger = binaryMessenger;
  }

  /** The codec used by MessageFlutterApi. */
  static getCodec(): MessageCodec<Object> {
    return new StandardMessageCodec();
  }

  flutterMethod(aStringArg: string, callback: Reply<string>) {
    let channel: BasicMessageChannel<Object> = 
        new BasicMessageChannel<Object>(
            this.binaryMessenger, "dev.flutter.pigeon.pigeon_example_package.MessageFlutterApi.flutterMethod", MessageFlutterApi.getCodec());
    channel.send(
         { aStringArg: aStringArg },
        channelReply => {
          let output: string = channelReply as string;
          callback.reply(output);
        });
  }
}
