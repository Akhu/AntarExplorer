//
//  ReceiptCell.swift
//  AntarExplorer
//
//  Created by Anthony Da Cruz on 28/06/2020.
//

import SwiftUI
import URLImage

struct ReceiptCell: View {
    var receipt: AGDocument
    @EnvironmentObject var appData: AppData
    
    var body: some View {
        VStack {
                AsyncImage(urlRequest:
                            buildUrlRequestWithBasicAuth(
                                username: imgProxyUsername,
                                password: imgProxyPassword,
                                url: buildImgProxyUrl(
                                    withImageUrl: URL(string: receipt.imageUrl)!,
                                    width: 250,
                                    height: 600)!
                            )
                )
                .aspectRatio(contentMode: .fill)
        }
        .transition(.slide)
        .buttonStyle(PlainButtonStyle())
        .overlay(
            ZStack {
                VStack(alignment: .leading,spacing: 6) {
                    Text(receipt.companyUid.capitalized)
                        .font(.headline)
                        .foregroundColor(.white)
                    Text(receipt.identifier)
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
                .padding(.all, 10)
            },alignment: .bottom)
    }
}

struct ReceiptCell_Previews: PreviewProvider {
    static var previews: some View {
        ReceiptCell(receipt: AppData().mockDocument)
            .frame(width: 350, height: 400, alignment: .center)
    }
}

struct InfoTag: View {
    let contentText: String
    let color : Color
    var body: some View {
        HStack {
            Text(contentText)
                .foregroundColor(.white)
                .padding(.all, 4)
                .background(color)
                .cornerRadius(6)
        }
    }
}
