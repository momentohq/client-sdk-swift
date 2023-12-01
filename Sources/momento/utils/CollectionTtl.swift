/**
  Represents the desired behavior for managing the TTL on collection
  objects (dictionaries, lists, sets) in your cache.
 
  For cache operations that modify a collection, there are a few things
  to consider.  The first time the collection is created, we need to
  set a TTL on it.  For subsequent operations that modify the collection
  you may choose to update the TTL in order to prolong the life of the
  cached collection object, or you may choose to leave the TTL unmodified
  in order to ensure that the collection expires at the original TTL.
 
  The default behavior is to refresh the TTL (to prolong the life of the
  collection) each time it is written.  This behavior can be modified
  by calling withNoRefreshTtlOnUpdates.
 */
public class CollectionTtl {
    private var _ttlSeconds: Int?
    private var _refreshTtl: Bool
    
    /**
     CollectionTtl constructor.
     - Parameter ttlSeconds: The number of seconds after which to expire the collection from the cache.
     - Parameter refreshTtl: If true, the collection's TTL will be refreshed (to prolong the life of the collection) on every update.
     If false, the collection's TTL will only be set when the collection is initially created.
     */
    init(ttlSeconds: Int? = nil, refreshTtl: Bool = true) {
        self._ttlSeconds = ttlSeconds
        self._refreshTtl = refreshTtl
    }
    
    /** 
     Current time-to-live value in seconds if it's set.
     - Returns Int or nil
    */
    public func ttlSeconds() -> Int? {
        return self._ttlSeconds
    }
    
    /** 
     Current time-to-live value in milliseconds if it's set.
     - Returns Int or nil
    */
    public func ttlMilliseconds() -> Int? {
        if let s = self._ttlSeconds {
            return s * 1000
        } else {
            return nil
        }
    }
    
    /** 
     Current value for whether to refresh a collection's TTL when it's modified.
     - Returns Bool
    */
    public func refreshTtl() -> Bool {
        return self._refreshTtl
    }
    
    /**
     The default way to handle TTLs for collections. The default TTL that was specified when constructing the
     CacheClient will be used, and the TTL for the collection will be refreshed any time the collection is modified.
     - Returns: CollectionTtl
    ```
     */
    public static func fromCacheTtl() -> CollectionTtl {
        return CollectionTtl(refreshTtl: true)
    }
    
    /** 
     Constructs a CollectionTtl with the specified TTL in seconds.  The TTL for the collection will be refreshed any time the collection is modified.
     - Parameter ttlSeconds: The number of seconds after which to expire the collection from the cache.
     - Returns: CollectionTtl
    */
    public static func of(ttlSeconds: Int) -> CollectionTtl {
        return CollectionTtl(ttlSeconds: ttlSeconds);
    }
    
    /**
     Constructs a CollectionTtl with the specified TTL in seconds. Will only refresh if the TTL is not nil.
     - Parameter ttlSeconds: The number of seconds after which to expire the collection from the cache. Defaults to nil.
     - Returns: CollectionTtl
    */
    public static func RefreshTtlIfProvided(ttlSeconds: Int? = nil) -> CollectionTtl {
        return CollectionTtl(ttlSeconds: ttlSeconds, refreshTtl: (ttlSeconds == nil));
    }
    
    /** 
     Specifies that the TTL for the collection should be refreshed when the collection is modified.  (This is the default behavior.)
     - Returns: CollectionTtl
    */
    public func withRefreshTtlOnUpdates() -> CollectionTtl {
        return CollectionTtl(ttlSeconds: self._ttlSeconds, refreshTtl: self._refreshTtl);
    }

    /**
     Specifies that the TTL for the collection should not be refreshed when the collection is modified.
     Use this if you want to ensure that your collection expires at the originally specified time, even
     if you make modifications to the value of the collection.
     - Returns: CollectionTtl
    */
    public func withNoRefreshTtlOnUpdates() -> CollectionTtl
    {
        return CollectionTtl(ttlSeconds: self._ttlSeconds, refreshTtl: false);
    }
}
