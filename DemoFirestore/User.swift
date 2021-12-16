//
//  User.swift
//  DemoFirestore
//
//  Created by Kemal Ekren on 15.12.2021.
//

import Foundation

struct User {
    
    var uuid: String
    var username: String
    var profile_image : String
    var sharedPosts: [Post]
    var likedPosts: [Post]
}


struct Post {
    var uuid: String
    var images: [PostImage]
    var likedData: Int
    var location : [PlaceLocation]
    
}

struct PostImage {
    var uuid: String
    var image: String
}

struct PlaceLocation {
    var lat: String
    var long: String
    
}
