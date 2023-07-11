//
//  SJZViewController.swift
//  Demo
//
//  Created by S JZ on 2023/5/15.
//

import UIKit

class SJZViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        
        title = "456"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        SJZPopManager.popVC {
            ToastView()
        }
    }

}
