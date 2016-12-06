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

private func someFunc0(_ str: String) {
    print("someFunc0: \(str)")
}

class SecondViewController : UIViewController {
    let disposeBag = DisposeBag()
    
    let str = Variable("Binded")
    
    func someFunc1(_ str: String) {
        print("someFunc1: \(str)")
    }
    
    let someFunc2 = { (str:String) in
        print("someFunc2: \(str)")
    }
    
    static func someFunc3(_ str: String) {
        print("someFunc3: \(str)")
    }
    
    override func viewDidLoad() {
        
        func someFunc4(_ str: String) {
            print("someFunc4: \(str)")
        }
        
        do {
            // This code causes leak
//            str.asObservable()
//                .subscribe(onNext: someFunc1)
//                .addDisposableTo(disposeBag)
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
                .subscribe(onNext: SecondViewController.someFunc3)
                .addDisposableTo(disposeBag)
        }
        
        do {
            // This code does not cause leak
            str.asObservable()
                .subscribe(onNext: someFunc4)
                .addDisposableTo(disposeBag)
        }
        
        do {
            // This code does not cause leak
            str.asObservable()
                .subscribe(onNext: someFunc0)
                .addDisposableTo(disposeBag)
        }
        
    }
    
    deinit {
        print("SecondViewController deinited.")
    }
}
