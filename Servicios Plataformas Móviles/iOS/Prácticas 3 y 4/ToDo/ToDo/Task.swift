//
//  Task.swift
//  ToDo
//
//  Created by Yaser  on 8/3/21.
//

import Foundation
import CloudKit

class Task {
    private let id: CKRecord.ID
    private(set) var nombre: String?
    
    init(record: CKRecord) {
        id = record.recordID
        nombre = record["nombre"] as? String
    }
    
    static func savePrivateTask(task: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        let container = CKContainer.default()
        let record = CKRecord(recordType: "Tarea")
        record.setValue(task, forKey: "nombre")
                
        container.privateCloudDatabase.save(record) { result, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            DispatchQueue.main.async {
                completion(.success("Success private: \(Task.init(record: result!))"))
            }
        }
    }
    
    static func savePublicTask(task: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        let container = CKContainer.default()
        let record = CKRecord(recordType: "Tarea")
        record.setValue(task, forKey: "nombre")
                
        container.publicCloudDatabase.save(record) { result, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            DispatchQueue.main.async {
                completion(.success("Success public: \(Task.init(record: result!))"))
            }
        }
    }
    
    static func deleteTask(taskName: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        let container = CKContainer.default()
        let query = CKQuery(recordType: "Tarea", predicate: NSPredicate(format: "nombre == %@", taskName))
        container.privateCloudDatabase.perform(query, inZoneWith: nil) { result, error in
            if let error = error {
                DispatchQueue.main.async {
                    print(error)
                    completion(.failure(error))
                }
                return
            }
                       
            guard let result = result else {
                DispatchQueue.main.async {
                    let error = NSError(
                        domain: "es.ua.mastermoviles", code: -1, userInfo: [NSLocalizedDescriptionKey: ["Could not download tasks"]]
                    )
                    completion(.failure(error))
                }
                return
            }
            let task = Task.init(record: result[0])
            container.privateCloudDatabase.delete(withRecordID: task.id) { result, error in
                if let error = error {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                    return
                }
                DispatchQueue.main.async {
                    completion(.success("Success: \(String(describing: result)) deleted"))
                }
            }
        }
    }
    
    static func fetchPrivateTasks(_ completion: @escaping (Result<[Task], Error>) -> Void) {
        let query = CKQuery(recordType: "Tarea", predicate: NSPredicate(value: true))
        let container = CKContainer.default()
        
        container.privateCloudDatabase.perform(query, inZoneWith: nil) { results, error in
            if let error = error {
                DispatchQueue.main.async {
                    print(error)
                    completion(.failure(error))
                }
                return
            }
            
            guard let results = results else {
                DispatchQueue.main.async {
                    let error = NSError(
                        domain: "es.ua.mastermoviles", code: -1, userInfo: [NSLocalizedDescriptionKey: ["Could not download tasks"]]
                    )
                    completion(.failure(error))
                }
                return
            }
            let tasks = results.map(Task.init)
            DispatchQueue.main.async {
                completion(.success(tasks))
            }
        }
    }
    
    static func fetchPublicTasks(_ completion: @escaping (Result<[Task], Error>) -> Void) {
        let query = CKQuery(recordType: "Tarea", predicate: NSPredicate(value: true))
        let container = CKContainer.default()
        
        container.publicCloudDatabase.perform(query, inZoneWith: nil) { results, error in
            if let error = error {
                DispatchQueue.main.async {
                    print(error)
                    completion(.failure(error))
                }
                return
            }
            
            guard let results = results else {
                DispatchQueue.main.async {
                    let error = NSError(
                        domain: "es.ua.mastermoviles", code: -1, userInfo: [NSLocalizedDescriptionKey: ["Could not download tasks"]]
                    )
                    completion(.failure(error))
                }
                return
            }
            let tasks = results.map(Task.init)
            DispatchQueue.main.async {
                completion(.success(tasks))
            }
        }
    }
}
