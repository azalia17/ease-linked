
import Foundation
import MapKit
import SwiftUI

struct Route: Identifiable, Codable {
    let id: String
    let name: String
    let routeNumber: Int
    let busStops: [String]
    let bus: [String]
    let schedule: [String]
    let note: [String]
    let colorName: String  // e.g., "red", "green"

    var color: Color {
        Color.from(name: colorName)
    }
    
}

extension Route {
    func getRouteGeneralDetail(routeid: String) -> (String, Int, [String]){
        let route = Route.all.filter {$0.id == routeid}.first ?? Route(id: "xx", name: "xx", routeNumber: 0, busStops: [], bus: [], schedule: [], note: ["xx"], colorName: "black")
        return (route.name, route.routeNumber, route.note)
    }
    
    static let all: [Route] = [
        Route(
            id: "route_1",
            name: "Intermoda - Sektor 1.3 - Intermoda",
            routeNumber: 1,
            busStops: [
                "intermoda",
                "cosmo",
                "verdantView",
                "eternity",
                "simplicity2",
                "edutown1",
                "edutown2",
                "ice1",
                "ice2",
                "ice6",
                "ice5",
                "gop1",
                "smlPlaza",
                "theBreeze",
                "cbdTimur1",
                "cbdTimur2",
                "navaPark1",
                "swa2",
                "giant",
                "ekaHospital1",
                "puspitaLoka",
                "polsekSerpong",
                "rukoMadrid",
                "pasarModernTimur",
                "griyaLoka1",
                "sektor13",
                "sektor13",
                "griyaLoka2",
                "santaUrsula1",
                "santaUrsula2",
                "sentraOnderdil",
                "autoparts",
                "ekaHospital2",
                "eastBusinessDistrict",
                "swa1",
                "greenCove",
                "theBreeze",
                "cbdTimur1",
                "aeonMall1",
                "cbdBarat2",
                "simplicity1",
                "cosmo",
                "verdantView",
                "eternity",
                "intermoda",
                "iconBusinessPark",
                "masjidAlUkhuwah",
                "divenaDeshna",
                "avani",
                "amarilla",
                "chadnya",
                "atmajaya",
                "intermoda"
            ],
            bus: ["bus_001", "bus_002"],
            schedule: ["r1_1", "r1_2"],
            note: [
                "**TIME TABLE IS SUBJECT TO CHANGE** DEPENDING ON OPERATIONAL CONDITIONS AND TRAFFIC",
                "**THE BREEZE** and **ICE 6** STOPS AND WAITS FOR **1 MINUTE OR ADJUSTS** ACCORDING TO THE SCHEDULE"
            ],
            colorName: "green"
        ),
        
        Route(
            id: "route_2",
            name: "Greenwich - Sektor 1.3 - Greenwich",
            routeNumber: 2,
            busStops: [
                "greenwichParkOffice",
                "jadeite",
                "deMaja",
                "deHeliconia2",
                "deNara",
                "dePark2",
                "navaPark2",
                "giardina",
                "collinare",
                "foglio",
                "studento2",
                "albera",
                "foresta1",
                "gop1",
                "smlPlaza",
                "theBreeze",
                "cbdTimur1",
                "cbdTimur2",
                "navaPark1",
                "swa2",
                "giant",
                "ekaHospital1",
                "puspitaLoka",
                "polsekSerpong",
                "rukoMadrid",
                "pasarModernTimur",
                "griyaLoka1",
                "sektor13",
                "sektor13",
                "griyaLoka2",
                "santaUrsula1",
                "santaUrsula2",
                "sentraOnderdil",
                "autoparts",
                "ekaHospital2",
                "eastBusinessDistrict",
                "swa1",
                "greenCove",
                "theBreeze",
                "cbdTimur1",
                "cbdTimur2",
                "simpangForesta",
                "allevare",
                "fiore",
                "studento1",
                "naturale",
                "fresco",
                "primavera",
                "foresta2",
                "fbl5",
                "courtsMegaStore",
                "qBig1",
                "lulu",
                "greenwichPark1",
                "greenwichParkOffice"
            ],
            bus: ["bus_003", "bus_004"],
            schedule: ["r2_1", "r2_2"],
            note: [
                "**TIME TABLE IS SUBJECT TO CHANGE** DEPENDING ON OPERATIONAL CONDITIONS AND TRAFFIC",
                "**THE BREEZE** STOPS AND WAITS FOR **1 MINUTE OR ADJUSTS** ACCORDING TO THE SCHEDULE"
                
            ],
            colorName: "cyan"
        ),
        
        Route(
            id: "route_3",
            name: "Intermoda - De Park - Intermoda (R1)",
            routeNumber: 3,
            busStops: [
                "intermoda",
                "simplicity2",
                "edutown1",
                "edutown2",
                "ice1",
                "ice2",
                "ice6",
                "ice5",
                "froogy",
                "gramedia",
                "astra",
                "courtsMegaStore",
                "qBig1",
                "lulu",
                "greenwichPark1",
                "greenwichParkOffice",
                "jadeite",
                "deMaja",
                "deHeliconia2",
                "deNara",
                "dePark2",
                "navaPark2",
                "gop1",
                "smlPlaza",
                "theBreeze",
                "casaDeParco2",
                "lobbyHouseOfTiktokers",
                "digitalHub1",
                "digitalHub2",
                "verdantView",
                "eternity",
                "intermoda"
            ],
            bus: ["bus_005", "bus_007a"],
            schedule: ["r3_1", "r3_2"],
            note: [
                "**TIME TABLE IS SUBJECT TO CHANGE** DEPENDING ON OPERATIONAL CONDITIONS AND TRAFFIC",
                "**THE BREEZE** and **ICE 6** STOPS AND WAITS FOR **1 MINUTE OR ADJUSTS** ACCORDING TO THE SCHEDULE"
            ],
            colorName: "indigo"
        ),
        
        Route(
            id: "route_4",
            name: "Intermoda - De Park - Intermoda (R2)",
            routeNumber: 4,
            busStops: [
                "intermoda",
                "iconCentro",
                "horizonBroadway",
                "extremePark",
                "saveria",
                "casaDeParco1",
                "smlPlaza",
                "theBreeze",
                "cbdTimur1",
                "aeonMall1",
                "aeonMall2",
                "cbdTimur2",
                "simpangForesta",
                "allevare",
                "fiore",
                "studento1",
                "naturale",
                "fresco",
                "primavera",
                "foresta2",
                "dePark1",
                "deFrangpani",
                "deHeliconia1",
                "deBrassia",
                "jadeite",
                "greenwichPark2",
                "qBig2",
                "qBig3",
                "bca",
                "fbl2",
                "fbl1",
                "ice1",
                "ice2",
                "ice6",
                "ice5",
                "cbdBarat1",
                "cbdBarat2",
                "simplicity1",
                "intermoda"
            ],
            bus: ["bus_006", "bus_008a"],
            schedule: ["r4_1", "r4_2"],
            note: [
                "**TIME TABLE IS SUBJECT TO CHANGE** DEPENDING ON OPERATIONAL CONDITIONS AND TRAFFIC",
                "**THE BREEZE** and **ICE 6** STOPS AND WAITS FOR **1 MINUTE OR ADJUSTS** ACCORDING TO THE SCHEDULE"
            ],
            colorName: "purple"
        ),
        
        Route(
            id: "route_5",
            name: "The Breeze - AEON Mall - ICE - AEON Mall - The Breeze",
            routeNumber: 5,
            busStops: [
                "theBreeze",
                "cbdTimur1",
                "lobbyAeonMall",
                "aeonMall2",
                "cbdUtara3",
                "ice1",
                "ice2",
                "ice6",
                "ice5",
                "cbdBarat1",
                "cbdBarat2",
                "lobbyAeonMall",
                "aeonMall2",
                "cbdTimur2",
                "navaPark1",
                "greenCove",
                "theBreeze"
            ],
            bus: ["bus_007b", "bus_008b"],
            schedule: ["r5_1", "r5_2"],
            note: [
                "**TIME TABLE IS SUBJECT TO CHANGE** DEPENDING ON OPERATIONAL CONDITIONS AND TRAFFIC",
                "**ICE 2** STOPS AND WAITS FOR **4 MINUTE OR ADJUSTS** ACCORDING TO THE SCHEDULE",
                "**ICE 6** STOPS AND WAITS FOR **1 MINUTE OR ADJUSTS** ACCORDING TO THE SCHEDULE"
            ],
            colorName: "pink"
        ),
        
        Route(
            id: "route_6",
            name: "Intermoda - Vanya Park - Intermoda",
            routeNumber: 6,
            busStops: [
                "intermoda",
                "simplicity2",
                "edutown1",
                "edutown2",
                "ice1",
                "ice2",
                "ice6",
                "prestigia",
                "theMozia1",
                "piazziaMozia",
                "tabebuya",
                "vanyaPark",
                "theMozia2",
                "illustria",
                "ice2",
                "ice6",
                "ice5",
                "cbdBarat1",
                "cbdBarat2",
                "simplicity1",
                "intermoda"
            ],
            bus: ["bus_009"],
            schedule: ["r6_1"],
            note: [
                "**TIME TABLE IS SUBJECT TO CHANGE** DEPENDING ON OPERATIONAL CONDITIONS AND TRAFFIC",
                "**VANYA PARK** and **ICE 6** STOPS AND WAITS FOR **1 MINUTE OR ADJUSTS** ACCORDING TO THE SCHEDULE"
            ],
            colorName: "orange"
        ),
        
        Route(
            id: "route_7",
            name: "Intermoda - CBD - Intermoda",
            routeNumber: 7,
            busStops: [
                "intermoda",
                "simplicity2",
                "edutown1",
                "edutown2",
                "ice1",
                "ice2",
                "ice6",
                "ice5",
                "froogy",
                "gramedia",
                "astra",
                "courtsMegaStore",
                "qBig1",
                "lulu",
                "qBig2",
                "qBig3",
                "bca",
                "fbl2",
                "fbl1",
                "gop1",
                "smlPlaza",
                "theBreeze",
                "casaDeParco2",
                "lobbyHouseOfTiktokers",
                "digitalHub1",
                "saveria",
                "casaDeParco1",
                "cbdTimur1",
                "lobbyAeonMall",
                "aeonMall2",
                "cbdBarat2",
                "simplicity1",
                "intermoda"
            ],
            bus: ["bus_010"],
            schedule: ["r7_1"],
            note: [
                "**TIME TABLE IS SUBJECT TO CHANGE** DEPENDING ON OPERATIONAL CONDITIONS AND TRAFFIC",
                "**QBIG** STOPS AND WAITS FOR **1 MINUTE OR ADJUSTS** ACCORDING TO THE SCHEDULE",
                "**THE BREEZE** STOPS AND WAITS FOR **2 MINUTE OR ADJUSTS** ACCORDING TO THE SCHEDULE",
                "**LOBBY AEON MALL** STOPS AND WAITS FOR **3 MINUTE OR ADJUSTS** ACCORDING TO THE SCHEDULE"
            ],
            colorName: "brown"
        )
    ]
}
