//
//  APIFetch.swift
//  Aksjer
//
//  Created by Kristoffer Melen on 23/12/2023.
//

import Foundation
import SwiftUI


struct Stock: Decodable, Encodable {
    var chart: ChartResult
//    var body: [Int: StockData]
//    var meta: Meta
}

struct ChartResult: Decodable, Encodable {
    var result: [StockResult]
    var error: String?
}

struct StockResult: Decodable, Encodable {
    var meta: Meta
    var timestamp: [Int]
    var indicators: Indicators
}

struct Indicators: Decodable, Encodable {
    var quote: [Quote]
}

struct Quote: Decodable, Encodable {
    var close: [Double?]
    var low: [Double?]
    var volume: [Int?]
    var open: [Double?]
    var high: [Double?]
    var adjclose: [Double?]?
}

struct Meta: Decodable, Encodable {
    var currency: String
    var symbol: String
    var exchangeName: String
    var fullExchangeName: String
    var instrumentType: String
    var firstTradeDate: Int?
    var regularMarketTime: Int
    var hasPrePostMarketData: Bool
    var gmtoffset: Int
    var timezone: String
    var exchangeTimezoneName: String
    var regularMarketPrice: Double
    var fiftyTwoWeekHigh: Double
    var fiftyTwoWeekLow: Double
    var regularMarketDayHigh: Double
    var regularMarketDayLow: Double
    var regularMarketVolume: Int
    var chartPreviousClose: Double
    var previousClose: Double?
    var scale: Int?
    var priceHint: Int
    var currentTradingPeriod: CurrentTradingPeriod
    var dataGranularity: String
    var range: String
    var validRanges: [String]
    var tradingPeriods: [[TradingPeriod]]?
    
    
}

struct TradingPeriod: Decodable, Encodable {
    var timezone: String
    var start: Int
    var end: Int
    var gmtoffset: Int
}

struct CurrentTradingPeriod: Decodable, Encodable {
    var pre: TradingPeriod
    var regular: TradingPeriod
    var post: TradingPeriod
}

struct StockData: Decodable, Comparable, Identifiable, Encodable {
    
    
    static func < (lhs: StockData, rhs: StockData) -> Bool {
        return lhs.date_utc < rhs.date_utc
    }
    var adjclose: Float?
    var close: Float
    var date: String
    var date_utc: Int
    var high: Float
    var low: Float
    var open: Float
    var volume: Int
    var id = UUID()
    
    private enum CodingKeys : String, CodingKey { case adjclose, close, date, date_utc, high, low, open, volume }
}




struct SearchStock: Decodable {
    var quotes: [Quotes]
//    var meta: SearchStatusInfo
//    var body: [SearchResponce]
}

struct Quotes: Decodable {
    var exchange: String
    var shortname: String
    var quoteType: String?
    var symbol: String
    var index: String?
    var score: Float?
    var typeDisp: String
    var longname: String?
    var exchDisp: String
    var sector: String?
    var sectorDisp: String?
    var industry: String?
    var industryDisp: String?
    
}

//struct SearchStatusInfo: Decodable {
//    var symbol: String
//    var status: Int
//    var processedTime: String
//    var version: String
//    var copywrite: String
//    
//}
//
//struct SearchResponce: Decodable, Hashable {
//    var symbol: String
//    var name: String
//    var exch: String
//    var type: String
//    var exchDisp: String
//    var typeDisp: String
//}

//struct SearchResults: Decodable, Hashable {
//    let symbol: String
//    let name: String
//    let exch: String
//    let type: String
//    let exchDisp: String
//    let typeDisp: String
//    var isFollowed: Bool
//}

@Observable final class SearchResults: Identifiable, Hashable, Encodable, Decodable {
    static func == (lhs: SearchResults, rhs: SearchResults) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var id = UUID()
    var symbol: String
    var name: String
    var exch: String
    var type: String
    var exchDisp: String
    var typeDisp: String
    
    var isFollowed: Bool
    
    init(id: UUID = UUID(), symbol: String = "", name: String = "", exch: String = "", type: String = "", exchDisp: String = "", typeDisp: String = "", isFollowed: Bool = true) {
        self.id = id
        self.symbol = symbol
        self.name = name
        self.exch = exch
        self.type = type
        self.exchDisp = exchDisp
        self.typeDisp = typeDisp
        self.isFollowed = isFollowed
    }
    
    enum CodingKeys: String, CodingKey {
        case _id = "id"
        case _symbol = "symbol"
        case _name = "name"
        case _exch = "exch"
        case _type = "type"
        case _exchDisp = "exchDisp"
        case _typeDisp = "typeDisp"
        case _isFollowed = "isFollowed"
        
    }
}


enum RangeType: String, CaseIterable, Decodable, Encodable, Identifiable {
    case oneDay = "1m"
    case oneWeek = "3m"
    case oneMonth1 = "5m"
    case oneMonth2 = "15m"
    case oneMonth3 = "30m"
    case oneMonth4 = "1h"
    case threeMonths = "3d"
    case sixMonths = "6d"
    case nineMonths = "9d"
    case ytd = "d"
    case oneYear = "1d"
    case twoYears = "2d"
    case threeYears = "3yd"
    case fiveYears = "1wk"
    case tenYears = "1mo"
    case max = "max"
    
    var id: String { self.rawValue }


    
    var length: String {
        switch self {
            case .oneDay:
                return "1 Dag"
            case .oneWeek:
                return "1 Uke"
            case .oneMonth1, .oneMonth2, .oneMonth3, .oneMonth4:
                return "1 Måned"
            case .threeMonths:
                return "3 Måneder"
            case .sixMonths:
                return "6 Måneder"
            case .nineMonths:
                return "9 Måneder"
            case .ytd:
                return "YTD"
            case .oneYear:
                return "1 År"
            case .twoYears:
                return "2 År"
            case .threeYears:
                return "3 År"
            case .fiveYears:
                return "5 år"
            case .tenYears:
                return "10 År"
            case .max:
                return "Hele"
                
        }
    }
    
    var ranking: Int {
        switch self {
            case .oneDay:
                return 1
            case .oneWeek:
                return 2
            case .oneMonth1:
                return 3
            case .oneMonth2:
                return 4
            case .oneMonth3:
                return 5
            case .oneMonth4:
                return 6
            case .threeMonths:
                return 7
            case .sixMonths:
                return 8
            case .nineMonths:
                return 9
            case .ytd:
                return 10
            case .oneYear:
                return 11
            case .twoYears:
                return 12
            case .threeYears:
                return 13
            case .fiveYears:
                return 14
            case .tenYears:
                return 15
            case .max:
                return 16
                
        }
    }
    
    var realRange: String {
        switch self {
            case .oneDay:
                return "1d"
            case .oneWeek:
                return "5d"
            case .oneMonth1:
                return "1mo"
            case .oneMonth2:
                return "1mo"
            case .oneMonth3:
                return "1mo"
            case .oneMonth4:
                return "1mo"
            case .threeMonths:
                return "3mo"
            case .sixMonths:
                return "6mo"
            case .nineMonths:
                return "1y"
            case .ytd:
                return "ytd"
            case .oneYear:
                return "1y"
            case .twoYears:
                return "2y"
            case .threeYears:
                return "5y"
            case .fiveYears:
                return "5y"
            case .tenYears:
                return "10y"
            case .max:
                return "max"
                
        }
    }
    
    var realInterval: String {
        switch self {
            case .oneDay:
                return "1m"
            case .oneWeek:
                return "2m"
            case .oneMonth1:
                return "5m"
            case .oneMonth2:
                return "15m"
            case .oneMonth3:
                return "30m"
            case .oneMonth4:
                return "1h"
            case .threeMonths, .sixMonths, .nineMonths, .ytd, .oneYear, .twoYears, .threeYears:
                return "1d"
            case .fiveYears:
                return "1wk"
            case .tenYears:
                return "1mo"
            case .max:
                return "1wk"
        }
    }
    
    func getDateComponents(startDate: Date, endDate: Date, timezone: TimeZone) -> Set<DateComponents> {
        let component: Calendar.Component
        let value: Int
        switch self {
            case .oneDay:
                component = .hour
                value = 1
            case .oneWeek:
                component = .day
                value = 1
            case .oneMonth1, .oneMonth2, .oneMonth3, .oneMonth4, .threeMonths, .sixMonths, .nineMonths, .ytd:
                component = .weekOfYear
                value = 1
            case .oneYear, .twoYears, .threeYears, .fiveYears, .tenYears, .max:
                component = .year
                value = 2
        }
        
        var set  = Set<DateComponents>()
        var date = startDate
        if self != .oneDay {
            set.insert(startDate.dateComponents(timeZone: timezone, rangeType: self.rawValue))
        }
        
        while date <= endDate {
            date = Calendar.current.date(byAdding: component, value: value, to: date)!
            set.insert(date.dateComponents(timeZone: timezone, rangeType: self.rawValue))
        }
        return set
    }
}


struct Utils {
    
    static let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = ""
        formatter.currencyDecimalSeparator = ","
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    static func format(value: Double?) -> String? {
        guard let value,
              let text = numberFormatter.string(from: NSNumber(value: value))
        else { return nil }
        return text
    }
    
}

public struct ChartData: Decodable {
    
    public let meta: ChartMeta
    public let indicators: [Indicator]
    
    enum CodingKeys: CodingKey {
        case meta
        case timestamp
        case indicators
    }
    
    enum IndicatorsKeys: CodingKey {
        case quote
    }
    
    enum QuoteKeys: CodingKey {
        case high
        case close
        case low
        case open
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        meta = try container.decode(ChartMeta.self, forKey: .meta)
        
        let timestamps = try container.decodeIfPresent([Date].self, forKey: .timestamp) ?? []
        if let indicatorsContainer = try? container.nestedContainer(keyedBy: IndicatorsKeys.self, forKey: .indicators),
           var quotes = try? indicatorsContainer.nestedUnkeyedContainer(forKey: .quote),
           let quoteContainer = try? quotes.nestedContainer(keyedBy: QuoteKeys.self) {
            
            
            let highs = try quoteContainer.decodeIfPresent([Double?].self, forKey: .high) ?? []
            let lows = try quoteContainer.decodeIfPresent([Double?].self, forKey: .low) ?? []
            let opens = try quoteContainer.decodeIfPresent([Double?].self, forKey: .open) ?? []
            let closes = try quoteContainer.decodeIfPresent([Double?].self, forKey: .close) ?? []
            
            indicators = timestamps.enumerated().compactMap { (offset, timestamp) in
                guard
                    let open = opens[offset],
                    let low = lows[offset],
                    let close = closes[offset],
                    let high = highs[offset]
                else { return nil}
                return .init(timestamp: timestamp, open: open, high: high, low: low, close: close)
            }
        } else {
            self.indicators = []
        }
    }
    
    public init(meta: ChartMeta, indicators: [Indicator]) {
        self.meta = meta
        self.indicators = indicators
    }
}

public struct ChartMeta: Decodable {
    
    public let currency: String
    public let symbol: String
    public let regularMarketPrice: Double?
    public let previousClose: Double?
    public let gmtOffset: Int
    public let regularTradingPeriodStartDate: Date
    public let regularTradingPeriodEndDate: Date
    
    enum CodingKeys: CodingKey {
        case currency
        case symbol
        case regularMarketPrice
        case previousClose
        case gmtoffset
        case currentTradingPeriod
    }
    
    enum CurrentTradingPeriodKeys: String, CodingKey {
        case pre
        case regular
        case post
    }
    
    enum TradingPeriodKeys: String, CodingKey {
        case start
        case end
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.currency = try container.decodeIfPresent(String.self, forKey: .currency) ?? ""
        self.symbol = try container.decodeIfPresent(String.self, forKey: .symbol) ?? ""
        self.regularMarketPrice = try container.decodeIfPresent(Double.self, forKey: .regularMarketPrice)
        self.previousClose = try container.decodeIfPresent(Double.self, forKey: .previousClose)
        self.gmtOffset = try container.decodeIfPresent(Int.self, forKey: .gmtoffset) ?? 0
        
        let currentTradingPeriodContainer = try? container.nestedContainer(keyedBy: CurrentTradingPeriodKeys.self, forKey: .currentTradingPeriod)
        let regularTradingPeriodContainer = try? currentTradingPeriodContainer?.nestedContainer(keyedBy: TradingPeriodKeys.self, forKey: .regular)
        self.regularTradingPeriodStartDate = try regularTradingPeriodContainer?.decode(Date.self, forKey: .start) ?? Date()
        self.regularTradingPeriodEndDate = try regularTradingPeriodContainer?.decode(Date.self, forKey: .end) ?? Date()
    }
}

extension ChartMeta {
    init(currency: String, symbol: String, regularMarketPrice: Double, previousClose: Double?, gmtOffset: Int, regularTradingPeriodStartDate: Date, regularTradingPeriodEndDate: Date) {
        self.currency = currency
        self.symbol = symbol
        self.regularMarketPrice = regularMarketPrice
        self.previousClose = previousClose
        self.gmtOffset = gmtOffset
        self.regularTradingPeriodStartDate = regularTradingPeriodStartDate
        self.regularTradingPeriodEndDate = regularTradingPeriodEndDate
    }
}



public struct Indicator: Decodable {
    public let timestamp: Date
    public let open: Double
    public let high: Double
    public let low: Double
    public let close: Double
    
    public init(timestamp: Date, open: Double, high: Double, low: Double, close: Double) {
        self.timestamp = timestamp
        self.open = open
        self.high = high
        self.low = low
        self.close = close
    }
}


struct ChartViewData: Identifiable, Equatable {
    static func == (lhs: ChartViewData, rhs: ChartViewData) -> Bool {
        return lhs.id == rhs.id && lhs.xAxisData == rhs.xAxisData && lhs.yAxisData == rhs.yAxisData && lhs.items == rhs.items
    }
    
    
    let id = UUID()
    var xAxisData: ChartAxisData
    var yAxisData: ChartAxisData
    let items: [ChartViewItem]
    
}

struct ChartViewItem: Identifiable, Equatable {
    
    let id = UUID()
    let timestamp: Date
    let value: Double
    
}

struct ChartAxisData: Equatable {
    
    var axisStart: Double
    var axisEnd: Double
    let strideBy: Double
    var map: [String: String]
    
}





extension Date {
    
    func dateComponents(timeZone: TimeZone, rangeType: String, calendar: Calendar = .current) -> DateComponents {
        let current = calendar.dateComponents(in: timeZone, from: self)
        
        var dc = DateComponents(timeZone: timeZone, year: current.year, month: current.month)
        
        if rangeType == "5m" || rangeType == "1m" || rangeType == "3m" {
            dc.day = current.day
        }
        
        if rangeType == "1m" {
            dc.hour = current.hour
        }
        
        return dc
    }
    
}



struct News: Decodable {
    var status: String
    var message: String?
    var feed: Feed?
    var items: [NewsItems]
//    var body: [NewsBody]
//    var meta: NewsMeta
    
}

struct Feed: Decodable {
    var url: String
    var title: String
    var link: String
    var author: String
    var description: String
    var image: String
}

struct NewsItems: Decodable, Hashable, Identifiable, Encodable{
    var title: String
    var pubDate: String
    var link: String
    var guid: String
    var description: String
    var id = UUID()
    
    private enum CodingKeys : String, CodingKey { case title, pubDate, link, guid, description }
}

//struct NewsBody: Decodable, Hashable, Identifiable, Encodable {
//    var title: String
//    var description: String
//    var pubDate: String
//    var link: String
//    var guid: String
//    var id = UUID()
//    
//    private enum CodingKeys : String, CodingKey { case title, description, pubDate, link, guid }
//}
//
//struct NewsMeta: Decodable {
//    var copywrite: String
//    var processedTime: String
//    var status: Int
//    var ticker: String
//    var version: String
//}

extension Double {
    var roundedString: String {
        String(format: "%.2f", self)
    }
    var roundedStringRSI: String {
        String(format: "%.0f", self)
    }
}


enum APIError: Error {
    case invalidURL
    case noData
}

struct Item: Identifiable, Equatable {
    var id = UUID()
    var amount: String
    var length: String
}

final class APIFetch {
    
    static let shared = APIFetch()
}

extension APIFetch {
    
    
    
    func fetchStockSearch(searchInput: String, completion: @escaping (Result<SearchStock, Error>) -> Void) {
//        let headers = [
//            "X-RapidAPI-Key": "561eb4fbafmsh5dbf010c70113c6p112a3djsn616b59572848",
//            "X-RapidAPI-Host": "yahoo-finance15.p.rapidapi.com"
//        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://query1.finance.yahoo.com/v1/finance/search?q=\(searchInput)")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
//        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
//        session.configuration.timeoutIntervalForResource = 120
//        session.configuration.timeoutIntervalForRequest = 120
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if let error = error {
                completion(.failure(error))
                print(error)
                print("noooo")
                return
            }
            let httpResponse = response as? HTTPURLResponse
            print("Response: \(String(describing: httpResponse))")
            
            guard let data = data else {
                completion(.failure(APIError.noData))
                print("noooooooooooo")
                return
            }
            
            var stock: SearchStock?
            
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
                if let jsonDict = jsonObject as? NSDictionary {
                    print ("Dict: \(jsonDict)")
                }
                stock = try JSONDecoder().decode(SearchStock.self, from: data)
                guard let stock2 = stock else {
                    print("failed to parse")
                    return
                }
                
                searchedStocks.removeAll()
                searchedStocks = stock2.quotes

                
                
                
                
                completion(.success(stock2))
                print(stock2)
                
                
            } catch {
                completion(.failure(error))
                print("error: \(error)")
                print("noooooooooooooooooooooo")
            }
            
            
            
        })
        
        dataTask.resume()
    }
    
    
    func fetchStockData(symbol: String, interval: String, range: String, completion: @escaping (Result<Stock, Error>) -> Void) {
//        let headers = [
//            "X-RapidAPI-Key": "561eb4fbafmsh5dbf010c70113c6p112a3djsn616b59572848",
//            "X-RapidAPI-Host": "yahoo-finance15.p.rapidapi.com"
//        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://query1.finance.yahoo.com/v8/finance/chart/\(symbol)?includePrePost=false&interval=\(interval)&useYfid=true&range=\(range)&corsDomain=finance.yahoo.com&.tsrc=finance")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
//        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
//        session.configuration.timeoutIntervalForResource = 120
//        session.configuration.timeoutIntervalForRequest = 120
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if let error = error {
                completion(.failure(error))
                print(error)
                print("noooo2121212")
                return
            }
            let httpResponse = response as? HTTPURLResponse
            print("Response: \(String(describing: httpResponse))")
            
            guard let data = data else {
                completion(.failure(APIError.noData))
                print("noooooooooooo")
                return
            }
            
            var stock: Stock?
            
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
                if let jsonDict = jsonObject as? NSDictionary {
                    print ("Dict: \(jsonDict)")
                }
                stock = try JSONDecoder().decode(Stock.self, from: data)
                guard let stock2 = stock else {
                    print("failed to parse")
                    return
                }
                
                
                completion(.success(stock2))
                print("yay!! Successfully parsed the json data!")
                
                
            } catch {
                completion(.failure(error))
                print("error: \(error)")
                print("noooooooooooooooooooooo!!")
            }
            
            
            
        })
        
        dataTask.resume()
    }
    
    func fetchStockData2(symbol: String, interval: String, range: String) async -> (Result<Stock, Error>) {
        await withCheckedContinuation { continuation in
            fetchStockData(symbol: symbol, interval: interval, range: range) { data in
                continuation.resume(returning: data)
                print("okda but why")
            }
        }
    }
    
    
    
    func fetchStockNews(symbol: String, completion: @escaping (Result<News, Error>) -> Void) {
//        let headers = [
//            "X-RapidAPI-Key": "561eb4fbafmsh5dbf010c70113c6p112a3djsn616b59572848",
//            "X-RapidAPI-Host": "yahoo-finance15.p.rapidapi.com"
//        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.rss2json.com/v1/api.json?rss_url=http://feeds.finance.yahoo.com/rss/2.0/headline?s=\(symbol)")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 20)
        request.httpMethod = "GET"
//        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        session.configuration.timeoutIntervalForResource = 120
        session.configuration.timeoutIntervalForRequest = 120
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if let error = error {
                completion(.failure(error))
                print(error)
                print("noooo")
                return
            }
            let httpResponse = response as? HTTPURLResponse
            print("Response: \(String(describing: httpResponse))")
            
            guard let data = data else {
                completion(.failure(APIError.noData))
                print("noooooooooooo")
                return
            }
            
            var stock: News?
            
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
                if let jsonDict = jsonObject as? NSDictionary {
                    print ("Dict: \(jsonDict)")
                }
                stock = try JSONDecoder().decode(News.self, from: data)
                guard let stock2 = stock else {
                    print("failed to parse")
                    return
                }
                
                
                completion(.success(stock2))
                print("yay!! Successfully parsed the json data!")
                
                
            } catch {
                completion(.failure(error))
                print("error: \(error)")
                print("noooooooooooooooooooooo!!")
            }
            
            
            
        })
        
        dataTask.resume()
    }
    
    func fetchStockNews2(symbol: String) async -> (Result<News, Error>) {
        await withCheckedContinuation { continuation in
            fetchStockNews(symbol: symbol) { data in
                continuation.resume(returning: data)
            }
        }
    }
    
    
    
}


