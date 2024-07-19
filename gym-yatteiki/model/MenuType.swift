import Foundation

/**
 メニュー種別を表現する列挙型
 */
enum MenuType: String, Codable, CaseIterable {
/** 肩 */
    case SHOULDER = "Shoulder"
    /** 胸 */
    case CHEST = "Chest"
    /** 背中 */
    case BACK = "Back"
    /** 脚 */
    case LEG = "Leg"
    /** 腕 */
    case ARM = "Arm"
    /** コア */
    case CORE = "Core"
}
