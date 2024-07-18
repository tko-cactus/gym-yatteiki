import Foundation
import SwiftData

/** メニュー種別を表現するクラス */
@Model
class Menu: Codable {
    /** トレーニングを一意に識別するためのID */
    let uuid: UUID
    /** トレーニングメニュー名 */
    let name: String
    /** メニュー種別 */
    let type: MenuType
    
    enum CodingKeys: String, CodingKey {
        case uuid
        case name
        case type
    }
    
    init(name: String, type: MenuType) {
        self.uuid = UUID()
        self.name = name
        self.type = type
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        uuid = try container.decode(UUID.self, forKey: .uuid)
        name = try container.decode(String.self, forKey: .name)
        type = try container.decode(MenuType.self, forKey: .type)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(uuid, forKey: .uuid)
        try container.encode(name, forKey: .name)
        try container.encode(type, forKey: .type)
    }
}
