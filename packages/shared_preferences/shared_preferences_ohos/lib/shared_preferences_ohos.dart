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

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_platform_interface.dart';
import 'package:shared_preferences_platform_interface/types.dart';

import 'src/messages.g.dart';

/// The Ohos implementation of [SharedPreferencesStorePlatform].
///
/// This class implements the `package:shared_preferences` functionality for Ohos.
class SharedPreferencesOhos extends SharedPreferencesStorePlatform {
  /// Creates a new plugin implementation instance.
  SharedPreferencesOhos({
    @visibleForTesting SharedPreferencesApi? api,
  }) : _api = api ?? SharedPreferencesApi();

  final SharedPreferencesApi _api;

  /// Registers this class as the default instance of [SharedPreferencesStorePlatform].
  static void registerWith() {
    SharedPreferencesStorePlatform.instance = SharedPreferencesOhos();
  }

  static const String _defaultPrefix = 'flutter.';
  static const String _doublePrefix = "VGhpcyBpcyB0aGUgcHJlZml4IGZvciBhIGRvdWJsZS4";

  @override
  Future<bool> remove(String key) async {
    return _api.remove(key);
  }

  @override
  Future<bool> setValue(String valueType, String key, Object value) async {
    switch (valueType) {
      case 'String':
        if((value as String).startsWith(_doublePrefix)) {
          throw PlatformException(
              code: 'InvalidOperation',
              message: 'StorageError: This string cannot be stored as it clashes with special identifier prefixes');
        }
        return _api.setString(key, value as String);
      case 'Bool':
        return _api.setBool(key, value as bool);
      case 'Int':
        return _api.setInt(key, value as int);
      case 'Double':
        return _api.setString(key, "$_doublePrefix$value");
      case 'StringList':
        return _api.setStringList(key, value as List<String>);
    }
    // TODO(tarrinneal): change to ArgumentError across all platforms.
    throw PlatformException(
        code: 'InvalidOperation',
        message: '"$valueType" is not a supported type.');
  }

  @override
  Future<bool> clear() async {
    return clearWithParameters(
      ClearParameters(
        filter: PreferencesFilter(prefix: _defaultPrefix),
      ),
    );
  }

  @override
  Future<bool> clearWithPrefix(String prefix) async {
    return clearWithParameters(
        ClearParameters(filter: PreferencesFilter(prefix: prefix)));
  }

  @override
  Future<bool> clearWithParameters(ClearParameters parameters) async {
    final PreferencesFilter filter = parameters.filter;
    return _api.clear(
      filter.prefix,
      filter.allowList?.toList(),
    );
  }

  @override
  Future<Map<String, Object>> getAll() async {
    return getAllWithParameters(
      GetAllParameters(
        filter: PreferencesFilter(prefix: _defaultPrefix),
      ),
    );
  }

  @override
  Future<Map<String, Object>> getAllWithPrefix(String prefix) async {
    return getAllWithParameters(
        GetAllParameters(filter: PreferencesFilter(prefix: prefix)));
  }

  @override
  Future<Map<String, Object>> getAllWithParameters(
      GetAllParameters parameters) async {
    final PreferencesFilter filter = parameters.filter;
    Map<String?, Object?> data =
        await _api.getAll(filter.prefix, filter.allowList?.toList());
    data = data.map((key, value) {
      if(value is String && value.startsWith(_doublePrefix)) {
        return MapEntry(key, double.tryParse(value.substring(_doublePrefix.length)));
      }
      return MapEntry(key, value);
    });
    return data.cast<String, Object>();
  }
}
