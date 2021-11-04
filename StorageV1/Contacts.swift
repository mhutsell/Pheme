//
//  Contacts.swift
//  StorageV1
//
//  Created by 龚晨 on 11/4/21.
//
import SwiftUI

import Foundation
struct Contacts: View {
 
    
    init() {
//        /* For iOS 15 */
//        if #available(iOS 15, *) {
//            UITableView.appearance().sectionHeaderTopPadding = 0
//        }
    }
    
    var body: some View {
        NavigationView {
            Text("HELLO!")
        }
            
    }
}

struct Contacts_Previews: PreviewProvider {
    static var previews: some View {
        Contacts()
    }
}
