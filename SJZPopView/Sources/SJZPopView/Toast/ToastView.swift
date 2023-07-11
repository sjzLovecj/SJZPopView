//
//  ToastView.swift
//  Demo
//
//  Created by S JZ on 2023/5/15.
//

import SwiftUI

public struct ToastView: Pop {
    
    public var text: String
    
    public var position: PopPosition = .center
    public var id: UUID = UUID()

    public func setupBody() -> some View {
        Text(text)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 15)
            .padding(.vertical, 8)
            .foregroundColor(.white)
            .background(
                Color.black
                    .opacity(0.8)
                    .cornerRadius(8)
            )
    }
    
    
    public func setupConfig(_ config: PopConfig) -> PopConfig {
        config
            .backgroundColour(.clear)
            .maxStackCount(1)
            .needMask(true)
            .autoDismiss(true)
            .horizontalPadding(20)
    }
}

struct ToastView_Previews: PreviewProvider {
    static var previews: some View {
        ToastView(text: "123123")
    }
}
