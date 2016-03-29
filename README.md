# Swift-Crate.io
Swift Crate.io Library

```

var crate = try! CrateIO(withHost: "10.0.1.3", onPort: 4200 )
crate.sql("create table if not exists t (name string) with (number_of_replicas = 0)")

```
