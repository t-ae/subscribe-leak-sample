//
//  SecondViewController.swift
//  SubscribeLeakSample
//
//  Created by Araki Takehiro on 2016/12/06.
//  Copyright © 2016年 Araki Takehiro. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

private func deg0(from rad: Double) -> Double {
    return rad * 180 / M_PI
}

class SecondViewController : UIViewController {
    let disposeBag = DisposeBag()
    
    let angle = Variable(1.0)
    
    func deg1(from rad: Double) -> Double {
        return rad * 180 / M_PI
    }
    
    let deg2 = { (rad: Double) in
        return rad * 180 / M_PI
    }
    
    static func deg3(from rad: Double) -> Double {
        return rad * 180 / M_PI
    }
    
    override func viewDidLoad() {
        
        func deg4(from rad: Double) -> Double {
            return rad * 180 / M_PI
        }
        
        do {
            // This code causes leak
//            angle.asObservable()
//                .map(deg1)
//                .subscribe()
//                .addDisposableTo(disposeBag)
        }
        
        do {
            // This code does not cause leak
            angle.asObservable()
                .map { [weak self] in self!.deg1(from: $0) }
                .subscribe()
                .addDisposableTo(disposeBag)
        }
        
        do {
            // This code does not cause leak
            angle.asObservable()
                .map(deg2)
                .subscribe()
                .addDisposableTo(disposeBag)
        }
        
        do {
            // This code does not cause leak
            angle.asObservable()
                .map(SecondViewController.deg3)
                .subscribe()
                .addDisposableTo(disposeBag)
        }
        
        do {
            // This code does not cause leak
            angle.asObservable()
                .map(deg4)
                .subscribe()
                .addDisposableTo(disposeBag)
        }
        
        do {
            // This code does not cause leak
            angle.asObservable()
                .map(deg0)
                .subscribe()
                .addDisposableTo(disposeBag)
        }
        
    }
    
    deinit {
        print("SecondViewController deinited.")
    }
}
