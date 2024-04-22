//
//  ThreadSafeCache.swift
//
//
//  Created by Nhat Dinh on 2024/04/19.
//

import Foundation

class ThreadSafeCache<Key: Hashable, Value> {
    private var cache = [Key: Value]()
    private let lock = NSLock()

    func setValue(_ value: Value, forKey key: Key) {
        lock.lock()
        defer {
            lock.unlock()
        }
        cache[key] = value
    }

    func getValue(forKey key: Key) -> Value? {
        lock.lock()
        defer {
            lock.unlock()
        }
        return cache[key]
    }

    func removeValue(forKey key: Key) {
        lock.lock()
        defer {
            lock.unlock()
        }
        cache.removeValue(forKey: key)
    }

    func removeAll() {
        lock.lock()
        defer {
            lock.unlock()
        }
        cache.removeAll()
    }

    subscript(key: Key) -> Value? {
        set(newValue) {
            lock.lock()
            defer {
                lock.unlock()
            }
            cache[key] = newValue
        }
        get {
            lock.lock()
            defer {
                lock.unlock()
            }
            return cache[key]
        }
    }
}
