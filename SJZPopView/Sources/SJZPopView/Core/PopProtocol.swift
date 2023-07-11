//
//  PopProtocol.swift
//  
//
//  Created by S JZ on 2023/5/12.
//

import SwiftUI

public enum PopPosition {
    case top, bottom, center
    
    public var alignment: Alignment {
        switch self {
        case .top: return .top
        case .bottom: return .bottom
        case .center: return .center
        }
    }
}

public protocol Pop: View, Equatable, Hashable {
    associatedtype V: View
    // 标识唯一ID
    var id: UUID { get }
    // pop展示所在位置
    var position: PopPosition { get set }
    // 子类创建页面
    func setupBody() -> V
    // 配置Pop
    func setupConfig(_ config: PopConfig) -> PopConfig
}

public extension Pop {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var body: V {
        setupBody()
    }
    
    func show() {
        HUDManager.shared.show(AnyPop(self))
    }
    
    func dismiss() {
        HUDManager.shared.dismiss(id)
    }
}

struct AnyPop: Pop {
    let id: UUID
    var position: PopPosition
    
    private let _body: AnyView
    private let _configBuilder: (PopConfig) -> PopConfig
    
    init(_ pop: some Pop) {
        self.id = pop.id
        self.position = pop.position
        self._body = AnyView(pop)
        self._configBuilder = pop.setupConfig
    }
}

extension AnyPop {
    func setupBody() -> some View {
        _body
    }
    
    func setupConfig(_ config: PopConfig) -> PopConfig {
        _configBuilder(config)
    }
}

