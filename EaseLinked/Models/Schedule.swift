//
//  Schedule.swift
//  BSDLink
//
//  Created by Brayen Fredgin Cahyadi on 27/03/25.
//
import Foundation

struct Schedule: Identifiable, Codable {
    let id: String
    let idx: Int // if there is only one schedule bakalan 1 terus. based on pdf
    let bus: String
    let scheduleDetail: [String]
}

struct ScheduleDetail: Identifiable, Codable {
    let id: String
    let index: Int // bus stops index, urutan keberapa
    let busStop: String
    let time: [ScheduleTime]
}

struct ScheduleTime: Identifiable, Codable {
    var id = UUID()
    let time: Date
    var isRegular: Bool = true
}

extension Schedule {
    static func getSchedules(by ids: [String]) -> [Schedule] {
        var schedules : [Schedule] = []
        
        for id in ids {
            schedules += all.filter { $0.id == id}
        }
        
        return schedules
    }
    
    
    
//    static func getScheduleBusStopBasedWithTime(
//        route: Route,
//        busStopId: String,
//        index: Int,
//        fromHour: Int,
//        fromMinute: Int
//    ) -> [ScheduleTime] {
//        let startTime = timeFrom(fromHour, fromMinute)
//        let endTime = timeFrom(fromHour + 20, fromMinute)
//        
//        let matchingSchedules = Schedule.all.filter { route.schedule.contains($0.id) }
//        
//        let allDetailIDs = matchingSchedules.flatMap { $0.scheduleDetail }
//        
//        let allScheduleDetails = ScheduleDetail.getManyScheduleDetails(by: allDetailIDs)
//        
//        let matchingDetails =
//        allScheduleDetails.filter { $0.busStop == busStopId && $0.index == index }
//        
//        let filteredTimes = matchingDetails.flatMap { detail in
//            detail.time.filter { $0.time >= startTime && $0.time < endTime }
//        }
//        
//        return filteredTimes.sorted { $0.time < $1.time }
//    }
    
    static func getScheduleBusStopBasedWithTime(
        route: Route,
        busStopId: String,
        index: Int,
        fromHour: Int,
        fromMinute: Int
    ) -> [ScheduleTime] {
        // Define the start and end time range for filtering
        let startTime = timeFrom(fromHour, fromMinute)
        let endTime = timeFrom(fromHour + 20, fromMinute)
        
        // Filter schedules that belong to the specified route
        let matchingSchedules = Schedule.all.filter { route.schedule.contains($0.id) }
        
        // Gather all scheduleDetail IDs from those matching schedules
        let allDetailIDs = matchingSchedules.flatMap { $0.scheduleDetail }
        
        // Fetch all the corresponding ScheduleDetail entries using the IDs
        let allScheduleDetails = ScheduleDetail.getManyScheduleDetails(by: allDetailIDs)
        
        // Filter for details that match the busStopId and index
        let matchingDetails = allScheduleDetails.filter { $0.busStop == busStopId && $0.index == index }
        
        // Gather all ScheduleTimes from the matching details and filter by time range
        let filteredTimes = matchingDetails.flatMap { detail in
            detail.time.filter { $0.time >= startTime && $0.time < endTime }
        }
        
        // Sort the times in ascending order and return
        return filteredTimes.sorted { $0.time < $1.time }
    }

    
    static let all: [Schedule] = [
        Schedule(
            id: "r1_1",
            idx: 1,
            bus: "bus_001",
            scheduleDetail: [
                "sd_r1_b1_intermoda_1",
                "sd_r1_b1_cosmo_2",
                "sd_r1_b1_verdantView_3",
                "sd_r1_b1_eternity_4",
                "sd_r1_b1_simplicity2_5",
                "sd_r1_b1_edutown1_6",
                "sd_r1_b1_edutown2_7",
                "sd_r1_b1_ice1_8",
                "sd_r1_b1_ice2_9",
                "sd_r1_b1_ice6_10",
                "sd_r1_b1_ice5_11",
                "sd_r1_b1_gop1_12",
                "sd_r1_b1_smlPlaza_13",
                "sd_r1_b1_theBreeze_14",
                "sd_r1_b1_cbdTimur1_15",
                "sd_r1_b1_cbdTimur2_16",
                "sd_r1_b1_navaPark1_17",
                "sd_r1_b1_swa2_18",
                "sd_r1_b1_giant_19",
                "sd_r1_b1_ekaHospital1_20",
                "sd_r1_b1_puspitaloka_21",
                "sd_r1_b1_polsekSerpong_22",
                "sd_r1_b1_rukoMadrid_23",
                "sd_r1_b1_pasarModernTimur_24",
                "sd_r1_b1_griyaLoka1_25",
                "sd_r1_b1_sektor13_26",
                "sd_r1_b1_sektor13_27",
                "sd_r1_b1_griyaLoka2_28",
                "sd_r1_b1_santaUrsula1_29",
                "sd_r1_b1_santaUrsula2_30",
                "sd_r1_b1_sentraOnderdil_31",
                "sd_r1_b1_autoparts_32",
                "sd_r1_b1_ekaHospital2_33",
                "sd_r1_b1_eastBusinessDistrict_34",
                "sd_r1_b1_swa1_35",
                "sd_r1_b1_greenCove_36",
                "sd_r1_b1_theBreeze_37",
                "sd_r1_b1_cbdTimur1_38",
                "sd_r1_b1_aeonMall1_39",
                "sd_r1_b1_cbdBarat2_40",
                "sd_r1_b1_simplicity1_41",
                "sd_r1_b1_cosmo_42",
                "sd_r1_b1_verdantView_43",
                "sd_r1_b1_eternity_44",
                "sd_r1_b1_intermoda_45",
                "sd_r1_b1_iconBusinessPark_46",
                "sd_r1_b1_masjidAlUkhuwah_47",
                "sd_r1_b1_divenaDeshna_48",
                "sd_r1_b1_avani_49",
                "sd_r1_b1_amarilla_50",
                "sd_r1_b1_chadnya_51",
                "sd_r1_b1_atmajaya_52",
                "sd_r1_b1_intermoda_53"
            ]
        ),
        Schedule(
            id: "r1_2",
            idx: 2,
            bus: "bus_002",
            scheduleDetail: [
                "sd_r1_b2_intermoda_1",
                "sd_r1_b2_cosmo_2",
                "sd_r1_b2_verdantView_3",
                "sd_r1_b2_eternity_4",
                "sd_r1_b2_simplicity2_5",
                "sd_r1_b2_edutown1_6",
                "sd_r1_b2_edutown2_7",
                "sd_r1_b2_ice1_8",
                "sd_r1_b2_ice2_9",
                "sd_r1_b2_ice6_10",
                "sd_r1_b2_ice5_11",
                "sd_r1_b2_gop1_12",
                "sd_r1_b2_smlPlaza_13",
                "sd_r1_b2_theBreeze_14",
                "sd_r1_b2_cbdTimur1_15",
                "sd_r1_b2_cbdTimur2_16",
                "sd_r1_b2_navaPark1_17",
                "sd_r1_b2_swa2_18",
                "sd_r1_b2_giant_19",
                "sd_r1_b2_ekaHospital1_20",
                "sd_r1_b2_puspitaloka_21",
                "sd_r1_b2_polsekSerpong_22",
                "sd_r1_b2_rukoMadrid_23",
                "sd_r1_b2_pasarModernTimur_24",
                "sd_r1_b2_griyaLoka1_25",
                "sd_r1_b2_sektor13_26",
                "sd_r1_b2_sektor13_27",
                "sd_r1_b2_griyaLoka2_28",
                "sd_r1_b2_santaUrsula1_29",
                "sd_r1_b2_santaUrsula2_30",
                "sd_r1_b2_sentraOnderdil_31",
                "sd_r1_b2_autoparts_32",
                "sd_r1_b2_ekaHospital2_33",
                "sd_r1_b2_eastBusinessDistrict_34",
                "sd_r1_b2_swa1_35",
                "sd_r1_b2_greenCove_36",
                "sd_r1_b2_theBreeze_37",
                "sd_r1_b2_cbdTimur1_38",
                "sd_r1_b2_aeonMall1_39",
                "sd_r1_b2_cbdBarat2_40",
                "sd_r1_b2_simplicity1_41",
                "sd_r1_b2_cosmo_42",
                "sd_r1_b2_verdantView_43",
                "sd_r1_b2_eternity_44",
                "sd_r1_b2_intermoda_45",
                "sd_r1_b2_iconBusinessPark_46",
                "sd_r1_b2_masjidAlUkhuwah_47",
                "sd_r1_b2_divenaDeshna_48",
                "sd_r1_b2_avani_49",
                "sd_r1_b2_amarilla_50",
                "sd_r1_b2_chadnya_51",
                "sd_r1_b2_atmajaya_52",
                "sd_r1_b2_intermoda_53"
            ]
        ),
        Schedule(
            id: "r2_1",
            idx: 1,
            bus: "bus_003",
            scheduleDetail: [
                "sd_r2_b3_greenwichParkOffice_1",
                "sd_r2_b3_jadeite_2",
                "sd_r2_b3_deMaja_3",
                "sd_r2_b3_deHeliconia2_4",
                "sd_r2_b3_deNara_5",
                "sd_r2_b3_dePark2_6",
                "sd_r2_b3_navaPark2_7",
                "sd_r2_b3_giardina_8",
                "sd_r2_b3_collinare_9",
                "sd_r2_b3_foglio_10",
                "sd_r2_b3_studento2_11",
                "sd_r2_b3_albera_12",
                "sd_r2_b3_foresta1_13",
                "sd_r2_b3_gop1_14",
                "sd_r2_b3_smlPlaza_15",
                "sd_r2_b3_theBreeze_16",
                "sd_r2_b3_cbdTimur1_17",
                "sd_r2_b3_cbdTimur2_18",
                "sd_r2_b3_navaPark1_19",
                "sd_r2_b3_swa2_20",
                "sd_r2_b3_giant_21",
                "sd_r2_b3_ekaHospital1_22",
                "sd_r2_b3_puspitaLoka_23",
                "sd_r2_b3_polsekSerpong_24",
                "sd_r2_b3_rukoMadrid_25",
                "sd_r2_b3_pasarModernTimur_26",
                "sd_r2_b3_griyaLoka1_27",
                "sd_r2_b3_sektor13_28",
                "sd_r2_b3_sektor13_29",
                "sd_r2_b3_griyaLoka2_30",
                "sd_r2_b3_santaUrsula1_31",
                "sd_r2_b3_santaUrsula2_32",
                "sd_r2_b3_sentraOnderdil_33",
                "sd_r2_b3_autoparts_34",
                "sd_r2_b3_ekaHospital2_35",
                "sd_r2_b3_eastBusinessDistrict_36",
                "sd_r2_b3_swa1_37",
                "sd_r2_b3_greenCove_38",
                "sd_r2_b3_theBreeze_39",
                "sd_r2_b3_cbdTimur1_40",
                "sd_r2_b3_cbdTimur2_41",
                "sd_r2_b3_simpangForesta_42",
                "sd_r2_b3_allevare_43",
                "sd_r2_b3_fiore_44",
                "sd_r2_b3_studento1_45",
                "sd_r2_b3_naturale_46",
                "sd_r2_b3_fresco_47",
                "sd_r2_b3_primavera_48",
                "sd_r2_b3_foresta2_49",
                "sd_r2_b3_fbl5_50",
                "sd_r2_b3_courtsMegaStore_51",
                "sd_r2_b3_qBig1_52",
                "sd_r2_b3_lulu_53",
                "sd_r2_b3_greenwichPark1_54",
                "sd_r2_b3_greenwichParkOffice_55"

            ]
        ),
        Schedule(
            id: "r2_2",
            idx: 2,
            bus: "bus_004",
            scheduleDetail: [
                "sd_r2_b4_greenwichParkOffice_1",
                "sd_r2_b4_jadeite_2",
                "sd_r2_b4_deMaja_3",
                "sd_r2_b4_deHeliconia2_4",
                "sd_r2_b4_deNara_5",
                "sd_r2_b4_dePark2_6",
                "sd_r2_b4_navaPark2_7",
                "sd_r2_b4_giardina_8",
                "sd_r2_b4_collinare_9",
                "sd_r2_b4_foglio_10",
                "sd_r2_b4_studento2_11",
                "sd_r2_b4_albera_12",
                "sd_r2_b4_foresta1_13",
                "sd_r2_b4_gop1_14",
                "sd_r2_b4_smlPlaza_15",
                "sd_r2_b4_theBreeze_16",
                "sd_r2_b4_cbdTimur1_17",
                "sd_r2_b4_cbdTimur2_18",
                "sd_r2_b4_navaPark1_19",
                "sd_r2_b4_swa2_20",
                "sd_r2_b4_giant_21",
                "sd_r2_b4_ekaHospital1_22",
                "sd_r2_b4_puspitaLoka_23",
                "sd_r2_b4_polsekSerpong_24",
                "sd_r2_b4_rukoMadrid_25",
                "sd_r2_b4_pasarModernTimur_26",
                "sd_r2_b4_griyaLoka1_27",
                "sd_r2_b4_sektor13_28",
                "sd_r2_b4_sektor13_29",
                "sd_r2_b4_griyaLoka2_30",
                "sd_r2_b4_santaUrsula1_31",
                "sd_r2_b4_santaUrsula2_32",
                "sd_r2_b4_sentraOnderdil_33",
                "sd_r2_b4_autoparts_34",
                "sd_r2_b4_ekaHospital2_35",
                "sd_r2_b4_eastBusinessDistrict_36",
                "sd_r2_b4_swa1_37",
                "sd_r2_b4_greenCove_38",
                "sd_r2_b4_theBreeze_39",
                "sd_r2_b4_cbdTimur1_40",
                "sd_r2_b4_cbdTimur2_41",
                "sd_r2_b4_simpangForesta_42",
                "sd_r2_b4_allevare_43",
                "sd_r2_b4_fiore_44",
                "sd_r2_b4_studento1_45",
                "sd_r2_b4_naturale_46",
                "sd_r2_b4_fresco_47",
                "sd_r2_b4_primavera_48",
                "sd_r2_b4_foresta2_49",
                "sd_r2_b4_fbl5_50",
                "sd_r2_b4_courtsMegaStore_51",
                "sd_r2_b4_qBig1_52",
                "sd_r2_b4_lulu_53",
                "sd_r2_b4_greenwichPark1_54",
                "sd_r2_b4_greenwichParkOffice_55"
            ]
        ),
        Schedule(
            id: "r3_1",
            idx: 1,
            bus: "bus_005",
            scheduleDetail: [
                "sd_r3_b5_terminalIntermoda_1",
                "sd_r3_b5_simplicity2_2",
                "sd_r3_b5_edutown1_3",
                "sd_r3_b5_edutown2_4",
                "sd_r3_b5_ice1_5",
                "sd_r3_b5_ice2_6",
                "sd_r3_b5_ice6_7",
                "sd_r3_b5_ice5_8",
                "sd_r3_b5_froogy_9",
                "sd_r3_b5_gramedia_10",
                "sd_r3_b5_astra_11",
                "sd_r3_b5_courtsMegaStore_12",
                "sd_r3_b5_qBig1_13",
                "sd_r3_b5_lulu_14",
                "sd_r3_b5_greenwichPark1_15",
                "sd_r3_b5_greenwichParkOffice_16",
                "sd_r3_b5_jadeite_17",
                "sd_r3_b5_deMaja_18",
                "sd_r3_b5_deHeliconia2_19",
                "sd_r3_b5_deNara_20",
                "sd_r3_b5_dePark2_21",
                "sd_r3_b5_navaPark2_22",
                "sd_r3_b5_gop1_23",
                "sd_r3_b5_smlPlaza_24",
                "sd_r3_b5_theBreeze_25",
                "sd_r3_b5_casaDeParco2_26",
                "sd_r3_b5_lobbyHouseOfTiktokers_27",
                "sd_r3_b5_digitalHub1_28",
                "sd_r3_b5_digitalHub2_29",
                "sd_r3_b5_verdantView_30",
                "sd_r3_b5_eternity_31",
                "sd_r3_b5_intermoda_32"
            ]
        ),
        Schedule(
            id: "r3_2",
            idx: 2,
            bus: "bus_007a",
            scheduleDetail: [
                "sd_r3_b7a_terminalIntermoda_1",
                "sd_r3_b7a_simplicity2_2",
                "sd_r3_b7a_edutown1_3",
                "sd_r3_b7a_edutown2_4",
                "sd_r3_b7a_ice1_5",
                "sd_r3_b7a_ice2_6",
                "sd_r3_b7a_ice6_7",
                "sd_r3_b7a_ice5_8",
                "sd_r3_b7a_froogy_9",
                "sd_r3_b7a_gramedia_10",
                "sd_r3_b7a_astra_11",
                "sd_r3_b7a_courtsMegaStore_12",
                "sd_r3_b7a_qBig1_13",
                "sd_r3_b7a_lulu_14",
                "sd_r3_b7a_greenwichPark1_15",
                "sd_r3_b7a_greenwichParkOffice_16",
                "sd_r3_b7a_jadeite_17",
                "sd_r3_b7a_deMaja_18",
                "sd_r3_b7a_deHeliconia2_19",
                "sd_r3_b7a_deNara_20",
                "sd_r3_b7a_dePark2_21",
                "sd_r3_b7a_navaPark2_22",
                "sd_r3_b7a_gop1_23",
                "sd_r3_b7a_smlPlaza_24",
                "sd_r3_b7a_theBreeze_25",
                "sd_r3_b7a_casaDeParco2_26",
                "sd_r3_b7a_lobbyHouseOfTiktokers_27",
                "sd_r3_b7a_digitalHub1_28",
                "sd_r3_b7a_digitalHub2_29",
                "sd_r3_b7a_verdantView_30",
                "sd_r3_b7a_eternity_31",
                "sd_r3_b7a_intermoda_32"

            ]
        ),
        Schedule(
            id: "r4_1",
            idx: 1,
            bus: "bus_006",
            scheduleDetail: [
                "sd_r4_b6_intermoda_1",
                "sd_r4_b6_iconCentro_2",
                "sd_r4_b6_horizonBroadway_3",
                "sd_r4_b6_extremePark_4",
                "sd_r4_b6_saveria_5",
                "sd_r4_b6_casaDeParco1_6",
                "sd_r4_b6_smlPlaza_7",
                "sd_r4_b6_theBreeze_8",
                "sd_r4_b6_cbdTimur1_9",
                "sd_r4_b6_aeonMall1_10",
                "sd_r4_b6_aeonMall2_11",
                "sd_r4_b6_cbdTimur2_12",
                "sd_r4_b6_simpangForesta_13",
                "sd_r4_b6_allevare_14",
                "sd_r4_b6_fiore_15",
                "sd_r4_b6_studento1_16",
                "sd_r4_b6_naturale_17",
                "sd_r4_b6_fresco_18",
                "sd_r4_b6_primavera_19",
                "sd_r4_b6_foresta2_20",
                "sd_r4_b6_dePark1_21",
                "sd_r4_b6_deFrangpani_22",
                "sd_r4_b6_deHeliconia1_23",
                "sd_r4_b6_deBrassia_24",
                "sd_r4_b6_jadeite_25",
                "sd_r4_b6_greenwichPark2_26",
                "sd_r4_b6_qBig2_27",
                "sd_r4_b6_qBig3_28",
                "sd_r4_b6_bca_29",
                "sd_r4_b6_fbl2_30",
                "sd_r4_b6_fbl1_31",
                "sd_r4_b6_ice1_32",
                "sd_r4_b6_ice2_33",
                "sd_r4_b6_ice6_34",
                "sd_r4_b6_ice5_35",
                "sd_r4_b6_cbdBarat1_36",
                "sd_r4_b6_cbdBarat2_37",
                "sd_r4_b6_simplicity1_38",
                "sd_r4_b6_intermoda_39"

            ]
        ),
        Schedule(
            id: "r4_2",
            idx: 2,
            bus: "bus_008a",
            scheduleDetail: [
                "sd_r4_b8a_intermoda_1",
                "sd_r4_b8a_iconCentro_2",
                "sd_r4_b8a_horizonBroadway_3",
                "sd_r4_b8a_extremePark_4",
                "sd_r4_b8a_saveria_5",
                "sd_r4_b8a_casaDeParco1_6",
                "sd_r4_b8a_smlPlaza_7",
                "sd_r4_b8a_theBreeze_8",
                "sd_r4_b8a_cbdTimur1_9",
                "sd_r4_b8a_aeonMall1_10",
                "sd_r4_b8a_aeonMall2_11",
                "sd_r4_b8a_cbdTimur2_12",
                "sd_r4_b8a_simpangForesta_13",
                "sd_r4_b8a_allevare_14",
                "sd_r4_b8a_fiore_15",
                "sd_r4_b8a_studento1_16",
                "sd_r4_b8a_naturale_17",
                "sd_r4_b8a_fresco_18",
                "sd_r4_b8a_primavera_19",
                "sd_r4_b8a_foresta2_20",
                "sd_r4_b8a_dePark1_21",
                "sd_r4_b8a_deFrangpani_22",
                "sd_r4_b8a_deHeliconia1_23",
                "sd_r4_b8a_deBrassia_24",
                "sd_r4_b8a_jadeite_25",
                "sd_r4_b8a_greenwichPark2_26",
                "sd_r4_b8a_qBig2_27",
                "sd_r4_b8a_qBig3_28",
                "sd_r4_b8a_bca_29",
                "sd_r4_b8a_fbl2_30",
                "sd_r4_b8a_fbl1_31",
                "sd_r4_b8a_ice1_32",
                "sd_r4_b8a_ice2_33",
                "sd_r4_b8a_ice6_34",
                "sd_r4_b8a_ice5_35",
                "sd_r4_b8a_cbdBarat1_36",
                "sd_r4_b8a_cbdBarat2_37",
                "sd_r4_b8a_simplicity1_38",
                "sd_r4_b8a_intermoda_39"

            ]
        ),
        Schedule(
            id: "r5_1",
            idx: 1,
            bus: "bus_007b",
            scheduleDetail: [
                "sd_r5_b7_theBreeze_1",
                "sd_r5_b7_cbdTimur1_2",
                "sd_r5_b7_lobbyAeonMall_3",
                "sd_r5_b7_aeonMall2_4",
                "sd_r5_b7_cbdUtara3_5",
                "sd_r5_b7_ice1_6",
                "sd_r5_b7_ice2_7",
                "sd_r5_b7_ice6_8",
                "sd_r5_b7_ice5_9",
                "sd_r5_b7_cbdBarat1_10",
                "sd_r5_b7_cbdBarat2_11",
                "sd_r5_b7_lobbyAeonMall_12",
                "sd_r5_b7_aeonMall2_13",
                "sd_r5_b7_cbdTimur2_14",
                "sd_r5_b7_navaPark1_15",
                "sd_r5_b7_greenCove_16",
                "sd_r5_b7_theBreeze_17"
            ]
        ),
        Schedule(
            id: "r5_2",
            idx: 2,
            bus: "bus_008b",
            scheduleDetail: [
                "sd_r5_b8_theBreeze_1",
                "sd_r5_b8_cbdTimur1_2",
                "sd_r5_b8_lobbyAeonMall_3",
                "sd_r5_b8_aeonMall2_4",
                "sd_r5_b8_cbdUtara3_5",
                "sd_r5_b8_ice1_6",
                "sd_r5_b8_ice2_7",
                "sd_r5_b8_ice6_8",
                "sd_r5_b8_ice5_9",
                "sd_r5_b8_cbdBarat1_10",
                "sd_r5_b8_cbdBarat2_11",
                "sd_r5_b8_lobbyAeonMall_12",
                "sd_r5_b8_aeonMall2_13",
                "sd_r5_b8_cbdTimur2_14",
                "sd_r5_b8_navaPark1_15",
                "sd_r5_b8_greenCove_16",
                "sd_r5_b8_theBreeze_17"
            ]
        ),
        Schedule(
            id: "r6_1",
            idx: 1,
            bus: "bus_009",
            scheduleDetail: [
                "sd_r6_b9_intermoda_1",
                "sd_r6_b9_simplicity2_2",
                "sd_r6_b9_edutown1_3",
                "sd_r6_b9_edutown2_4",
                "sd_r6_b9_ice1_5",
                "sd_r6_b9_ice2_6",
                "sd_r6_b9_ice6_7",
                "sd_r6_b9_prestigia_8",
                "sd_r6_b9_theMozia1_9",
                "sd_r6_b9_piazziaMozia_10",
                "sd_r6_b9_tabebuya_11",
                "sd_r6_b9_vanyaPark_12",
                "sd_r6_b9_theMozia2_13",
                "sd_r6_b9_illustria_14",
                "sd_r6_b9_ice2_15",
                "sd_r6_b9_ice6_16",
                "sd_r6_b9_ice5_17",
                "sd_r6_b9_cbdBarat1_18",
                "sd_r6_b9_cbdBarat2_19",
                "sd_r6_b9_simplicity1_20",
                "sd_r6_b9_intermoda_21"
            ]
        ),
        Schedule(
            id: "r7_1",
            idx: 1,
            bus: "bus_010",
            scheduleDetail: [
                "sd_r7_b10_terminalIntermoda_1",
                "sd_r7_b10_simplicity2_2",
                "sd_r7_b10_edutown1_3",
                "sd_r7_b10_edutown2_4",
                "sd_r7_b10_ice1_5",
                "sd_r7_b10_ice2_6",
                "sd_r7_b10_ice6_7",
                "sd_r7_b10_ice5_8",
                "sd_r7_b10_froogy_9",
                "sd_r7_b10_gramedia_10",
                "sd_r7_b10_astra_11",
                "sd_r7_b10_courtsMegaStore_12",
                "sd_r7_b10_qBig1_13",
                "sd_r7_b10_lulu_14",
                "sd_r7_b10_qBig2_15",
                "sd_r7_b10_qBig3_16",
                "sd_r7_b10_bca_17",
                "sd_r7_b10_fbl2_18",
                "sd_r7_b10_fbl1_19",
                "sd_r7_b10_gop1_20",
                "sd_r7_b10_smlPlaza_21",
                "sd_r7_b10_theBreeze_22",
                "sd_r7_b10_casaDeParco2_23",
                "sd_r7_b10_lobbyHouseOfTiktokers_24",
                "sd_r7_b10_digitalHub1_25",
                "sd_r7_b10_saveria_26",
                "sd_r7_b10_casaDeParco1_27",
                "sd_r7_b10_cbdTimur1_28",
                "sd_r7_b10_lobbyAeonMall_29",
                "sd_r7_b10_aeonMall2_30",
                "sd_r7_b10_cbdBarat2_31",
                "sd_r7_b10_simplicity1_32",
                "sd_r7_b10_intermoda_33"
            ]
        )
    ]
}

// Custom decoding for time to handle missing 'isRegular' in JSON
struct TimeDecoder: Codable {
    let hour: Int
    let minute: Int
    let isRegular: Bool?

    // Computed property for date
    var date: Date {
        let calendar = Calendar.current
        let date = calendar.date(bySettingHour: hour, minute: minute, second: 0, of: Date())!
        return date
    }

    // Custom initializer for 'isRegular' to default to true if missing
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        hour = try container.decode(Int.self, forKey: .hour)
        minute = try container.decode(Int.self, forKey: .minute)
        isRegular = try container.decodeIfPresent(Bool.self, forKey: .isRegular) ?? true
    }

    private enum CodingKeys: String, CodingKey {
        case hour, minute, isRegular
    }
}

extension ScheduleDetail {
    // Custom decoding to handle the 'time' array
        private enum CodingKeys: String, CodingKey {
            case id, index, busStop = "BusStop", time
        }

        // Custom initializer for decoding 'time' and handling 'isRegular' default
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            id = try container.decode(String.self, forKey: .id)
            index = try container.decode(Int.self, forKey: .index)
            busStop = try container.decode(String.self, forKey: .busStop)
            
            // Decode time and map to ScheduleTime
            let timeArray = try container.decode([TimeDecoder].self, forKey: .time)
            time = timeArray.map { ScheduleTime(time: $0.date, isRegular: $0.isRegular ?? true) }
        }
    
    static func getScheduleDetail(by id: String) -> ScheduleDetail {
        return all.first(where: {$0.id == id}) ?? ScheduleDetail(id: "", index: 0, busStop: "", time: [])
    }
    
    static func getManyScheduleDetails(by ids: [String]) -> [ScheduleDetail] {
        var schedules : [ScheduleDetail] = []
        
        for id in ids {
            schedules += all.filter { $0.id == id }
        }
        
        return schedules
    }
    
    static func getScheduleTime(schedule: [String], index: Int, busStopId: String) -> [ScheduleTime] {
        print()
        return getManyScheduleDetails(by: schedule).filter { $0.index == index && $0.busStop == busStopId }.first?.time ?? [ScheduleTime(time: timeFrom(0, 0))]
    }
    
    static let all: [ScheduleDetail] = load("scheduleDetail.json")
    
}

func timeFrom(_ hour: Int, _ minute: Int) -> Date {
    return Calendar.current.date(from: DateComponents(hour: hour, minute: minute))!
}

func load<T: Decodable>(_ filename: String) -> T {
    let data: Data

    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else {
        fatalError("Couldn't find \(filename) in main bundle.")
    }

    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }

    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}
