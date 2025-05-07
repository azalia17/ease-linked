//
//  Bus.swift
//  BSDLink
//
//  Created by Azalia Amanda on 02/04/25.
//

import Foundation

struct Bus: Identifiable, Codable {
    let id: String
    let code: String
    let platNumber: String
    let operationalHour: String
    var isElectric: Bool = false
}

extension Bus {
    static func getBus(by id: String) -> Bus {
        return all.first(where: { $0.id == id }) ?? Bus(id: "000", code: "000", platNumber: "xx xxxx xx", operationalHour: "00.00 - 00.00")
    }
    
    static func getBusses(by ids: [String]) -> [Bus] {
        var buses : [Bus] = []
        
        for id in ids {
            buses += all.filter { $0.id == id}
        }
            
        return buses
    }
    
    static let all: [Bus] = [
        Bus(
            id: "bus_001",
            code: "B01",
            platNumber: "B 7666 PAA",
            operationalHour: "06.00 - 21.00"
        ),
        Bus(
            id: "bus_002",
            code: "B02",
            platNumber: "B 7966 PAA",
            operationalHour: "06.00 - 21.00"
        ),
        Bus(
            id: "bus_003",
            code: "B03",
            platNumber: "B 7466 PAA",
            operationalHour: "06.00 - 21.00"
        ),
        Bus(
            id: "bus_004",
            code: "B04",
            platNumber: "B 7266 JF",
            operationalHour: "06.00 - 21.00"
        ),
        Bus(
            id: "bus_005",
            code: "B05",
            platNumber: "B 7366 JE",
            operationalHour: "06.00 - 21.00"
        ),
        Bus(
            id: "bus_007a",
            code: "B07",
            platNumber: "B 7166 PAA",
            operationalHour: "06.00 - 09.00"
        ),
        Bus(
            id: "bus_006",
            code: "B06",
            platNumber: "B 7366 PAA",
            operationalHour: "06.00 - 21.00"
        ),
        Bus(
            id: "bus_008a",
            code: "B08",
            platNumber: "B 7866 PAA",
            operationalHour: "06.00 - 09.00"
        ),
        Bus(
            id: "bus_008b",
            code: "B08",
            platNumber: "B 7166 PAA",
            operationalHour: "09.00 - 21.00"
        ),
        Bus(
            id: "bus_007b",
            code: "B07",
            platNumber: "B 7866 PAA",
            operationalHour: "09.00 - 21.00"
        ),
        Bus(
            id: "bus_009",
            code: "B09",
            platNumber: "B 7766 PAA",
            operationalHour: "06.00 - 21.00"
        ),
        Bus(
            id: "bus_010",
            code: "B10",
            platNumber: "B 7002 PGX",
            operationalHour: "06.00 - 21.00",
            isElectric: true
        ),
    ]
}
