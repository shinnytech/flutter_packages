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

import '../types/javascript_channel.dart';
import '../types/javascript_message.dart';

/// Utility class for managing named JavaScript channels and forwarding incoming
/// messages on the correct channel.
class JavascriptChannelRegistry {
  /// Constructs a [JavascriptChannelRegistry] initializing it with the given
  /// set of [JavascriptChannel]s.
  JavascriptChannelRegistry(Set<JavascriptChannel>? channels) {
    updateJavascriptChannelsFromSet(channels);
  }

  /// Maps a channel name to a channel.
  final Map<String, JavascriptChannel> channels = <String, JavascriptChannel>{};

  /// Invoked when a JavaScript channel message is received.
  void onJavascriptChannelMessage(String channel, String message) {
    final JavascriptChannel? javascriptChannel = channels[channel];

    if (javascriptChannel == null) {
      throw ArgumentError('No channel registered with name $channel.');
    }

    javascriptChannel.onMessageReceived(JavascriptMessage(message));
  }

  /// Updates the set of [JavascriptChannel]s with the new set.
  void updateJavascriptChannelsFromSet(Set<JavascriptChannel>? channels) {
    this.channels.clear();
    if (channels == null) {
      return;
    }

    for (final JavascriptChannel channel in channels) {
      this.channels[channel.name] = channel;
    }
  }
}
