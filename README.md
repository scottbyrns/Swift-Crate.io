Crate.io Client Library
========


[![Swift 3.0](https://img.shields.io/badge/Swift-3.0-orange.svg?style=flat)](https://developer.apple.com/swift/)
[![Platforms Linux](https://img.shields.io/badge/Platforms-Linux-lightgray.svg?style=flat)](https://developer.apple.com/swift/)
[![License MIT](https://img.shields.io/badge/License-MIT-blue.svg?style=flat)](https://tldrlegal.com/license/mit-license)
[![Slack Status](https://zewo-slackin.herokuapp.com/badge.svg)](http://slack.zewo.io)

## Status

- [x] Blobs
- [x] Sql Statements
- [ ] Connection Pool
- [ ] Error Handling
- [ ] Arg Statements
- [x] Socket Connection

## Usage

### SQL

```swift

var crate = try! CrateIO(withHost: "10.0.1.3", onPort: 4200 )
crate.sql("create table if not exists t (name string) with (number_of_replicas = 0)")

```

### Blob

```swift

let result = crate.sql("create blob table myblobs clustered into 3 shards with (blobs_path='/tmp/crate_blob_data')")

let _digest = crate.blob(insert: "The quick brwn fox jumps over the lazy dog", into: "myblobs")

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

