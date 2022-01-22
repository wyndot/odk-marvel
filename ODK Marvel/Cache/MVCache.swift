//
//  MVCache.swift
//  ODK Marvel
//
//  Created by wyndot on 1/22/22.
//

import Foundation

final class WrappedKey<T: Hashable>: NSObject {
    private var key: T
    
    init(key: T) {
        self.key = key
        super.init()
    }
    
    override var hash: Int {
        return key.hashValue
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let another = object as? Self else {
            return false
        }
        return self.key == another.key
    }
}


final class EntryValue<T> {
    private(set) var value: T
    
    init(value: T) {
        self.value = value
    }
}

final class MVCache<K: Hashable, V> {
    private var cache: NSCache<WrappedKey<K>, EntryValue<V>> = NSCache<WrappedKey<K>, EntryValue<V>>()
    
    init() {
        
    }
    
    func insert(value: V, for key: K) {
        self.cache.setObject(EntryValue(value: value), forKey: WrappedKey(key: key))
    }
    
    func remove(for key: K) {
        self.cache.removeObject(forKey: WrappedKey(key: key))
    }
    
    func value(for key: K) -> V? {
        guard let wrapped = self.cache.object(forKey: WrappedKey(key: key)) as? EntryValue else {
            return nil
        }
        
        return wrapped.value
    }
    
    subscript(key: K) -> V? {
        get {
            self.value(for: key)
        }
        set {
            self.remove(for: key)
            guard let v = newValue else {
                return
            }
            
            self.insert(value: v, for: key)
        }
    }
}
