/*
 * Copyright (c) 2024 Hunan OpenValley Digital Industry Development Co., Ltd.
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

import 'package:flutter_test/flutter_test.dart';
import 'package:webview_flutter_platform_interface/src/webview_flutter_platform_interface_legacy.dart';

void main() {
  final Map<String, String> log = <String, String>{};
  final Set<JavascriptChannel> channels = <JavascriptChannel>{
    JavascriptChannel(
      name: 'js_channel_1',
      onMessageReceived: (JavascriptMessage message) =>
          log['js_channel_1'] = message.message,
    ),
    JavascriptChannel(
      name: 'js_channel_2',
      onMessageReceived: (JavascriptMessage message) =>
          log['js_channel_2'] = message.message,
    ),
    JavascriptChannel(
      name: 'js_channel_3',
      onMessageReceived: (JavascriptMessage message) =>
          log['js_channel_3'] = message.message,
    ),
  };

  tearDown(() {
    log.clear();
  });

  test('ctor should initialize with channels.', () {
    final JavascriptChannelRegistry registry =
        JavascriptChannelRegistry(channels);

    expect(registry.channels.length, 3);
    for (final JavascriptChannel channel in channels) {
      expect(registry.channels[channel.name], channel);
    }
  });

  test('onJavascriptChannelMessage should forward message on correct channel.',
      () {
    final JavascriptChannelRegistry registry =
        JavascriptChannelRegistry(channels);

    registry.onJavascriptChannelMessage(
      'js_channel_2',
      'test message on channel 2',
    );

    expect(
        log,
        containsPair(
          'js_channel_2',
          'test message on channel 2',
        ));
  });

  test(
      'onJavascriptChannelMessage should throw ArgumentError when message arrives on non-existing channel.',
      () {
    final JavascriptChannelRegistry registry =
        JavascriptChannelRegistry(channels);

    expect(
        () => registry.onJavascriptChannelMessage(
              'js_channel_4',
              'test message on channel 2',
            ),
        throwsA(
          isA<ArgumentError>().having((ArgumentError error) => error.message,
              'message', 'No channel registered with name js_channel_4.'),
        ));
  });

  test(
      'updateJavascriptChannelsFromSet should clear all channels when null is supplied.',
      () {
    final JavascriptChannelRegistry registry =
        JavascriptChannelRegistry(channels);

    expect(registry.channels.length, 3);

    registry.updateJavascriptChannelsFromSet(null);

    expect(registry.channels, isEmpty);
  });

  test('updateJavascriptChannelsFromSet should update registry with new set.',
      () {
    final JavascriptChannelRegistry registry =
        JavascriptChannelRegistry(channels);

    expect(registry.channels.length, 3);

    final Set<JavascriptChannel> newChannels = <JavascriptChannel>{
      JavascriptChannel(
        name: 'new_js_channel_1',
        onMessageReceived: (JavascriptMessage message) =>
            log['new_js_channel_1'] = message.message,
      ),
      JavascriptChannel(
        name: 'new_js_channel_2',
        onMessageReceived: (JavascriptMessage message) =>
            log['new_js_channel_2'] = message.message,
      ),
    };

    registry.updateJavascriptChannelsFromSet(newChannels);

    expect(registry.channels.length, 2);
    for (final JavascriptChannel channel in newChannels) {
      expect(registry.channels[channel.name], channel);
    }
  });
}
