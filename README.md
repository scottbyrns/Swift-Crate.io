Crate.io Client Library
========


[![Swift 3.0](https://img.shields.io/badge/Swift-3.0-orange.svg?style=flat)](https://developer.apple.com/swift/)
[![Platforms Linux](https://img.shields.io/badge/Platforms-Linux-lightgray.svg?style=flat)](https://developer.apple.com/swift/)
[![License MIT](https://img.shields.io/badge/License-MIT-blue.svg?style=flat)](https://tldrlegal.com/license/mit-license)
[![Slack Status](https://zewo-slackin.herokuapp.com/badge.svg)](http://slack.zewo.io)

## Features

- [x] Sql Statements
- [x] Blobs
- [x] Connection Pools
- [x] Socket Connections
- [ ] Error Handling
- [ ] Arg Statements

## Usage

### Setup

```swift

// Create a set of TCPSocketClients to use as the connection pool.
let connections = [TCPSocketClient]()
let configuration = CratePoolConfiguration()

// Set how long a pool can suffer a continued series of errors before it is removed from the pool.
configuration.maxErrorDuration = 1.minute

// Set how long to wait before trying to issue a connection to a consumer after finding none available.
configuration.retryDelay = 10.milliseconds

// How long to wait for a connection to be available before giving up.
configuration.connectionWait = 30.milliseconds

// How long to keep trying to reconnect a closed socket before removing it from the pool.
configuration.maxReconnectDuration = 5.minutes


var crate = try! CrateIO(pool: connections, using: configuration)

```

### SQL

```swift
guard let json = try! crate.sql("create table if not exists t (name string) with (number_of_replicas = 0)") else {
  
}

```

### Blob

```swift

let result = crate.sql("create blob table myblobs clustered into 3 shards with (blobs_path='/tmp/crate_blob_data')")

let _digest = crate.blob(insert: Data("The quick brwn fox jumps over the lazy dog"), into: "myblobs")

if let digest = _digest {
  print(crate.blob(fetch: digest, from: "myblobs"))
}

```


## Community

[![Slack](http://s13.postimg.org/ybwy92ktf/Slack.png)](http://slack.zewo.io)

Join us on [Slack](http://slack.zewo.io).

License
-------

**Swift-Crate.io** is released under the MIT license. See LICENSE for details.

