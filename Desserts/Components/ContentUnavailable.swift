//
//  ContentUnavailable.swift
//  Desserts
//
//  Created by Sameer Mungole on 3/20/24.
//

import SwiftUI

struct ContentUnavailable: View {
    let image: String
    let title: String
    let message: LocalizedStringKey
    let retryAction: () -> Void
    
    var body: some View {
        ContentUnavailableView {
            VStack {
                Image(image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                
                Text(title)
                    .font(.title)
                
                (Text(message) + Text("**Tap to retry!**"))
                    .font(.callout)
            }
        }
        .onTapGesture(perform: retryAction)
    }
}

#Preview {
    ContentUnavailable(
        image: "DessertsUnavailable",
        title: "Unavailable at the moment",
        message: "**[themealdb](https://themealdb.com/api/json/v1/1/filter.php?c=Dessert)** returned either empty or invalid data."
    ) {
        // Do nothing
    }
}
