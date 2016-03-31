# Swift-Crate.io
Swift Crate.io Library

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
