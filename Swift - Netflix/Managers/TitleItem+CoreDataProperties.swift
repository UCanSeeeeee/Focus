//
//  TitleItem+CoreDataProperties.swift
//  Swift - Netflix
//
//  Created by 王杰 on 2022/8/11.
//
//

import Foundation
import CoreData


extension TitleItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TitleItem> {
        return NSFetchRequest<TitleItem>(entityName: "TitleItem")
    }

    @NSManaged public var id: Int64
    @NSManaged public var original_title: String?
    @NSManaged public var overview: String?
    @NSManaged public var poster_path: String?

}

extension TitleItem : Identifiable {

}
