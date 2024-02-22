## Warehouse introduction

The warehouse is based on the upstream Flutter community [packages warehouse] (https://github.com/flutter/packages/), based on commitId: b8b84b2304f00a3f93ce585cc7a30e1235bde7a0.

This repository mainly adds compatibility with the OpenHarmony platform.

## OpenHarmony platform has compatible libraries

| Warehouse name | Dependency path | Type |
| ----- | ----------------------------------------------- -- | ----- |
| pigeon | packages/pigeons | tool library |
| file_selector | packages/file_selector/file_selector | plugins |
| image_picker | packages/image_picker/image_picker | plugins |
| animations | packages/animations | New example |
| url_launcher | packages/url_launcher/url_launcher | plugins |
| shared_preferences | packages/shared_preferences/shared_preferences | plugins |
| path_provuder | packages/path_provuder/path_provuder | plugins |
| local_auth | packages/local_auth/local_auth | plugins |
    
## How to reference these libraries

### 1. Use of tool library pigeon

1. Introduce the pigeon library and add new configuration to dev_dependencies in pubspec.yaml:
  ```
dev_dependencies:
   pigeon:
     git:
       url: "https://gitee.com/openharmony-sig/flutter_packages.git"
       path: "packages/pigeons"
  ```
2. Run `flutter pub get` in the project root directory;

3. Run `flutter pub run pigeon in the project root directory --input <dart communication model file path> --arkts_out <arkts platform method code output file path, example./ohos/entry/src/main/ets/xxx.ets> `

  The template code for communication between Flutter and the OpenHarmony platform will be generated;

4. For calling examples, refer to packages/pigeon/example/app/ohos/entry/src/main/ets/plugins/MessagePlugin.ets

### 2. Use of plug-in library

Take path_provider as an example:
1. In the referenced project, add new dependencies configuration in pubspec.yaml:
```
dependencies:
   path_provider:
     git:
       url: "https://gitee.com/openharmony-sig/flutter_packages.git"
       path: "packages/path_provider/path_provider"
```

2. Run `flutter pub get` in the project root directory; (ohos/entry/oh-package.json5 will automatically add related plug-in har dependencies)

3. Call the path_provider related API in the business code, and it will run normally on the OpenHarmony platform.

Example: Add the path_provider library dependency that supports the OpenHarmony platform to a Flutter-compatible OpenHarmony project;

Reference examples: https://gitee.com/openharmony-sig/flutter_samples/tree/master/ohos/pictures_provider_demo.

## FAQ

### 1. Run `flutter pub get` displayed `"File name too long"` error

Open the `Git Bash` or `cmd.exe`(you need to have git as an environment variable) and execute the following command:
``` 
  git config --global core.longpaths true
```