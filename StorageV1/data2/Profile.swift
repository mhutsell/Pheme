//
//  Profile.swift
//  StorageV1
//
//  Created by Ray Chen on 11/22/21.
//

import Foundation

class Profile: ObservableObject {
    @Published(persistingTo: "Profile/identity.json") var idtt: Identity2 = Identity2()
}
