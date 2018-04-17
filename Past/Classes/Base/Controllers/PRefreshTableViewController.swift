//
//  PRefreshTableViewController.swift
//  Past
//
//  Created by jiangliang on 2018/4/2.
//  Copyright © 2018年 Jiang Liang. All rights reserved.
//

import UIKit

class PRefreshTableViewController<E: Entity, Type>: PBaseViewController, UITableViewDelegate, UITableViewDataSource {
 
    var tableView: UITableView?
    
    var loadMoreView: PLoadMoreView?
    
    var refreshControl: UIRefreshControl = {
        return UIRefreshControl()
    }()
    
    var dataModel: PDataModel<E, Type> = {
       return PDataModel()
    }()
    
    override func viewDidLoad() {
        self.layoutSubviews()
        self.refresh()
    }
    
    open func layoutSubviews() {
        tableView = UITableView(frame: self.view.bounds, style: .plain)

        tableView?.autoresizingMask = UIViewAutoresizing.flexibleHeight
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.tableFooterView = UIView()
        self.view.addSubview(tableView!)
        
        tableView?.refreshControl = refreshControl
        
        loadMoreView = PLoadMoreView(frame: CGRect(x: 0, y: max(tableView!.contentSize.height, tableView!.height), width: self.view.width, height: 44))
        loadMoreView?.backgroundColor = UIColor.red
        loadMoreView?.autoresizingMask = UIViewAutoresizing.flexibleTopMargin
        tableView?.addSubview(loadMoreView!)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.itemCount
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        
//    }
//    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        let offset_Y = scrollView.contentOffset.y
        print("offset = \(offset_Y)")
        if self.canRefresh(offset: offset_Y) {
            self.refresh()
            refreshControl.beginRefreshing()
        }
        
        if self.canLoadMore(offset: offset_Y) {
            self.loadData()
        }
    }
    
    func canRefresh(offset: CGFloat) -> Bool {
        if dataModel.loading {
            return false
        }
        
        if offset >= -128 {
            return false
        }
        return true
    }
    
    func canLoadMore(offset: CGFloat) -> Bool {
        
        if dataModel.loading || dataModel.canLoadMore == false {
            return false
        }
        
        if (tableView!.contentSize.height - tableView!.contentOffset.y - tableView!.contentInset.bottom - tableView!.height > 0) {
            return false
        }
        return true
    }
    
    func refresh() {
        dataModel.isReload = true
        self.loadData()
    }
    
    func loadData() {
        dataModel.load(start: {
            
        }, finished: { (data, error) in
            if (error != nil) {
                Hud.show(content: error!.description)
            } else {                
                self.loadMoreView?.isHidden = !self.dataModel.canLoadMore
                self.tableView?.reloadData()
            }
            self.refreshControl.endRefreshing()

        })
    }
}


