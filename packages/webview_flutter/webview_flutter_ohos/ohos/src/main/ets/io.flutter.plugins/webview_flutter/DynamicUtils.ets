import { DVModelParameters } from '@ohos/flutter_ohos/src/main/ets/view/DynamicView/dynamicView'

export class DynamicUtils {
  static getParams(params: DVModelParameters, element: string): string | ESObject {
    let params2 = params as Record<string, ESObject>;
    return params2[element];
  }

  static setParams(params: DVModelParameters, key: string, element: ESObject): void {
    let params2 = params as Record<string, ESObject>;
    params2[key] = element;
  }
}

export class DVModelJson {
  compType: string
  children: Array<ESObject>
  attributes: ESObject
  events: ESObject
  build: ESObject

  constructor(compType: string, children: Array<ESObject>, attributes: ESObject, events: ESObject, build?: ESObject) {
    this.compType = compType
    this.children = children
    this.attributes = attributes
    this.events = events;
    this.build = build;
  }
}