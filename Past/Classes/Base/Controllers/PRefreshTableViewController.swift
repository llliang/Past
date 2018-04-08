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
        self.initialize()
        self.refresh()
    }
    
    open func initialize() {
        tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView?.autoresizingMask = [UIViewAutoresizing.flexibleHeight, UIViewAutoresizing.flexibleTopMargin, UIViewAutoresizing.flexibleBottomMargin]
        tableView?.delegate = self
        self.view.addSubview(tableView!)
        if #available(iOS 11.0, *) {
            tableView?.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
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
        return 0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
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
            self.refreshControl.endRefreshing()
            self.loadMoreView?.isHidden = !self.dataModel.canLoadMore
        })
    }
}


