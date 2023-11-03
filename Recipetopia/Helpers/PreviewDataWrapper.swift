//
//  PreviewDataWrapper.swift
//  Recipetopia
//
//  Created by Dominique Miller on 11/2/23.
//

import SwiftUI

// Decode json data and make availble to previews
// Only to be used for previews
struct PreviewDataWrapper<T: Decodable, Content: View>: View {
    let content: (T) -> Content
    var filename: String
    
    var body: some View {
        let url = Bundle.main.url(forResource: filename, withExtension: "json")!
        let jsonData = try! Data(contentsOf: url)
        let decoder = JSONDecoder()
        let sampleData = try! decoder.decode(T.self, from: jsonData)
        
        return self.content(sampleData)
    }
    
    init(filename: String, model: T.Type, @ViewBuilder content: @escaping (T) -> Content) {
        self.content = content
        self.filename = filename
    }
}
