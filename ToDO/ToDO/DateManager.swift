//
//  DateManager.swift
//  ToDO
//
//  Created by 김기현 on 2023/08/28.
//

import Foundation


class DateManager {
    static let shared = DateManager() // 싱글톤 인스턴스
    
    private init() {} // 외부에서 인스턴스 생성 방지
    
    func formattedDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: date)
    }
}
