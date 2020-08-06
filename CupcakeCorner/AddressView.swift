//
//  AddressView.swift
//  CupcakeCorner
//
//  Created by Gavin Butler on 04-08-2020.
//  Copyright © 2020 Gavin Butler. All rights reserved.
//

import SwiftUI

struct AddressView: View {
    @ObservedObject var wrappedOrder: OrderWrapper
    
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $wrappedOrder.order.name)
                TextField("Street Address", text: $wrappedOrder.order.streetAddress)
                TextField("City", text: $wrappedOrder.order.city)
                TextField("Zip", text: $wrappedOrder.order.zip)
            }
            Section {
                NavigationLink(destination: CheckoutView(wrappedOrder: wrappedOrder)) {
                    Text("Check out")
                }
            }
            .disabled(!wrappedOrder.order.hasValidAddress)
        }
        .navigationBarTitle("Delivery Details", displayMode: .inline)
    }
}

struct AddressView_Previews: PreviewProvider {
    static var previews: some View {
        AddressView(wrappedOrder: OrderWrapper())
    }
}
