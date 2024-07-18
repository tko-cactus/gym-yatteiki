import Foundation
import SwiftData

/**
 メニュー毎の負荷を表現するクラス
 */
@Model
class LoadByMenu: Codable, Hashable {
    /** トレーニングを一意に識別するためのID */
    var uuid: UUID = UUID()
    /** トレーニングを行った日付 */
    var date: Date
    /** メニュー */
    var menu: Menu
    /** 総レップ数 */
    var lep: Int
    /** セット数 */
    var set: Int
    /** セット間の休憩時間（秒） */
    var rest: Int
    /** ウェイトの重量（ポンド） */
    var weightPound: Double

    private init(menu: Menu, lep: Int, set: Int, rest: Int, weightPound: Double) {
        self.date = Date.now
        self.menu = menu
        self.lep = lep
        self.set = set
        self.rest = rest
        self.weightPound = weightPound
    }
    
    /** メニューを指定してインスタンスを作成する */
    
    public static func create(menu: Menu) -> LoadByMenu {
        return LoadByMenu(menu: menu, lep: 0, set: 0, rest: 0, weightPound: 0.0)
    }
    
    /** ウェイトの重量をキログラムに変換した値を返す */
    public func getWeightKg() -> Double {
        return weightPound * 0.45359237
    }
    
    /** 総負荷を計算して返す */
    public func getTotalLoad() -> Double {
        return weightPound * Double(lep) * Double(set)
    }
    
    // MARK: - Codable
    enum CodingKeys: String, CodingKey {
        case date
        case menu
        case lep
        case set
        case rest
        case weightPound
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        date = try container.decode(Date.self, forKey: .date)
        menu = try container.decode(Menu.self, forKey: .menu)
        lep = try container.decode(Int.self, forKey: .lep)
        set = try container.decode(Int.self, forKey: .set)
        rest = try container.decode(Int.self, forKey: .rest)
        weightPound = try container.decode(Double.self, forKey: .weightPound)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(date, forKey: .date)
        try container.encode(menu, forKey: .menu)
        try container.encode(lep, forKey: .lep)
        try container.encode(set, forKey: .set)
        try container.encode(rest, forKey: .rest)
        try container.encode(weightPound, forKey: .weightPound)
    }
    
    // MARK: - Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
    
    // MARK: - Equatable
    static func == (lhs: LoadByMenu, rhs: LoadByMenu) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}
