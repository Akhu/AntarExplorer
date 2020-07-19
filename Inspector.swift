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
    @State var specificFilters : String = ""
    
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
                    Label("Direction", systemImage: "arrow.up.arrow.down.circle.fill").foregroundColor(.gray)
                    Spacer()
                    Picker(selection: $sortDirection, label: Text("Direction")) {
                        ForEach(AGDocumentSortingDirection.allCases) { sort in
                            Text("\(String(describing: sort).capitalized)").tag(sort)
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                    
                    
                }
                Picker(selection: $sortProperty, label: Text("Property")) {
                    ForEach(AGDocumentSortingOption.allCases) { property in
                        Text("\(String(describing: property).capitalized)").tag(property)
                    }
                }
                
            }
                
            Section(
                header: Label("Custom Filters", systemImage: "square.and.pencil"),
                footer: Button(action: {
                    UIApplication.shared.open(URL(string: "https://doc.agoods.fr/v2/api/antar.html#documents_get")!)
                }) {
                    HStack {
                        Image(systemName: "info.circle")
                            .foregroundColor(.blue)
                        Text("Documentation")
                            .foregroundColor(.blue)
                            .underline()
                    }
                }
            ) {
                TextField("Custom Filters", text: $specificFilters)
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
                    HStack{
                        Image(systemName: "checkmark.circle")
                        Text("Done")
                            .padding(.all, 10)
                    }
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
            Inspector(selectedCompany: Company.aboutgoods).previewLayout(.device).environmentObject(AppData())
        }
    }
}
