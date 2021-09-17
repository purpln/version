import Foundation

public class Version {
    private static var defaults = UserDefaults.standard
    
    public static var saved: String? { defaults.object(forKey: "version") as? String }
    public static var current: String {
        guard let dictionary = Bundle.main.infoDictionary else { return "nil" }
        guard let version = dictionary["CFBundleShortVersionString"] as? String else { return "nil" }
        return version
    }
    
    public static var state: State {
        guard let saved = saved else { return .new }
        guard !current.is(greaterThan: saved) else { return .updated }
        guard !current.is(lessThan: saved) else { return .downgrated }
        return .none
    }
    
    public static func update() { defaults.set(current, forKey: "version") }
    
    public enum State: String { case none, new, updated, downgrated }
}

private extension String {
    func `is`(equalTo version: String)              -> Bool { compare(version) == .orderedSame }
    func `is`(greaterThan version: String)          -> Bool { compare(version) == .orderedDescending }
    func `is`(greaterThanOrEqualTo version: String) -> Bool { compare(version) != .orderedAscending }
    func `is`(lessThan version: String)             -> Bool { compare(version) == .orderedAscending }
    func `is`(lessThanOrEqualTo version: String)    -> Bool { compare(version) != .orderedDescending }
    
    func compare(_ targetVersion: String) -> ComparisonResult {
        var result: ComparisonResult = .orderedSame
        var versionComponents = self.components(separatedBy: ".")
        var targetComponents = targetVersion.components(separatedBy: ".")
        let spareCount = versionComponents.count - targetComponents.count
        
        if spareCount == 0 {
            result = compare(targetVersion, options: .numeric)
        } else {
            let spareZeros = repeatElement("0", count: abs(spareCount))
            if spareCount > 0 {
                targetComponents.append(contentsOf: spareZeros)
            } else {
                versionComponents.append(contentsOf: spareZeros)
            }
            result = versionComponents.joined(separator: ".")
                .compare(targetComponents.joined(separator: "."), options: .numeric)
        }
        return result
    }
}
