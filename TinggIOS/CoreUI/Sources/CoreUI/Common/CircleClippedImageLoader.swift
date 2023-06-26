//
//  ImageLoader.swift
//  
//
//  Created by Abdulrasaq on 21/06/2023.
//

import SwiftUI

public struct CircleClippedImageLoader: View {
    var imageUrl = ""
    var size: CGSize
    public init(imageUrl: String = "https://mula.co.ke/mula_ke/api/v1/images/icons/utilities.png", size: CGSize = CGSize(width: 40, height: 40)) {
        self.imageUrl = imageUrl
        self.size = size
    }
    public var body: some View {
        AsyncImage(url: URL(string: imageUrl)) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(.black)
            case .failure(_):
                Image(systemName: "photo")
                    .foregroundColor(.black)
            case .empty:
                Color.clear
            @unknown default:
                Color.clear
            }
        }
        .frame(width: size.width,
               height: size.height,
               alignment: .center)
        
        
    }
}

struct CircleClippedImageLoader_Previews: PreviewProvider {
    static var previews: some View {
        CircleClippedImageLoader()
    }
}
