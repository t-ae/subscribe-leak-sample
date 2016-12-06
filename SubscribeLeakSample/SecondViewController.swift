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

class SecondViewController : UIViewController {
    let disposeBag = DisposeBag()
    
    let str = Variable("Binded")
    
    func someFunc1(_ str: String) {
        print("someFunc1: \(str)")
    }
    
    let someFunc2 = { (str:String) in
        print("someFunc2: \(str)")
    }
    
    override func viewDidLoad() {
        
        func someFunc3(_ str: String) {
            print("someFunc3: \(str)")
        }
        
        do {
            // This code causes leak
            str.asObservable()
                .subscribe(onNext: { self.someFunc1($0)})
                .addDisposableTo(disposeBag)
        }
        
        do {
            // This code does not cause leak
            str.asObservable()
                .subscribe(onNext: { [weak self] in self!.someFunc1($0) })
                .addDisposableTo(disposeBag)
        }
        
        do {
            // This code does not cause leak
            str.asObservable()
                .subscribe(onNext: someFunc2)
                .addDisposableTo(disposeBag)
        }
        
        do {
            // This code does not cause leak
            str.asObservable()
                .subscribe(onNext: someFunc3)
                .addDisposableTo(disposeBag)
        }
        
    }
    
    deinit {
        print("SecondViewController deinited.")
    }
}
