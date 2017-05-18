//
//  ActivityWebViewController.swift
//  YoungYellowCar
//
//  Created by zhy on 2017/5/18.
//  Copyright © 2017年 zhanghaiyong. All rights reserved.
//

import UIKit
import WebKit
class ActivityWebViewController: UIViewController {

    var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        self.title = "热门活动"
        
        self.webView = WKWebView(frame: self.view.bounds)
        self.view.addSubview(self.webView)
        let url = NSURL.init(string: "http://m.ofo.so/active.html")
        let request = NSURLRequest.init(url: url! as URL)
        self.webView.load(request as URLRequest)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
