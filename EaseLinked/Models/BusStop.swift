import Foundation
import MapKit

struct BusStop: Identifiable, Codable {
    let id: String
    let name: String
    let latitude: Double
    let longitude: Double
//    let schedule: [Schedule]
    let images: [String]
    let routes: [String]
    //    let id: String
    //    let name: String
    //    let coordinates: CLLocationCoordinate2D
    //    //    let schedule: [String]
    //    let images: [String]
    //    let routes: [String]
    //    var isBigHalte: Bool = false
}




extension BusStop {
    
    var isTransitStop: Bool {
        return routes.count > 1
    }
    
    static func getSingleStop(by id: String) -> BusStop {
        return all.first(where: {$0.id == id}) ?? BusStop(id: "", name: "xx", latitude: 0.0, longitude: 0.0, images: [], routes: [])
    }
    
    static func getStops(by ids: [String]) -> [BusStop] {
        var stops : [BusStop] = []
        
        for id in ids {
            stops += all.filter { $0.id == id}
        }
            
        return stops
    }
    
//    static let all: [BusStop] = [
//             BusStop(id: "intermoda", name: "Intermoda", latitude: CLLocationCoordinate2D.intermoda.latitude, longitude: CLLocationCoordinate2D.intermoda.longitude, images: ["Intermoda_1", "Intermoda_2"], routes: ["route_1"]),
//             BusStop(id: "bs_aeon_mall_1", name: "Aeon Mall 1", latitude: CLLocationCoordinate2D.intermoda.latitude, longitude: CLLocationCoordinate2D.intermoda.longitude, images: ["Intermoda_1", "Intermoda_2"], routes: ["route_1"]),
//         ]
    
    
    static let all: [BusStop] = [
        
        BusStop(
            id: "aeonMall1",
            name: "Aeon Mall 1",
            latitude: CLLocationCoordinate2D.aeonMall1.latitude,
            longitude: CLLocationCoordinate2D.aeonMall1.longitude,
            images: ["Aeon Mall 1_1", "Aeon Mall 1_2"],
            routes: ["route_1", "route_4", "route_7"]
        ),
        BusStop(
            id: "aeonMall2",
            name: "Aeon Mall 2",
            latitude: CLLocationCoordinate2D.aeonMall2.latitude,
            longitude: CLLocationCoordinate2D.aeonMall2.longitude,
            images: ["Aeon Mall 2_1"],
            routes: ["route_5", "route_7"]
        ),
        BusStop(
            id: "albera",
            name: "Albera",
            latitude: CLLocationCoordinate2D.albera.latitude,
            longitude: CLLocationCoordinate2D.albera.longitude,
            images: ["Albera_1"],
            routes: ["route_2", "route_3"]
        ),
        BusStop(
            id: "allevare",
            name: "Allevare",
            latitude: CLLocationCoordinate2D.allevare.latitude,
            longitude: CLLocationCoordinate2D.allevare.longitude,
            images: ["Allevare_1"],
            routes: ["route_2", "route_4"]
        ),
        BusStop(
            id: "amarilla",
            name: "Amarilla",
            latitude: CLLocationCoordinate2D.amarilla.latitude,
            longitude: CLLocationCoordinate2D.amarilla.longitude,
            images: ["Amarilla_1"],
            routes: ["route_1"]
        ),
        BusStop(
            id: "astra",
            name: "Astra",
            latitude: CLLocationCoordinate2D.astra.latitude,
            longitude: CLLocationCoordinate2D.astra.longitude,
            images: ["Astra_1"],
            routes: ["route_3", "route_7"]
        ),
        BusStop(
            id: "atmajaya",
            name: "Atmajaya",
            latitude: CLLocationCoordinate2D.atmajaya.latitude,
            longitude: CLLocationCoordinate2D.atmajaya.longitude,
            images: ["Atmajaya_1"],
            routes: ["route_1"]
        ),
        BusStop(
            id: "autoparts",
            name: "Autoparts",
            latitude: CLLocationCoordinate2D.autoparts.latitude,
            longitude: CLLocationCoordinate2D.autoparts.longitude,
            images: ["Autoparts_1"],
            routes: ["route_1", "route_2"]
        ),
        BusStop(
            id: "avani",
            name: "Avani",
            latitude: CLLocationCoordinate2D.avani.latitude,
            longitude: CLLocationCoordinate2D.avani.longitude,
            images: ["Avani_1"],
            routes: ["route_1"]
        ),
        
        BusStop(
            id: "digitalHub1",
            name: "Digital Hub 1",
            latitude: CLLocationCoordinate2D.bmcDigitalHub1.latitude,
            longitude: CLLocationCoordinate2D.bmcDigitalHub1.longitude,
            images: ["Digital Hub 1_1", "Digital Hub 1_2"],
            routes: ["route_3", "route_7"]
        ),
        
        BusStop(
            id: "lobbyHouseOfTiktokers",
            name: "Lobby House of Tiktokers",
            latitude: CLLocationCoordinate2D.bmcDigitalHub1.latitude,
            longitude: CLLocationCoordinate2D.bmcDigitalHub1.longitude,
            images: ["Digital Hub 1_1", "Digital Hub 1_2"],
            routes: ["route_3", "route_7"]
        ),
        
        BusStop(
            id: "bca",
            name: "BCA",
            latitude: CLLocationCoordinate2D.bca.latitude,
            longitude: CLLocationCoordinate2D.bca.longitude,
            images: ["BCA_1", "BCA_2"],
            routes: ["route_4", "route_7"]
        ),

        BusStop(
            id: "casaDeParco1",
            name: "Casa De Parco 1",
            latitude: CLLocationCoordinate2D.casaDeParco1.latitude,
            longitude: CLLocationCoordinate2D.casaDeParco1.longitude,
            images: ["Casa De Parco 1_1"],
            routes: ["route_4", "route_7"]
        ),

        BusStop(
            id: "casaDeParco2",
            name: "Casa De Parco 2",
            latitude: CLLocationCoordinate2D.casaDeParco2.latitude,
            longitude: CLLocationCoordinate2D.casaDeParco2.longitude,
            images: ["Casa De Parco 2_1"],
            routes: ["route_3", "route_7"]
        ),

        BusStop(
            id: "cbdBarat1",
            name: "CBD Barat 1",
            latitude: CLLocationCoordinate2D.cbdBarat1.latitude,
            longitude: CLLocationCoordinate2D.cbdBarat1.longitude,
            images: ["CBD Barat 1_1"],
            routes: ["route_4", "route_5", "route_6"]
        ),

        BusStop(
            id: "cbdBarat2",
            name: "CBD Barat 2",
            latitude: CLLocationCoordinate2D.cbdBarat2.latitude,
            longitude: CLLocationCoordinate2D.cbdBarat2.longitude,
            images: ["CBD Barat 2_1"],
            routes: ["route_1", "route_4", "route_5", "route_6", "route_7"]
        ),

        BusStop(
            id: "cbdSelatan1",
            name: "CBD Selatan 1",
            latitude: CLLocationCoordinate2D.cbdSelatan1.latitude,
            longitude: CLLocationCoordinate2D.cbdSelatan1.longitude,
            images: [""],
            routes: ["route_1", "route_4", "route_5", "route_7"]
        ),

        BusStop(
            id: "cbdTimur1",
            name: "CBD Timur 1",
            latitude: CLLocationCoordinate2D.cbdTimur1.latitude,
            longitude: CLLocationCoordinate2D.cbdTimur1.longitude,
            images: ["CBD Timur 1_1"],
            routes: ["route_1", "route_2", "route_4", "route_5", "route_7"]
        ),

        BusStop(
            id: "cbdTimur2",
            name: "CBD Timur 2",
            latitude: CLLocationCoordinate2D.cbdTimurGop2.latitude,
            longitude: CLLocationCoordinate2D.cbdTimurGop2.longitude,
            images: ["CBD Timur 2_1"],
            routes: ["route_1", "route_2", "route_4", "route_5"]
        ),

        BusStop(
            id: "cbdUtara3",
            name: "CBD Utara 3",
            latitude: CLLocationCoordinate2D.cbdUtara3.latitude,
            longitude: CLLocationCoordinate2D.cbdUtara3.longitude,
            images: ["Intermoda_1"],
            routes: ["route_5"]
        ),

        BusStop(
            id: "chadnya",
            name: "Chadnya",
            latitude: CLLocationCoordinate2D.chadnya.latitude,
            longitude: CLLocationCoordinate2D.chadnya.longitude,
            images: ["Chadnya_1"],
            routes: ["route_1"]
        ),

        BusStop(
            id: "collinare",
            name: "Collinare",
            latitude: CLLocationCoordinate2D.collinare.latitude,
            longitude: CLLocationCoordinate2D.collinare.longitude,
            images: ["Collinare_1"],
            routes: ["route_2", "route_3"]
        ),

        BusStop(
            id: "cosmo",
            name: "Cosmo",
            latitude: CLLocationCoordinate2D.cosmo.latitude,
            longitude: CLLocationCoordinate2D.cosmo.longitude,
            images: ["Cosmo_1"],
            routes: ["route_1"]
        ),

        BusStop(
            id: "courtsMegaStore",
            name: "Courts Mega Store",
            latitude: CLLocationCoordinate2D.courtsMegaStore.latitude,
            longitude: CLLocationCoordinate2D.courtsMegaStore.longitude,
            images: ["Courts Mega Store_1"],
            routes: ["route_2", "route_3", "route_7"]
        ),

        BusStop(
            id: "deBrassia",
            name: "De Brassia",
            latitude: CLLocationCoordinate2D.deBrassia.latitude,
            longitude: CLLocationCoordinate2D.deBrassia.longitude,
            images: ["De Brassia_1"],
            routes: ["route_4"]
        ),

        BusStop(
            id: "deFrangpani",
            name: "De Frangipani",
            latitude: CLLocationCoordinate2D.deFrangpani.latitude,
            longitude: CLLocationCoordinate2D.deFrangpani.longitude,
            images: ["De Frangipani_1"],
            routes: ["route_4"]
        ),

        BusStop(
            id: "deHeliconia1",
            name: "De Heliconia1",
            latitude: CLLocationCoordinate2D.deHeliconia1.latitude,
            longitude: CLLocationCoordinate2D.deHeliconia1.longitude,
            images: ["De Heliconia 1_1"],
            routes: ["route_4"]
        ),

        BusStop(
            id: "deHeliconia2",
            name: "De Heliconia 2",
            latitude: CLLocationCoordinate2D.deHeliconia2.latitude,
            longitude: CLLocationCoordinate2D.deHeliconia2.longitude,
            images: ["De Heliconia 2_1"],
            routes: ["route_2", "route_3"]
        ),

        BusStop(
            id: "deMaja",
            name: "De Maja",
            latitude: CLLocationCoordinate2D.deMaja.latitude,
            longitude: CLLocationCoordinate2D.deMaja.longitude,
            images: ["De Maja_1"],
            routes: ["route_2", "route_3"]
        ),

        BusStop(
            id: "deNara",
            name: "De Nara",
            latitude: CLLocationCoordinate2D.deNara.latitude,
            longitude: CLLocationCoordinate2D.deNara.longitude,
            images: ["De Nara_1"],
            routes: ["route_2", "route_3"]
        ),
        
        BusStop(
            id: "dePark1",
            name: "De Park1",
            latitude: CLLocationCoordinate2D.dePark1.latitude,
            longitude: CLLocationCoordinate2D.dePark1.longitude,
            images: ["De Park 1_1"],
            routes: ["route_4"]
        ),

        BusStop(
            id: "dePark2",
            name: "De Park 2",
            latitude: CLLocationCoordinate2D.dePark2.latitude,
            longitude: CLLocationCoordinate2D.dePark2.longitude,
            images: ["De Park 2_1"],
            routes: ["route_2", "route_3"]
        ),

        BusStop(
            id: "digitalHub1",
            name: "Digital Hub1",
            latitude: CLLocationCoordinate2D.digitalHub1.latitude,
            longitude: CLLocationCoordinate2D.digitalHub1.longitude,
            images: ["Digital Hub 1_1", "Digital Hub 1_2"],
            routes: ["route_3", "route_7"]
        ),

        BusStop(
            id: "digitalHub2",
            name: "Digital Hub 2",
            latitude: CLLocationCoordinate2D.digitalHub2.latitude,
            longitude: CLLocationCoordinate2D.digitalHub2.longitude,
            images: ["Digital Hub 2_1"],
            routes: ["route_3"]
        ),

        BusStop(
            id: "divenaDeshna",
            name: "Divena & Deshna",
            latitude: CLLocationCoordinate2D.divenaDeshna.latitude,
            longitude: CLLocationCoordinate2D.divenaDeshna.longitude,
            images: ["Divena & Deshna_1"],
            routes: ["route_1"]
        ),

        BusStop(
            id: "eastBusinessDistrict",
            name: "East Business District",
            latitude: CLLocationCoordinate2D.eastBusinessDistrict.latitude,
            longitude: CLLocationCoordinate2D.eastBusinessDistrict.longitude,
            images: ["East Business District_1"],
            routes: ["route_1", "route_2"]
        ),

        BusStop(
            id: "edutown1",
            name: "Edutown 1",
            latitude: CLLocationCoordinate2D.edutown1.latitude,
            longitude: CLLocationCoordinate2D.edutown1.longitude,
            images: ["Edutown 1_1"],
            routes: ["route_1", "route_3", "route_6", "route_7"]
        ),

        BusStop(
            id: "edutown2",
            name: "Edutown 2",
            latitude: CLLocationCoordinate2D.edutown2.latitude,
            longitude: CLLocationCoordinate2D.edutown2.longitude,
            images: ["Edutown 2_1"],
            routes: ["route_1", "route_3", "route_6", "route_7"]
        ),

        BusStop(
            id: "ekaHospital1",
            name: "Eka Hospital 1",
            latitude: CLLocationCoordinate2D.ekaHospital1.latitude,
            longitude: CLLocationCoordinate2D.ekaHospital1.longitude,
            images: ["Eka Hospital 1_1"],
            routes: ["route_1", "route_2"]
        ),

        BusStop(
            id: "ekaHospital2",
            name: "Eka Hospital 2",
            latitude: CLLocationCoordinate2D.ekaHospital2.latitude,
            longitude: CLLocationCoordinate2D.ekaHospital2.longitude,
            images: ["Eka Hospital 2_1"],
            routes: ["route_1", "route_2"]
        ),

        BusStop(
            id: "froogy",
            name: "Froogy",
            latitude: CLLocationCoordinate2D.epicon.latitude,
            longitude: CLLocationCoordinate2D.epicon.longitude,
            images: ["EPICON_1"],
            routes: ["route_3", "route_7"]
        ),

        BusStop(
            id: "eternity",
            name: "Eternity",
            latitude: CLLocationCoordinate2D.eternity.latitude,
            longitude: CLLocationCoordinate2D.eternity.longitude,
            images: ["Eternity_1"],
            routes: ["route_1", "route_3"]
        ),

        BusStop(
            id: "extremePark",
            name: "Extreme Park",
            latitude: CLLocationCoordinate2D.extremePark.latitude,
            longitude: CLLocationCoordinate2D.extremePark.longitude,
            images: ["Extreme Park_1"],
            routes: ["route_4"]
        ),

        BusStop(
            id: "fbl1",
            name: "FBL 1",
            latitude: CLLocationCoordinate2D.fbl1.latitude,
            longitude: CLLocationCoordinate2D.fbl1.longitude,
            images: ["FBL 1_1"],
            routes: ["route_4", "route_7"]
        ),

        BusStop(
            id: "fbl2",
            name: "FBL 2",
            latitude: CLLocationCoordinate2D.fbl2.latitude,
            longitude: CLLocationCoordinate2D.fbl2.longitude,
            images: ["FBL 2_1"],
            routes: ["route_4", "route_7"]
        ),

        BusStop(
            id: "fbl5",
            name: "FBL 5",
            latitude: CLLocationCoordinate2D.fbl5.latitude,
            longitude: CLLocationCoordinate2D.fbl5.longitude,
            images: ["FBL 5_1"],
            routes: ["route_2"]
        ),

        BusStop(
            id: "fiore",
            name: "Fiore",
            latitude: CLLocationCoordinate2D.fiore.latitude,
            longitude: CLLocationCoordinate2D.fiore.longitude,
            images: ["Fiore_1"],
            routes: ["route_2", "route_4"]
        ),

        BusStop(
            id: "foglio",
            name: "Foglio",
            latitude: CLLocationCoordinate2D.foglio.latitude,
            longitude: CLLocationCoordinate2D.foglio.longitude,
            images: ["Foglio_1"],
            routes: ["route_2", "route_3"]
        ),

        BusStop(
            id: "foresta1",
            name: "Foresta 1",
            latitude: CLLocationCoordinate2D.foresta1.latitude,
            longitude: CLLocationCoordinate2D.foresta1.longitude,
            images: ["Foresta 1_1"],
            routes: ["route_2", "route_3"]
        ),

        BusStop(
            id: "foresta2",
            name: "Foresta 2",
            latitude: CLLocationCoordinate2D.foresta2.latitude,
            longitude: CLLocationCoordinate2D.foresta2.longitude,
            images: ["Foresta 2_1"],
            routes: ["route_2", "route_4"]
        ),

        BusStop(
            id: "fresco",
            name: "Fresco",
            latitude: CLLocationCoordinate2D.fresco.latitude,
            longitude: CLLocationCoordinate2D.fresco.longitude,
            images: ["Fresco_1"],
            routes: ["route_2", "route_4"]
        ),

        BusStop(
            id: "giant",
            name: "Giant",
            latitude: CLLocationCoordinate2D.giantBSDCity1.latitude,
            longitude: CLLocationCoordinate2D.giantBSDCity1.longitude,
            images: ["Giant_1"],
            routes: ["route_1", "route_2"]
        ),

        BusStop(
            id: "giardina",
            name: "Giardina",
            latitude: CLLocationCoordinate2D.giardina.latitude,
            longitude: CLLocationCoordinate2D.giardina.longitude,
            images: ["Giardina_1"],
            routes: ["route_2", "route_3"]
        ),

        BusStop(
            id: "gop1",
            name: "GOP 1",
            latitude: CLLocationCoordinate2D.gop1.latitude,
            longitude: CLLocationCoordinate2D.gop1.longitude,
            images: ["GOP 1_1"],
            routes: ["route_1", "route_2", "route_3", "route_7"]
        ),

        BusStop(
            id: "gramedia",
            name: "Gramedia",
            latitude: CLLocationCoordinate2D.gramedia.latitude,
            longitude: CLLocationCoordinate2D.gramedia.longitude,
            images: ["Gramedia_1"],
            routes: ["route_3", "route_7"]
        ),

        BusStop(
            id: "grandLucky1",
            name: "Grand Lucky 1",
            latitude: CLLocationCoordinate2D.grandLucky1.latitude,
            longitude: CLLocationCoordinate2D.grandLucky1.longitude,
            images: ["Grand Lucky 1_1"],
            routes: ["route_6"]
        ),

        BusStop(
            id: "greenCove",
            name: "Green Cove",
            latitude: CLLocationCoordinate2D.greencove.latitude,
            longitude: CLLocationCoordinate2D.greencove.longitude,
            images: ["Greencove_1"],
            routes: ["route_1", "route_2", "route_5"]
        ),

        BusStop(
            id: "greenwichPark1",
            name: "Greenwich Park 1",
            latitude: CLLocationCoordinate2D.greenwichPark1.latitude,
            longitude: CLLocationCoordinate2D.greenwichPark1.longitude,
            images: ["Greenwich Park 1_1"],
            routes: ["route_2", "route_3"]
        ),

        BusStop(
            id: "greenwichPark2",
            name: "Greenwich Park 2",
            latitude: CLLocationCoordinate2D.greenwichPark2.latitude,
            longitude: CLLocationCoordinate2D.greenwichPark2.longitude,
            images: ["Greenwich Park 2_1"],
            routes: ["route_4"]
        ),

        BusStop(
            id: "greenwichParkOffice",
            name: "Greenwich Park Office",
            latitude: CLLocationCoordinate2D.greenwichParkOffice.latitude,
            longitude: CLLocationCoordinate2D.greenwichParkOffice.longitude,
            images: ["Greenwich Park Office_1"],
            routes: ["route_2"]
        ),

        BusStop(
            id: "griyaLoka1",
            name: "Griya Loka 1",
            latitude: CLLocationCoordinate2D.griyaLoka1.latitude,
            longitude: CLLocationCoordinate2D.griyaLoka1.longitude,
            images: ["Griya Loka 1_1"],
            routes: ["route_1", "route_2"]
        ),

        BusStop(
            id: "griyaLoka2",
            name: "Griya Loka 2",
            latitude: CLLocationCoordinate2D.griyaLoka2.latitude,
            longitude: CLLocationCoordinate2D.griyaLoka2.longitude,
            images: ["Griya Loka 2_1"],
            routes: ["route_1", "route_2"]
        ),

        BusStop(
            id: "horizonBroadway",
            name: "Horizon Broadway",
            latitude: CLLocationCoordinate2D.horizonBroadway.latitude,
            longitude: CLLocationCoordinate2D.horizonBroadway.longitude,
            images: ["Horizon Broadway_1"],
            routes: ["route_4"]
        ),

        BusStop(
            id: "ice1",
            name: "ICE 1",
            latitude: CLLocationCoordinate2D.ice1.latitude,
            longitude: CLLocationCoordinate2D.ice1.longitude,
            images: ["ICE 1_1"],
            routes: ["route_1", "route_3", "route_4", "route_5", "route_6", "route_7"]
        ),

        BusStop(
            id: "ice2",
            name: "ICE 2",
            latitude: CLLocationCoordinate2D.ice2.latitude,
            longitude: CLLocationCoordinate2D.ice2.longitude,
            images: ["ICE 2_1"],
            routes: ["route_1", "route_3", "route_4", "route_5", "route_6", "route_7"]
        ),

        BusStop(
            id: "ice5",
            name: "ICE 5",
            latitude: CLLocationCoordinate2D.ice5.latitude,
            longitude: CLLocationCoordinate2D.ice5.longitude,
            images: ["ICE 5_1"],
            routes: ["route_1", "route_3", "route_4", "route_5", "route_6", "route_7"]
        ),

        BusStop(
            id: "ice6",
            name: "ICE 6",
            latitude: CLLocationCoordinate2D.ice6.latitude,
            longitude: CLLocationCoordinate2D.ice6.longitude,
            images: ["ICE 6_1"],
            routes: ["route_1", "route_3", "route_4", "route_5", "route_6", "route_7"]
        ),

        BusStop(
            id: "iceBusinessPark",
            name: "ICE Business Park",
            latitude: CLLocationCoordinate2D.iceBusinessPark.latitude,
            longitude: CLLocationCoordinate2D.iceBusinessPark.longitude,
            images: ["ICE Business Park_1"],
            routes: ["route_1", "route_3", "route_4", "route_5", "route_6", "route_7"]
        ),

        BusStop(
            id: "iconBusinessPark",
            name: "Icon Business Park",
            latitude: CLLocationCoordinate2D.iconBusinessPark.latitude,
            longitude: CLLocationCoordinate2D.iconBusinessPark.longitude,
            images: ["Icon Business Park_1"],
            routes: ["route_1"]
        ),

        BusStop(
            id: "iconCentro",
            name: "Icon Centro",
            latitude: CLLocationCoordinate2D.iconCentro.latitude,
            longitude: CLLocationCoordinate2D.iconCentro.longitude,
            images: ["Icon Centro_1"],
            routes: ["route_4"]
        ),

        BusStop(
            id: "illustria",
            name: "Illustria",
            latitude: CLLocationCoordinate2D.illustria.latitude,
            longitude: CLLocationCoordinate2D.illustria.longitude,
            images: ["Illustria_1"],
            routes: ["route_6"]
        ),

        BusStop(
            id: "intermoda",
            name: "Intermoda",
            latitude: CLLocationCoordinate2D.intermoda.latitude,
            longitude: CLLocationCoordinate2D.intermoda.longitude,
            images: ["Intermoda_1"],
            routes: ["route_1", "route_3", "route_4", "route_6", "route_7"]
        ),

        BusStop(
            id: "jadeite",
            name: "Jadeite",
            latitude: CLLocationCoordinate2D.jadeite.latitude,
            longitude: CLLocationCoordinate2D.jadeite.longitude,
            images: ["Jadeite_1"],
            routes: ["route_2", "route_3", "route_4"]
        ),

        BusStop(
            id: "lobbyAeonMall",
            name: "Lobby AEON Mall",
            latitude: CLLocationCoordinate2D.lobbyAeon.latitude,
            longitude: CLLocationCoordinate2D.lobbyAeon.longitude,
            images: ["Lobby Aeon Mall_1"],
            routes: ["route_5", "route_7"]
        ),

        BusStop(
            id: "lulu",
            name: "Lulu",
            latitude: CLLocationCoordinate2D.lulu.latitude,
            longitude: CLLocationCoordinate2D.lulu.longitude,
            images: ["Lulu_1"],
            routes: ["route_2", "route_3", "route_7"]
        ),

        BusStop(
            id: "masjidAlUkhuwah",
            name: "Masjid Al-Ukhuwah",
            latitude: CLLocationCoordinate2D.masjidAlUkhuwah.latitude,
            longitude: CLLocationCoordinate2D.masjidAlUkhuwah.longitude,
            images: ["Masjid Al-Ukhuwah_1"],
            routes: ["route_1"]
        ),

        BusStop(
            id: "naturale",
            name: "Naturale",
            latitude: CLLocationCoordinate2D.naturale.latitude,
            longitude: CLLocationCoordinate2D.naturale.longitude,
            images: ["Naturale_1"],
            routes: ["route_2", "route_4"]
        ),

        BusStop(
            id: "navaPark1",
            name: "Nava Park 1",
            latitude: CLLocationCoordinate2D.navaPark1.latitude,
            longitude: CLLocationCoordinate2D.navaPark1.longitude,
            images: ["Nava Park 1_1"],
            routes: ["route_1", "route_2", "route_5"]
        ),

        BusStop(
            id: "navaPark2",
            name: "Nava Park 2",
            latitude: CLLocationCoordinate2D.navaPark2.latitude,
            longitude: CLLocationCoordinate2D.navaPark2.longitude,
            images: ["Nava Park 2_1"],
            routes: ["route_2", "route_3"]
        ),

        BusStop(
            id: "pasarModernTimur",
            name: "Pasar Modern Timur",
            latitude: CLLocationCoordinate2D.pasarModernTimur.latitude,
            longitude: CLLocationCoordinate2D.pasarModernTimur.longitude,
            images: ["Pasar Modern Timur_1"],
            routes: ["route_1", "route_2"]
        ),

        BusStop(
            id: "piazziaMozia",
            name: "Piazzia Mozia",
            latitude: CLLocationCoordinate2D.piazziaMozia.latitude,
            longitude: CLLocationCoordinate2D.piazziaMozia.longitude,
            images: ["Piazzia Mozia_1"],
            routes: ["route_6"]
        ),

        BusStop(
            id: "polsekSerpong",
            name: "Polsek Serpong",
            latitude: CLLocationCoordinate2D.polsekSerpong.latitude,
            longitude: CLLocationCoordinate2D.polsekSerpong.longitude,
            images: ["Polsek Serpong_1"],
            routes: ["route_1", "route_2"]
        ),

        BusStop(
            id: "prestigia",
            name: "Prestigia",
            latitude: CLLocationCoordinate2D.prestigia.latitude,
            longitude: CLLocationCoordinate2D.prestigia.longitude,
            images: ["Prestigia_1"],
            routes: ["route_6"]
        ),

        BusStop(
            id: "primavera",
            name: "Primavera",
            latitude: CLLocationCoordinate2D.primavera.latitude,
            longitude: CLLocationCoordinate2D.primavera.longitude,
            images: ["Primavera_1"],
            routes: ["route_2", "route_4"]
        ),

        BusStop(
            id: "puspitaLoka",
            name: "Puspita Loka",
            latitude: CLLocationCoordinate2D.puspitaloka.latitude,
            longitude: CLLocationCoordinate2D.puspitaloka.longitude,
            images: ["Puspita Loka_1"],
            routes: ["route_1", "route_2"]
        ),

        BusStop(
            id: "qBig1",
            name: "Q Big 1",
            latitude: CLLocationCoordinate2D.qBig1.latitude,
            longitude: CLLocationCoordinate2D.qBig1.longitude,
            images: ["Q Big 1_1"],
            routes: ["route_2", "route_3", "route_7"]
        ),

        BusStop(
            id: "qBig2",
            name: "Q Big 2",
            latitude: CLLocationCoordinate2D.qBig2.latitude,
            longitude: CLLocationCoordinate2D.qBig2.longitude,
            images: ["Q Big 2_1"],
            routes: ["route_4", "route_7"]
        ),

        BusStop(
            id: "qBig3",
            name: "Q Big 3",
            latitude: CLLocationCoordinate2D.qBig3.latitude,
            longitude: CLLocationCoordinate2D.qBig3.longitude,
            images: ["Q Big 3_1"],
            routes: ["route_4", "route_7"]
        ),

        BusStop(
            id: "rukoMadrid",
            name: "Ruko Madrid",
            latitude: CLLocationCoordinate2D.rukoMadrid.latitude,
            longitude: CLLocationCoordinate2D.rukoMadrid.longitude,
            images: ["Ruko Madrid_1"],
            routes: ["route_1", "route_2"]
        ),

        BusStop(
            id: "rukoTheLoop",
            name: "Ruko The Loop",
            latitude: CLLocationCoordinate2D.rukoTheLoop.latitude,
            longitude: CLLocationCoordinate2D.rukoTheLoop.longitude,
            images: ["Ruko The Loop_1"],
            routes: ["route_6"]
        ),

        BusStop(
            id: "santaUrsula1",
            name: "Santa Ursula 1",
            latitude: CLLocationCoordinate2D.santaUrsula1.latitude,
            longitude: CLLocationCoordinate2D.santaUrsula1.longitude,
            images: ["Santa Ursula 1_1"],
            routes: ["route_1", "route_2"]
        ),

        BusStop(
            id: "santaUrsula2",
            name: "Santa Ursula 2",
            latitude: CLLocationCoordinate2D.santaUrsula2.latitude,
            longitude: CLLocationCoordinate2D.santaUrsula2.longitude,
            images: ["Santa Ursula 2_1"],
            routes: ["route_1", "route_2"]
        ),

        BusStop(
            id: "saveria",
            name: "Saveria",
            latitude: CLLocationCoordinate2D.saveria.latitude,
            longitude: CLLocationCoordinate2D.saveria.longitude,
            images: ["Saveria_1"],
            routes: ["route_4", "route_7"]
        ),

        BusStop(
            id: "sektor13",
            name: "Sektor 1.3",
            latitude: CLLocationCoordinate2D.sektor13.latitude,
            longitude: CLLocationCoordinate2D.sektor13.longitude,
            images: ["Sektor 1.3_1"],
            routes: ["route_1", "route_2"]
        ),

        BusStop(
            id: "sentraOnderdil",
            name: "Sentra Onderdil",
            latitude: CLLocationCoordinate2D.sentraOnderdil.latitude,
            longitude: CLLocationCoordinate2D.sentraOnderdil.longitude,
            images: ["Sentra Onderdil_1"],
            routes: ["route_1", "route_2"]
        ),

        BusStop(
            id: "simpangForesta",
            name: "Simpang Foresta",
            latitude: CLLocationCoordinate2D.simpangForesta.latitude,
            longitude: CLLocationCoordinate2D.simpangForesta.longitude,
            images: ["Simpang Foresta_1"],
            routes: ["route_2", "route_4"]
        ),

        BusStop(
            id: "simplicity1",
            name: "Simplicity 1",
            latitude: CLLocationCoordinate2D.simplicity1.latitude,
            longitude: CLLocationCoordinate2D.simplicity1.longitude,
            images: ["Simplicity 1_1"],
            routes: ["route_1", "route_4", "route_6", "route_7"]
        ),

        BusStop(
            id: "simplicity2",
            name: "Simplicity 2",
            latitude: CLLocationCoordinate2D.simplicity2.latitude,
            longitude: CLLocationCoordinate2D.simplicity2.longitude,
            images: ["Simplicity 2_1"],
            routes: ["route_1", "route_3", "route_6", "route_7"]
        ),

        BusStop(
            id: "smlPlaza",
            name: "SML Plaza",
            latitude: CLLocationCoordinate2D.smlPlaza.latitude,
            longitude: CLLocationCoordinate2D.smlPlaza.longitude,
            images: ["SML Plaza_1"],
            routes: ["route_1", "route_2", "route_3", "route_4", "route_7"]
        ),
        
        
        BusStop(
            id: "studento1",
            name: "Studento 1",
            latitude: CLLocationCoordinate2D.studento1.latitude,
            longitude: CLLocationCoordinate2D.studento1.longitude,
            images: ["Studento 1_1"],
            routes: ["route_2", "route_4"]
        ),

        BusStop(
            id: "studento2",
            name: "Studento 2",
            latitude: CLLocationCoordinate2D.studento2.latitude,
            longitude: CLLocationCoordinate2D.studento2.longitude,
            images: ["Studento 2_1"],
            routes: ["route_2", "route_3"]
        ),

        BusStop(
            id: "swa1",
            name: "SWA 1",
            latitude: CLLocationCoordinate2D.swa1.latitude,
            longitude: CLLocationCoordinate2D.swa1.longitude,
            images: ["SWA 1_1"],
            routes: ["route_1", "route_2"]
        ),

        BusStop(
            id: "swa2",
            name: "SWA 2",
            latitude: CLLocationCoordinate2D.swa2.latitude,
            longitude: CLLocationCoordinate2D.swa2.longitude,
            images: ["SWA 2_1"],
            routes: ["route_1", "route_2"]
        ),

        BusStop(
            id: "tabebuya",
            name: "Tabebuya",
            latitude: CLLocationCoordinate2D.tabebuya.latitude,
            longitude: CLLocationCoordinate2D.tabebuya.longitude,
            images: ["Tabebuya_1"],
            routes: ["route_6"]
        ),

        BusStop(
            id: "theBreeze",
            name: "The Breeze",
            latitude: CLLocationCoordinate2D.theBreeze.latitude,
            longitude: CLLocationCoordinate2D.theBreeze.longitude,
            images: ["The Breeze_1"],
            routes: ["route_1", "route_2", "route_3", "route_4", "route_5", "route_7"]
        ),

        BusStop(
            id: "theMozia1",
            name: "The Mozia 1",
            latitude: CLLocationCoordinate2D.theMozia1.latitude,
            longitude: CLLocationCoordinate2D.theMozia1.longitude,
            images: ["The Mozia_1"],
            routes: ["route_6"]
        ),

        BusStop(
            id: "theMozia2",
            name: "The Mozia 2",
            latitude: CLLocationCoordinate2D.theMozia2.latitude,
            longitude: CLLocationCoordinate2D.theMozia2.longitude,
            images: ["The Mozia 2_1"],
            routes: ["route_6"]
        ),

        BusStop(
            id: "vanyaPark",
            name: "Vanya Park",
            latitude: CLLocationCoordinate2D.vanyaPark.latitude,
            longitude: CLLocationCoordinate2D.vanyaPark.longitude,
            images: ["Vanya Park_1"],
            routes: ["route_6"]
        ),

        BusStop(
            id: "verdantView",
            name: "Verdant View",
            latitude: CLLocationCoordinate2D.verdantView.latitude,
            longitude: CLLocationCoordinate2D.verdantView.longitude,
            images: ["Verdant View_1"],
            routes: ["route_1", "route_3"]
        ),

        BusStop(
            id: "westPark",
            name: "West Park",
            latitude: CLLocationCoordinate2D.westPark.latitude,
            longitude: CLLocationCoordinate2D.westPark.longitude,
            images: ["West Park_1"],
            routes: ["route_6"]
        )
    ]
    
    
    //            static let all: [BusStop] = [
    //                BusStop(
    //                    id: "bs_aeon_mall_1",
    //                    name: "AEON Mall 1",
    //                    coordinates: .aeonMall1,
    //                    images: [],
    //                    routes: ["route_1"]
    //                ),
    //                BusStop(
    //                    id: "intermoda",
    //                    name: "Intermoda",
    //                    coordinates: .aeonMall1,
    //                    images: ["Intermoda_1", "Intermoda_2"],
    //                    routes: ["route_1"]
    //                ),
    //            ]
    //    static func getSingleStop(by id: String) -> BusStop {
    //        return all.first(where: {$0.id == id} ?? BusStop(id: "xx", name: "xx", coordinates: CLLocationCoordinate2D(), images: [], routes: [))
    //            }
    //
    //            static func getStops(by ids: [String]) -> [BusStop] {
    //            return all.filter { $0.id ==  }
    //        }
}
