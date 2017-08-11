//
//  OverviewViewController.swift
//  Cubie
//
//  Created by Jordan.Dixon on 11/08/2017.
//  Copyright © 2017 Mubaloo. All rights reserved.
//

import UIKit

class OverviewViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var dataSource = [ARExample]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    private func setupView() {
        
        dataSource = [RemoteCarViewController.example,
                      LightEstimationViewController.example,
                      MeasuringTapeViewController.example,
                      TargetShooterViewController.example,
                      MissileLaunchViewController.example,
                      OverlayingPlaneViewController.example,
                      CubeViewController.example,
                      TextViewController.example,
                      MultipleObjectsViewController.example,
                      TapGestureViewController.example,
                      DetectingPlaneViewController.example,
                      VirtualObjectsViewController.example,
                      PlanetsViewController.example]
    }
    
}

extension OverviewViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: VCTableViewCell.reuseID) as! VCTableViewCell
        
        cell.populate(from: dataSource[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let instance = dataSource[indexPath.row].instance.init()
        
        self.navigationController?.pushViewController(instance, animated: true)
        
    }
}

struct ARExample {
    var title: String
    var subtitle: String
    var instance: UIViewController.Type
}
