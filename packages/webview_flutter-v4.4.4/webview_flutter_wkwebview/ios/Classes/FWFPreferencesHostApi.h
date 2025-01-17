// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#ifndef FWFPREFERENCESHOSTAPI_H
#define FWFPREFERENCESHOSTAPI_H

#import <Flutter/Flutter.h>
#import <WebKit/WebKit.h>

#import "FWFGeneratedWebKitApis.h"
#import "FWFInstanceManager.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Host api implementation for WKPreferences.
 *
 * Handles creating WKPreferences that intercommunicate with a paired Dart object.
 */
@interface FWFPreferencesHostApiImpl : NSObject <FWFWKPreferencesHostApi>
- (instancetype)initWithInstanceManager:(FWFInstanceManager *)instanceManager;
@end

NS_ASSUME_NONNULL_END

#endif // FWFPREFERENCESHOSTAPI_H
