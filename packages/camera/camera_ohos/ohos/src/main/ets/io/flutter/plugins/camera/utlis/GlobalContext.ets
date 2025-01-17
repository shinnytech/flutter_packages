export class GlobalContext {
  private constructor() {
  }

  private static instance: GlobalContext;
  private _objects = new Map<string, Object>();

  public static getContext(): GlobalContext {
    if (!GlobalContext.instance) {
      GlobalContext.instance = new GlobalContext();
    }
    return GlobalContext.instance;
  }

  getValue(value: string): Object {
    let result = this._objects.get(value);
    if (!result) {
      throw new Error("this value undefined")
    }
    return result;
  }

  setValue(key: string, objectClass: Object): void {
    this._objects.set(key, objectClass);
  }
}