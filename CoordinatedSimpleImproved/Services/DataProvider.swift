//___FILEHEADER___

import Foundation
import UIKit
import Reachability
import PromiseKit

public class DataProvider {

    // MARK: - Properties
    let persistentStorage:PersistentStorage = PersistentStorage()
    let apiManager: APIManager = APIManager()
    let reachability = Reachability()!
    var onlineConnection = false
    
    init() {
        reachability.whenReachable = { reachability in
            if reachability.connection == .wifi {
                self.onlineConnection = true
            } else {
                self.onlineConnection = true
            }
        }
        
        reachability.whenUnreachable = { _ in
            self.onlineConnection = false
        }
        
        do {
            try reachability.startNotifier()
        } catch {
        }
    }
    
    func readAllUsers() -> Promise<[UserModel]>{
        if self.onlineConnection {
            return Promise { seal in
                self.apiManager.readUsers().done({ (users: [UserModel]) in
                    _ = self.persistentStorage.saveUsers(users: users)
                    seal.fulfill(users)
                }).catch({ (error: Error) in
                    seal.reject(error)
                })
            }
        } else {
            return self.persistentStorage.readUsers()
        }
    }
    
    func readAllTodos() -> Promise <[ToDoModel]> {
        if self.onlineConnection {
            return Promise { seal in
                self.apiManager.readTodos().done({ (todos: [ToDoModel]) in
                    _ = self.persistentStorage.saveTodos(todos: todos)
                    seal.fulfill(todos)
                }).catch({ (error: Error) in
                    seal.reject(error)
                })
            }
        } else {
            return self.persistentStorage.readTodos()
        }
    }
    
    func readTodos(from userId: Int) -> Promise <[ToDoModel]> {
        if self.onlineConnection {
            return Promise { seal in
                self.apiManager.readTodos(from: userId).done({ (todos: [ToDoModel]) in
                    _ = self.persistentStorage.saveTodos(todos: todos)
                    seal.fulfill(todos)
                }).catch({ (error: Error) in
                    seal.reject(error)
                })
            }
        } else {
            return self.persistentStorage.readTodos(from: userId)
        }
    }
    
    func prefetchUIImage(imageLink: String){
        // 1. Save image
    }
    
    func getUIImage(from photo: PhotoModel) -> Promise<UIImage> {
        return Promise { resolve in
            self.persistentStorage.hasPhoto(photo: photo).done({ (hasUIImg: Bool) in
                if hasUIImg {
                    self.persistentStorage.getPhoto(photo: photo).done({ (result: UIImage) in
                        resolve.fulfill(result)
                    }).catch({ (error: Error) in
                        self.apiManager.fetchUIImage(photo: photo).done({ (image: UIImage) in
                            self.persistentStorage.savePhoto(photo: photo, uiImage: image, uiImageThumbnail: image)
                            resolve.fulfill(image)
                        }).catch({ (error: Error) in
                            resolve.reject(error)
                        })
                    })
                } else {
                    self.apiManager.fetchUIImage(photo: photo).done({ (image: UIImage) in
                        self.persistentStorage.savePhoto(photo: photo, uiImage: image, uiImageThumbnail: image)
                        resolve.fulfill(image)
                    }).catch({ (error: Error) in
                        resolve.reject(error)
                    })
                }
            }) .catch({ (error: Error) in
                self.apiManager.fetchUIImage(photo: photo).done({ (image: UIImage) in
                    self.persistentStorage.savePhoto(photo: photo, uiImage: image, uiImageThumbnail: image)
                    resolve.fulfill(image)
                }).catch({ (error: Error) in
                    resolve.reject(error)
                })
            })
        }
    }
    
}
