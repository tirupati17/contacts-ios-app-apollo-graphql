//
//  GKConstant.swift
//  Contacts
//
//  Created by Tirupati Balan on 22/04/20.
//  Copyright © 2019 Tirupati Balan. All rights reserved.
//


class GKConstant {
    static var AppBundleName : String {
        return Bundle.main.infoDictionary!["CFBundleIdentifier"] as! String
    }
}
