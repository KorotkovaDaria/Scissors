//
//  ContentView.swift
//  test
//
//  Created by Daria on 24.05.2024.
//

import SwiftUI

struct GridStack <Content: View>: View {
    let rows: Int
    let columns: Int
    let content: (Int,Int) -> Content
    
    var body: some View {
        VStack {
            ForEach(0..<rows, id: \.self) {row in
                HStack {
                    ForEach(0..<columns, id: \.self) {column in
                        content(row,column)
                    }
                }
            }
        }
    }
}

struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundStyle(.white)
            .padding()
            .background(.blue)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct WaterMark: ViewModifier {
    var text: String
    
    func body(content: Content) -> some View {
        ZStack(alignment: .bottomTrailing) {
            content
            
            Text(text)
                .font(.caption)
                .foregroundStyle(.white)
                .padding(5)
                .background(.black)
        }
            
    }
}

extension View {
    func titleStyle() -> some View {
        modifier(Title())
    }
    
    func waterMarkStyle(text: String) -> some View {
        modifier(WaterMark(text: text))
    }
}
struct ContentView: View {
    var body: some View {
            Text("Hello, world!")
            .titleStyle()
            .waterMarkStyle(text: "Hello")
        
        GridStack(rows: 4, columns: 4) { row, column in
            HStack {
                Image(systemName: "\(row * 4 + column).circle")
                Text("R\(row), C\(column)")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
