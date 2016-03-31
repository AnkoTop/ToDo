//
//  KeychainAccessible.swift
//  ToDo
//
//  Created by Anko Top on 30/03/16.
//  Copyright © 2016 Anko Top. All rights reserved.
//

import Foundation

protocol KeychainAccessible {
    func setPassword(password: String,
                     account: String)
    
    func deletePasswortForAccount(account: String)
    
    func passwordForAccount(account: String) -> String?
}

