//
//  GKContactListProtocol.swift
//  Contacts
//
//  Created by Tirupati Balan on 22/04/20.
//  Copyright © 2019 Tirupati Balan. All rights reserved.
//


protocol GKContactListViewProtocol : UIViewControllerProtocol {
    func updateContactList(_ contacts : [Contact])
    func updateFavouriteStatus()
}

protocol GKContactListPresenterProtocol {
    func didDeleteContact(contact : Contact)
    func didSelectContact(contact : Contact)
    func didUpdateFavourite(forContact : Contact)
    func didFetchContacts()
}
