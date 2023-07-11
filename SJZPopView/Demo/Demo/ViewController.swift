//
//  ViewController.swift
//  Demo
//
//  Created by S JZ on 2023/4/24.
//

import UIKit
import SwiftUI

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        title = "第一个页面"
        
        let vc = UIHostingController(rootView: ContentView())
        vc.view.backgroundColor = .clear
        addChild(vc)
        vc.didMove(toParent: self)
        
        vc.view.frame = view.frame
        view.addSubview(vc.view)
    }

//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let vc = SJZViewController()
//        vc.hidesBottomBarWhenPushed = true
//        navigationController?.pushViewController(vc, animated: true)
//    }
}




