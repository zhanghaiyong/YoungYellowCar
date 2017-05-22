//
//  ViewController.swift
//  YoungYellowCar
//
//  Created by zhy on 2017/5/18.
//  Copyright © 2017年 zhanghaiyong. All rights reserved.
//

import UIKit

class MainController: UIViewController,MAMapViewDelegate,AMapSearchDelegate {

    var mapView : MAMapView!
    var search : AMapSearchAPI!
    
    @IBOutlet weak var panelView: UIView!
    
    /**
     搜索周边小黄车
     */
    func searchBikeNearBy() {
        
        
    }
    
    func searchCustomLocation(_ center : CLLocationCoordinate2D) {
        
        /// POI周边搜索请求
        let request = AMapPOIAroundSearchRequest()
        request.location = AMapGeoPoint.location(withLatitude: CGFloat(center.latitude), longitude: CGFloat(center.longitude))
        request.keywords = "餐馆"
        request.radius = 500
        /**
         扩展
         */
        request.requireExtension = true
        self.search.aMapPOIAroundSearch(request)
        
    }
    
    /**
     AMapSearchDelegate
     */
    
    //搜索周边完成后的回调
    func onPOISearchDone(_ request: AMapPOISearchBaseRequest!, response: AMapPOISearchResponse!) {
        
        guard response.count > 0 else {
        
            print("周边没有小黄车")
            return
        }
        
        /**
         @property (nonatomic, copy)   NSString     *uid; //!< POI全局唯一ID
         @property (nonatomic, copy)   NSString     *name; //!< 名称
         @property (nonatomic, copy)   NSString     *type; //!< 兴趣点类型
         @property (nonatomic, copy)   NSString     *typecode; //!< 类型编码
         @property (nonatomic, copy)   AMapGeoPoint *location; //!< 经纬度
         @property (nonatomic, copy)   NSString     *address;  //!< 地址
         @property (nonatomic, copy)   NSString     *tel;  //!< 电话
         @property (nonatomic, assign) NSInteger     distance; //!< 距中心点的距离，单位米。在周边搜索时有效。
         @property (nonatomic, copy)   NSString     *parkingType; //!< 停车场类型，地上、地下、路边
         @property (nonatomic, copy)   NSString     *shopID; //!< 商铺id
         */
        for poi in response.pois {
            
            print(poi)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        //UINavigationbar中间的恩图标
        let ofoicon = UIImageView(frame: CGRect(x: 0, y: 0, width: 167/2.0, height: 20))
        ofoicon.image = UIImage(named: "ofoLogo")
        self.navigationItem.titleView = ofoicon;
        
        self.mapView = MAMapView(frame: self.view.bounds)
        self.mapView.delegate = self
        /**
         *  先缩放
         */
        self.mapView.zoomLevel = 17
        /**
         *  后定位
         */
        self.mapView.showsUserLocation = true;
        self.mapView.userTrackingMode = MAUserTrackingMode.follow;
        self.view.addSubview(self.mapView)
        AMapServices.shared().enableHTTPS = true
        
        //搜索poi
        self.search = AMapSearchAPI()
        self.search.delegate = self
        
        /// 侧滑栏
        let revealViewCtrl = self.revealViewController()
        revealViewCtrl?.panGestureRecognizer()
        revealViewCtrl?.tapGestureRecognizer()
        
    }

    /**
     侧滑栏
     
     - parameter sender: UIBarButtonItem
     */
    @IBAction func leftItemAction(_ sender: Any) {

        self.revealViewController().revealToggle(animated: true)
    }

    /**
     定位
     
     - parameter sender: UIButton
     */
    @IBAction func locationAction(_ sender: Any) {
    }
    /**
     吐槽
     
     - parameter sender: UIButton
     */
    @IBAction func spitAction(_ sender: Any) {
    }
    /**
     立即用车
     
     - parameter sender: UIButton
     */
    @IBAction func userCarAction(_ sender: Any) {
    }
    
}

