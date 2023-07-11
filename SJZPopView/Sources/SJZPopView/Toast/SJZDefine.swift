//
//  SJZDefine.swift
//  Demo
//
//  Created by S JZ on 2023/4/24.
//

import Foundation
import UIKit

// MARK: - 获取屏幕宽高
public var screenWidth: CGFloat {
    (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.screen.bounds.width ?? 0
}

public var screenHeight: CGFloat {
    (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.screen.bounds.height ?? 0
}

// 用于判断是否为刘海屏
public var isPhoneX: Bool {
    statusBarHeight > 30
}

// 状态栏高度
public var statusBarHeight: CGFloat {
    keyWindow?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
}

// 导航栏高度
public var navigationBarHeight: CGFloat {
    statusBarHeight + UINavigationController().navigationBar.frame.size.height
}

//public var navigationHeight: CGFloat {
//    statusBarHeight + UINavigationController().navigationBar.frame.size.height
//}

// 底部Home条的高度：刘海屏：34，非刘海屏：0
public var bottomHomeHeight: CGFloat {
    keyWindow?.safeAreaInsets.bottom ?? 0
}

// 动态获取TabBar的高度
public var tabBarHeight: CGFloat {
    bottomHomeHeight + UITabBarController().tabBar.frame.size.height
}

// MARK: 获取KeyWindow
public var keyWindow: UIWindow? {
    // iOS13.0 之前获取方式
    // UIApplication.shared.keyWindow
    let windowScreen = UIApplication.shared.connectedScenes.first as? UIWindowScene
    return windowScreen?.windows.first { key in
        key.isKeyWindow
    }
}

public var topWindow: UIWindow? {
    let windowScreen = UIApplication.shared.connectedScenes.first as? UIWindowScene
    return windowScreen?.windows.last
}

func topViewController(_ controller: UIViewController? = keyWindow?.rootViewController) -> UIViewController? {
    if let navigationController = controller as? UINavigationController {
        if  let visible =   navigationController.visibleViewController {
            return  topViewController(visible)
        }
    }

    if let tabController = controller as? UITabBarController {
        if let selected = tabController.selectedViewController {
            return topViewController(selected)
        }
    }
    
    if let presented = controller?.presentedViewController {
        return topViewController(presented)
    }
    
    return controller
}

