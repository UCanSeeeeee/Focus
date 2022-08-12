//
//  DataPersistenceManager.swift
//  Swift - Netflix
//
//  Created by 王杰 on 2022/6/20.
//

import Foundation
import UIKit
import CoreData

enum DatabasError: Error {
    case failedToSaveData
    case failedToFetchData
    case failedToDeleteData
}

class DataPersistenceManager {
    
    static let shared = DataPersistenceManager()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //        let request: NSFetchRequest<TitleItem>
    //        let request = TitleItem.fetchRequest()
    /// 用于获取titles
    func fetchingTitlesFromDataBase(completion: @escaping (Result<[TitleItem], Error>) -> Void) {
        do {
            let titles = try context.fetch(TitleItem.fetchRequest())
            completion(.success(titles))
        } catch {
            completion(.failure(DatabasError.failedToFetchData))
        }
    }
    
    //        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
    //            return
    //        }
    //        let context = appDelegate.persistentContainer.viewContext
    func downloadTitleWith(model: Title, completion: @escaping (Result<Void, Error>) -> Void) {
        
        let item = TitleItem(context: context)
        
        item.original_title = model.original_title
        item.id = Int64(model.id)
        item.original_name = model.original_name
        item.overview = model.overview
        item.media_type = model.media_type
        item.poster_path = model.poster_path
        item.release_date = model.release_date
        item.vote_count = Int64(model.vote_count)
        item.vote_average = model.vote_average
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DatabasError.failedToSaveData))
        }
    }
    
    //        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
    //            return
    //        }
    //        let context = appDelegate.persistentContainer.viewContext
    func deleteTitleWith(model: TitleItem, completion: @escaping (Result<Void, Error>)-> Void) {
        context.delete(model)
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DatabasError.failedToDeleteData))
        }
    }
}
