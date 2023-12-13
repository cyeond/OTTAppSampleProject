//
//  Constants.swift
//  OTTAppSampleProject
//
//  Created by YD on 12/13/23.
//

struct Constants {
    static let DUMMY_ITEMS = Array(1...20).map { ContentData(title: "TITLE \($0)", subtitle: "SUBTITLE \($0)", imageUrl: "https://source.unsplash.com/user/c_v_r/100x100")}
    static let API_IMAGE_URL_PREFIX = "https://image.tmdb.org/t/p/w500"
    static let API_KEY = ""
}
