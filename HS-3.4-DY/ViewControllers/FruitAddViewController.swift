//
//  FruitAddViewController.swift
//  HW-3.2-DY-New
//
//  Created by Denis Yarets on 19/11/2023.
//

import UIKit

protocol FruitAddViewControllerDelegate {
    func postFruit(title: String, family: String, genus: String)
}

final class FruitAddViewController: UIViewController {
    
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfFamily: UITextField!
    @IBOutlet weak var tfGenus: UITextField!
    
    var delegate: FruitAddViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func buttonSavePressed(_ sender: Any) {
        delegate?.postFruit(title: tfName.text ?? "404", family: tfFamily.text ?? "404", genus: tfGenus.text ?? "404")
        dismiss(animated: true)
    }
    
    
    @IBAction func buttonCancelPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
}
