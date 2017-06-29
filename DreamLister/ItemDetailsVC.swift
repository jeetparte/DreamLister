//
//  ItemDetailsVC.swift
//  DreamLister
//
//  Created by Jeet Parte on 29/06/17.
//  Copyright © 2017 Jeet Parte. All rights reserved.
//

import UIKit

class ItemDetailsVC: UIViewController {

    @IBOutlet weak var imagePreview: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePreview.imageView?.contentMode = .scaleAspectFit
        
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
