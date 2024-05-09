//
//  ThreadSafeCache.swift
//
//
//  Created by Nhat Dinh on 2024/04/19.
//

import Foundation

public class ThreadSafeDictionary<Key: Hashable, Value> {
    private var cache = [Key: Value]()
    private let lock = NSLock()

    public init() {
    }

    public func setValue(_ value: Value, forKey key: Key) {
        lock.lock()
        defer {
            lock.unlock()
        }
        cache[key] = value
    }

    public func getValue(forKey key: Key) -> Value? {
        lock.lock()
        defer {
            lock.unlock()
        }
        return cache[key]
    }

    public func removeValue(forKey key: Key) {
        lock.lock()
        defer {
            lock.unlock()
        }
        cache.removeValue(forKey: key)
    }

    public func removeAll() {
        lock.lock()
        defer {
            lock.unlock()
        }
        cache.removeAll()
    }

    public subscript(key: Key) -> Value? {
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

extension ThreadSafeDictionary: Collection {
    public var startIndex: Dictionary<Key, Value>.Index {
        lock.lock()
        defer {
            lock.unlock()
        }
        return self.cache.startIndex
    }

    public var endIndex: Dictionary<Key, Value>.Index {
        lock.lock()
        defer {
            lock.unlock()
        }
        return self.cache.endIndex
    }

    public func index(after i: Dictionary<Key, Value>.Index) -> Dictionary<Key, Value>.Index {
        lock.lock()
        defer {
            lock.unlock()
        }
        return cache.index(after: i)
    }

    public subscript(index: Dictionary<Key, Value>.Index) -> Dictionary<Key, Value>.Element {
        lock.lock()
        defer {
            lock.unlock()
        }
        return self.cache[index]
    }
}
