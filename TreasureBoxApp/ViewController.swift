//
//  ViewController.swift
//  TreasureBoxApp
//
//  Created by miyamo on 2016/07/06.
//  Copyright © 2016年 Zombiyamo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var treasureBoxCollectionView: UICollectionView?

    @IBOutlet weak var backGroundImageView: UIImageView?
    var treasureNum :Int?
    let reuseIdentifier :String = "TreasureBoxCollectionViewCell"
    var imageArray :[String] = ["box1.png","box2.png","box3.png","box4.png","box5.png","box6.png","box7.png","box8.png","box9.png","box10.png"]
    var imageNum :Int = 0
    var cellNum :Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let backGroundImageView = backGroundImageView {
            let blurEffect = UIBlurEffect(style: .Dark)
            let visualEffectView = UIVisualEffectView(effect: blurEffect)
            visualEffectView.frame = self.view.frame
            self.view.addSubview(visualEffectView)
        }
        
        treasureNum = Int(arc4random_uniform(10))
        
        if let treasureBoxCollectionView = treasureBoxCollectionView {
            treasureBoxCollectionView.delegate = self
            treasureBoxCollectionView.dataSource = self
            treasureBoxCollectionView.registerNib(UINib(nibName: "TreasureBoxCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
            self.view.bringSubviewToFront(treasureBoxCollectionView)
        }
        
        func viewWillAppear(animated: Bool) {
            super.viewWillAppear(animated)
            
            cellMotion()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: UICollectionViewDelegate{
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row == treasureNum {
            let foundAlertView :UIAlertController = UIAlertController(title: "おめでとう！", message: "お宝を発見しました！", preferredStyle: .Alert)
            let defaultAction :UIAlertAction = UIAlertAction(title: "やったー！", style: .Default, handler: nil)
            foundAlertView.addAction(defaultAction)
            presentViewController(foundAlertView, animated: true, completion: nil)
        }else{
            let foundAlertView :UIAlertController = UIAlertController(title: "なんも", message: "ないで", preferredStyle: .Alert)
            let defaultAction :UIAlertAction = UIAlertAction(title: "えー！", style: .Default, handler: nil)
            foundAlertView.addAction(defaultAction)
            presentViewController(foundAlertView, animated: true, completion: nil)
        }
    
    }
    
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        //再利用できるセルがあればそれを使うなければ生成する
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)  as! TreasureBoxCollectionViewCell
        cell.cellImageView.image = UIImage(named: imageArray[indexPath.row])
        if cellNum < imageArray.count {
            cell.cellImageView.addMotionEffect(cellMotion())
            cellNum += 1
        }
        return cell
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func cellMotion() -> UIMotionEffectGroup {
        let min = -30.0
        let max = 30.0
        
        let xAxis = UIInterpolatingMotionEffect(keyPath: "center.x", type: .TiltAlongHorizontalAxis)
        xAxis.minimumRelativeValue = min
        xAxis.maximumRelativeValue = max
        let yAxis = UIInterpolatingMotionEffect(keyPath: "center.y", type: .TiltAlongVerticalAxis)
        yAxis.minimumRelativeValue = min
        yAxis.maximumRelativeValue = max
        
        let group = UIMotionEffectGroup()
        group.motionEffects = [xAxis, yAxis]
        
        return group
        
    }

}

extension ViewController: UICollectionViewDelegateFlowLayout {
    // Screenサイズに応じたセルサイズを返す
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let cellSize:CGFloat = collectionView.frame.size.width/2-5
        // 正方形で返すためにwidth,heightを同じにする
        return CGSizeMake(cellSize, cellSize)
    }
}