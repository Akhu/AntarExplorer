//
//  ActiveFiltersView.swift
//  AntarExplorer
//
//  Created by Anthony Da Cruz on 18/07/2020.
//

import SwiftUI

struct ActiveFiltersView: View {
    
    let filters : AntarFilters
    
    /**
     var company: Company = Company.none
     var itemPerPage: Int = 20
     var status: AGAnalysisStatus? = nil
     var sortDirection : AGDocumentSortingDirection = .descending
     var sortProperty : AGDocumentSortingOption = .createdAt
     var specificFilters : String? = nil
     */
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Active filters")
                .foregroundColor(.gray)
                .bold()
        ScrollView(.horizontal) {
            HStack {
                Text("\(String(describing: filters.company).capitalized)")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.all, 10)
                    .background(Color.blue)
                    .cornerRadius(8.0)
                
                Text("\(String(describing: filters.sortDirection)) order")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.all, 10)
                    .background(Color.pink)
                    .cornerRadius(8.0)
                
                Text("by \(String(describing: filters.sortProperty))")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.all, 10)
                    .background(Color.pink)
                    .cornerRadius(8.0)
                if filters.specificFilters != nil {
                Text("\(String(describing: filters.specificFilters))")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.all, 10)
                    .background(Color.yellow)
                    .cornerRadius(8.0)
                }
            }
        }.animation(.easeIn)
        }
    }
}

struct ActiveFiltersView_Previews: PreviewProvider {
    static var previews: some View {
        ActiveFiltersView(filters: AntarFilters())
    }
}
