//
//  ViewController.swift
//  YoungYellowCar
//
//  Created by zhy on 2017/5/18.
//  Copyright © 2017年 zhanghaiyong. All rights reserved.
//

import UIKit

class MainController: UIViewController,MAMapViewDelegate,AMapSearchDelegate,AMapNaviWalkManagerDelegate {

    var mapView : MAMapView!
    var search : AMapSearchAPI!
    var pin : MyPinAnntation!
    var pinView : MAAnnotationView!
    var nearbySearch = true
    var walkManager : AMapNaviWalkManager!
    var start,end : CLLocationCoordinate2D!
    
    @IBOutlet weak var panelView: UIView!
    
    /**
     搜索周边小黄车
     */
    func searchBikeNearBy() {
        
        self.searchCustomLocation(self.mapView.userLocation.coordinate)
    }
    
    func searchCustomLocation(_ center : CLLocationCoordinate2D) {
        
        /// POI周边搜索请求
        let request = AMapPOIAroundSearchRequest()
        request.location = AMapGeoPoint.location(withLatitude: CGFloat(center.latitude), longitude: CGFloat(center.longitude))
        /**
         关键字
         */
        request.keywords = "餐馆"
        /**
         搜索范围
         */
        request.radius = 500
        /**
         扩展
         */
        request.requireExtension = true
        self.search.aMapPOIAroundSearch(request)
        
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
        
        //导航步行管理
        self.walkManager = AMapNaviWalkManager()
        self.walkManager.delegate = self;
        
        /// 侧滑栏
        let revealViewCtrl = self.revealViewController()
        revealViewCtrl?.panGestureRecognizer()
        revealViewCtrl?.tapGestureRecognizer()
        
        self.view.bringSubview(toFront: self.panelView)
        
    }
    
    /**
     大头针动画
     */
    func pinAnimation() {
        
        //坠落效果
        let endFrame = pinView.frame
        
        self.pinView.frame = endFrame.offsetBy(dx: 0, dy: -15)
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0, options: [], animations: { 
            
            self.pinView.frame = endFrame
            
        }) { (finish) in
            
        }
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
        
        self.searchBikeNearBy()
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
    
    
    /**
     MAMapViewDelegate
     */
    
    func mapView(_ mapView: MAMapView!, didSelect view: MAAnnotationView!) {
        
        print("点击了我！")
        self.start = pin.coordinate
        self.end = view.annotation.coordinate
        
        let startPoint = AMapNaviPoint.location(withLatitude: CGFloat(self.start.latitude), longitude: CGFloat(self.start.longitude))!
        let endPoint   = AMapNaviPoint.location(withLatitude: CGFloat(self.end.latitude), longitude: CGFloat(self.end.longitude))!
        self.walkManager.calculateWalkRoute(withStart: [startPoint], end: [endPoint])
    }
    
    /**
     添加标注
     - parameter mapView: mapView
     - parameter views:   大头针
     */
    func mapView(_ mapView: MAMapView!, didAddAnnotationViews views: [Any]!) {
        
        let aViews = views as! [MAAnnotationView]
        for aView in aViews {
            guard aView.annotation is MAPointAnnotation else {
                continue
            }
            
            //缩小
            aView.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0, options: [], animations: { 
                
                //还原
                aView.transform = .identity
                
            }, completion: nil)
        }
    }
    
    /**
     用户移动地图交互
     - parameter mapView:       mapView
     - parameter wasUserAction: 用户是否移动
     */
    func mapView(_ mapView: MAMapView!, mapDidMoveByUser wasUserAction: Bool) {
        
        if wasUserAction {
            self.pin.isLockedToScreen = true
            self.pinAnimation()
            self.searchCustomLocation(mapView.centerCoordinate)
        }
        
    }
    
    /**
     地图加载完毕
     
     - parameter mapView: mapView
     */
    func mapInitComplete(_ mapView: MAMapView!) {
        
        pin = MyPinAnntation()
        ///经纬度
        pin.coordinate = mapView.centerCoordinate
        ///固定屏幕点的坐标
        pin.lockedScreenPoint = CGPoint(x: kSCREEN_WIDTH/2, y: kSCREEN_HEIGHT/2)
        pin.isLockedToScreen = true;
        mapView.addAnnotation(pin)
        mapView.showAnnotations([pin], animated: true)
    }
    
    /**
     自定义大头针试图
     
     - parameter mapView:    mapView
     - parameter annotation: 标注
     
     - returns: 大头针视图
     */
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {

        /**
         *  用户自己的位置
         */
        if annotation is MAUserLocation {
        
            return nil
        }
        /**
         *  屏幕中心点的大头针
         */
        if annotation is MyPinAnntation {
        
            let reuserid = "anchor"
            var av = MAPinAnnotationView(annotation: annotation, reuseIdentifier: reuserid)
            if av == nil {
            
                av = MAPinAnnotationView(annotation: annotation, reuseIdentifier: reuserid)
            }
            av?.image = UIImage(named: "homePage_wholeAnchor")
            av?.canShowCallout = true
            av?.animatesDrop = true

            pinView = av
            return av
        }
        
        /// 红包车和普通车的大头针
        let reuserid = "myid"
        var anntationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuserid) as? MAPinAnnotationView
        if anntationView == nil {
        
            anntationView = MAPinAnnotationView(annotation: annotation, reuseIdentifier: reuserid)
        }
        
        if annotation.title == "正常可用" {
            
            anntationView?.image = UIImage(named: "HomePage_nearbyBike")
            
        }else {
        
            anntationView?.image = UIImage(named: "HomePage_nearbyBikeRedPacket")
        }
        
        anntationView?.canShowCallout = true
        anntationView?.animatesDrop = true
        
        return anntationView
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
        var annotations : [MAPointAnnotation] = []
        for poi in response.pois {
            
            let annotation = MAPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(poi.location.latitude), CLLocationDegrees(poi.location.longitude))
            if poi.distance < 200 {
                
                annotation.title = "红包区域内开锁任意小黄车"
                annotation.subtitle = "骑行10分钟可获得现金红包"
                
            }else {
                
                annotation.title = "正常可用"
            }
            
            annotations.append(annotation)
        }
        
        self.mapView.addAnnotations(annotations)
        
        //判断是否是当前位置搜索，则全部显示
        if self.nearbySearch {
        
            /**
             *  设置地图使其可以显示数组中所有的annotation
             */
            self.mapView.showAnnotations(annotations, animated: true)
            self.nearbySearch = false
        }
    }
    
    /**
     显示折线
     
     - parameter mapView: mapView
     - parameter overlay: 折线
     
     - returns: <#return value description#>
     */
    func mapView(_ mapView: MAMapView!, rendererFor overlay: MAOverlay!) -> MAOverlayRenderer! {
        if overlay.isKind(of: MAPolyline.self) {
            let renderer: MAPolylineRenderer = MAPolylineRenderer(overlay: overlay)
            renderer.lineWidth = 8.0
            renderer.strokeColor = UIColor.cyan
            
            return renderer
        }
        return nil
    }
    
    
    /**
     *  AMapNaviWalkManagerDelegate
     */
    func walkManager(onCalculateRouteSuccess walkManager: AMapNaviWalkManager) {
        
        print("步行路线规划成功")
        
        var coordinate :[CLLocationCoordinate2D] = []
        for point in (walkManager.naviRoute?.routeCoordinates)! {
            
           let coor = CLLocationCoordinate2DMake(CLLocationDegrees(point.latitude), CLLocationDegrees(point.longitude))
            coordinate.append(coor)
        }
        let polyLine = MAPolyline(coordinates: &coordinate, count: UInt(coordinate.count))
        self.mapView.add(polyLine)
    }
    
    func walkManager(_ walkManager: AMapNaviWalkManager, onCalculateRouteFailure error: Error) {
        print("步行路线规划失败 error = \(error)")
    }
    
}

