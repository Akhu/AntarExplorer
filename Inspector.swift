//
//  Inspector.swift
//  AntarExplorer
//
//  Created by Anthony Da Cruz on 30/06/2020.
//

import SwiftUI

struct Inspector: View {

    @EnvironmentObject var appState : AppData
    
    @State var selectedCompany : Company
    @State var itemPerPage = 20
    @State var sortDirection : AGDocumentSortingDirection = .descending
    @State var sortProperty : AGDocumentSortingOption = .createdAt
    
    var body: some View {
        NavigationView {
            Form {
                    Section(header: Text("Company")) {
                        Picker(selection: $selectedCompany, label: Text("Company")) {
                            ForEach(AntarFilters.companies) { company in
                                Text("\(String(describing: company).capitalized)").tag(company)
                            }
                        }
                    }.navigationTitle("Filters")
            
            Section(header: Text("Sort and Page")) {
                Stepper(value: $itemPerPage, in: 10 ... 50) {
                    Label("Items per page", systemImage: "number.circle.fill")
                        .foregroundColor(.gray)
                    Spacer()
                    Text("\(itemPerPage)")
                        .bold()
                }
                HStack {
                    Label("Sort direction", systemImage: "arrow.up.arrow.down.circle.fill").foregroundColor(.gray)
                    Spacer()
                    Picker(selection: $sortDirection, label: Text("Sort direction")) {
                        ForEach(AGDocumentSortingDirection.allCases) { sort in
                            Text("\(String(describing: sort).capitalized)").tag(sort)
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                }
                
            }
            
            Section {
                Button(action: {
                    let newFilters = appState.filters
                    newFilters.company = selectedCompany
                    newFilters.itemPerPage = itemPerPage
                    newFilters.sortDirection = sortDirection
                    newFilters.sortProperty = sortProperty
                    appState.setFilters(newFilters)
                }) {
                    Image(systemName: "floppy")
                    Text("Done")
                        .padding(.all, 10)                        
                }
            }
                
            }
        }
    }
}

struct Inspector_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Inspector(selectedCompany: Company.aboutgoods).environmentObject(AppData())
            Inspector(selectedCompany: Company.aboutgoods).environmentObject(AppData())
        }
    }
}
