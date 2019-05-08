//
//  UsersDisplayCoordinator.swift
//  CoordinatedSimpleImproved
//
//  Created by Seavus on 5/8/19.
//  Copyright © 2019 Seavus. All rights reserved.
//

import Foundation
import UIKit
import PromiseKit

class UsersDisplayCoordinator:NSObject, Coordinator {

    // MARK: - Class properties
    lazy var dataProvider = { () -> DataProvider in
        if let parent = self.parentCoordinator {
            return parent.getDataProvider()
        } else {
            return DataProvider()
        }
    }()

    weak var parentCoordinator: Coordinator?
    weak var viewController: UsersDisplayViewController!

    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    // MARK: - Initialization
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    // MARK: - Protocol implementation
    func start(){
        self.navigationController.delegate = self // This line is a must do not remove
        self.viewController = UsersDisplayViewController.instantiate()
        self.viewController.coordinator = self
        self.navigationController.pushViewController(self.viewController, animated: true)
    }

    func childPop(_ child: Coordinator?){
        self.navigationController.delegate = self // This line is a must do not remove

        // Do coordinator parsing //
        if let todoDisplayCoordinator = child as? TODODsiplayCoordinator, let user = todoDisplayCoordinator.selectedUser {
            if todoDisplayCoordinator.numberOfTodos != 0 {
                let popup = PopupHandler.shared().displayTODOsPopup(selectedUser: user, totalTodos: todoDisplayCoordinator.numberOfTodos, completedTodos: todoDisplayCoordinator.numberOfFinishedTodos)
                self.viewController.presentPopups(popup: popup)
            }
        }
        // ////////////////////// //

        // Default code used for removing of child coordinators // TODO: refactor it
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }

    internal func getDataProvider() -> DataProvider {
        return self.dataProvider
    }

    // MARK: - Transition functions
    // These are the functions that can be called by the view controller as well

    func transitionBack(){
        self.navigationController.popViewController(animated: true)
    }
    
    func transitionToDoDisplay(){
        let child = TODODsiplayCoordinator(navigationController: navigationController)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start()
    }
    
    func transitionToDoDisplay(selectedUser:UserModel){
        let child = TODODsiplayCoordinator(navigationController: navigationController)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.selectedUser = selectedUser
        child.start()
    }

    
    
    // MARK: - Logic functions
    // These are the functions that may be called by the viewcontroller. Example: Request for data, update data, etc.
    
    func getUsersList() -> Promise<[UserModel]>{
        return self.dataProvider.readAllUsers()
    }

    // MARK: - Others


    /* ************************************************************* */
    // Sadly I don't know how to put this code into the protocol :( //
    /* ************************************************************* */

    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        // Read the view controller we’re moving from.
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            return
        }

        // Check whether our view controller array already contains that view controller. If it does it means we’re pushing a different view controller on top rather than popping it, so exit.
        if navigationController.viewControllers.contains(fromViewController) {
            return
        }

        if let parent = self.parentCoordinator {
            parent.childPop(self)
        }
    }
}
