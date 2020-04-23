//
//  UIViewController+Protocol.swift
//  Contacts
//
//  Created by Tirupati Balan on 22/04/20.
//  Copyright © 2019 Tirupati Balan. All rights reserved.
//

protocol UIViewControllerProtocol {
    func presentController<T>(_ vc: T)
    func pushController<T>(_ vc: T)
    func didFailedResponse<T>(_ error : T)
    func didSuccessfulResponse<T>(_ response : T)
}
