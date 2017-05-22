//
//  MeumTableViewController.swift
//  YoungYellowCar
//
//  Created by zhy on 2017/5/18.
//  Copyright © 2017年 zhanghaiyong. All rights reserved.
//

import UIKit

class MeumTableViewController: UITableViewController {

    /// 钱包
    @IBOutlet weak var balanceLabel: UILabel!
    /// 头像
    @IBOutlet weak var avatar: UIImageView!
    /// 认证图标
    @IBOutlet weak var CerTificationImage: UIImageView!
    /// 认证类型
    @IBOutlet weak var CerTificationType: UILabel!
    /// 信用分
    @IBOutlet weak var creditLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
