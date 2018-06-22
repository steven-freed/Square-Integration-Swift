//
//  PaymentMethod.swift
//  square-integration
//
//  Created by steven freed on 6/22/18.
//  Copyright © 2018 steven freed. All rights reserved.
//

import Foundation

class PaymentMethod
{
    var _id: String?
    var _brand: String?
    var _last4: String?
    
    init(brand: String?, last4: String?, id: String?) {
        self._id = id
        self._brand = brand
        self._last4 = last4
    }
}
