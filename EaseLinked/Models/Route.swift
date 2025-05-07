
import Foundation
import MapKit

struct Route: Identifiable, Codable {
    let id: String
    let name: String
    let routeNumber: Int
    let busStops: [String]
    let bus: [String]
    let schedule: [String]
    let note: [String]
}

extension Route {
    func getRouteGeneralDetail(routeid: String) -> (String, Int, [String]){
        let route = Route.all.filter {$0.id == routeid}.first ?? Route(id: "xx", name: "xx", routeNumber: 0, busStops: [], bus: [], schedule: [], note: ["xx"])
        return (route.name, route.routeNumber, route.note)
    }

    // Returns the schedule for a bus stop (for simplicity, assume the bus stop is indexed)
//    func getSchedule(for busStopID: String) -> [ScheduleDetail] {
//        // Fetch the schedule for this bus stop from the route's schedule
//        return self.schedule
//            .flatMap { Schedule.getSchedules(by: [$0]) }
//            .flatMap { ScheduleDetail.getManyScheduleDetails(by: [$0.scheduleDetail])}
//            .flatMap { $0.scheduleDetail }
//            .filter { $0.busStop == busStopID }
//    }
//    
    
//    static.le
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
//                "iceBusinessPark",
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
//                "cbdSelatan1",
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
                "TIME TABLE SEWAKTU - WAKTU DAPAT BERUBAH MENYESUAIKAN KONDISI OPERASIONAL DAN TRAFFIC",
                "JADWAL BERWARNA KUNING HANYA BERLAKU, SABTU, MINGGU DAN HARI LIBUR BERLAKU",
                "THE BREEZE BERHENTI DAN MENUNGGU 1 MENIT ATAU MENYESUAIKAN DENGAN JADWAL",
                "ICE 6 BERHENTI DAN MENUNGGU 1 MENIT ATAU MENYESUAIKAN DENGAN JADWAL"
            ]
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
//            schedule: ["r1_1"],
            schedule: ["r2_1", "r2_2"],
            note: [
                "TIME TABLE SEWAKTU - WAKTU DAPAT BERUBAH MENYESUAIKAN KONDISI OPERASIONAL DAN TRAFFIC",
                "JADWAL BERWARNA KUNING HANYA BERLAKU, SABTU, MINGGU DAN HARI LIBUR BERLAKU",
                "THE BREEZE BERHENTI DAN MENUNGGU 1 MENIT ATAU MENYESUAIKAN DENGAN JADWAL",
            ]
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
//                "iceBusinessPark",
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
                "TIME TABLE SEWAKTU - WAKTU DAPAT BERUBAH MENYESUAIKAN KONDISI OPERASIONAL DAN TRAFFIC",
                "JADWAL BERWARNA KUNING HANYA BERLAKU, SABTU, MINGGU DAN HARI LIBUR BERLAKU",
                "ICE 6 BERHENTI DAN MENUNGGU 1 MENIT ATAU MENYESUAIKAN DENGAN JADWAL",
                "THE BREEZE BERHENTI DAN MENUNGGU 1 MENIT ATAU MENYESUAIKAN DENGAN JADWAL"
            ]
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
//                "iceBusinessPark",
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
                "TIME TABLE SEWAKTU - WAKTU DAPAT BERUBAH MENYESUAIKAN KONDISI OPERASIONAL DAN TRAFFIC",
                "JADWAL BERWARNA KUNING HANYA BERLAKU, SABTU, MINGGU DAN HARI LIBUR BERLAKU",
                "ICE 6 BERHENTI DAN MENUNGGU 1 MENIT ATAU MENYESUAIKAN DENGAN JADWAL",
                "THE BREEZE BERHENTI DAN MENUNGGU 1 MENIT ATAU MENYESUAIKAN DENGAN JADWAL"
            ]
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
                "TIME TABLE SEWAKTU - WAKTU DAPAT BERUBAH MENYESUAIKAN KONDISI OPERASIONAL DAN TRAFFIC",
                "JADWAL BERWARNA KUNING HANYA BERLAKU, SABTU, MINGGU DAN HARI LIBUR BERLAKU",
                "LOBBY AEON MALL BERHENTI MENUNGGU 5 MENIT ATAU MENYESUAIKAN DENGAN JADWAL",
                "ICE 2 BERHENTI MENUNGGU 4 MENIT ATAU MENYESUAIKAN DENGAN JADWAL",
                "ICE 6 BERHENTI DAN MENUNGGU 1 MENIT ATAU MENYESUAIKAN DENGAN JADWAL"
            ]
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
//                "iceBusinessPark",
                "ice6",
                "prestigia",
//                "rukoTheLoop",
                "theMozia1",
                "piazziaMozia",
//                "grandLucky1",
                "tabebuya",
//                "westPark",
                "vanyaPark",
//                "grandLucky1",
                "theMozia2",
                "illustria",
                "ice2",
//                "iceBusinessPark",
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
                "TIME TABLE SEWAKTU - WAKTU DAPAT BERUBAH MENYESUAIKAN KONDISI OPERASIONAL DAN TRAFFIC",
                "JADWAL BERWARNA KUNING HANYA BERLAKU, SABTU, MINGGU DAN HARI LIBUR BERLAKU",
                "ICE 6 BERHENTI DAN MENUNGGU 1 MENIT ATAU MENYESUAIKAN DENGAN JADWAL",
                "VANYA PARK BERHENTI DAN MENUNGGU 1 MENIT ATAU MENYESUAIKAN DENGAN JADWAL"
            ]
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
                "TIME TABLE SEWAKTU - WAKTU DAPAT BERUBAH MENYESUAIKAN KONDISI OPERASIONAL DAN TRAFFIC",
                "JADWAL BERWARNA KUNING HANYA BERLAKU, SABTU, MINGGU DAN HARI LIBUR BERLAKU",
                "QBIG BERHENTI DAN MENUNGGU 1 MENIT ATAU MENYESUAIKAN DENGAN JADWAL",
                "THE BREEZE BERHENTI DAN MENUNGGU 2 MENIT ATAU MENYESUAIKAN DENGAN JADWAL",
                "LOBBY AEON MALL BERHENTI DAN MENUNGGU 3 MENIT ATAU MENYESUAIKAN DENGAN JADWAL"
            ]
        )
    ]
}
