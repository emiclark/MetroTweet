//
//  LineWebDataViewController.swift
//  MetroTweet
//
//  Created by Avery Barrantes on 7/20/17.
//  Copyright © 2017 Avery Barrantes. All rights reserved.
//

import UIKit
import WebKit

class LineWebDataViewController: UIViewController {

    var url: URL? = nil
//    var title: String() = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Align the top of the controller to the bottom of navigation bar rather
        // than to the top of the screen.
        edgesForExtendedLayout = []
        
        let webView = WKWebView(frame: view.frame)
        view = webView

        let request = URLRequest(url: url!)
        webView.load(request)
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
