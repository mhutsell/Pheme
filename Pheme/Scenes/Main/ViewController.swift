//
//  ViewController.swift
//  Pheme
//
//  Created by William Mack Hutsell on 10/1/21.
//

import BerkananSDK
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var enterApp: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let configuration = Configuration(
          // The identifier is used to identify what kind of configuration the service has.
          // It should be the same across app runs.
          identifier: UUID(uuidString: "3749ED8E-DBA0-4095-822B-1DC61762CCF3")!,
          userInfo: "My User Info".data(using: .utf8)!
        )
        // Throws if the configuration is too big or invalid.
        do {
            let localService = try BerkananBluetoothService(configuration: configuration)
            localService.start()
        }
        catch {
            print("hahahaha!")
        }
    }


}

