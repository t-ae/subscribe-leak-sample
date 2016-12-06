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
    @IBOutlet weak var label: UILabel!
    
    let str = Variable("Binded")
    
    override func viewDidLoad() {
        
        str.asObservable()
            .bindTo(label.rx.text)
            .addDisposableTo(disposeBag)
        
        func someFunc2(_ str: String) {
            print("someFunc2: \(str)")
        }
        
        str.asObservable()
//            .subscribe(onNext: { [weak self] in self!.someFunc($0) }) // This don't cause leak
            .subscribe(onNext: someFunc) // This causes leak
//            .bindNext(someFunc2) // This causes, too
            .addDisposableTo(disposeBag)
        
    }
    
    func someFunc(_ str: String) {
        print("someFunc: \(str)")
    }
    
    let someFunc3 = { (str:String) in
        print("someFunc3: \(someFunc)")
    }
    
    deinit {
        print("SecondViewController deinited.")
    }
}
