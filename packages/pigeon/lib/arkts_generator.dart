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

import 'ast.dart';
import 'functional.dart';
import 'generator.dart';
import 'generator_tools.dart';
import 'pigeon_lib.dart' show TaskQueueType;

/// Documentation open symbol.
const String _docCommentPrefix = '/*';

/// Documentation continuation symbol.
const String _docCommentContinuation = '* ';

/// Documentation close symbol.
const String _docCommentSuffix = '*/';

/// Documentation comment spec.
const DocumentCommentSpecification _docCommentSpec =
    DocumentCommentSpecification(
  _docCommentPrefix,
  closeCommentToken: _docCommentSuffix,
  blockContinuationToken: _docCommentContinuation,
);

/// The standard codec for Flutter, used for any non custom codecs and extended for custom codecs.
const String _standardMessageCodec = 'StandardMessageCodec';

/// arkts参数
class ArkTSOptions {
  /// 构造
  const ArkTSOptions({
    this.copyrightHeader,
  });

  final Iterable<String>? copyrightHeader;

  static ArkTSOptions fromMap(Map<String, Object> map) {
    final Iterable<dynamic>? copyrightHeader =
        map['copyrightHeader'] as Iterable<dynamic>?;
    return ArkTSOptions(copyrightHeader: copyrightHeader?.cast<String>());
  }

  /// 转为map对象
  Map<String, Object> toMap() {
    final Map<String, Object> result = <String, Object>{
      if (copyrightHeader != null) 'copyrightHeader': copyrightHeader!,
    };
    return result;
  }

  /// Overrides any non-null parameters from [options] into this to make a new
  /// [ArkTSOptions].
  ArkTSOptions merge(ArkTSOptions options) {
    return ArkTSOptions.fromMap(mergeMaps(toMap(), options.toMap()));
  }
}

/// arkts code generator
class ArkTSGenerator extends StructuredGenerator<ArkTSOptions> {
  /// Instantiates a ArkTS Generator.
  const ArkTSGenerator();

  @override
  void writeFilePrologue(
      ArkTSOptions generatorOptions, Root root, Indent indent,
      {required String dartPackageName}) {
    if (generatorOptions.copyrightHeader != null) {
      indent.writeln('/*');
      addLines(indent, generatorOptions.copyrightHeader!, linePrefix: '* ');
      indent.writeln('*/');
    }
  }

  @override
  void writeFileImports(ArkTSOptions generatorOptions, Root root, Indent indent,
      {required String dartPackageName}) {
    indent.writeln(
        "import StandardMessageCodec from '@ohos/flutter_ohos/src/main/ets/plugin/common/StandardMessageCodec';");
    indent.writeln(
        "import BasicMessageChannel, { Reply } from '@ohos/flutter_ohos/src/main/ets/plugin/common/BasicMessageChannel';");
    indent.writeln(
        "import { BinaryMessenger,TaskQueue } from '@ohos/flutter_ohos/src/main/ets/plugin/common/BinaryMessenger';");
    indent.writeln(
        "import MessageCodec from '@ohos/flutter_ohos/src/main/ets/plugin/common/MessageCodec';");
    indent.writeln(
        "import { ByteBuffer } from '@ohos/flutter_ohos/src/main/ets/util/ByteBuffer';");
    indent.newln();
  }

  /// 输出枚举
  @override
  void writeEnum(
    ArkTSOptions generatorOptions,
    Root root,
    Indent indent,
    Enum anEnum, {
    required String dartPackageName,
  }) {
    String camelToSnake(String camelCase) {
      final RegExp regex = RegExp('([a-z])([A-Z]+)');
      return camelCase
          .replaceAllMapped(regex, (Match m) => '${m[1]}_${m[2]}')
          .toUpperCase();
    }

    indent.newln();
    addDocumentationComments(
        indent, anEnum.documentationComments, _docCommentSpec);

    indent.write('export enum ${anEnum.name} ');
    indent.addScoped('{', '}', () {
      enumerate(anEnum.members, (int index, final EnumMember member) {
        addDocumentationComments(
            indent, member.documentationComments, _docCommentSpec);
        indent.writeln(
            '${camelToSnake(member.name)}${index == anEnum.members.length - 1 ? '' : ','}');
      });
    });
  }

  @override
  void writeDataClass(
      ArkTSOptions generatorOptions, Root root, Indent indent, Class klass,
      {required String dartPackageName}) {
    final Set<String> customClassNames =
        root.classes.map((Class x) => x.name).toSet();
    final Set<String> customEnumNames =
        root.enums.map((Enum x) => x.name).toSet();

    const List<String> generatedMessages = <String>[
      ' Generated class from Pigeon that represents data sent in messages.'
    ];
    indent.newln();
    addDocumentationComments(
        indent, klass.documentationComments, _docCommentSpec,
        generatorComments: generatedMessages);

    indent.write('export class ${klass.name} ');
    indent.addScoped('{', '}', () {
      for (final NamedType field in getFieldsInSerializationOrder(klass)) {
        _writeClassField(generatorOptions, root, indent, field);
        indent.newln();
      }

      _writeClassBuilder(generatorOptions, root, indent, klass);
      writeClassEncode(
        generatorOptions,
        root,
        indent,
        klass,
        customClassNames,
        customEnumNames,
        dartPackageName: dartPackageName,
      );
      writeClassDecode(
        generatorOptions,
        root,
        indent,
        klass,
        customClassNames,
        customEnumNames,
        dartPackageName: dartPackageName,
      );
    });
  }

  void _writeClassField(ArkTSOptions generatorOptions, Root root, Indent indent,
      NamedType field) {
    final HostDatatype hostDatatype = getFieldHostDatatype(field, root.classes,
        root.enums, (TypeDeclaration x) => _arkTSTypeForBuiltinDartType(x));
    indent.writeln('private ${field.name}: ${hostDatatype.datatype};');
    indent.newln();
    indent.write('${_makeGetter(field)}(): ${hostDatatype.datatype} ');
    indent.addScoped('{', '}', () {
      indent.writeln('return this.${field.name};');
    });
  }

  // 构造函数
  void _writeClassBuilder(
    ArkTSOptions generatorOptions,
    Root root,
    Indent indent,
    Class klass,
  ) {
    indent.write('constructor');
    final List<String> argSignature = <String>[];
    if (klass.fields.isNotEmpty) {
      for (final NamedType element in klass.fields) {
        final String type = _arkTSTypeForDartType(element.type);
        final String name = getSafeConstructorArgument(element.name);
        argSignature.add('$name: $type');
      }
    }
    indent.add('(${argSignature.join(', ')}) ');
    indent.addScoped('{', '}', () {
      for (final NamedType field in getFieldsInSerializationOrder(klass)) {
        final String value = getSafeConstructorArgument(field.name);
        indent.writeln('this.${field.name} = $value;');
      }
    });
  }

  /// 编写dataclass的tolist()方法
  /// toList(): Object[]{
  ///	  let arr: Object[] = new Array();
  ///	  arr.push(field1);
  ///	  arr.push(field2);
  ///	  return arr;
  /// }
  @override
  void writeClassEncode(
    ArkTSOptions generatorOptions,
    Root root,
    Indent indent,
    Class klass,
    Set<String> customClassNames,
    Set<String> customEnumNames, {
    required String dartPackageName,
  }) {
    indent.newln();
    indent.write('toList(): Object[] ');
    indent.addScoped('{', '}', () {
      indent.writeln('let arr: Object[] = new Array();');
      for (final NamedType field in getFieldsInSerializationOrder(klass)) {
        final String fieldName = field.name;
        final HostDatatype hostDatatype = getFieldHostDatatype(
            field,
            root.classes,
            root.enums,
            (TypeDeclaration x) => _arkTSTypeForBuiltinDartType(x));
        if (!hostDatatype.isBuiltin &&
            customClassNames.contains(field.type.baseName)) {
          indent.writeln('''
if (this.$fieldName instanceof Array) {
      arr.push(this.$fieldName);
    } else {
      arr.push(this.$fieldName.toList());
    }''');
        } else {
          indent.writeln('arr.push(this.$fieldName);');
        }
      }
      indent.writeln('return arr;');
    });
  }

  /// 编写dataclass的fromlist方法
  /// fromList(arr: Object[]):Class {
  /// 	let instance: Class = new Class(arr[0] as xxx,arr[1] as  xxx);
  /// 	return instance;
  /// }
  @override
  void writeClassDecode(
    ArkTSOptions generatorOptions,
    Root root,
    Indent indent,
    Class klass,
    Set<String> customClassNames,
    Set<String> customEnumNames, {
    required String dartPackageName,
  }) {
    indent.newln();
    indent.write('static fromList(arr: Object[]): ${klass.name} ');
    indent.addScoped('{', '}', () {
      indent.write('let instance: ${klass.name} = new ${klass.name}(');
      for (int i = 0; i < klass.fields.length; i++) {
        final NamedType field = klass.fields[i];
        if (customEnumNames.contains(field.type.baseName)) {
          indent.add(
              '${field.type.baseName}[${field.type.baseName}[arr[$i] as number]]');
        } else if (customClassNames.contains(field.type.baseName)) {
          indent.add('arr[$i] instanceof Array ? ${field.type.baseName}.fromList(arr[$i] as Object[]) : null');
        } else {
          final String type = _arkTSTypeForDartType(field.type);
          indent.add('arr[$i] as $type');
        }
        if (i != klass.fields.length - 1) {
          indent.add(', ');
        }
      }
      indent.add(');');
      indent.newln();
      indent.writeln('return instance;');
    });
  }

  @override
  void writeFlutterApi(
      ArkTSOptions generatorOptions, Root root, Indent indent, Api api,
      {required String dartPackageName}) {
    assert(api.location == ApiLocation.flutter);
    if (getCodecClasses(api, root).isNotEmpty) {
      _writeCodec(indent, api, root);
    }

    const List<String> generatedMessages = <String>[
      ' Generated class from Pigeon that represents Flutter messages that can be called from ArkTS.'
    ];
    addDocumentationComments(indent, api.documentationComments, _docCommentSpec,
        generatorComments: generatedMessages);

    indent.write('export class ${api.name} ');
    indent.addScoped('{', '}', () {
      indent.writeln('binaryMessenger: BinaryMessenger;');
      indent.newln();
      indent.write('constructor(binaryMessenger: BinaryMessenger) ');
      indent.addScoped('{', '}', () {
        indent.writeln('this.binaryMessenger = binaryMessenger;');
      });

      indent.newln();
      final String codecName = _getCodecName(api);
      indent.writeln('/** The codec used by ${api.name}. */');
      indent.write('static getCodec(): MessageCodec<Object> ');
      indent.addScoped('{', '}', () {
        indent.write('return ');
        if (getCodecClasses(api, root).isNotEmpty) {
          indent.addln('$codecName.INSTANCE;');
        } else {
          indent.addln('new $_standardMessageCodec();');
        }
      });

      indent.newln();

      /// Returns an argument name that can be used in a context where it is possible to collide
      /// and append `.index` to enums.
      String getEnumSafeArgumentExpression(int count, NamedType argument) {
        if (isEnum(root, argument.type)) {
          return argument.type.isNullable
              ? '${_getArgumentName(count, argument)}Arg == null ? null : ${_getArgumentName(count, argument)}Arg.index'
              : '${_getArgumentName(count, argument)}Arg.index';
        }
        return '${_getArgumentName(count, argument)}Arg';
      }

      for (final Method func in api.methods) {
        final String channelName = makeChannelName(api, func, dartPackageName);
        final String returnType = func.returnType.isVoid
            ? 'void'
            : _arkTSTypeForDartType(func.returnType);
        String sendArgument;
        addDocumentationComments(
            indent, func.documentationComments, _docCommentSpec);
        if (func.arguments.isEmpty) {
          indent.write('${func.name}(callback: Reply<$returnType>):void ');
          sendArgument = 'null';
        } else {
          final Iterable<String> argTypes = func.arguments
              .map((NamedType e) => _arkTSTypeForDartType(e.type));
          final Iterable<String> argNames =
              indexMap(func.arguments, _getSafeArgumentName);
          final Iterable<String> enumSafeArgNames =
              indexMap(func.arguments, getEnumSafeArgumentExpression);
          sendArgument = '[${argNames.join(', ')}]';
          final String argsSignature =
              map2(argTypes, argNames, (String x, String y) => '$y: $x')
                  .join(',');
          indent.write(
              '${func.name}($argsSignature, callback: Reply<$returnType>) ');
        }
        indent.addScoped('{', '}', () {
          const String channel = 'channel';
          indent.writeln('let $channel: BasicMessageChannel<Object> = ');
          indent.nest(2, () {
            indent.writeln('new BasicMessageChannel<Object>(');
            indent.nest(2, () {
              indent.writeln(
                  'this.binaryMessenger, "$channelName", ${api.name}.getCodec());');
            });
          });
          indent.writeln('$channel.send(');
          indent.nest(2, () {
            indent.writeln('$sendArgument,');
            indent.write('channelReply => ');
            if (func.returnType.isVoid) {
              indent.addln('callback.reply(null));');
            } else {
              indent.addScoped('{', '});', () {
                const String output = 'output';
                if (func.returnType.baseName == 'number') {
                  indent.writeln(
                      'let $output: $returnType = channelReply == null ? null : channelReply as number;');
                } else if (isEnum(root, func.returnType)) {
                  indent.writeln(
                      'let $output: $returnType = channelReply == null ? null : $returnType[channelReply as number];');
                } else {
                  indent.writeln(
                      'let $output: $returnType = ${_cast('channelReply', artTSType: returnType)};');
                }
                indent.writeln('callback.reply($output);');
              });
            }
          });
        });
      }
    });
  }

  @override
  void writeApis(
    ArkTSOptions generatorOptions,
    Root root,
    Indent indent, {
    required String dartPackageName,
  }) {
    if (root.apis.any((Api api) =>
        api.location == ApiLocation.host &&
        api.methods.any((Method it) => it.isAsynchronous))) {
      indent.newln();
      _writeResultInterface(indent);
    }
    super.writeApis(generatorOptions, root, indent,
        dartPackageName: dartPackageName);
  }

  @override
  void writeHostApi(
      ArkTSOptions generatorOptions, Root root, Indent indent, Api api,
      {required String dartPackageName}) {
    assert(api.location == ApiLocation.host);
    if (getCodecClasses(api, root).isNotEmpty) {
      _writeCodec(indent, api, root);
    }
    const List<String> generatedMessages = <String>[
      ' Generated abstract class from Pigeon that represents a handler of messages from Flutter.'
    ];
    addDocumentationComments(indent, api.documentationComments, _docCommentSpec,
        generatorComments: generatedMessages);

    indent.write('export abstract class ${api.name} ');
    indent.addScoped('{', '}', () {
      for (final Method method in api.methods) {
        _writeInterfaceMethod(generatorOptions, root, indent, api, method);
      }
      final String codecName = _getCodecName(api);
      indent.writeln('/** The codec used by ${api.name}. */');
      indent.write('static getCodec(): MessageCodec<Object>');
      indent.addScoped('{', '}', () {
        indent.write('return ');
        if (getCodecClasses(api, root).isNotEmpty) {
          indent.addln('$codecName.INSTANCE;');
        } else {
          indent.addln('new $_standardMessageCodec();');
        }
      });

      indent.writeln(
          '${_docCommentPrefix}Sets up an instance of `${api.name}` to handle messages through the `binaryMessenger`.$_docCommentSuffix');
      indent.write(
          'static setup(binaryMessenger: BinaryMessenger, api: ${api.name} | null): void ');
      indent.addScoped('{', '}', () {
        for (final Method method in api.methods) {
          _writeMethodSetup(
            generatorOptions,
            root,
            indent,
            api,
            method,
            dartPackageName: dartPackageName,
          );
        }
      });
    });
  }

  /// Write a static setup function in the interface.
  /// Example:
  ///   static void setup(BinaryMessenger binaryMessenger, Foo api) {...}
  void _writeMethodSetup(
    ArkTSOptions generatorOptions,
    Root root,
    Indent indent,
    Api api,
    final Method method, {
    required String dartPackageName,
  }) {
    final String channelName = makeChannelName(api, method, dartPackageName);
    indent.write('');
    indent.addScoped('{', '}', () {
      String? taskQueue;
      if (method.taskQueueType != TaskQueueType.serial) {
        taskQueue = 'taskQueue';
        indent.writeln(
            'let taskQueue: TaskQueue = binaryMessenger.makeBackgroundTaskQueue();');
      }
      indent.writeln('let channel: BasicMessageChannel<Object> =');
      indent.nest(2, () {
        indent.writeln('new BasicMessageChannel(');
        indent.nest(2, () {
          indent
              .write('binaryMessenger, "$channelName", ${api.name}.getCodec()');
          indent.addln(');');
        });
      });
      indent.write('if (api != null) ');
      indent.addScoped('{', '} else {', () {
        indent.writeln('channel.setMessageHandler({');
        indent.nest(2, () {
          indent.write('onMessage(message: Object ,reply: Reply<Object> ) ');
          indent.addScoped('{', '} });', () {
            String enumTag = '';
            final String returnType = method.returnType.isVoid
                ? 'void'
                : _arkTSTypeForDartType(method.returnType);
            final List<String> methodArgument = <String>[];
            if (method.arguments.isNotEmpty) {
              indent.writeln(
                  'let args: Array<Object> = message as Array<Object>;');
              enumerate(method.arguments, (int index, NamedType arg) {
                final String argExpression =
                    'args[$index] as ${_arkTSTypeForDartType(arg.type)}';
                methodArgument.add(argExpression);
              });
            }
            if (method.isAsynchronous) {
              final String resultValue =
                  method.returnType.isVoid ? 'null' : 'result';
              if (isEnum(root, method.returnType)) {
                enumTag = method.returnType.isNullable
                    ? ' == null ? null : $resultValue.index'
                    : '.index';
              }
              const String resultName = 'resultCallback';
              indent.format('''
class ResultImp implements Result<$returnType>{
\t\t\tsuccess(result: $returnType): void {
\t\t\t\tlet res: Array<Object> = [];
\t\t\t\tres.push($resultValue);
\t\t\t\treply.reply(res);
\t\t\t}

\t\t\terror(error: Error): void {
\t\t\t\tlet wrappedError: Array<Object> = wrapError(error);
\t\t\t\treply.reply(wrappedError);
\t\t\t}
}
let $resultName: Result<$returnType> = new ResultImp();
''');
              methodArgument.add(resultName);
            }
            final String call =
                'api!.${method.name}(${methodArgument.join(', ')})';
            // indent.writeln('$call;');
            if (method.isAsynchronous) {
              indent.writeln('$call;');
            } else {
              // indent.writeln('let res: Array<Object> = [];');
              // indent.writeln('let output: $returnType = $call;');
              // indent.writeln('res[0] = output;');
              // indent.writeln('reply.reply(res);');

              indent.writeln('let res: Array<Object> = [];');
              indent.write('try ');
              indent.addScoped('{', '}', () {
                if (method.returnType.isVoid) {
                  indent.writeln('$call;');
                  indent.writeln('res.push(null);');
                } else {
                  indent.writeln('let output: $returnType = $call;');
                  indent.writeln('res.push(output);');
                }
              });
              indent.add(' catch (error) ');
              indent.addScoped('{', '}', () {
                indent.writeln(
                    'let wrappedError: Array<Object> = wrapError(error);');
                if (method.isAsynchronous) {
                  indent.writeln('reply.reply(wrappedError);');
                } else {
                  indent.writeln('res = wrappedError;');
                }
              });
              indent.writeln('reply.reply(res);');
            }
          });
        });
      });
      indent.addScoped(null, '}', () {
        indent.writeln('channel.setMessageHandler(null);');
      });
    });
  }

  /// Writes the codec class that will be used by [api].
  /// Example:
  /// private static class FooCodec extends StandardMessageCodec {...}
  void _writeCodec(Indent indent, Api api, Root root) {
    assert(getCodecClasses(api, root).isNotEmpty);
    final Iterable<EnumeratedClass> codecClasses = getCodecClasses(api, root);
    final String codecName = _getCodecName(api);
    indent.newln();
    indent.write('class $codecName extends $_standardMessageCodec ');
    indent.addScoped('{', '}', () {
      indent.writeln('static INSTANCE: $codecName = new $codecName();');
      indent.newln();
      _writeGetByteMethoe(indent);
      indent.newln();
      indent.write(
          'readValueOfType(type: number, buffer: ByteBuffer): ESObject ');
      indent.addScoped('{', '}', () {
        indent.write('switch (type) ');
        indent.addScoped('{', '}', () {
          for (final EnumeratedClass customClass in codecClasses) {
            indent.writeln('case this.getByte(${customClass.enumeration}):');
            indent.nest(1, () {
              indent.writeln(
                  'return ${customClass.name}.fromList(super.readValue(buffer));');
            });
          }
          indent.writeln('default:');
          indent.nest(1, () {
            indent.writeln('return super.readValueOfType(type, buffer);');
          });
        });
      });
      indent.newln();
      // todo 这里的解析，要更精确一点
      indent
          .write('writeValue(stream: ByteBuffer, value: ESObject): ESObject ');
      indent.addScoped('{', '}', () {
        bool firstClass = true;
        for (final EnumeratedClass customClass in codecClasses) {
          if (firstClass) {
            indent.write('');
            firstClass = false;
          }
          indent.add('if (value instanceof ${customClass.name}) ');
          indent.addScoped('{', '} else ', () {
            indent.writeln(
                'stream.writeUint8(this.getByte(${customClass.enumeration}));');
            indent.writeln(
                'this.writeValue(stream, (value as ${customClass.name}).toList());');
          }, addTrailingNewline: false);
        }
        indent.addScoped('{', '}', () {
          indent.writeln('super.writeValue(stream, value);');
        });
      });
    });
    indent.newln();
  }

  /// Write a method in the interface.
  /// Example:
  ///   int add(int x, int y);
  void _writeInterfaceMethod(ArkTSOptions generatorOptions, Root root,
      Indent indent, Api api, final Method method) {
    final String returnType = method.isAsynchronous
        ? 'void'
        : _arkTSTypeForDartType(method.returnType);

    final List<String> argSignature = <String>[];
    if (method.arguments.isNotEmpty) {
      final Iterable<String> argTypes =
          method.arguments.map((NamedType e) => _arkTSTypeForDartType(e.type));
      final Iterable<String> argNames =
          method.arguments.map((NamedType e) => e.name);
      argSignature
          .addAll(map2(argTypes, argNames, (String argType, String argName) {
        return '$argName: $argType ';
      }));
    }
    if (method.isAsynchronous) {
      final String resultType = method.returnType.isVoid
          ? 'void'
          : _arkTSTypeForDartType(method.returnType);
      argSignature.add('result: Result<$resultType>');
    }
    if (method.documentationComments.isNotEmpty) {
      addDocumentationComments(
          indent, method.documentationComments, _docCommentSpec);
    } else {
      indent.newln();
    }
    indent.writeln(
        'abstract ${method.name}(${argSignature.join(', ')}): $returnType;');
  }

  void _writeResultInterface(Indent indent) {
    indent.write('export interface Result<T> ');
    indent.addScoped('{', '}', () {
      indent.writeln('success( result: T ): void;');
      indent.newln();
      indent.writeln('error( error: Error): void;');
    });
  }

  void _writeErrorClass(Indent indent) {
    indent.writeln(
        '/** Error class for passing custom error details to Flutter via a thrown PlatformException. */');
    indent.write('export class FlutterError implements Error ');
    indent.addScoped('{', '}', () {
      indent.newln();
      indent.writeln('/** The error code. */');
      indent.writeln('public code: string;');
      indent.newln();
      indent.writeln('/** The error name. */');
      indent.writeln('public name: string;');
      indent.newln();
      indent.writeln('/** The error message. */');
      indent.writeln('public message: string;');
      indent.writeln('/** The error stack. */');
      indent.writeln('public stack?: string;');
      indent.newln();
      indent.writeln(
          'constructor(code: string, name: string,  message: string, stack: string) ');
      indent.writeScoped('{', '}', () {
        indent.writeln('this.code = code;');
        indent.writeln('this.name = name;');
        indent.writeln('this.message = message;');
        indent.writeln('this.stack = stack;');
      });
    });
  }

  void _writeWrapError(Indent indent) {
    indent.format('''
function wrapError(error: Error): Array<Object> {
\tlet errorList: Array<Object> = new Array<Object>(3);
\tif (error instanceof FlutterError) {
\t\tlet err: FlutterError = error as FlutterError;
\t\terrorList[0] = err.code;
\t\terrorList[1] = err.name;
\t\terrorList[2] = err.message;
\t} else {
\t\terrorList[0] = error.toString();
\t\terrorList[1] = error.name;
\t\terrorList[2] = "Cause: " + error.message + ", Stacktrace: " + error.stack;
\t}
\treturn errorList;
}''');
  }

  void _writeGetByteMethoe(Indent indent) {
    indent.format('''
getByte(n: number): number {
\tlet byteArray = new Uint8Array(1);
\tbyteArray[0] = n;
\treturn byteArray[0] as number;
}''');
  }

  @override
  void writeGeneralUtilities(
    ArkTSOptions generatorOptions,
    Root root,
    Indent indent, {
    required String dartPackageName,
  }) {
    indent.newln();
    _writeErrorClass(indent);
    indent.newln();
    _writeWrapError(indent);
  }

  /// Calculates the name of the codec that will be generated for [api].
  String _getCodecName(Api api) => '${api.name}Codec';

  /// Converts an expression that evaluates to an nullable int to an expression
  /// that evaluates to a nullable enum.
  String _intToEnum(String expression, String enumName, bool nullable) =>
      nullable
          ? '$expression == null ? null : $enumName.values()[$expression]'
          : '$enumName.values()[$expression]';

  String _getArgumentName(int count, NamedType argument) =>
      argument.name.isEmpty ? 'arg$count' : argument.name;

  String _getSafeArgumentName(int count, NamedType argument) =>
      '${_getArgumentName(count, argument)}Arg';

  /// arkts方法参数如果是arguments，会与参数关键字冲突
  String getSafeConstructorArgument(String argument) {
    return (argument == 'arguments') ? 'argumentsArg' : argument;
  }

// get函数
  String _makeGetter(NamedType field) {
    final String uppercased =
        field.name.substring(0, 1).toUpperCase() + field.name.substring(1);
    return 'get$uppercased';
  }

  /// Returns an expression to cast [variable] to [artTSType].
  String _cast(String variable, {required String artTSType}) {
    // Special-case object, since casting to object doesn't do anything, and
    // causes a warning.
    return artTSType == 'Object' ? variable : '$variable as $artTSType';
  }

  String _arkTSTypeForDartType(TypeDeclaration type) {
    return _arkTSTypeForBuiltinDartType(type) ?? type.baseName;
  }

  /// Converts a [List] of [TypeDeclaration]s to a comma separated [String] to be
  /// used in Java code.
  String _flattenTypeArguments(List<TypeDeclaration> args) {
    return args.map<String>(_arkTSTypeForDartType).join(', ');
  }

  /// 泛型转换
  String _arkTSTypeForBuiltinGenericDartType(
    TypeDeclaration type,
    int numberTypeArguments,
  ) {
    final String typeName = type.baseName == 'List' ? 'Array' : type.baseName;
    if (type.typeArguments.isEmpty) {
      return '$typeName<${repeat('Object', numberTypeArguments).join(', ')}>';
    } else {
      return '$typeName<${_flattenTypeArguments(type.typeArguments)}>';
    }
  }

  String? _arkTSTypeForBuiltinDartType(TypeDeclaration type) {
    const Map<String, String> arkTSTypeForDartTypeMap = <String, String>{
      'bool': 'boolean',
      'int': 'number',
      'String': 'string',
      'double': 'number',
      'Uint8List': 'number[]',
      'Int32List': 'number[]',
      'Int64List': 'number[]',
      'Float64List': 'number[]',
      'Object': 'Object',
    };
    if (arkTSTypeForDartTypeMap.containsKey(type.baseName)) {
      return arkTSTypeForDartTypeMap[type.baseName];
    } else if (type.baseName == 'List') {
      return _arkTSTypeForBuiltinGenericDartType(type, 1);
    } else if (type.baseName == 'Map') {
      return _arkTSTypeForBuiltinGenericDartType(type, 2);
    } else {
      return null;
    }
  }
}
