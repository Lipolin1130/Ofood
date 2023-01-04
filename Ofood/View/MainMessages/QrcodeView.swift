//
//  QrcodeView.swift
//  Ofood
//
//  Created by funghi on 2023/1/4.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct QrcodeView: View {
    @Binding var showQrcode: Bool
    var key: String
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    var body: some View {
        VStack (alignment: .center){
            HStack {
                Spacer()
                Button {
                    showQrcode.toggle()
                } label: {
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 23,height: 25)
                }
                .padding([.trailing, .top], 15)
            }
            Spacer()
            Image(uiImage: generateQRCode(from: key))
                .resizable()
                .interpolation(.none)
                .scaledToFit()
                .frame(width: 200, height: 200)
            Spacer()
        }
        .frame(width: 300, height: 350)
        .background(.black.opacity(0.15))
        .cornerRadius(20)
    }
    
    func generateQRCode(from string: String) -> UIImage {
        filter.message = Data(string.utf8)
        
        if let outputImage = filter.outputImage {
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgimg)
            }
        }
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
}

struct QrcodeView_Previews: PreviewProvider {
    static var previews: some View {
        QrcodeView(showQrcode: .constant(false), key: "Qrcode generate")
    }
}
