//
//  PopupHandler.swift
//  CoordinatedSimpleImproved
//
//  Created by Seavus on 5/8/19.
//  Copyright © 2019 Seavus. All rights reserved.
//

import UIKit
import PopupDialog

class PopupHandler {

    // MARK: - Singleton Implementation
    private static var sharedClassReference: PopupHandler = {

        let classReference = PopupHandler()

        // Configuration
        // ...

        return classReference
    }()

    // MARK: - Singleton init
    private init() {

    }

    // MARK: - Singleton Accessors
    class func shared() -> PopupHandler {
        return sharedClassReference
    }

    // MARK: - Your class properties
    var activePopup: PopupDialog?
    
    // MARK: - Your functions
    func displayTODOsPopup(selectedUser: UserModel, totalTodos: Int, completedTodos: Int) -> PopupDialog {
        let title = "Number of TODOS"
        let message = "\(selectedUser.username!) has finished: \(completedTodos) todos out of the total: \(totalTodos)"
        self.activePopup = PopupDialog(title: title, message: message)
        
        let okButton = DefaultButton(title: "OK", dismissOnTap: true) {
            print("PopupHandler -> displayTODOsPopup: Hi!")
        }
        
        self.activePopup?.addButton(okButton)
        return self.activePopup!
    }

}
