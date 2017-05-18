//
//  ViewController.swift
//  YoungYellowCar
//
//  Created by zhy on 2017/5/18.
//  Copyright © 2017年 zhanghaiyong. All rights reserved.
//

import UIKit

class MainController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        //UINavigationbar中间的恩图标
        let ofoicon = UIImageView(frame: CGRect(x: 0, y: 0, width: 167/2.0, height: 20))
        ofoicon.image = UIImage(named: "ofoLogo")
        self.navigationItem.titleView = ofoicon;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

