

//
//  UserDataModel.swift
//  ASTest
//
//  Created by Ashwini on 21/03/20.
//  Copyright © 2020 Ashwini. All rights reserved.
//

import Foundation

class DataModel
{
    var image:Data?
    var name:String?
    var email:String?
    var phone:String?
    
    init(image:Data? ,name:String? ,email:String? ,phone:String?)
    {
        self.image = image
        self.name = name
        self.email = email
        self.phone = phone
    }
}
