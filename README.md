## 仓库介绍

该仓库基于上游Flutter社区[packages仓库](https://github.com/flutter/packages/),基于commitId：b8b84b2304f00a3f93ce585cc7a30e1235bde7a0。

该仓库主要新增对OpenHarmony平台的兼容。

## OpenHarmony平台已兼容库

| 仓库名 | 依赖路径 | 类型 |
| ----- | --------------------------------------------- | ----- |
| pigeon | packages/pigeons | 工具库 |
| file_selector | packages/file_selector/file_selector | 插件 |
| image_picker | packages/image_picker/image_picker | 插件 |
| animations | packages/animations | 新增示例 |
| url_launcher | packages/url_launcher/url_launcher | 插件 |
| shared_preferences | packages/shared_preferences/shared_preferences | 插件 |
| path_provuder | packages/path_provuder/path_provuder | 插件 |
| local_auth | packages/local_auth/local_auth | 插件 |
    
## 如何引用这些库

### 一、工具库pigeon使用

1. 引入pigeon库，在pubspec.yaml中dev_dependencies新增配置：
 ```
dev_dependencies:
  pigeon:
    git:
      url: "https://gitee.com/openharmony-sig/flutter_packages.git"
      path: "packages/pigeon"
 ```
2. 项目根目录运行`flutter pub get`；

3. 项目根目录运行`flutter pub run pigeon --input <dart通信模型文件路径> --arkts_out <arkts平台方法代码输出文件路径，示例./ohos/entry/src/main/ets/xxx.ets>`

 将会生成Flutter与OpenHarmony平台通信的模板代码；

4. 调用示例，参考packages/pigeon/example/app/ohos/entry/src/main/ets/plugins/MessagePlugin.ets

### 二、 插件库使用

以path_provider举例：
1. 在引用的项目中，pubspec.yaml中dependencies新增配置：
```
dependencies:
  path_provider:
    git:
      url: "https://gitee.com/openharmony-sig/flutter_packages.git"
      path: "packages/path_provider/path_provider"
```

2、项目根目录运行`flutter pub get`；（ohos/entry/oh-package.json5会自动添加相关插件har依赖）

3、在业务代码中调用path_provider相关api，它会在OpenHarmony平台正常运行。

示例：在某个Flutter兼容OpenHarmony项目中加入支持OpenHarmony平台的path_provider库依赖；

可参考示例：https://gitee.com/openharmony-sig/flutter_samples/tree/master/ohos/pictures_provider_demo。

## FAQ

### 一、 运行 `flutter pub get` 遇到 `"File name too long"` 问题

打开`Git Bash`或`运行 cmd`（需要将git添加到环境变量中）,执行以下命令：
``` 
  git config --global core.longpaths true
```