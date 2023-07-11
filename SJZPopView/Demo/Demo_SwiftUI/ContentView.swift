//
//  ContentView.swift
//  Demo_SwiftUI
//
//  Created by S JZ on 2023/4/28.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
//            NavigationLink {
//                Text("ajflasfkalsfjal")
//                    .navigationTitle("第二个页面")
//
//            } label: {
//
//            }

            
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
        .onTapGesture {
            SJZPopManager.popVC {
                ToastView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



