// Copyright (c) 2024 SwanLink (Jiangsu) Technology Development Co., LTD.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE_ODID file.

import { iap } from '@kit.IAPKit'
export const ProductType: Array<iap.ProductType> = [
  iap.ProductType.CONSUMABLE,
  iap.ProductType.NONCONSUMABLE,
  iap.ProductType.AUTORENEWABLE
]