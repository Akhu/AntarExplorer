//
//  ReceiptDetail.swift
//  AntarExplorer
//
//  Created by Anthony Da Cruz on 28/06/2020.
//

import SwiftUI

struct ReceiptDetail: View {
    @EnvironmentObject var appData: AppData
    let receipt: AGDocument
    
    var body: some View {
        
        Form {
            Section(header: Text("🧾 Overview")) {
                HStack(alignment: .top) {
                    Image("ReceiptPlaceholder")
                        .resizable()
                        .cornerRadius(9.0)
                        .frame(width: 150, height: 250)
                        .aspectRatio(contentMode: .fill)
                        .clipped()
                        .shadow(color: Color.black.opacity(0.2), radius: 3, y: 5)
                        .shadow(color: Color.black.opacity(0.1), radius: 10, y: 20)
                    VStack(alignment: .leading) {
                        Text(receipt.companyUid.capitalized)
                            .font(.largeTitle)
                        HStack {
                            Image(systemName: "grid.circle.fill")
                                .foregroundColor(.blue)
                            Text(receipt.identifier)
                            .font(.callout)
                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        }
                        HStack{
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text(AGAnalysisStatus.statusReasons[receipt.status]!)
                        }
                        
                    }
                }.padding([.top, .leading, .bottom])
            }
            Section(header: Text("⚡️ Actions")) {
                HStack {
                    Image(systemName: "link.circle.fill")
                        .foregroundColor(.blue)
                    Button("See it on Kweeri") {
                        //"https://receipt-manager.kweeri.io/#/promotions/\(receipt.identifier)/details"
                        let url = URL.init(string: "https://receipt-manager.kweeri.io/#/promotions/\(receipt.identifier)/details")
                                            guard let kweeriUrl = url, UIApplication.shared.canOpenURL(kweeriUrl) else { return }
                                            UIApplication.shared.open(kweeriUrl)
                    }
                }
            }
        }
    }
}

struct ReceiptDetail_Previews: PreviewProvider {
    static var previews: some View {
        ReceiptDetail(receipt: AppData().mockDocument)
            .environmentObject(AppData())
    }
}
