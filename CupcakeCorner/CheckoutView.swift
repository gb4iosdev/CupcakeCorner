//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by Gavin Butler on 04-08-2020.
//  Copyright © 2020 Gavin Butler. All rights reserved.
//

import SwiftUI

struct CheckoutView: View {
    @ObservedObject var wrappedOrder: OrderWrapper
    @State private var confirmationMessage = ""
    @State private var showingConfirmation = false
    @State private var noWifi = false
    
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack {
                    Image("cupcakes")
                    .resizable()
                    .scaledToFit()
                        .frame(width: geo.size.width)
                    
                    Text("Your total is: $\(self.wrappedOrder.order.cost, specifier: "%.2f")")
                        .font(.title)
                    Button("Place order") {
                        self.placeOrder()
                    }
                    .padding()
                }
            }
            
        }
        .navigationBarTitle("Check Out", displayMode: .inline)
            //Don't know how to get multiple alerts to work (repositioning to another view didn't work).  Testing is complicated by the fact that I can't simulate broken wifi (see "TestMultipleAlerts" view in this project for proof that this works.
//        .alert(isPresented: self.$noWifi) {
//            Alert(title: Text("No Wifi"), message: Text(self.confirmationMessage), dismissButton: .default(Text("OK")))
//        }
        .alert(isPresented: self.$showingConfirmation) {
            Alert(title: Text("Thankyou"), message: Text(self.confirmationMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    func placeOrder() {
        guard let encoded = try? JSONEncoder().encode(wrappedOrder.order) else {
            print("Failed to encode order")
            return
        }
        
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encoded
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                //self.noWifi = true
                //self.confirmationMessage = "Unable to connect to Wifi"
                return
            }
            
            if let decodedOrder = try? JSONDecoder().decode(Order.self, from: data) {
                self.confirmationMessage = "Your order for \(decodedOrder.quantity) \(Order.types[decodedOrder.type].lowercased()) cupcakes is on its way"
                self.showingConfirmation = true
            } else {
                print("Invalid response from server")
            }
        }.resume()
        
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView(wrappedOrder: OrderWrapper())
    }
}
