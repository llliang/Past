//
//  PRefreshTableViewController.swift
//  Past
//
//  Created by jiangliang on 2018/4/2.
//  Copyright © 2018年 Jiang Liang. All rights reserved.
//

import UIKit

protocol PRefreshTableViewControllerProtocol : NSObjectProtocol {
    
    func refreshTableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    
    func refreshTableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    
    func refreshTableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
}

class PRefreshTableViewController<E: Entity, Type>: PBaseViewController, PRefreshTableViewControllerProtocol, UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView?
    
    var loadMoreView: PLoadMoreView?
    
    /// 数据为0时显示
    private var emptyView: UIView?
    
    var emptyText: String = "暂无数据"
    
    lazy var refreshControl: UIRefreshControl = {
        return UIRefreshControl()
    }()
    
    var dataModel: PDataModel<E, Type> = {
       return PDataModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.layoutSubviews()
        self.loadData()
    }
    
    open func layoutSubviews() {
        
        tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView?.autoresizingMask = UIViewAutoresizing.flexibleHeight
        tableView?.backgroundColor = UIColor.clear
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.tableFooterView = UIView()
//        tableView?.contentInset = UIEdgeInsetsMake(10, 0, 0, 0)
        tableView?.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        self.view.addSubview(tableView!)
        
        tableView?.refreshControl = refreshControl
        
        loadMoreView = PLoadMoreView(style: .default, reuseIdentifier: nil)
        
        emptyView = UIView(frame: self.view.bounds)
        emptyView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        emptyView?.isHidden = true
        self.view.addSubview(emptyView!)
        emptyView?.isUserInteractionEnabled = false
        
        let label = UILabel(frame: emptyView!.bounds.insetBy(dx: 0, dy: 100).offsetBy(dx: 0, dy: -100))
        label.autoresizingMask = emptyView!.autoresizingMask
        label.font = PFont(size: 18)
        label.textColor = UIColor.titleColor
        label.text = emptyText
        label.textAlignment = .center
        emptyView?.addSubview(label)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if dataModel.canLoadMore {
            return 2
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if 1 == indexPath.section {
            return loadMoreView!
        }
        
        let cell = self.refreshTableView(tableView, cellForRowAt: indexPath)
        if indexPath.row == dataModel.itemCount - 1 {
            cell.separatorInset = UIEdgeInsetsMake(0, self.view.width/2, 0, self.view.width/2)
        } else {
            cell.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if 1 == section {
            return 1
        }
        return dataModel.itemCount
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.refreshTableView(tableView, didSelectRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if 1 == indexPath.section {
           return 50
        }
        return self.refreshTableView(tableView, heightForRowAt: indexPath)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        let offset_Y = scrollView.contentOffset.y
//        print("offset = \(offset_Y)")
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
    
    @objc func refresh() {
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
                
                self.emptyView?.isHidden = !(self.dataModel.itemCount == 0)
            }
            self.refreshControl.endRefreshing()
        })
    }
    
    func refreshTableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func refreshTableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func refreshTableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}


