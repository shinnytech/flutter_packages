# Copyright (c) 2024 Hunan OpenValley Digital Industry Development Co., Ltd.
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

@import XCTest;
@import os.log;

static UIColor *getPixelColorInImage(CGImageRef image, size_t x, size_t y) {
  CFDataRef pixelData = CGDataProviderCopyData(CGImageGetDataProvider(image));
  const UInt8 *data = CFDataGetBytePtr(pixelData);

  size_t bytesPerRow = CGImageGetBytesPerRow(image);
  size_t pixelInfo = (bytesPerRow * y) + (x * 4);  // 4 bytes per pixel

  UInt8 red = data[pixelInfo + 0];
  UInt8 green = data[pixelInfo + 1];
  UInt8 blue = data[pixelInfo + 2];
  UInt8 alpha = data[pixelInfo + 3];
  CFRelease(pixelData);

  return [UIColor colorWithRed:red / 255.0f
                         green:green / 255.0f
                          blue:blue / 255.0f
                         alpha:alpha / 255.0f];
}

@interface FLTWebViewUITests : XCTestCase
@property(nonatomic, strong) XCUIApplication *app;
@end

@implementation FLTWebViewUITests

- (void)setUp {
  self.continueAfterFailure = NO;

  self.app = [[XCUIApplication alloc] init];
  [self.app launch];
}

- (void)testTransparentBackground {
  XCTSkip(@"Test is flaky. See https://github.com/flutter/flutter/issues/124156");

  XCUIApplication *app = self.app;
  XCUIElement *menu = app.buttons[@"Show menu"];
  if (![menu waitForExistenceWithTimeout:30.0]) {
    os_log_error(OS_LOG_DEFAULT, "%@", app.debugDescription);
    XCTFail(@"Failed due to not able to find menu");
  }
  [menu tap];

  XCUIElement *transparentBackground = app.buttons[@"Transparent background example"];
  if (![transparentBackground waitForExistenceWithTimeout:30.0]) {
    os_log_error(OS_LOG_DEFAULT, "%@", app.debugDescription);
    XCTFail(@"Failed due to not able to find Transparent background example");
  }
  [transparentBackground tap];

  XCUIElement *transparentBackgroundLoaded =
      app.webViews.staticTexts[@"Transparent background test"];
  if (![transparentBackgroundLoaded waitForExistenceWithTimeout:30.0]) {
    os_log_error(OS_LOG_DEFAULT, "%@", app.debugDescription);
    XCTFail(@"Failed due to not able to find Transparent background test");
  }

  XCUIScreenshot *screenshot = [[XCUIScreen mainScreen] screenshot];

  UIImage *screenshotImage = screenshot.image;
  CGImageRef screenshotCGImage = screenshotImage.CGImage;
  UIColor *centerLeftColor =
      getPixelColorInImage(screenshotCGImage, 0, CGImageGetHeight(screenshotCGImage) / 2);
  UIColor *centerColor =
      getPixelColorInImage(screenshotCGImage, CGImageGetWidth(screenshotCGImage) / 2,
                           CGImageGetHeight(screenshotCGImage) / 2);

  CGColorSpaceRef centerLeftColorSpace = CGColorGetColorSpace(centerLeftColor.CGColor);
  // Flutter Colors.green color : 0xFF4CAF50 -> rgba(76, 175, 80, 1)
  // https://github.com/flutter/flutter/blob/f4abaa0735eba4dfd8f33f73363911d63931fe03/packages/flutter/lib/src/material/colors.dart#L1208
  // The background color of the webview is : rgba(0, 0, 0, 0.5)
  // The expected color is : rgba(38, 87, 40, 1)
  CGFloat flutterGreenColorComponents[] = {38.0f / 255.0f, 87.0f / 255.0f, 40.0f / 255.0f, 1.0f};
  CGColorRef flutterGreenColor = CGColorCreate(centerLeftColorSpace, flutterGreenColorComponents);
  CGFloat redColorComponents[] = {1.0f, 0.0f, 0.0f, 1.0f};
  CGColorRef redColor = CGColorCreate(centerLeftColorSpace, redColorComponents);
  CGColorSpaceRelease(centerLeftColorSpace);

  XCTAssertTrue(CGColorEqualToColor(flutterGreenColor, centerLeftColor.CGColor));
  XCTAssertTrue(CGColorEqualToColor(redColor, centerColor.CGColor));
}
@end
