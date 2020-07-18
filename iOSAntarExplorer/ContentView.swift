//
//  ContentView.swift
//  iOSAntarExplorer
//
//  Created by Anthony Da Cruz on 26/06/2020.
//

import SwiftUI
import URLImage

struct ContentView: View {
    @EnvironmentObject var appState: AppData
    
    @State var showDetail: Bool = false
    
    @State var isFilterOpen = false
    
    var columns = [
        GridItem(.adaptive(minimum: 250), spacing: 0)
    ]

    var body: some View {
            VStack(alignment: .leading) {
            HStack {
                Text("Antar Receipt Explorer")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                Spacer()
                Button(action: {
                    isFilterOpen.toggle()
                }) {
                    Image(systemName: "line.horizontal.3.decrease.circle")
                    Text("Filters")
                }.popover(isPresented: $isFilterOpen) {
                    Inspector(selectedCompany: appState.filters.company)
                        .frame(width: 450, height: 500, alignment: .center)
                        .environmentObject(appState)
                }
            }.padding()
            if(!appState.filters.isEmpty()) {
                ActiveFiltersView(filters: appState.filters)
            }
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: 0) {
                    if(appState.isLoading){
                        ProgressView(value: 0.5).progressViewStyle(CircularProgressViewStyle())
                    } else {
                        ForEach(appState.loadedDocuments, id: \.identifier) { document in
                            ReceiptCell(receipt: document)
                                .cornerRadius(10)
                                .aspectRatio(1, contentMode: .fit)
                                .padding(.all, 10)
                                .onTapGesture {
                                    showDetail = true
                                }.sheet(isPresented: $showDetail) {
                                    ReceiptDetail(receipt: document)
                                }
                            }
                    }
                }.padding(.all, 10)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(AppData())
        
    }
}

struct SampleRow: View {
    let id: Int

    var body: some View {
        Text("Row \(id)")
    }

    init(id: Int) {
        print("Loading row \(id)")
        self.id = id
    }
}
