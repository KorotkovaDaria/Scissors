//
//  ContentView.swift
//  Animations
//
//  Created by Daria on 03.06.2024.
//

import SwiftUI

struct CornerRotateModifier: ViewModifier {
    let amount: Double
    let anchor: UnitPoint

    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(amount), anchor: anchor)
            .clipped()
    }
}

extension AnyTransition {
    static var pivot: AnyTransition {
        .modifier(
            active: CornerRotateModifier(amount: -90, anchor: .bottomLeading),
            identity: CornerRotateModifier(amount: 0, anchor: .bottomLeading)
        )
    }
}


struct ContentView: View {
    @State private var isShowingRed = true

    var body: some View {
        ZStack {
            Rectangle()
                .fill(.red)
                .frame(width: 200, height: 200)

            if isShowingRed {
                Rectangle()
                    .fill(.blue)
                    .frame(width: 200, height: 200)
                    .transition(.pivot)
            }
        }
        .onTapGesture {
            withAnimation {
                isShowingRed.toggle()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
