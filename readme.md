```swift
typealias version = Version

var logs: String {
    switch Version.state {
    case .new: return "app is new, " + Version.current
    case .updated: return "app is updated, " + Version.current
    case .downgrated: return "app is downgrated, " + Version.current
    case .none: return "app version is " + Version.current
    }
}

print(logs)
version.update()
```
