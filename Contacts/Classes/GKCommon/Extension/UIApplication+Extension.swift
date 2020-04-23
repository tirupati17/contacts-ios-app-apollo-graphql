//
//  UIApplication+Extension.swift
//  Contacts
//
//  Created by Tirupati Balan on 22/04/20.
//  Copyright © 2019 Tirupati Balan. All rights reserved.
//

import Foundation


extension UIApplication {
    
    class func showNetworkActivity() {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
    }
    
    class func hideNetworkActivity() {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
}
