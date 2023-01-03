//
//  ImageLoadingView.swift
//  Ofood
//
//  Created by funghi on 2023/1/3.
//

import SwiftUI

struct ImageLoadingView: View {
    @StateObject var imageLoader: ImageLoader
    
    init(url: String?) {
        self._imageLoader = StateObject(wrappedValue: ImageLoader(url: url!))
    }
    
    var body: some View {
        Group {
            if imageLoader.image != nil {
                Image(uiImage: imageLoader.image!)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 128, height: 128)
                    .cornerRadius(64)
                
            } else if imageLoader.erroerMessage != nil {
                Text(imageLoader.erroerMessage!)
                    .foregroundColor(Color.red)
            } else {
                ProgressView()
            }
        }
        .frame(width: 140, height: 140)
        .cornerRadius(5)
        .padding(5)
        .onAppear{
            imageLoader.fetch()
        }
    }
}

struct ImageLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        ImageLoadingView(url: nil)
    }
}
