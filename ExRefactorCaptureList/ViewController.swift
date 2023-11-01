//
//  ViewController.swift
//  ExRefactorCaptureList
//
//  Created by 김종권 on 2023/11/01.
//

import UIKit

class ViewController: UIViewController {
    var someValue = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var b: B? = B()
        b = nil
        
        weak var weakSelf = self
//        guard let weakSelf else { return } // <- strong self로 잡히므로 이 weakSelf를 closure안에서 쓰면 retain cycle
        
        someFunc1 {
            print(weakSelf?.someValue)
        }
        
        someFunc2 {
            print(weakSelf?.someValue)
        }
        
        someFunc3 {
            print(weakSelf?.someValue)
        }
    }
    
    func someFunc1(block: @escaping () -> ()) {
        // Some working...
    }
    
    func someFunc2(block: @escaping () -> ()) {
        // Some working...
    }
    
    func someFunc3(block: @escaping () -> ()) {
        // Some working...
    }
}

class A {
    private var closureEscaper: ((String) -> ())?

    func escape(closure: @escaping (String) -> ()) {
        print("escaping!")
        closureEscaper = closure
    }
}

class B {
    var name = "Jake"
    let a = A() // 1. B에서 A참조

    init() {
        
        // 1). 클로저 내부에서 strong self 참조: retain cycle 발생 o
        a.escape { string in
            self.name = string // 2. A에서 B참조
        }
        
        // 2). 외부에서 weak self: retain cycle 발생 x
//        weak var weakSelf = self
//        a.escape { string in
//            weakSelf?.name = string // 2. A에서 B참조
//        }
        
        // 3). 외부에서 weak self한 후 옵셔널 바인딩: strong self로 다시 참조하므로 retain cycle 발생 o
//        weak var weakSelf = self
//        guard let weakSelf else { return }
//        a.escape { string in
//            weakSelf.name = string // 2. A에서 B참조
//        }
    }

    deinit {
        print("DEINIT: B")
    }
}
