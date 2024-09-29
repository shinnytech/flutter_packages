# in\_app\_purchase\_ohos

The Ohos implementation of [`in_app_purchase`][1].

## Usage

This package is [endorsed][2], which means you can simply use `in_app_purchase`
normally. This package will be automatically included in your app when you do,
so you do not need to add it to your `pubspec.yaml`.

## Contributing

This plugin uses
[json_serializable](https://pub.dev/packages/json_serializable) for the
many data structs passed between the underlying platform layers and Dart. After
editing any of the serialized data structs, rebuild the serializers by running
`flutter pub run build_runner build --delete-conflicting-outputs`.
`flutter pub run build_runner watch --delete-conflicting-outputs` will monitor the filesystem for changes.

If you would like to contribute to the plugin, please refer to our
[contribution guide](https://github.com/flutter/plugins/blob/main/CONTRIBUTING.md).

[1]: https://pub.dev/packages/in_app_purchase
[2]: https://flutter.dev/docs/development/packages-and-plugins/developing-packages#endorsed-federated-plugin
