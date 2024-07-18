import Foundation

/**
 メニュー種別を表現する列挙型
 */
enum MenuType: Codable {
    /** 肩 */
    case SHOULDER
    /** 胸 */
    case CHEST
    /** 背中 */
    case BACK
    /** 脚 */
    case LEG
    /** 腕 */
    case ARM
    /** コア */
    case CORE
}
