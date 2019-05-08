//___FILEHEADER___

import Foundation
import PromiseKit

// TIP: Make this class a protocol so it is easier to change the types of persistent storage that you might need
class PersistentStorage {
    
    // MARK: - Properties
    
    // MARK: - Functions
    
    // MARK: - Users Model
    func readUsers() -> Promise<[UserModel]> {
        return Promise { seal in
            do {
                let data = try Data(contentsOf: self.getUsersDataURL())
                do {
                    let products = try JSONDecoder().decode([UserModel].self, from: data)
                    seal.fulfill(products)
                } catch let error {
                    seal.reject(error)
                }
            } catch let err {
                seal.reject(err)
            }
        }
    }
    
    func saveUsers(users: [UserModel]) -> Promise<Bool> {
        return Promise { seal in
            do {
                let archiveData = try JSONEncoder().encode(users)
                try archiveData.write(to: self.getUsersDataURL())
                seal.fulfill(true)
            } catch let err {
                seal.reject(err)
            }
        }
    }
    
    // MARK: - TODO Model
    func readTodos() -> Promise<[ToDoModel]> {
        return Promise { seal in
            do {
                let data = try Data(contentsOf: self.getTODOsDataURL())
                do {
                    let products = try JSONDecoder().decode([ToDoModel].self, from: data)
                    seal.fulfill(products)
                } catch let error {
                    seal.reject(error)
                }
            } catch let err {
                seal.reject(err)
            }
        }
    }
    
    func saveTodos(todos: [ToDoModel]) -> Promise<Bool> {
        return Promise { seal in
            do {
                let archiveData = try JSONEncoder().encode(todos)
                try archiveData.write(to: self.getTODOsDataURL())
                seal.fulfill(true)
            } catch let err {
                seal.reject(err)
            }
        }
    }
    
    func readTodos(from userId: Int) -> Promise<[ToDoModel]> {
        return Promise { seal in
            do {
                let data = try Data(contentsOf: self.getTODOsDataURL())
                do {
                    var products = try JSONDecoder().decode([ToDoModel].self, from: data)
                    products.removeAll(where: { (model: ToDoModel) -> Bool in
                        return model.userId != userId
                    })
                    seal.fulfill(products)
                } catch let error {
                    seal.reject(error)
                }
            } catch let err {
                seal.reject(err)
            }
        }
    }
    
    
    // MARK: - Local URLs
    func getUsersDataURL() -> URL {
        let path = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        
        var documentsDirectoryURL = path.appendingPathComponent("usersData")
        if !FileManager.default.fileExists(atPath: documentsDirectoryURL.path) {
            _ = try? FileManager.default.createDirectory(at: documentsDirectoryURL, withIntermediateDirectories: true, attributes: nil)
        }
        
        documentsDirectoryURL = path.appendingPathComponent("usersModelArray.usermodel")
        if !FileManager.default.fileExists(atPath: documentsDirectoryURL.path) {
            FileManager.default.createFile(atPath: documentsDirectoryURL.path, contents: nil, attributes: nil)
            do {
                let array = [UserModel]()
                let archiveData = try JSONEncoder().encode(array)
                try archiveData.write(to: documentsDirectoryURL)
            } catch let error {
                print(error)
            }
        }
        
        return documentsDirectoryURL
    }
    
    func getTODOsDataURL() -> URL {
        let path = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        
        var documentsDirectoryURL = path.appendingPathComponent("todosData")
        if !FileManager.default.fileExists(atPath: documentsDirectoryURL.path) {
            _ = try? FileManager.default.createDirectory(at: documentsDirectoryURL, withIntermediateDirectories: true, attributes: nil)
        }
        
        documentsDirectoryURL = path.appendingPathComponent("todosModelArray.todomodel")
        if !FileManager.default.fileExists(atPath: documentsDirectoryURL.path) {
            FileManager.default.createFile(atPath: documentsDirectoryURL.path, contents: nil, attributes: nil)
            do {
                let elems = [ToDoModel]()
                let archiveData = try JSONEncoder().encode(elems)
                try archiveData.write(to: documentsDirectoryURL)
            } catch let error {
                print(error)
            }
        }
        
        return documentsDirectoryURL
    }
    
}
