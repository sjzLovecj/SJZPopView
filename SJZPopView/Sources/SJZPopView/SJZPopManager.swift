//
//  SJZPopManager.swift
//  Demo
//
//  Created by S JZ on 2023/5/15.
//

import Foundation
import SwiftUI

public class SJZPopManager {
    
    static public func popVC<Content: Pop>(_ content: @escaping () -> Content) {
        if let _ = HUDManager.shared.popController {
            content().show()
        }else {
            let popVC = hostingVC()
            HUDManager.shared.popController = popVC
            if let topVC = keyWindow?.rootViewController {
                topVC.present(popVC, animated: false, completion: {
                    content().show()
                })
            }
        }
    }
    
    static func hostingVC() -> SJZPopController<ContainerView> {
        let popVC = SJZPopController(rootView: ContainerView())
        popVC.modalPresentationStyle = .overCurrentContext
        popVC.modalTransitionStyle = .crossDissolve
        popVC.view.backgroundColor = .clear
        return popVC
    }
    
    static public func toast(_ text: String) {
        popVC {
            ToastView(text: text)
        }
    }
}


