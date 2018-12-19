//
//  PConfigManager.swift
//  Past
//
//  Created by liang on 2018/12/19.
//  Copyright © 2018 Jiang Liang. All rights reserved.
//

import UIKit

class PConfig: Entity {
    var key: String?
    var value: String?
}

class PConfigManager: NSObject {
    
    static let manager = PConfigManager()
    
    var configs: Array<PConfig>?
    
    private let cachKey = "PConfigManagerCacheKey"
    override init() {
        super.init()
        configs = PCacheManager.instance.cache(forKey: cachKey)
    }
    func updateConfig() {
        let configModel = PDataModel<PConfig, [PConfig]>()
        configModel.url = "/config/allConfigs"
        configModel.limited = 1000
        
        configModel.load(start: {
            
        }, finished: { (configs, error) in
            self.configs = configs
            if let cs = configs {
                PCacheManager.instance.setCache(cache: cs, forKey: self.cachKey)
            }
        })
    }
    
    func value(forKey key: String) -> String? {
        
        guard let configs = configs else {
            return nil
        }
        
        for config in configs {
            if key == config.key {
                return config.value
            }
        }
        return nil
    }
}
