//
//  Extension-View.swift
//  SwiftUITaskManagement
//
//  Created by Richard Price on 21/01/2022.
//

import SwiftUI
//step 6
extension View {
    
    func hLeading()-> some View {
        self
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func hTrailing()-> some View {
        self
            .frame(maxWidth: .infinity, alignment: .trailing)
    }
    
    func hCenter()-> some View {
        self
            .frame(maxWidth: .infinity, alignment: .center)
    }
    
    //step 31 create a safeArea checker fucntion we ll use this at the top of
    //the view to ignore and check the safe area around any text, we ll be applying this to the header view
    func getSafeArea()-> UIEdgeInsets {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .zero
        }
        
        guard let safeArea = screen.windows.first?.safeAreaInsets else {
            return .zero
        }
        
        return safeArea
    }
    
}
