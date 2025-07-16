//
//  ViewController.swift
//  ToDoList
//
//  Created by Alaa Gawish on 16/07/2025.
//

import UIKit

protocol BaseProtocol {
    func registerCell()
    func bindValues()
    func initValues()
}
class BaseViewController: UIViewController, BaseProtocol {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initValues()
        registerCell()
        bindValues()
    }
    
    func registerCell() {
    }
    
    func bindValues() {
    }
    func initValues() {
    }
    
}

