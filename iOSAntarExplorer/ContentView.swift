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
                Text("\(appState.loadedDocuments.total) ")
                    .font(.system(size: 18, weight: .heavy, design: .rounded))
                    + Text("Total results")
                    .foregroundColor(.gray)
                    .bold()
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
                        .padding()
                }
                
            
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 0) {
                        if(appState.isLoading){
                            ProgressView(value: 0.5).progressViewStyle(CircularProgressViewStyle())
                        } else {
                            ForEach(appState.loadedDocuments.documents, id: \.identifier) { document in
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
                HStack {
                    Button(action: {
                        appState.loadPreviousPage()
                    }) {
                        Text("\(appState.filters.itemPerPage) previous items")
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                        .strokeBorder())
                    }
                    .disabled(appState.loadedDocuments.prevPageUri != nil ? true : false)
                    Spacer()
                    Text("Total pages ")
                    + Text("\(String(describing: appState.loadedDocuments.pages))")
                        .bold()
                    Spacer()
                        if appState.loadedDocuments.nextPageUri != nil && !appState.loadedDocuments.nextPageUri!.isEmpty {
                        Text("\(appState.filters.itemPerPage) next items")
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                            .strokeBorder())
                        }
                }.padding(.horizontal)
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(AppData())
        
    }
}
