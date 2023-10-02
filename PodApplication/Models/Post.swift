//
//  Post.swift
//  PodApplication
//
//  Created by rosen on 02/10/2023.
//

import Foundation

struct Post: Decodable, Hashable {
    var title: String
    
    // Implement Hashable protocol
       func hash(into hasher: inout Hasher) {
           hasher.combine(title)
           // You can combine other properties here if needed
       }

       static func == (lhs: Post, rhs: Post) -> Bool {
           return lhs.title == rhs.title
           // Compare other properties here if needed
       }
}


#if DEBUG
extension Post {
    static var data = [
        
        Post(title: "Hello world1!!!!"),
        Post(title: "Hello world!!!!"),
        Post(title: "Hello world2!!!!"),
        Post(title: "Hello world3!!!!")
        
        
        
    ]
}
#endif
