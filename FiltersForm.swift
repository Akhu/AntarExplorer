//
//  FiltersForm.swift
//  AntarExplorer
//
//  Created by Anthony Da Cruz on 16/07/2020.
//

import SwiftUI

struct FiltersForm: View {
    @State private var selectedColor = 0
    @State private var colors = ["Red", "Green", "Blue"]

    
    var body: some View {
        Form {
            Section(header: Text("Filters")){
                Picker(selection: $selectedColor, label: Text("Select a company")) {
                    ForEach(0 ..< colors.count) {
                        Text(self.colors[$0]).tag($0)
                    }
                }.pickerStyle(WheelPickerStyle())
            }
        }
    }
}

struct FiltersForm_Previews: PreviewProvider {
    static var previews: some View {
        FiltersForm()
    }
}
