//
//  ViewController.swift
//  Demo
//
//  Created by shuhei komino on 2018/10/11.
//  Copyright © 2018年 komi2. All rights reserved.
//

import UIKit
import XTagView

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let option = XTagViewOption(
            marginX: CGFloat(6),
            marginY: CGFloat(6),
            font: UIFont.boldSystemFont(ofSize: 14),
            containerWidth: view.frame.width,
            titleColor: .white,
            backgroundColor: .red,
            cornerRadius: CGFloat(12),
            insets: UIEdgeInsets(top: 6, left: 8, bottom: 6, right: 8)
        )
        
        let titles = ["strawberry", "cherry", "watermelon", "plum",
                      "pear", "pineapple", "banana", "grape", "melon", "peach", "apple", "mandarin"]
        let v = XTagView(option: option)
        v.delegate = self
        
        v.frame = CGRect(origin: CGPoint(x: 0, y: 100), size: v.frame.size)
        v.updateTags(titles: titles)
        v.backgroundColor = UIColor(red: 0.90, green: 0.90, blue: 0.90, alpha: 1)
        view.addSubview(v)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: XTagViewDelegate {
    
    func selectTag(sender: UILabel) {
        print(sender.text ?? "nil")
    }
}


