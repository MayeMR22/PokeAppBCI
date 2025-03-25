struct FormatHelper {
    static func toMeters(_ value: Double?) -> String {
        guard let value else { return "0.0 m" }
        return String(format: "%.1f m", value / 10.0)
    }

    static func toKilograms(_ value: Double?) -> String {
        guard let value else { return "0.0 kg" }
        return String(format: "%.1f kg", value / 10.0)
    }
}
