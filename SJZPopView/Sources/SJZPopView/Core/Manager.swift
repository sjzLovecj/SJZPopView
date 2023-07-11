//
//  hudManager.swift
//  Show
//
//  Created by iOS on 2023/5/4.
//

import SwiftUI

public extension View {
    /// 添加popView控制器,需要弹窗的页面最外层添加
    func addHUD() -> some View {
        overlay(
            ContainerView() 
        )
    }
}

public class HUDManager: ObservableObject {
    @Published var views: [AnyPop] = []
    @Published var popController: SJZPopController<ContainerView>?
    static let shared = HUDManager()
    private init() {}
}

public extension HUDManager {
    /// 收起最后一个hud
    func dismissLast() {
        views.removeLast()
        
        if views.isEmpty, let popController {
            popController.dismiss(animated: false) {
                self.popController = nil
            }
        }
    }
    /// 收起指定hud
    func dismiss(_ id: UUID) {
        views.removeAll { vi in
            vi.id == id
        }
        
        if views.isEmpty, let popController {
            popController.dismiss(animated: false) {
                self.popController = nil
            }
        }
    }
    /// 收起所有hud
    func dismissAll() {
        views.removeAll()
        
        if views.isEmpty, let popController {
            popController.dismiss(animated: false) {
                self.popController = nil
            }
        }
    }
}

extension HUDManager {
    /// 弹出hud
    func show(_ hud: AnyPop) {
        DispatchQueue.main.async {
            withAnimation{
                if self.canBeInserted(hud){
                    self.views.append(hud)
                    let config = hud.setupConfig(PopConfig())
                    if config.autoDismiss {
                        DispatchQueue.main.asyncAfter(deadline: .now() + config.autoDismissTime) {
                            self.dismiss(hud.id)
                        }
                    }
                }
            }
        }
    }
}

extension HUDManager {
    var tops: [AnyPop] {
        views.compactMap { now in
            if now.position == .top{
                return now
            }
            return nil
        }
    }
    var centers: [AnyPop] {
        views.compactMap { now in
            if now.position == .center{
                return now
            }
            return nil
        }
    }
    var bottoms: [AnyPop] {
        views.compactMap { now in
            if now.position == .bottom{
                return now
            }
            return nil
        }
    }
}

private extension HUDManager {
    func canBeInserted(_ hud: AnyPop) -> Bool {
        !views.contains { current in
            current.id == hud.id
        }
    }
}

