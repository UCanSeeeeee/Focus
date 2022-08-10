//
//  YoutubeSearchResponse.swift
//  Swift - Netflix
//
//  Created by 王杰 on 2022/6/20.
//

import Foundation

struct YoutubeSearchResponse: Codable {
    let items: [VideoElement]
}

struct VideoElement: Codable {
    let id: IdVideoElement
}

struct IdVideoElement: Codable {
    let kind: String
    let videoId: String
}
