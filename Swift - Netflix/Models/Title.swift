//
//  Movie.swift
//  Swift - Netflix
//
//  Created by 王杰 on 2022/6/20.
//

import Foundation

struct TrendingTitleResponse: Codable {
    let results: [Title]
}

struct Title: Codable {
//    let id: Int
    let original_title: String?
    let poster_path: String?
    let overview: String?
}

/*
 {
adult = 0;
"backdrop_path" = "/9n5e1vToDVnqz3hW10Jdlvmzpo0.jpg";
"genre_ids" =             (
 28,
 18
);
id = 361743;
"media_type" = movie;
"original_language" = en;
"original_title" = "Top Gun: Maverick";
overview = "After more than thirty years of service as one of the Navy\U2019s top aviators, and dodging the advancement in rank that would ground him, Pete \U201cMaverick\U201d Mitchell finds himself training a detachment of TOP GUN graduates for a specialized mission the likes of which no living pilot has ever seen.";
popularity = "2496.396";
"poster_path" = "/62HCnUTziyWcpDaBO2i1DX17ljH.jpg";
"release_date" = "2022-05-24";
title = "Top Gun: Maverick";
video = 0;
"vote_average" = "8.366";
"vote_count" = 3180;
},
 */


// 1
