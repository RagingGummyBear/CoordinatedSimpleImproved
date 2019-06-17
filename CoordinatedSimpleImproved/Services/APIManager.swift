//___FILEHEADER___

import Foundation
import UIKit
import PromiseKit

class APIManager {
    // MARK: - Properties

    // MARK: - Functions
    
    // MARK: - Users Model
    func readUsers() -> Promise<[UserModel]>{
        return Promise { seal in
            firstly {
                URLSession.shared.dataTask(.promise, with: try self.createAllUsersUrlRequest()).validate()
                }.map {
                    try JSONDecoder().decode([UserModel].self, from: $0.data)
                }.done { result in
                    seal.fulfill(result)
                }.catch { error in
                    seal.reject(error)
            }
        }
    }
    
    // MARK: - TODO Model
    func readTodos() -> Promise<[ToDoModel]> {
        return Promise { seal in
            firstly {
                URLSession.shared.dataTask(.promise, with: try self.createReadAllToDos()).validate()
                }.map {
                    try JSONDecoder().decode([ToDoModel].self, from: $0.data)
                }.done { result in
                    seal.fulfill(result)
                }.catch { error in
                    seal.reject(error)
            }
        }
    }
    
    func readTodos(from userId: Int) -> Promise<[ToDoModel]> {
        return Promise { seal in
            firstly {
                URLSession.shared.dataTask(.promise, with: try self.createReadToDoFromUserIdRequest(from: userId)).validate()
                }.map {
                    try JSONDecoder().decode([ToDoModel].self, from: $0.data)
                }.done { result in
                    seal.fulfill(result)
                }.catch { error in
                    seal.reject(error)
            }
        }
    }
    
    // MARK: - Urls Creation
    private func createReadAllToDos() throws -> URLRequest {
        let urlString = "https://jsonplaceholder.typicode.com/todos"
        let url = URL(string: urlString)!
        var rq = URLRequest(url: url)
        return self.prepareGetRequest(request: &rq)
    }
    
    private func createAllUsersUrlRequest() throws -> URLRequest {
        let urlString = "https://jsonplaceholder.typicode.com/users"
        let url = URL(string: urlString)!
        var rq = URLRequest(url: url)
        return self.prepareGetRequest(request: &rq)
    }
    
    private func createReadToDoFromUserIdRequest(from userId: Int) throws -> URLRequest {
        let urlString = "https://jsonplaceholder.typicode.com/todos?userId=\(userId)"
        let url = URL(string: urlString)!
        var rq = URLRequest(url: url)
        return self.prepareGetRequest(request: &rq)
    }
    
    private func prepareGetRequest(request: inout URLRequest) -> URLRequest {
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
    
    // MARK - Other
    func fetchUIImage(photo: PhotoModel) -> Promise<UIImage> {
        return Promise { resolve in
            DispatchQueue.global(qos: .background).async {
                do {
                    let data = try Data( contentsOf: URL(string: photo.url)!)
                    resolve.fulfill(UIImage(data: data)!)
                } catch let error {
                    resolve.reject(error)
                }
            }
        }
    }
    
}
