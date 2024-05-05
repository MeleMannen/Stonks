//
//  ViewModel.swift
//  Aksjer
//
//  Created by Kristoffer Melen on 16/01/2024.
//

import SwiftUI
import Charts

class ViewModel: ObservableObject {
    
    @Published var ready = true
    @Published var stock: SearchResults
    @Published var recivedStock: Stock
    @Published var StockArray: [StockData] = []
    @Published var StockArray2: [StockData] = []
    @Published var StockArraySnitt: [StockData] = []
    @Published var StockRSI: [StockData] = []
    @Published var StockNews: [NewsItems] = []
    @Published var StockOptions: [OptionChainResult] = []
    @Published var RSIValues: [(Int, Double)] = []
    
    @AppStorage var storedRecivedStock: Data
    @AppStorage var StoredStockArray: Data
    @AppStorage var StoredStockArray2: Data
    @AppStorage var StoredStockArraySnitt: Data
    @AppStorage var StoredStockArrayRSI: Data
    @AppStorage var storedStockNews: Data
    @AppStorage var storedLastNewsCheck: Data
    @AppStorage var storedStockOptions: Data
    
    @Published var isShowingOldData = false
    @Published var isUp = true
    @Published var minValue: Float = 1
    @Published var maxValue: Float = 500
    @Published var minValue2: Float = 1
    @Published var maxValue2: Float = 500
    @Published var selectedX: (any Plottable)?
    @Published var selectedXRSI: (any Plottable)?
    @Published var selectedXRSIIndex: Int = 0
    @Published var selectedXY: (any Plottable, any Plottable)?
    @Published var myMap: [(String, String)] = []
    
    @Published var selectedXLine1: (any Plottable)?
    @Published var selectedXLine2: (any Plottable)?
    @Published var selectedXLine3: (any Plottable)?
    @Published var isLine1Selected = false
    @Published var isLine2Selected = false
    @Published var isLine3Selected = false
    @Published var maxXValue: Float = 0
    
    @Published var storedYStartValue: Double = 0
    @Published var storedYEndValue: Double = 0
    @Published var isFixingTestChart = true
    @Published var isMakingLine = false
    @Published var isShowingSnitt50 = false
    @Published var isShowingSnitt200 = false
    @Published var isShowingSnittOptional = false
    @Published var hasShownSnitt50 = false
    @Published var hasShownSnitt200 = false
    @Published var hasShownSnittOptional = false
    @Published var isShowingRSI = false
    @Published var hasShownRSI = false
    @Published var chosenAmount = 0
    @Published var hasChosenAmount = false
    @Published var minutesAdded = 0
    @Published var storedMap: [String: String] = [:]
    @Published var yAxisArray: [Float] = []
    @Published var yAxisArrayRSI: [Float] = [0, 20, 40, 60, 80, 100]

    
    @Published var testChart: ChartViewData
    @Published var tupleArray: [(String, String)] = []
    @Published var tupleArrayOfDates: [(String, Date)] = []
    @Published var newSnittChartTupleArray: [(Int, ChartViewItem)] = []
    @Published var newRSIChartTupleArray: [(Int, ChartViewItem)] = []
    @Published var snittChart: ChartViewData
    @Published var rsiChart: ChartViewData
    
    @Published var number1: Float = 0.00
    @Published var number2: Float = 0.00
    @Published var number3: Float = 0.00
    @Published var openOptions: Float = 0.00
    
    @Published var change: Float = 0
    
    @Published var isFirst = true
    
    @Published var numbersArray: [Int] = []
    
    
    @Published var isViewLoaded = false
    @Published var isViewLoaded2 = false
    @Published var isViewLoaded3 = false
    @Published var isLoadingFirst = true
    @Published var isLoadingOther = false
    @Published var isRefreshing = false
    @Published var shouldShowError = false
    @Published var errorMessage = ""
    
    @Published var isShowingOverlay = false
    @Published var isShowingOptionalView = false
    
    @Published var selectedRange: RangeType = .oneDay
    
    @Published var fileURL: URL?
    
    @Published var isShowingNewsArray: [Bool] = []
//    @Published private var trainingData: MLDataTable?
    
    let dateFormatter = DateFormatter()
    
    let selectedValueDateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .long
        df.locale = Locale(identifier: "nb_NO")
        return df
    }()
    
    var calendar: Calendar {
        var c = Calendar.current
        c.firstWeekday = 2
        return c
    }
    
    
    
    var foregroundMarkColor: Color {
        if isMakingLine {
            Color("ColorBlue")
        } else {
            (selectedX != nil) ? Color("ColorBlue") : (isUp ? .green : .red)
        }
    }
    
    var selectedLineMark1: (value: Int, text: String)? {
        guard let selectedX = selectedXLine1 as? Int else {
            return nil
        }
        return (selectedX, testChart.items[selectedX].value.roundedString)
    }
    
    var selectedLineMark2: (value: Int, text: String)? {
        guard let selectedX = selectedXLine2 as? Int else {
            return nil
        }
        return (selectedX, testChart.items[selectedX].value.roundedString)
    }
    
    var selectedLineMark3: (value: Int, text: String)? {
        guard let selectedX = selectedXLine3 as? Int else {
            return nil
        }
        return (selectedX, testChart.items[selectedX].value.roundedString)
    }
    
    

    
    var selectedXRuleMark: (value: Int, text: String)? {
        guard let selectedX = selectedX as? Int, !isLine3Selected else { return nil }
        return (selectedX, testChart.items[selectedX].value.roundedString)
    }
    
    var selectedXRuleMark2: (xPos: Double, yPos: Double)? {
        guard let selectedXY = selectedXY else { return nil }
        return (selectedXY) as? (xPos: Double, yPos: Double)
    }
    
    var selectedXRuleMarkRSI: (value: Int, text: String)? {
        // , let selectedX = selectedX as? Int, selectedXRSI <= StockArray.count-1
        guard let selectedXRSI = selectedXRSI as? Int else { return nil }
//        if self.selectedRange == .oneWeek || self.selectedRange == .oneMonth1 || self.selectedRange == .oneMonth2 || self.selectedRange == .oneMonth3 || self.selectedRange == .oneMonth4 {
//            var index = selectedXRSI
//            while index >= rsiChart.items.count-1 {
//                index -= 1
//            }
//            let newIndex = self.fixNewStride(index: Int(index))
//            print("oldIndex3: \(index)")
//            print("newIndex3: \(newIndex)")
//            return (newIndex, rsiChart.items[index].value.roundedString)
//            
//        } else {
            return (selectedXRSI, rsiChart.items[selectedXRSIIndex].value.roundedString)
//        }
        
    }
    
    var selectedXDateText: String {
        
        if selectedRange == .oneDay || selectedRange == .oneWeek || selectedRange == .oneMonth1 || selectedRange == .oneMonth2 || selectedRange == .oneMonth3 || selectedRange == .oneMonth4 {
            selectedValueDateFormatter.timeStyle = .short
        } else {
            selectedValueDateFormatter.timeStyle = .none
        }
        if isLine3Selected {
            guard let (xPos, _) = selectedXY else {
                print("No SelectedXY")
                return ""
            }
            let xPos2 = Int(round(xPos as! Double))
            if testChart.items.count - 1 >= xPos2 {
                print("xPos2: \(xPos2)")
                
                let item = testChart.items[xPos2]
                print("item.timestamp: \(item.timestamp)")
                return selectedValueDateFormatter.string(from: item.timestamp)
                
            } else {
                print("xPos2: \(xPos2)")
                print("myMap: \(tupleArrayOfDates)")
                print("count: \(tupleArrayOfDates.count)")
                if let text = tupleArrayOfDates.first(where: { String($0.0) == String(describing: xPos2) }) {
//                    let text2 = text.1.capitalized
                    return selectedValueDateFormatter.string(from: text.1)
                    
                    
                    
                } else {
                    return "No Date"
                }
            }
            
            
            
            
            
        } else {
            guard let selectedX = selectedX as? Int else {
                print("No SelectedX")
                return ""
            }
            let item = testChart.items[selectedX]
            return selectedValueDateFormatter.string(from: item.timestamp)
        }
        
    }
    
    var selectedXOpacity: Double {
        if isLine3Selected {
            selectedXY == nil ? 1 : 0
        } else {
            selectedX == nil ? 1 : 0
        }
        
        
        
    }
    
    init(ready: Bool = true, stock: SearchResults, recivedStock: Stock, StockArray: [StockData] = [], StockArray2: [StockData] = [], StockArraySnitt: [StockData] = [], isUp: Bool = true, minValue: Float = 1, maxValue: Float = 500, selectedX: (any Plottable)? = nil, testChart: ChartViewData, tupleArray: [(String, String)] = [], snittChart: ChartViewData, rsiChart: ChartViewData, number1: Float = 0.00, number2: Float = 0.00, change: Float = 0, isLoading: Bool = true, shouldShowError: Bool = false, errorMessage: String = "", selectedRange: RangeType = .oneDay) {
        self.ready = ready
        self._storedRecivedStock = AppStorage(wrappedValue: Data(), "StoredRecivedStockFor: \(stock.symbol), \(selectedRange)")
        self._StoredStockArray = AppStorage(wrappedValue: Data(), "StoredStockArrayFor: \(stock.symbol), \(selectedRange)")
        self._StoredStockArray2 = AppStorage(wrappedValue: Data(), "StoredStockArray2For: \(stock.symbol), \(selectedRange)")
        self._StoredStockArraySnitt = AppStorage(wrappedValue: Data(), "StoredStockArraySnittFor: \(stock.symbol), \(selectedRange)")
        self._StoredStockArrayRSI = AppStorage(wrappedValue: Data(), "StoredStockArrayRSIFor: \(stock.symbol), \(selectedRange)")
        self._storedStockNews = AppStorage(wrappedValue: Data(), "StoredStockNewsFor: \(stock.symbol)")
        self._storedLastNewsCheck = AppStorage(wrappedValue: Data(), "StoredLastNewsCheck: \(stock.symbol)")
        self._storedStockOptions = AppStorage(wrappedValue: Data(), "StoredStockOptionsFor: \(stock.symbol)")
        self.stock = stock
        self.recivedStock = recivedStock
        self.StockArray = StockArray
        self.StockArray2 = StockArray2
        self.StockArraySnitt = StockArraySnitt
        self.isUp = isUp
        self.minValue = minValue
        self.maxValue = maxValue
        self.selectedX = selectedX
        self.testChart = testChart
        self.tupleArray = tupleArray
        self.snittChart = snittChart
        self.rsiChart = rsiChart
        self.number1 = number1
        self.number2 = number2
        self.change = change
        self.isLoadingFirst = isLoading
        self.shouldShowError = shouldShowError
        self.errorMessage = errorMessage
        self.selectedRange = selectedRange
        
    }
    
    
    func getNewStockChartAsync() async {
        print("i am running this function4")
        if ready {
            self._storedRecivedStock = AppStorage(wrappedValue: Data(), "StoredRecivedStockFor: \(stock.symbol), \(selectedRange)")
            self._StoredStockArray = AppStorage(wrappedValue: Data(), "StoredStockArrayFor: \(stock.symbol), \(selectedRange)")
            self._StoredStockArray2 = AppStorage(wrappedValue: Data(), "StoredStockArray2For: \(stock.symbol), \(selectedRange)")
            self._storedStockNews = AppStorage(wrappedValue: Data(), "StoredStockNewsFor: \(stock.symbol)")
            self._storedStockOptions = AppStorage(wrappedValue: Data(), "StoredStockOptionsFor: \(stock.symbol)")
            print("but i am here now")
            let stock = await APIFetch.shared.fetchStockData2(symbol: "\(stock.symbol)", interval: selectedRange.realInterval, range: selectedRange.realRange)
            print("okda jeg er her nå!")
            switch stock {
                    
                case .success(let result):
                    print("result: \(result)")
                    self.recivedStock = result
                    self.StockArray.removeAll()
                    self.StockArray2.removeAll()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd-MM-yyyy"
                    
                    let quote = result.chart.result[0].indicators.quote[0]
                    let timestamps = result.chart.result[0].timestamp
                    print("Klar for for-loop")
                    for i in 0..<quote.close.count {
                        let close = quote.close[i]
                        
                        if let close = close, close != 0 {
                            let timestamp = timestamps[i]
                            let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
                            let newDate = dateFormatter.string(from: date)
                            
                            let high = quote.high[i] ?? 0
                            let low = quote.low[i] ?? 0
                            let open = quote.open[i] ?? 0
                            let volume = quote.volume[i] ?? 0
                            
                            let stockdata = StockData(close: Float(close),
                                                      date: newDate,
                                                      date_utc: timestamp,
                                                      high: Float(high),
                                                      low: Float(low),
                                                      open: Float(open),
                                                      volume: volume)
                            
                            DispatchQueue.main.async {
                                self.StockArray.append(stockdata)
                            }
                        } else {
                            print("feil data")
                        }
                    }
                    print("Ferdig med for-loop")
                    
                    
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.00001) {
                        print("jeg er inni delay")
                        
                        if let encodedData = try? JSONEncoder().encode(self.recivedStock) {
                            self.storedRecivedStock = encodedData
                            print("i am here1")
                            
                        } else {
                            print("Error: Kunne ikke lagre recivedStock")
                        }
                        
                        if let encodedData = try? JSONEncoder().encode(self.StockArray) {
                            self.StoredStockArray = encodedData
                            print("i am here2")
                            
                        } else {
                            print("Error: Kunne ikke lagre StockArray")
                        }
                        
                        print("but why!!!: \(self.StockArray)")
                        if self.selectedRange == .nineMonths {
                            let nineMonthsPriorDate = self.getNineMonthsPriorDate()
                            let filteredItems = self.StockArray.filter { Date(timeIntervalSince1970: TimeInterval($0.date_utc)) > nineMonthsPriorDate }
                            
                            self.StockArray = Array(filteredItems)
                            print("lastNineMonths: \(self.StockArray)")
                            
                            
                        } else if self.selectedRange == .threeYears {
                            let threeYearsPriorDate = self.getThreeYearsPriorDate()
                            let filteredItems = self.StockArray.filter { Date(timeIntervalSince1970: TimeInterval($0.date_utc)) > threeYearsPriorDate }
                            self.StockArray = Array(filteredItems)
                            print("lastThreeYears: \(self.StockArray)")
                        }
                        
                        
                        print("fikser TestChart")
                        self.fixTestChart()
                        print("har fikset TestChart")
                        
                        
                        if let minV = self.StockArray.map({ $0.close }).min(), let maxV = self.StockArray.map({ $0.close }).max() {
                            self.minValue = minV
                            self.maxValue = maxV
                            
                        }
                        
                        if self.selectedRange == .oneDay {
                            if let lastClose = self.StockArray.last?.close, let last = self.recivedStock.chart.result.first?.meta.chartPreviousClose {
                                self.isUp = lastClose >= Float(last)
                                
                            }  else {
                                self.isUp = true
                                
                            }
                        } else {
                            if let lastClose = self.StockArray.last?.close, let firstClose = self.StockArray.first?.close {
                                self.isUp = lastClose >= firstClose
                            }
                            else {
                                self.isUp = true
                            }
                        }
                        
                        
                        
                        self.isFirst = true
                        self.isShowingOldData = false
                        
                        print("nå skal alt være bra!")
                        self.shouldShowError = false
                        
                        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                            print("jeg er inni delay2")
                            self.isLoadingFirst = false
                            self.isLoadingOther = false
                            self.isRefreshing = false
                            print("nå skal alt være bra2!")
                        }
                        print("jeg er ferdig med delay2")
                        
                        
                    }
                    
                    print("jeg er ferdig med delay")
                    
                    
                case .failure(let error):
                    print("Error: \(error)")
                    let errorText = "\(error)"
                    if errorText.contains("CFNetwork") {
                        if let decodedData = try? JSONDecoder().decode(Stock.self, from: self.storedRecivedStock) {
                            self.recivedStock = decodedData
                            print("Hentet lagret Stock")
                            
                        } else {
                            self.shouldShowError = true
                            self.errorMessage = "\(error)"
                            self.isLoadingFirst = false
                            self.isLoadingOther = false
                            self.isRefreshing = false
                            return
                        }
                        
                        if let decodedData = try? JSONDecoder().decode([StockData].self, from: self.StoredStockArray) {
                            self.StockArray = decodedData
                            print("Hentet lagret Stock")
                            
                        } else {
                            self.shouldShowError = true
                            self.errorMessage = "\(error)"
                            self.isLoadingFirst = false
                            self.isLoadingOther = false
                            self.isRefreshing = false
                            return
                        }
                        

                        print("but why!!!: \(self.StockArray)")
                        if self.selectedRange == .nineMonths {
                            let nineMonthsPriorDate = self.getNineMonthsPriorDate()
                            let filteredItems = self.StockArray.filter { Date(timeIntervalSince1970: TimeInterval($0.date_utc)) > nineMonthsPriorDate }
                            
                            self.StockArray = Array(filteredItems)
                            print("lastNineMonths: \(self.StockArray)")
                            
                            
                        } else if self.selectedRange == .threeYears {
                            let threeYearsPriorDate = self.getThreeYearsPriorDate()
                            let filteredItems = self.StockArray.filter { Date(timeIntervalSince1970: TimeInterval($0.date_utc)) > threeYearsPriorDate }
                            self.StockArray = Array(filteredItems)
                            print("lastThreeYears: \(self.StockArray)")
                        }
                        
                        
                        print("fikser TestChart")
                        self.fixTestChart()
                        print("har fikset TestChart")
                        
                        
                        if let minV = self.StockArray.map({ $0.close }).min(), let maxV = self.StockArray.map({ $0.close }).max() {
                            self.minValue = minV
                            self.maxValue = maxV
                            
                        }
                        
                        if self.selectedRange == .oneDay {
                            if let lastClose = self.StockArray.last?.close, let last = self.recivedStock.chart.result.first?.meta.chartPreviousClose {
                                self.isUp = lastClose >= Float(last)
                                
                            }  else {
                                self.isUp = true
                                
                            }
                        } else {
                            if let lastClose = self.StockArray.last?.close, let firstClose = self.StockArray.first?.close {
                                self.isUp = lastClose >= firstClose
                            }
                            else {
                                self.isUp = true
                            }
                        }
                        
                        
                        
                        self.isFirst = true
                        self.isShowingOldData = true
                        
                        print("nå skal alt være bra!")
                        self.shouldShowError = false
                        
                        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                            self.isLoadingFirst = false
                            self.isLoadingOther = false
                            self.isRefreshing = false
                            print("nå skal alt være bra2!")
                        }
                        
                        
                        
                        
                    } else {
                        self.isLoadingFirst = false
                        self.isLoadingOther = false
                        self.isRefreshing = false
                        self.shouldShowError = true
                        self.errorMessage = "\(error)"
                        self.isShowingOldData = false
                        print("Nå er jeg ferdig5!")
                    }
                    
                    isFirst = true
            }
            
        } else {
            print("False!!")
        }
    }
    
    
    func getStockOptions() {
        print("fetching stock options")
        self._storedStockOptions = AppStorage(wrappedValue: Data(), "StoredStockOptionsFor: \(stock.symbol)")
        APIFetch.shared.fetchStockOptions(symbol: stock.symbol, completion: { options in
            switch options {
                case .success(let result):
                    DispatchQueue.main.async {
                        self.StockOptions = result.optionChain.result
                        print("moving forward")
                        print("StockOptions: \(self.StockOptions)")
                        
                        
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.0001) {
                        if let encodedData = try? JSONEncoder().encode(self.StockOptions) {
                            self.storedStockOptions = encodedData
                            
                        } else {
                            print("Error: Kunne ikke lagre StockOptions")
                        }
                        
                        print("nå er jeg ferdig med StockOptions")
                    }
                    
                    
                    
                    
                    
                case .failure(let error):
                    print("error: \(error)")
                    if let decodedData = try? JSONDecoder().decode([OptionChainResult].self, from: self.storedStockOptions) {
                        DispatchQueue.main.async {
                            self.StockOptions = decodedData
                            print("Hentet lagret Stock Options: \(self.StockOptions)")
                        }
                        
                        
                    } else {
                        self.StockOptions.removeAll()
                    }
            }
        })
        
        
        
        
    }
    
    func getNewStockSnitt(days: Int) {
        print("i am running this function5")
        if ready {
            self.isLoadingFirst = true
            self._storedRecivedStock = AppStorage(wrappedValue: Data(), "StoredRecivedStockFor: \(stock.symbol), \(selectedRange)")
            self._StoredStockArray = AppStorage(wrappedValue: Data(), "StoredStockArrayFor: \(stock.symbol), \(selectedRange)")
            self._StoredStockArray2 = AppStorage(wrappedValue: Data(), "StoredStockArray2For: \(stock.symbol), \(selectedRange)")
            self._StoredStockArraySnitt = AppStorage(wrappedValue: Data(), "StoredStockArraySnittFor: \(stock.symbol), \(selectedRange)")
            self._storedStockNews = AppStorage(wrappedValue: Data(), "StoredStockNewsFor: \(stock.symbol)")
            print("but i am here now2")
            
            APIFetch.shared.fetchStockData(symbol: stock.symbol, interval: "1d", range: "10y", completion: { stock in
                print("okda jeg er her nå2!")
                switch stock {
                        
                    case .success(let result):
                        print("result2: \(result)")
                        
                        self.StockArraySnitt.removeAll()
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "dd-MM-yyyy"
                        
                        let quote = result.chart.result[0].indicators.quote[0]
                        let timestamps = result.chart.result[0].timestamp
                        
                        for i in 0..<quote.close.count {
                            let close = quote.close[i]
                            
                            if let close = close, close != 0 {
                                let timestamp = timestamps[i]
                                let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
                                let newDate = dateFormatter.string(from: date)
                                
                                let high = quote.high[i] ?? 0
                                let low = quote.low[i] ?? 0
                                let open = quote.open[i] ?? 0
                                let volume = quote.volume[i] ?? 0
                                
                                let stockdata = StockData(close: Float(close),
                                                          date: newDate,
                                                          date_utc: timestamp,
                                                          high: Float(high),
                                                          low: Float(low),
                                                          open: Float(open),
                                                          volume: volume)
                                
                                DispatchQueue.main.async {
                                    self.StockArraySnitt.append(stockdata)
                                }
                            } else {
                                print("feil data")
                            }
                        }
                        print("jeg er her1")
                        
                        DispatchQueue.main.asyncAfter(deadline: .now()+0.0000000000000000001) {
                            self.StockArraySnitt.sort() {$0 < $1}
                            print("StockArraySnitt: \(self.StockArraySnitt)")
                            
                            if let encodedData = try? JSONEncoder().encode(self.StockArraySnitt) {
                                self.StoredStockArraySnitt = encodedData
                                print("i am here3")
                                
                            } else {
                                print("Error: Kunne ikke lagre StockArraySnitt")
                            }
                            
                            var snittArray: [StockData] = []
                            
                            for item in self.StockArraySnitt {
                                var closeSnitt: Float = 0
                                if let itemIndex = self.StockArraySnitt.firstIndex(of: item) {
                                    if itemIndex >= days {
                                        let startIndex = itemIndex - days
                                        let endIndex = itemIndex
                                        let subarray = Array(self.StockArraySnitt[startIndex..<endIndex])
                                        
                                        for snitt in subarray {
                                            closeSnitt += snitt.close
                                        }
                                        
                                        
                                        let snitt = StockData(close: Float(closeSnitt/Float(days)), date: item.date, date_utc: item.date_utc, high: item.high, low: item.low, open: item.open, volume: item.volume)
                                        snittArray.append(snitt)
                                    } else {
                                        print("kan ikke brukes")
                                    }
                                    
                                    
                                } else {
                                    print("bad bad")
                                }
                                
                            }
                            
                            
                            
                            self.StockArraySnitt = snittArray
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.000000000001) {
                                self.StockArraySnitt = self.fixSnittChart()
                                print("StockArraySnitt2: \(self.StockArraySnitt)")
                                
                                
                                var indicators2: [Indicator] = []
                                for indicator in self.StockArraySnitt {
                                    let date = indicator.date_utc
                                    indicators2.append(Indicator(timestamp: Date(timeIntervalSince1970: TimeInterval(date)),
                                                                 open: Double(indicator.open),
                                                                 high: Double(indicator.high),
                                                                 low: Double(indicator.low),
                                                                 close: Double(indicator.close)))
                                }
                                
                                print("nah mtf2")
                                if let tradingPeriods = self.recivedStock.chart.result[0].meta.tradingPeriods {
                                    self.snittChart = self.transformChartViewData(ChartData(
                                        meta: ChartMeta(currency: self.recivedStock.chart.result[0].meta.currency,
                                                        symbol: self.recivedStock.chart.result[0].meta.symbol,
                                                        regularMarketPrice: Double(self.recivedStock.chart.result[0].meta.regularMarketPrice),
                                                        previousClose: self.recivedStock.chart.result[0].meta.chartPreviousClose,
                                                        gmtOffset: self.recivedStock.chart.result[0].meta.gmtoffset,
                                                        regularTradingPeriodStartDate: Date(timeIntervalSince1970: TimeInterval(tradingPeriods[0][0].start)),
                                                        regularTradingPeriodEndDate: Date(timeIntervalSince1970: TimeInterval(tradingPeriods[0][0].end))),
                                        indicators: indicators2))
                                } else {
                                    self.snittChart = self.transformChartViewData(ChartData(
                                        meta: ChartMeta(currency: self.recivedStock.chart.result[0].meta.currency,
                                                        symbol: self.recivedStock.chart.result[0].meta.symbol,
                                                        regularMarketPrice: Double(self.recivedStock.chart.result[0].meta.regularMarketPrice),
                                                        previousClose: self.recivedStock.chart.result[0].meta.chartPreviousClose,
                                                        gmtOffset: self.recivedStock.chart.result[0].meta.gmtoffset,
                                                        regularTradingPeriodStartDate: Date(timeIntervalSince1970: TimeInterval(self.recivedStock.chart.result[0].meta.currentTradingPeriod.regular.start)),
                                                        regularTradingPeriodEndDate: Date(timeIntervalSince1970: TimeInterval(self.recivedStock.chart.result[0].meta.currentTradingPeriod.regular.end))),
                                        indicators: indicators2))
                                }
                                
                                let array = Array(zip(self.snittChart.items.indices, self.snittChart.items))
                                self.newSnittChartTupleArray.removeAll()
                                for (index, item) in array {
                                    if item.value != 0 {
                                        if self.selectedRange == .oneWeek || self.selectedRange == .oneMonth1 || self.selectedRange == .oneMonth2 || self.selectedRange == .oneMonth3 || self.selectedRange == .oneMonth4 {
                                            let newIndex = self.fixNewStride(index: index)
                                            print("oldIndex: \(index)")
                                            print("newIndex: \(newIndex), value: \(item.value)")
                                            self.newSnittChartTupleArray.append((newIndex, item))
                                        } else {
                                            self.newSnittChartTupleArray.append((index, item))
                                        }
                                        
                                        
                                        
                                        
                                    }
                                }
                                self.newSnittChartTupleArray.sort { $0.0 < $1.0 }
                                
                                
                                
                                self.isFirst = true
                                self.isShowingOldData = false
                                self.isLoadingFirst = false
                                self.isLoadingOther = false
                                self.isRefreshing = false
                                
                                print("nå skal alt være bra2: Snitt: \(self.newSnittChartTupleArray.count), \(self.StockArray.count)!")
                                self.shouldShowError = false
                            }
                        }
                        
                        
                        
                        
                        
                        
                    case .failure(let error):
                        print("Error: \(error)")
                        let errorText = "\(error)"
                        if errorText.contains("CFNetwork") {
                            self.shouldShowError = false
                            if let decodedData = try? JSONDecoder().decode(Stock.self, from: self.storedRecivedStock) {
                                self.recivedStock = decodedData
                                print("Hentet lagret Stock")
                                
                            } else {
                                self.shouldShowError = true
                                self.errorMessage = "\(error)"
                                self.isLoadingFirst = false
                                self.isLoadingOther = false
                                self.isRefreshing = false
                            }
                            
                            if let decodedData = try? JSONDecoder().decode([StockData].self, from: self.StoredStockArray) {
                                self.StockArray = decodedData
                                print("Hentet lagret Stock")
                                
                            } else {
                                self.shouldShowError = true
                                self.errorMessage = "\(error)"
                                self.isLoadingFirst = false
                                self.isLoadingOther = false
                                self.isRefreshing = false
                            }
                            
                            if let decodedData = try? JSONDecoder().decode([StockData].self, from: self.StoredStockArray2) {
                                self.StockArray2 = decodedData
                                print("Hentet lagret Stock")
                                
                            } else {
                                self.shouldShowError = true
                                self.errorMessage = "\(error)"
                                self.isLoadingFirst = false
                                self.isLoadingOther = false
                                self.isRefreshing = false
                            }
                            
                            if let decodedData = try? JSONDecoder().decode([StockData].self, from: self.StoredStockArraySnitt) {
                                self.StockArraySnitt = decodedData
                                print("Hentet lagret Stock")
                                
                            } else {
                                self.shouldShowError = true
                                self.errorMessage = "\(error)"
                                self.isLoadingFirst = false
                                self.isLoadingOther = false
                                self.isRefreshing = false
                            }
                            
                            
                            
                            var snittArray: [StockData] = []
                            
                            for item in self.StockArraySnitt {
                                var closeSnitt: Float = 0
                                if let itemIndex = self.StockArraySnitt.firstIndex(of: item) {
                                    if itemIndex >= days {
                                        let startIndex = itemIndex - days
                                        let endIndex = itemIndex
                                        let subarray = Array(self.StockArraySnitt[startIndex..<endIndex])
                                        
                                        for snitt in subarray {
                                            closeSnitt += snitt.close
                                        }
                                        
                                        
                                        let snitt = StockData(close: Float(closeSnitt/Float(days)), date: item.date, date_utc: item.date_utc, high: item.high, low: item.low, open: item.open, volume: item.volume)
                                        snittArray.append(snitt)
                                    } else {
                                        print("kan ikke brukes")
                                    }
                                    
                                    
                                } else {
                                    print("bad bad")
                                }
                                
                            }
                            
                            
                            
                            self.StockArraySnitt = snittArray
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.000000000001) {
                                self.StockArraySnitt = self.fixSnittChart()
                                print("StockArraySnitt2: \(self.StockArraySnitt)")
                                
                                
                                var indicators2: [Indicator] = []
                                for indicator in self.StockArraySnitt {
                                    let date = indicator.date_utc
                                    indicators2.append(Indicator(timestamp: Date(timeIntervalSince1970: TimeInterval(date)),
                                                                 open: Double(indicator.open),
                                                                 high: Double(indicator.high),
                                                                 low: Double(indicator.low),
                                                                 close: Double(indicator.close)))
                                }
                                
                                print("nah mtf2")
                                if let tradingPeriods = self.recivedStock.chart.result[0].meta.tradingPeriods {
                                    self.snittChart = self.transformChartViewData(ChartData(
                                        meta: ChartMeta(currency: self.recivedStock.chart.result[0].meta.currency,
                                                        symbol: self.recivedStock.chart.result[0].meta.symbol,
                                                        regularMarketPrice: Double(self.recivedStock.chart.result[0].meta.regularMarketPrice),
                                                        previousClose: self.recivedStock.chart.result[0].meta.chartPreviousClose,
                                                        gmtOffset: self.recivedStock.chart.result[0].meta.gmtoffset,
                                                        regularTradingPeriodStartDate: Date(timeIntervalSince1970: TimeInterval(tradingPeriods[0][0].start)),
                                                        regularTradingPeriodEndDate: Date(timeIntervalSince1970: TimeInterval(tradingPeriods[0][0].end))),
                                        indicators: indicators2))
                                } else {
                                    self.snittChart = self.transformChartViewData(ChartData(
                                        meta: ChartMeta(currency: self.recivedStock.chart.result[0].meta.currency,
                                                        symbol: self.recivedStock.chart.result[0].meta.symbol,
                                                        regularMarketPrice: Double(self.recivedStock.chart.result[0].meta.regularMarketPrice),
                                                        previousClose: self.recivedStock.chart.result[0].meta.chartPreviousClose,
                                                        gmtOffset: self.recivedStock.chart.result[0].meta.gmtoffset,
                                                        regularTradingPeriodStartDate: Date(timeIntervalSince1970: TimeInterval(self.recivedStock.chart.result[0].meta.currentTradingPeriod.regular.start)),
                                                        regularTradingPeriodEndDate: Date(timeIntervalSince1970: TimeInterval(self.recivedStock.chart.result[0].meta.currentTradingPeriod.regular.end))),
                                        indicators: indicators2))
                                }
                                
                                let array = Array(zip(self.snittChart.items.indices, self.snittChart.items))
                                self.newSnittChartTupleArray.removeAll()
                                for (index, item) in array {
                                    if item.value != 0 {
                                        if self.selectedRange == .oneWeek || self.selectedRange == .oneMonth1 || self.selectedRange == .oneMonth2 || self.selectedRange == .oneMonth3 || self.selectedRange == .oneMonth4 {
                                            let newIndex = self.fixNewStride(index: index)
                                            print("oldIndex: \(index)")
                                            print("newIndex: \(newIndex), value: \(item.value)")
                                            self.newSnittChartTupleArray.append((newIndex, item))
                                        } else {
                                            self.newSnittChartTupleArray.append((index, item))
                                        }
                                        
                                        
                                        
                                        
                                    }
                                }
                                self.newSnittChartTupleArray.sort { $0.0 < $1.0 }
                                
                                
                                
                                self.isFirst = true
                                self.isLoadingFirst = false
                                self.isLoadingOther = false
                                self.isRefreshing = false
                                
                                print("nå skal alt være bra2: Snitt: \(self.newSnittChartTupleArray.count), \(self.StockArray.count)!")
                                self.shouldShowError = false
                            }
                            
                            
                            
                            
                        } else {
                            self.shouldShowError = true
                            self.errorMessage = "\(error)"
                            self.isLoadingFirst = false
                            self.isLoadingOther = false
                            self.isRefreshing = false
                            print("Nå er jeg ferdig5!")
                        }
                        
                        self.isFirst = true
                }
                
            })
            
            
        } else {
            print("False!!")
            }
            
    }
    
    
    
    
    func getNewStockRSI() {
        print("i am running this function5")
        if ready {
            self.isLoadingFirst = true
            self._storedRecivedStock = AppStorage(wrappedValue: Data(), "StoredRecivedStockFor: \(stock.symbol), \(selectedRange)")
            self._StoredStockArray = AppStorage(wrappedValue: Data(), "StoredStockArrayFor: \(stock.symbol), \(selectedRange)")
            self._StoredStockArray2 = AppStorage(wrappedValue: Data(), "StoredStockArray2For: \(stock.symbol), \(selectedRange)")
            self._StoredStockArraySnitt = AppStorage(wrappedValue: Data(), "StoredStockArraySnittFor: \(stock.symbol), \(selectedRange)")
            self._StoredStockArrayRSI = AppStorage(wrappedValue: Data(), "StoredStockArrayRSIFor: \(stock.symbol), \(selectedRange)")
            self._storedStockNews = AppStorage(wrappedValue: Data(), "StoredStockNewsFor: \(stock.symbol)")
            print("but i am here now2")
            
            APIFetch.shared.fetchStockData(symbol: stock.symbol, interval: "1d", range: "10y", completion: { stock in
                print("okda jeg er her nå2!")
                switch stock {
                        
                    case .success(let result):
                        print("result22: \(result)")
                        
                        self.StockRSI.removeAll()
                        
                        
                        for i in 0..<result.chart.result[0].indicators.quote[0].close.count  {
                            let quote = result.chart.result[0].indicators.quote[0]
                            
                            if quote.close[i] != 0 && quote.close[i] != nil {
                                let date = Date(timeIntervalSince1970: TimeInterval(result.chart.result[0].timestamp[i]))
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "dd-MM-yyyy"
                                let newDate = dateFormatter.string(from: date)
                                let stockdata = StockData(close: Float(quote.close[i]!), date: newDate, date_utc: result.chart.result[0].timestamp[i], high: Float(quote.high[i]!), low: Float(quote.low[i]!), open: Float(quote.open[i]!), volume: quote.volume[i]!)
                                self.StockRSI.append(stockdata)
                            }
                        }
                        
                        
                        self.StockRSI.sort() {$0 < $1}
                        print("StockRSI: \(self.StockRSI)")
                        
                        if let encodedData = try? JSONEncoder().encode(self.StockRSI) {
                            self.StoredStockArrayRSI = encodedData
                            print("i am here3")
                            
                        } else {
                            print("Error: Kunne ikke lagre StockArray2")
                        }
                        
                        self.getRSI()
                        
                        
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.000000000001) { [self] in
                            self.StockRSI = Array(self.StockRSI.suffix(self.getMaxRSINumber()))
                            var newRsi: [StockData] = []
                            
                            
                            for rsi in self.StockRSI {
                                if let index = self.StockRSI.firstIndex(of: rsi) {
                                    newRsi.append(StockData(close: Float(self.RSIValues[index].1), date: rsi.date, date_utc: rsi.date_utc, high: rsi.high, low: rsi.low, open: rsi.open, volume: rsi.volume))
                                }
                            }
                            self.StockRSI = newRsi
                            var indicators2: [Indicator] = []
                            for indicator in self.StockRSI {
                                let date = indicator.date_utc
                                indicators2.append(Indicator(timestamp: Date(timeIntervalSince1970: TimeInterval(date)),
                                                             open: Double(indicator.open),
                                                             high: Double(indicator.high),
                                                             low: Double(indicator.low),
                                                             close: Double(indicator.close)))
                            }
                            print("StockRSI: \(self.StockRSI)")
                            print("nah mtf2")
                            if let tradingPeriods = self.recivedStock.chart.result[0].meta.tradingPeriods {
                                self.rsiChart = self.transformChartViewDataRSI(ChartData(
                                    meta: ChartMeta(currency: self.recivedStock.chart.result[0].meta.currency,
                                                    symbol: self.recivedStock.chart.result[0].meta.symbol,
                                                    regularMarketPrice: Double(self.recivedStock.chart.result[0].meta.regularMarketPrice),
                                                    previousClose: self.recivedStock.chart.result[0].meta.chartPreviousClose,
                                                    gmtOffset: self.recivedStock.chart.result[0].meta.gmtoffset,
                                                    regularTradingPeriodStartDate: Date(timeIntervalSince1970: TimeInterval(tradingPeriods[0][0].start)),
                                                    regularTradingPeriodEndDate: Date(timeIntervalSince1970: TimeInterval(tradingPeriods[0][0].end))),
                                    indicators: indicators2))
                            } else {
                                self.rsiChart = self.transformChartViewDataRSI(ChartData(
                                    meta: ChartMeta(currency: self.recivedStock.chart.result[0].meta.currency,
                                                    symbol: self.recivedStock.chart.result[0].meta.symbol,
                                                    regularMarketPrice: Double(self.recivedStock.chart.result[0].meta.regularMarketPrice),
                                                    previousClose: self.recivedStock.chart.result[0].meta.chartPreviousClose,
                                                    gmtOffset: self.recivedStock.chart.result[0].meta.gmtoffset,
                                                    regularTradingPeriodStartDate: Date(timeIntervalSince1970: TimeInterval(self.recivedStock.chart.result[0].meta.currentTradingPeriod.regular.start)),
                                                    regularTradingPeriodEndDate: Date(timeIntervalSince1970: TimeInterval(self.recivedStock.chart.result[0].meta.currentTradingPeriod.regular.end))),
                                    indicators: indicators2))
                            }
                            let array = Array(zip(self.rsiChart.items.indices, self.rsiChart.items))
                            self.newRSIChartTupleArray.removeAll()
                            for (index, item) in array {
                                if item.value != 0 {
                                    if self.selectedRange == .oneWeek || self.selectedRange == .oneMonth1 || self.selectedRange == .oneMonth2 || self.selectedRange == .oneMonth3 || self.selectedRange == .oneMonth4 {
                                        let newIndex = self.fixNewStride(index: index)
                                        print("oldIndex2: \(index)")
                                        print("newIndex2: \(newIndex), value2: \(item.value)")
                                        self.newRSIChartTupleArray.append((newIndex, item))
                                    } else {
                                        self.newRSIChartTupleArray.append((index, item))
                                    }
                                    
                                    
                                    
                                    
                                }
                            }
//                            for (index, item) in array {
//                                if item.value != 0 {
//                                    self.newRSIChartTupleArray.append((index, item))
//                                }
//                            }
                            self.newRSIChartTupleArray.sort { $0.0 < $1.0 }
                            print("newRSIChartTupleArray: \(self.newRSIChartTupleArray)")
                            
                            self.isLoadingFirst = false
                            self.isLoadingOther = false
                            self.isRefreshing = false
                            self.isFirst = true
                            
                            print("nå skal alt være bra!")
                            self.shouldShowError = false
                            
                            
                            print("nå skal alt være bra2!")
                        }
                        
                        
                        
                        
                        
                    case .failure(let error):
                        print("Error: \(error)")
                        let errorText = "\(error)"
                        if errorText.contains("CFNetwork") {
                            
                            if let decodedData = try? JSONDecoder().decode([StockData].self, from: self.StoredStockArrayRSI) {
                                self.StockRSI = decodedData
                                print("Hentet lagret Stock123")
                                self.getRSI()
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.000000000001) { [self] in
                                    self.StockRSI = Array(self.StockRSI.suffix(self.getMaxRSINumber()))
                                    var newRsi: [StockData] = []
                                    
                                    
                                    for rsi in self.StockRSI {
                                        if let index = self.StockRSI.firstIndex(of: rsi) {
                                            newRsi.append(StockData(close: Float(self.RSIValues[index].1), date: rsi.date, date_utc: rsi.date_utc, high: rsi.high, low: rsi.low, open: rsi.open, volume: rsi.volume))
                                        }
                                    }
                                    self.StockRSI = newRsi
                                    var indicators2: [Indicator] = []
                                    for indicator in self.StockRSI {
                                        let date = indicator.date_utc
                                        indicators2.append(Indicator(timestamp: Date(timeIntervalSince1970: TimeInterval(date)),
                                                                     open: Double(indicator.open),
                                                                     high: Double(indicator.high),
                                                                     low: Double(indicator.low),
                                                                     close: Double(indicator.close)))
                                    }
                                    print("StockRSI: \(self.StockRSI)")
                                    print("nah mtf2")
                                    if let tradingPeriods = self.recivedStock.chart.result[0].meta.tradingPeriods {
                                        self.rsiChart = self.transformChartViewData(ChartData(
                                            meta: ChartMeta(currency: self.recivedStock.chart.result[0].meta.currency,
                                                            symbol: self.recivedStock.chart.result[0].meta.symbol,
                                                            regularMarketPrice: Double(self.recivedStock.chart.result[0].meta.regularMarketPrice),
                                                            previousClose: self.recivedStock.chart.result[0].meta.chartPreviousClose,
                                                            gmtOffset: self.recivedStock.chart.result[0].meta.gmtoffset,
                                                            regularTradingPeriodStartDate: Date(timeIntervalSince1970: TimeInterval(tradingPeriods[0][0].start)),
                                                            regularTradingPeriodEndDate: Date(timeIntervalSince1970: TimeInterval(tradingPeriods[0][0].end))),
                                            indicators: indicators2))
                                    } else {
                                        self.rsiChart = self.transformChartViewData(ChartData(
                                            meta: ChartMeta(currency: self.recivedStock.chart.result[0].meta.currency,
                                                            symbol: self.recivedStock.chart.result[0].meta.symbol,
                                                            regularMarketPrice: Double(self.recivedStock.chart.result[0].meta.regularMarketPrice),
                                                            previousClose: self.recivedStock.chart.result[0].meta.chartPreviousClose,
                                                            gmtOffset: self.recivedStock.chart.result[0].meta.gmtoffset,
                                                            regularTradingPeriodStartDate: Date(timeIntervalSince1970: TimeInterval(self.recivedStock.chart.result[0].meta.currentTradingPeriod.regular.start)),
                                                            regularTradingPeriodEndDate: Date(timeIntervalSince1970: TimeInterval(self.recivedStock.chart.result[0].meta.currentTradingPeriod.regular.end))),
                                            indicators: indicators2))
                                    }
                                    
                                    let array = Array(zip(self.rsiChart.items.indices, self.rsiChart.items))
                                    self.newRSIChartTupleArray.removeAll()
                                    for (index, item) in array {
                                        if item.value != 0 {
                                            self.newRSIChartTupleArray.append((index, item))
                                        }
                                    }
                                    self.newRSIChartTupleArray.sort { $0.0 < $1.0 }
                                    print("newRSIChartTupleArray: \(self.newRSIChartTupleArray)")
                                    
                                    self.isLoadingFirst = false
                                    self.isLoadingOther = false
                                    self.isRefreshing = false
                                    self.isFirst = true
                                    
                                    print("nå skal alt være bra!")
                                    self.shouldShowError = false
                                    
                                    
                                    print("nå skal alt være bra2!")
                                }
                                
                            } else {
                                self.shouldShowError = true
                                self.errorMessage = "\(error)"
                                self.isLoadingFirst = false
                                self.isLoadingOther = false
                                self.isRefreshing = false
                                print("Nå er jeg ferdig6!")
                            }
                            
                            
                            
                            
                        } else {
                            self.shouldShowError = true
                            self.errorMessage = "\(error)"
                            self.isLoadingFirst = false
                            self.isLoadingOther = false
                            self.isRefreshing = false
                            print("Nå er jeg ferdig5!")
                        }
                        
                        self.isFirst = true
                }
                
            })
            
            
        } else {
            print("False!!")
        }
        
    }
    
    
    
    func getStockNews() {
        self._storedLastNewsCheck = AppStorage(wrappedValue: Data(), "StoredLastNewsCheck: \(stock.symbol)")
        APIFetch.shared.fetchStockNews(symbol: stock.symbol, completion: { news in
            switch news {
                case .success(let result):
                    DispatchQueue.main.async {
                        self.StockNews = result.items
                        print("moving forward")
                        self.isShowingNewsArray = Array(repeating: false, count: self.StockNews.count)
                    }
                    
                    
                    print("StockNews: \(self.StockNews)")
                    if let encodedData = try? JSONEncoder().encode(["\(Date().timeIntervalSince1970)"]) {
                        self.storedLastNewsCheck = encodedData
                        print("jeg klarte å lagre storedLastNewsCheck")
                        
                    } else {
                        print("Error: Kunne ikke lagre storedLastNewsCheck")
                    }
                    if let encodedData = try? JSONEncoder().encode(self.StockNews) {
                        self.storedStockNews = encodedData
                        
                    } else {
                        print("Error: Kunne ikke lagre StockNews")
                    }
                    
                case .failure(let error):
                    print("error: \(error)")
                    if let decodedData = try? JSONDecoder().decode([NewsItems].self, from: self.storedStockNews) {
                        DispatchQueue.main.async {
                            self.StockNews = decodedData
                            self.isShowingNewsArray = Array(repeating: false, count: self.StockNews.count)
                            print("Hentet lagret Stock: \(self.StockNews)")
                        }
                        
                        
                    } else {
                        self.StockNews.removeAll()
                    }
            }
        })
        
        
        
        
    }
    
    func fixTestChart() {
        self.isFixingTestChart = true
        var indicators2: [Indicator] = []
        for indicator in self.StockArray {
            let date = indicator.date_utc
            indicators2.append(Indicator(timestamp: Date(timeIntervalSince1970: TimeInterval(date)),
                                         open: Double(indicator.open),
                                         high: Double(indicator.high),
                                         low: Double(indicator.low),
                                         close: Double(indicator.close)))
        }
        
        print("jeg er her4")
        
        print("indicators2: \(indicators2)")
        if let tradingPeriods = self.recivedStock.chart.result[0].meta.tradingPeriods {
            self.testChart = self.transformChartViewData(ChartData(
                meta: ChartMeta(currency: self.recivedStock.chart.result[0].meta.currency,
                                symbol: self.recivedStock.chart.result[0].meta.symbol,
                                regularMarketPrice: Double(self.recivedStock.chart.result[0].meta.regularMarketPrice),
                                previousClose: self.recivedStock.chart.result[0].meta.chartPreviousClose,
                                gmtOffset: self.recivedStock.chart.result[0].meta.gmtoffset,
                                regularTradingPeriodStartDate: Date(timeIntervalSince1970: TimeInterval(tradingPeriods[0][0].start)),
                                regularTradingPeriodEndDate: Date(timeIntervalSince1970: TimeInterval(tradingPeriods[0][0].end))),
                indicators: indicators2))
        } else {
            self.testChart = self.transformChartViewData(ChartData(
                meta: ChartMeta(currency: self.recivedStock.chart.result[0].meta.currency,
                                symbol: self.recivedStock.chart.result[0].meta.symbol,
                                regularMarketPrice: Double(self.recivedStock.chart.result[0].meta.regularMarketPrice),
                                previousClose: self.recivedStock.chart.result[0].meta.chartPreviousClose,
                                gmtOffset: self.recivedStock.chart.result[0].meta.gmtoffset,
                                regularTradingPeriodStartDate: Date(timeIntervalSince1970: TimeInterval(self.recivedStock.chart.result[0].meta.currentTradingPeriod.regular.start)),
                                regularTradingPeriodEndDate: Date(timeIntervalSince1970: TimeInterval(self.recivedStock.chart.result[0].meta.currentTradingPeriod.regular.end))),
                indicators: indicators2))
        }
        
        
        self.isFixingTestChart = false
    }
    

    
    
    func fixSnittChart() -> [StockData] {
        var array: [StockData] = []
        if self.selectedRange == .oneDay {
            return []
            
        } else if self.selectedRange == .oneWeek {
            let startIndex = max(self.StockArraySnitt.count - 6, 0)
            array = Array(self.StockArraySnitt[startIndex..<self.StockArraySnitt.count])
            
        } else if self.selectedRange == .oneMonth1 || self.selectedRange == .oneMonth2 || self.selectedRange == .oneMonth3 || self.selectedRange == .oneMonth4 {
            let date = self.getOneMonthPriorDate()
            let filteredItems = self.StockArraySnitt.filter { Date(timeIntervalSince1970: TimeInterval($0.date_utc)) >= date }
            
            array = Array(filteredItems)
            
            
        } else if self.selectedRange == .threeMonths {
            let date = self.getThreeMonthsPriorDate()
            let filteredItems = self.StockArraySnitt.filter { Date(timeIntervalSince1970: TimeInterval($0.date_utc)) > date }
            
            array = Array(filteredItems)
            
        } else if self.selectedRange == .sixMonths {
            let date = self.getSixMonthsPriorDate()
            let filteredItems = self.StockArraySnitt.filter { Date(timeIntervalSince1970: TimeInterval($0.date_utc)) > date }
            
            array = Array(filteredItems)
            
        } else if self.selectedRange == .nineMonths {
            let date = self.getNineMonthsPriorDate()
            let filteredItems = self.StockArraySnitt.filter { Date(timeIntervalSince1970: TimeInterval($0.date_utc)) > date }
            
            array = Array(filteredItems)
            
        } else if self.selectedRange == .ytd {
            let date = self.getFirstDateOfYear()
            guard let date = date else {
                return []
            }
            let filteredItems = self.StockArraySnitt.filter { Date(timeIntervalSince1970: TimeInterval($0.date_utc)) > date }
            
            array = Array(filteredItems)
            
        } else if self.selectedRange == .oneYear {
            let date = self.getOneYearPriorDate()
            let filteredItems = self.StockArraySnitt.filter { Date(timeIntervalSince1970: TimeInterval($0.date_utc)) > date }
            
            array = Array(filteredItems)
            
        } else if self.selectedRange == .twoYears {
            let date = self.getTwoYearsPriorDate()
            let filteredItems = self.StockArraySnitt.filter { Date(timeIntervalSince1970: TimeInterval($0.date_utc)) > date }
            
            array = Array(filteredItems)
            
        } else if self.selectedRange == .threeYears {
            let date = self.getThreeYearsPriorDate()
            let filteredItems = self.StockArraySnitt.filter { Date(timeIntervalSince1970: TimeInterval($0.date_utc)) > date }
            
            array = Array(filteredItems)
            
        } else if self.selectedRange == .fiveYears {
            let date = self.getFiveYearsPriorDate()
            let filteredItems = self.StockArraySnitt.filter { Date(timeIntervalSince1970: TimeInterval($0.date_utc)) > date }
            
            array = Array(filteredItems)
            
        }

        return array
    }
    
    
    
    
    
    func getOneYearPriorDate() -> Date {
        guard let date = self.StockArray.last?.date_utc else {
            return Date()
        }
        let lastItemDate = Date(timeIntervalSince1970: TimeInterval(date))
        
        let calendar = Calendar.current
        let oneYearAgo = calendar.date(byAdding: .year, value: -1, to: lastItemDate) ?? Date()
        let oneYearAgo2 = calendar.date(byAdding: .day, value: -1, to: oneYearAgo) ?? oneYearAgo
        
        return oneYearAgo2
    }
    
    func getTwoYearsPriorDate() -> Date {
        guard let date = self.StockArray.last?.date_utc else {
            return Date()
        }
        let lastItemDate = Date(timeIntervalSince1970: TimeInterval(date))
        
        let calendar = Calendar.current
        let twoYearsAgo = calendar.date(byAdding: .year, value: -2, to: lastItemDate) ?? Date()
        let twoYearsAgo2 = calendar.date(byAdding: .day, value: -1, to: twoYearsAgo) ?? twoYearsAgo
        
        return twoYearsAgo2
    }
    
    func getThreeYearsPriorDate() -> Date {
        guard let date = self.StockArray.last?.date_utc else {
            return Date()
        }
        let lastItemDate = Date(timeIntervalSince1970: TimeInterval(date))
        
        let calendar = Calendar.current
        let threeYearsAgo = calendar.date(byAdding: .year, value: -3, to: lastItemDate) ?? Date()
        let threeYearsAgo2 = calendar.date(byAdding: .day, value: -1, to: threeYearsAgo) ?? threeYearsAgo
        
        return threeYearsAgo2
    }
    
    func getFiveYearsPriorDate() -> Date {
        guard let date = self.StockArray.last?.date_utc else {
            return Date()
        }
        let lastItemDate = Date(timeIntervalSince1970: TimeInterval(date))
        
        let calendar = Calendar.current
        let fiveYearsAgo = calendar.date(byAdding: .year, value: -5, to: lastItemDate) ?? Date()
        let fiveYearsAgo2 = calendar.date(byAdding: .day, value: -1, to: fiveYearsAgo) ?? fiveYearsAgo
        
        return fiveYearsAgo2
    }
    
    func getOneMonthPriorDate() -> Date {
        guard let date = self.StockArray.last?.date_utc else {
            return Date()
        }
        let lastItemDate = Date(timeIntervalSince1970: TimeInterval(date))
        
        let calendar = Calendar.current
        let threeMonthsAgo = calendar.date(byAdding: .month, value: -1, to: lastItemDate) ?? Date()
        let threeMonthsAgo2 = calendar.date(byAdding: .day, value: -1, to: threeMonthsAgo) ?? threeMonthsAgo
        return threeMonthsAgo2
    }
    
    func getThreeMonthsPriorDate() -> Date {
        guard let date = self.StockArray.last?.date_utc else {
            return Date()
        }
        let lastItemDate = Date(timeIntervalSince1970: TimeInterval(date))
        
        let calendar = Calendar.current
        let threeMonthsAgo = calendar.date(byAdding: .month, value: -3, to: lastItemDate) ?? Date()
        let threeMonthsAgo2 = calendar.date(byAdding: .day, value: -1, to: threeMonthsAgo) ?? threeMonthsAgo
        return threeMonthsAgo2
    }
    
    func getSixMonthsPriorDate() -> Date {
        guard let date = self.StockArray.last?.date_utc else {
            return Date()
        }
        let lastItemDate = Date(timeIntervalSince1970: TimeInterval(date))
        
        let calendar = Calendar.current
        let sixMonthsAgo = calendar.date(byAdding: .month, value: -6, to: lastItemDate) ?? Date()
        
        return sixMonthsAgo
    }
    
    func getNineMonthsPriorDate() -> Date {
        guard let date = self.StockArray.last?.date_utc else {
            return Date()
        }
        let lastItemDate = Date(timeIntervalSince1970: TimeInterval(date))
        
        let calendar = Calendar.current
        let sixMonthsAgo = calendar.date(byAdding: .month, value: -9, to: lastItemDate) ?? Date()
        
        return sixMonthsAgo
    }
    
    func getFirstDateOfYear() -> Date? {
        let calendar = Calendar.current
        let components = DateComponents(year: calendar.component(.year, from: Date()), month: 1, day: 1)
        guard let calendar2 = calendar.date(from: components) else {
            return Date()
        }
        let thisYear = calendar.date(byAdding: .day, value: -1, to: calendar2) ?? calendar2
        
        return thisYear
        
    }
    
    func formattedTimeAgo(from dateString: String) -> String {
        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "E, dd MMM yyyy HH:mm:ss Z"
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = .current

        
        if let date = dateFormatter.date(from: dateString) {
            let now = Date()
            
            let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date, to: now)
            
            if let years = components.year, years > 0 {
                return "\(years) år siden"
            } else if let months = components.month, months > 0 {
                return "\(months) måned\(months > 1 ? "er" : "") siden"
            } else if let days = components.day, days > 0 {
                return "\(days) dag\(days > 1 ? "er" : "") siden"
            } else if let hours = components.hour, hours > 0 {
                return "\(hours) time\(hours > 1 ? "r" : "") siden"
            } else if let minutes = components.minute, minutes > 0 {
                return "\(minutes) minutt\(minutes > 1 ? "er" : "") siden"
            } else {
                return "Akuratt nå"
            }
        } else {
            return "Feil i formatering av dato: \(dateString)"
        }
    }
    
    func fixMaxY(maxY: Float) -> Float? {
        
        if selectedRange == .oneDay {
            if let lastClose: Float = self.StockArray2.last?.close, lastClose > maxY  {
                print("wtf last: \(lastClose), \(maxY)")
                if lastClose >= maxY {
                    return lastClose
                    
                } else {
                    return maxY
                    
                }
            }
            return nil
            
        }
        return nil
    }
    
    func fixNumbersArray() {
        numbersArray.removeAll()
        for i in 10...500 {
            if i % 5 == 0 {
                numbersArray.append(i)
            }
        }
        
    }
    
    func updateNumbers() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.23) {
            withAnimation {
                if let lastClose = self.StockArray.last?.close {
                    let _ = print("lastClose: \(lastClose)")
                    
                    self.number1 = lastClose
                    
                } else {
                    let _ = print("StockArray2: \(self.StockArray)")
                    self.number1 = 0.00
                    
                }
                
                
                if self.selectedRange == .oneDay {
                    if let last = self.StockArray.max(by: { $0.date_utc < $1.date_utc }), let last2 = self.recivedStock.chart.result.first?.meta.chartPreviousClose {
                        let change = last.close - Float(last2)
                        print("change: \(change)")
                        
                        self.number2 = change
                        
                    } else {
                        let _ = print("StockArray3: \(self.StockArray)")
                        self.number2 = 0.00
                        
                        
                    }
                } else {
                    if let lastClose = self.StockArray.last?.close, let firstClose = self.StockArray.first?.close {
                        let change = Float(lastClose - firstClose)
                        let change2 = change.magnitude
                        let _ = print("change2: \(change2)")
                        self.number2 = change2
                        
                    } else {
                        let _ = print("StockArray4: \(self.StockArray)")
                        self.number2 = 0.00
                        
                        
                    }
                }
                
            }
        }
    }
    
    func fy(x: Float, x1: Float, y1: Float, stigning: Float) -> Float {
            //        let y = stigning * x + (y1 - stigning * x1)
        let y = stigning * (x - x1) + y1
        return y
    }
    
    func fx(y: Float, x1: Float, y1: Float, stigning: Float) -> Float {
            //        let y = stigning * x + (y1 - stigning * x1)
        let x = ((y1 - stigning * x1) - y) / -stigning
        return x
    }
    
    func stigning(yChange: Float, xChange: Float) -> Float {
        if xChange != 0 {
            let stigning = yChange / xChange
            return stigning
        } else {
            return 0
        }
        
    }

    func computeRSI(on prices: [Double], periods: Int = 14, minimumPoints: Int = 200) -> [Double] {
        precondition(periods > 1 && minimumPoints > periods && prices.count >= minimumPoints)
        
        return Array(unsafeUninitializedCapacity: prices.count) { (buffer, count) in
            buffer.initialize(repeating: 50)
            
            var (previousPrice, gain, loss) = (prices[0], 0.0, 0.0)
            for i in stride(from: 1, through: periods, by: 1) {
                let price = prices[i]
                
                let value = price - previousPrice
                if value > 0 {
                    gain += value
                } else {
                    loss -= value
                }
                
                previousPrice = price
            }
            
            let (numPeriods, numPeriodsMinusOne) = (Double(periods), Double(periods &- 1))
            var avg = (gain: gain / numPeriods, loss: loss / numPeriods)
            buffer[periods] = (avg.loss > .zero) ? 100 - 100 / (1 + avg.gain/avg.loss) : 100
            
            for i in stride(from: periods &+ 1, to: prices.count, by: 1) {
                let price = prices[i]
                avg.gain *= numPeriodsMinusOne
                avg.loss *= numPeriodsMinusOne
                
                let value = price - previousPrice
                if value > 0 {
                    avg.gain += value
                } else {
                    avg.loss -= value
                }
                
                avg.gain /= numPeriods
                avg.loss /= numPeriods
                
                if avg.loss > .zero {
                    buffer[i] = 100 - 100 / (1 + avg.gain/avg.loss)
                } else {
                    buffer[i] = 100
                }
                
                previousPrice = price
            }
            
            count = prices.count
        }
    }

    
    func getRSI() {
        var closingPrices: [Double] = []
        for row in StockRSI {
            closingPrices.append(Double(row.close))
        }
        RSIValues.removeAll()
        var rsiValues = computeRSI(on: closingPrices, periods: 14, minimumPoints: 28)
        if rsiValues.count >= getMaxRSINumber() {
            let lastItems = Array(rsiValues.suffix(getMaxRSINumber()))
            rsiValues = lastItems
        }
        var counter = 0
        for rsi in rsiValues {
            RSIValues.append((counter, rsi))
            counter += 1

            
        }
        
        print("RSIValues: \(RSIValues), count: \(RSIValues.count)")
        
    }
    
    func getMaxRSINumber() -> Int {
        if self.selectedRange == .oneWeek {
            let startDate = Date(timeIntervalSince1970: TimeInterval(self.recivedStock.chart.result[0].meta.currentTradingPeriod.regular.start))
            let endDate = Date(timeIntervalSince1970: TimeInterval(self.recivedStock.chart.result[0].meta.currentTradingPeriod.regular.end))
            
            let calendar = Calendar.current
            
            let difference = calendar.dateComponents([.minute], from: startDate, to: endDate)
            
            if let minutes = difference.minute {
                let numberOf30MinuteIntervals = minutes / 2
                
                print("There are \(numberOf30MinuteIntervals) 2-minute intervals between the two dates.")
                print("There are \(StockArray.count / numberOf30MinuteIntervals + 2)")
                return StockArray.count / numberOf30MinuteIntervals + 2
            } else {
                print("Unable to calculate the difference in minutes.")
                return StockArray.count
            }
        } else if self.selectedRange == .oneMonth1 {
            let startDate = Date(timeIntervalSince1970: TimeInterval(self.recivedStock.chart.result[0].meta.currentTradingPeriod.regular.start))
            let endDate = Date(timeIntervalSince1970: TimeInterval(self.recivedStock.chart.result[0].meta.currentTradingPeriod.regular.end))
            
            let calendar = Calendar.current
            
            let difference = calendar.dateComponents([.minute], from: startDate, to: endDate)
            
            if let minutes = difference.minute {
                let numberOf30MinuteIntervals = minutes / 5
                
                print("There are \(numberOf30MinuteIntervals) 5-minute intervals between the two dates.")
                return StockArray.count / numberOf30MinuteIntervals
            } else {
                print("Unable to calculate the difference in minutes.")
                return StockArray.count
            }
        } else if self.selectedRange == .oneMonth2 {
            let startDate = Date(timeIntervalSince1970: TimeInterval(self.recivedStock.chart.result[0].meta.currentTradingPeriod.regular.start))
            let endDate = Date(timeIntervalSince1970: TimeInterval(self.recivedStock.chart.result[0].meta.currentTradingPeriod.regular.end))
            
            let calendar = Calendar.current
            
            let difference = calendar.dateComponents([.minute], from: startDate, to: endDate)
            
            if let minutes = difference.minute {
                let numberOf30MinuteIntervals = minutes / 15
                
                print("There are \(numberOf30MinuteIntervals) 15-minute intervals between the two dates.")
                return StockArray.count / numberOf30MinuteIntervals
            } else {
                print("Unable to calculate the difference in minutes.")
                return StockArray.count
            }
        } else if self.selectedRange == .oneMonth3 {
            let startDate = Date(timeIntervalSince1970: TimeInterval(self.recivedStock.chart.result[0].meta.currentTradingPeriod.regular.start))
            let endDate = Date(timeIntervalSince1970: TimeInterval(self.recivedStock.chart.result[0].meta.currentTradingPeriod.regular.end))
            
            let calendar = Calendar.current
            
            let difference = calendar.dateComponents([.minute], from: startDate, to: endDate)
            
            if let minutes = difference.minute {
                let numberOf30MinuteIntervals = minutes / 30
                
                print("There are \(StockArray.count / numberOf30MinuteIntervals) 30-minute intervals between the two dates.")
                return StockArray.count / numberOf30MinuteIntervals
            } else {
                print("Unable to calculate the difference in minutes.")
                return StockArray.count
            }
        } else if self.selectedRange == .oneMonth4 {
            let startDate = Date(timeIntervalSince1970: TimeInterval(self.recivedStock.chart.result[0].meta.currentTradingPeriod.regular.start))
            let endDate = Date(timeIntervalSince1970: TimeInterval(self.recivedStock.chart.result[0].meta.currentTradingPeriod.regular.end))
            
            let calendar = Calendar.current
            
            let difference = calendar.dateComponents([.minute], from: startDate, to: endDate)
            
            if let minutes = difference.minute {
                let numberOf30MinuteIntervals = minutes / 60
                
                print("There are \(numberOf30MinuteIntervals) 60-minute intervals between the two dates.")
                return StockArray.count / numberOf30MinuteIntervals
            } else {
                print("Unable to calculate the difference in minutes.")
                return StockArray.count
            }
        } else {
            return StockArray.count
        }
    }

    
    
    
    
    func convertToCSV() -> String {
        var csvString = ""
        var data: [[String]] = [
            ["Date", "Previous Close Prices", "Next Close Prices", "Previous Open", "Previous High", "Previous Low", "Previous Volume", "Lag1", "Lag2", "Lag3", "Previous RSI Value"]
        ]
        
        
        for row in self.StockArray {
            var newData: [String] = []
            let date = Date(timeIntervalSince1970: TimeInterval(row.date_utc))
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd"
            df.locale = Locale(identifier: "nb_NO")
            let newDate = df.string(from: date)
            let index = self.StockArray.firstIndex(of: row) ?? 0
            if index <= self.StockArray.count - 1 && index > 2 {
                newData.append("\(newDate)")
                if index == 0 {
                    newData.append("NaN")
                } else {
                    newData.append("\(self.StockArray[index-1].close)")
                }
                
                newData.append("\(row.close)")
                if index == 0 {
                    newData.append("NaN")
                } else {
                    newData.append("\(self.StockArray[index-1].open)")
                }
                if index == 0 {
                    newData.append("NaN")
                } else {
                    newData.append("\(self.StockArray[index-1].high)")
                }
                if index == 0 {
                    newData.append("NaN")
                } else {
                    newData.append("\(self.StockArray[index-1].low)")
                }
                if index == 0 {
                    newData.append("NaN")
                } else {
                    newData.append("\(self.StockArray[index-1].volume)")
                }
                if index == 0 {
                    newData.append("NaN")
                } else {
                    newData.append("\(self.StockArray[index-1].close)")
                }
                if index == 0 || index == 1 {
                    newData.append("NaN")
                } else {
                    newData.append("\(self.StockArray[index-2].close)")
                }
                if index == 0 || index == 1 || index == 2 {
                    newData.append("NaN")
                } else {
                    newData.append("\(self.StockArray[index-3].close)")
                }
                if index == 0 {
                    newData.append("NaN")
                } else {
                    newData.append("\(self.RSIValues[index-1].1)")
                }
                data.append(newData)
                
            }
            
            
        }
        
        
        for row in data {
            let rowString = row.map { "\"\($0)\"" }.joined(separator: ",")
            csvString.append(rowString + "\n")
        }
        
        return csvString
    }
    
    func convertToCSVTest() -> String {
        var csvString = ""
        var data: [[String]] = [
            ["Date", "Previous Close Prices", "Next Close Prices", "Previous Open", "Previous High", "Previous Low", "Previous Volume", "Lag1", "Lag2", "Lag3", "Previous RSI Value"]
        ]
        var newData: [String] = []
        var newData2: [String] = []
        newData = ["2024-04-25", "15.89", "16.30", "14.15", "15.98", "14.1", "18994525", "15.89", "13.97", "13.94", "73.21"]
        newData2 = ["2024-04-26", "16.3", "17.26", "15.8", "16.52", "15.68", "8843626", "16.30", "15.89", "13.97", "75.16"]
//        newData = ["2024-03-31", "12.55", "13.38", "13.79", "13.94", "11.6", "74572607", "12.55", "13.65", "15.65"]
//        newData2 = ["2024-04-30", "13.38", "14.10", "12.75", "13.55", "12.4", "22296611", "13.38", "12.55", "13.65"]
        data.append(newData)
        data.append(newData2)
        
        for row in data {
            let rowString = row.map { "\"\($0)\"" }.joined(separator: ",")
            csvString.append(rowString + "\n")
        }
        
        return csvString
    }
    
    func saveCSVToFile(csvString: String, fileName: String) {
        guard let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        
        let fileURL = directoryURL.appendingPathComponent(fileName + ".csv")
        
        do {
            try csvString.write(to: fileURL, atomically: true, encoding: .utf8)
            print("File saved successfully at: \(fileURL)")
            self.fileURL = fileURL
        } catch {
            print("Error saving file:", error.localizedDescription)
        }
    }
    
//    func loadIntoCreateML(fileURL: URL) {
//        do {
            // Load the CSV file into a Create ML dataset
//            let dataTable = try MLDataTable(contentsOf: fileURL)
//            trainingData = dataTable
//            print("Data loaded successfully:", dataTable)
            
            // You can use 'trainingData' to train your model using Create ML
            // Example: let model = try MLRegressor(trainingData: trainingData, targetColumn: "targetColumnName")
//            let model = try MLLinearRegressor(trainingData: trainingData!, targetColumn: "targetColumnName")
//            
//        } catch {
//            print("Error loading data:", error.localizedDescription)
//        }
//    }
    
    

    
    func formatLargeNumber(_ number: Int) -> String {
        let numberFormatter = NumberFormatter()
        
            // Use the decimal style for better localization support
        numberFormatter.numberStyle = .decimal
        
            // Choose the number of fraction digits based on your preference
        numberFormatter.maximumFractionDigits = 3
        
            // Define the suffixes for each order of magnitude
        let suffixes = ["", "", " mill.", " mrd.", " bill."]
        
        
            // Handle the case when the number is zero or negative
        guard number != 0 else {
            return "0"
        }
        
            // Calculate the order of magnitude
        let orderOfMagnitude = Int(log10(abs(Double(number))) / 3.0)
        
            // Apply the suffix based on the order of magnitude, excluding "K" for thousands or below
        numberFormatter.positiveSuffix = orderOfMagnitude > 0 ? suffixes[orderOfMagnitude] : ""
        
            // Format the number using the number formatter
        let formattedNumber = numberFormatter.string(from: NSNumber(value: Double(number) / pow(10, Double(orderOfMagnitude) * 3))) ?? "\(number)"
        
        return formattedNumber
    }
    
    
    
    
    func onChangeDrag(value: DragGesture.Value, chartProxy: ChartProxy, geometryProxy: GeometryProxy) {
        let xCurrent = value.location.x - geometryProxy[chartProxy.plotFrame!].origin.x
        if let index: Double = chartProxy.value(atX: xCurrent), index >= 0, Int(index) <= StockArray.count - 1 {
            self.selectedX = Int(index)
        }
    }
    
    func onChangeDragRSI(value: DragGesture.Value, chartProxy: ChartProxy, geometryProxy: GeometryProxy) {
        let xCurrent = value.location.x - geometryProxy[chartProxy.plotFrame!].origin.x
        if self.selectedRange == .oneWeek || self.selectedRange == .oneMonth1 || self.selectedRange == .oneMonth2 || self.selectedRange == .oneMonth3 || self.selectedRange == .oneMonth4 {
            if let index: Double = chartProxy.value(atX: xCurrent), index >= 0, Int(index) <= StockArray.count - 1 {
                let intIndex = Int(index)
                self.selectedXRSI = intIndex
                let newIndex1 = StockArray.count / StockRSI.count
                let newIndex2 = Int(floor(Double(newIndex1)))
                var niceIndex = 0
                for i in 0...StockArray.count - 1 {
                    if Int((i*newIndex2)) <= intIndex {
                        niceIndex = intIndex/newIndex2
                    }
                    if intIndex/newIndex2 == StockRSI.count {
                        niceIndex = StockRSI.count - 1
                    }
                }
                self.selectedXRSIIndex = niceIndex
            }
            
        } else {
            if let index: Double = chartProxy.value(atX: xCurrent), index >= 0, Int(index) <= StockRSI.count - 1 {
                self.selectedXRSI = Int(index)
                self.selectedXRSIIndex = Int(index)
            }
        }
            
        
        
    }
    
    
    func onChangeDrag2(value: DragGesture.Value, chartProxy: ChartProxy, geometryProxy: GeometryProxy) {
        let origin = geometryProxy[chartProxy.plotFrame!].origin
        let location = CGPoint(
            x: value.location.x - origin.x,
            y: value.location.y - origin.y
        )
        // Get the x (date) and y (price) value from the location.
        guard var (xPos, yPos) = chartProxy.value(at: location, as: (Double, Double).self) else {
            return
        }
        if xPos > Double(maxXValue) {
            xPos = Double(maxXValue)
        } else if xPos < 0 {
            xPos = 0
        }
        
        if yPos > Double(maxValue2) {
            yPos = Double(maxValue2)
        } else if yPos < Double(minValue2) {
            yPos = Double(minValue2)
        }
        selectedXY = (xPos, yPos)
        print("Location: \(xPos), \(yPos)")
        
        
    }
    
    func onChangeDragLine(value: DragGesture.Value, chartProxy: ChartProxy, geometryProxy: GeometryProxy) {
        let xCurrent = value.location.x - geometryProxy[chartProxy.plotFrame!].origin.x
        print("shit is happening3!!")
        if let index: Double = chartProxy.value(atX: xCurrent),
           index >= 0,
           Int(index) <= StockArray.count - 1 {
            if !isLine1Selected {
                self.selectedXLine1 = Int(index)
            } else if !isLine2Selected {
                self.selectedXLine2 = Int(index)
            } else if !isLine3Selected {
                self.selectedXLine3 = Int(index)
            } 
            
        }
    }
    
    
    func fixNewStride(index: Int) -> Int {
        var newIndex: Int = 0
        var dates: [String] = []
        var alldates: [String] = []
        for i in StockArray {
            if !dates.contains(i.date) {
                dates.append(i.date)
            }
            alldates.append(i.date)
        }
        
        
        for date in alldates {
            if index == 0 {
                newIndex = 0
//                print("newIndex: \(newIndex), date: \(dates[index])")
            }
            else if index-1 < dates.count && index != 0 {
                if dates[index-1] == date {
                    if let stockIndex = alldates.lastIndex(of: date) {
                        newIndex = stockIndex
                        
                    } else {
                        if selectedRange == .oneWeek {
                            newIndex = 30 * index
                        } else if selectedRange == .oneMonth1 {
                            newIndex = 88 * index
                        } else if selectedRange == .oneMonth2 {
                            newIndex = 30 * index
                        } else if selectedRange == .oneMonth3 {
                            newIndex = 15 * index
                        } else if selectedRange == .oneMonth4 {
                            newIndex = 8 * index
                        } else {
                            newIndex = index
                        }
                        
                    }
//                    print("newIndex: \(newIndex), date: \(dates[index-1])")
                    
                }
            } else {
                if selectedRange == .oneWeek {
                    newIndex = 30 * index
                } else if selectedRange == .oneMonth1 {
                    newIndex = 88 * index
                } else if selectedRange == .oneMonth2 {
                    newIndex = 30 * index
                } else if selectedRange == .oneMonth3 {
                    newIndex = 15 * index
                } else if selectedRange == .oneMonth4 {
                    newIndex = 8 * index
                } else {
                    newIndex = index
                }
//                print("newIndex: \(newIndex), date: \(dates[index-1])")
            }
        }
        
        return newIndex
    }
    

    
    var chartXAxis: some AxisContent {
        AxisMarks(values: .stride(by: testChart.xAxisData.strideBy)) { value in
            
            if let text = self.tupleArray.first(where: { $0.0 == String(value.index) }) {
                
                let text2 = text.1.capitalized
                if self.selectedRange == .oneDay {
                    let text3 = text2.prefix(2).replacingOccurrences(of: " ", with: "")
                    AxisGridLine(stroke: .init(lineWidth: 0.3))
                    AxisTick(stroke: .init(lineWidth: 0.3))
                    AxisValueLabel(collisionResolution: .greedy(priority: 1)) {
                        Text(text3)
                            .foregroundColor(Color(uiColor: .label))
                            .font(.caption.bold())
                    }
                } else {
                    AxisGridLine(stroke: .init(lineWidth: 0.3))
                    AxisTick(stroke: .init(lineWidth: 0.3))
                    if !self.isShowingRSI {
                        AxisValueLabel(collisionResolution: .greedy()) {
                            Text(text2)
                                .foregroundColor(Color(uiColor: .label))
                                .font(.caption.bold())
                        }
                    }
                }
            }
        }
    }
    
    var chartXAxisRSI: some AxisContent {
        AxisMarks(values: .stride(by: testChart.xAxisData.strideBy)) { value in
            
            if let text = self.tupleArray.first(where: { $0.0 == String(value.index) }) {
                
                let text2 = text.1.capitalized
                if self.selectedRange == .oneDay {
                    let text3 = text2.prefix(2).replacingOccurrences(of: " ", with: "")
                    AxisGridLine(stroke: .init(lineWidth: 0.3))
                    AxisTick(stroke: .init(lineWidth: 0.3))
                    AxisValueLabel(collisionResolution: .greedy(priority: 1)) {
                        Text(text3)
                            .foregroundColor(Color(uiColor: .label))
                            .font(.caption.bold())
                    }
                } else {
                    AxisGridLine(stroke: .init(lineWidth: 0.3))
                    AxisTick(stroke: .init(lineWidth: 0.3))
                    AxisValueLabel(collisionResolution: .greedy()) {
                        Text(text2)
                            .foregroundColor(Color(uiColor: .label))
                            .font(.caption.bold())
                    }
                    
                }
            }
        }
    }
    
    func fixViewForLines() {
        self.isFixingTestChart = true
        var indicators2: [Indicator] = []
        for indicator in self.StockArray {
            let date = indicator.date_utc
            indicators2.append(Indicator(timestamp: Date(timeIntervalSince1970: TimeInterval(date)),
                                         open: Double(indicator.open),
                                         high: Double(indicator.high),
                                         low: Double(indicator.low),
                                         close: Double(indicator.close)))
        }
        
        if self.selectedRange == .oneDay, let first = self.StockArray.first?.date_utc, let last = self.StockArray.last?.date_utc, let last2 = self.recivedStock.chart.result.last?.meta.currentTradingPeriod.regular.end, let lastClose: Double = self.recivedStock.chart.result[0].indicators.quote[0].close.last ?? 0 {
            let originalDate = Date(timeIntervalSince1970: TimeInterval(last2))
            
            // Get the current date
            let currentDate = Date(timeIntervalSince1970: TimeInterval(last))
            
            // Get the calendar and extract time components from the original date
            let calendar = Calendar.current
            let originalTimeComponents = calendar.dateComponents([.hour, .minute, .second], from: originalDate)
            
            // Create a new date with today's date and the extracted time components
            if let todayWithOriginalTime = calendar.date(bySettingHour: originalTimeComponents.hour ?? 0,
                                                         minute: originalTimeComponents.minute ?? 0,
                                                         second: originalTimeComponents.second ?? 0,
                                                         of: currentDate) {
                print("Today with original time: \(todayWithOriginalTime)")
                self.testChart = self.transformChartViewData(ChartData(
                    meta: ChartMeta(currency: self.recivedStock.chart.result[0].meta.currency,
                                    symbol: self.recivedStock.chart.result[0].meta.symbol,
                                    regularMarketPrice: Double(self.recivedStock.chart.result[0].meta.regularMarketPrice),
                                    previousClose: lastClose,
                                    gmtOffset: self.recivedStock.chart.result[0].meta.gmtoffset,
                                    regularTradingPeriodStartDate: Date(timeIntervalSince1970: TimeInterval(first)),
                                    regularTradingPeriodEndDate: todayWithOriginalTime),
                    indicators: indicators2))
            } else {
                print("Failed to create date.")
                self.testChart = self.transformChartViewData(ChartData(
                    meta: ChartMeta(currency: self.recivedStock.chart.result[0].meta.currency,
                                    symbol: self.recivedStock.chart.result[0].meta.symbol,
                                    regularMarketPrice: Double(self.recivedStock.chart.result[0].meta.regularMarketPrice),
                                    previousClose: Double(lastClose),
                                    gmtOffset: self.recivedStock.chart.result[0].meta.gmtoffset,
                                    regularTradingPeriodStartDate: Date(timeIntervalSince1970: TimeInterval(first)),
                                    regularTradingPeriodEndDate: Date(timeIntervalSince1970: TimeInterval(last2))),
                    indicators: indicators2))
            }
            
        } else {
            if self.selectedRange == .oneWeek || self.selectedRange == .oneMonth1 || self.selectedRange == .oneMonth2 || self.selectedRange == .oneMonth3 || self.selectedRange == .oneMonth4 {
                let secondDate = self.StockArray[1].date
                let secondDateArray = self.StockArray.filter { $0.date == secondDate }
                
                if let first = secondDateArray.first?.date_utc, let last = self.StockArray.last?.date_utc {
                    self.testChart = self.transformChartViewData(ChartData(
                        meta: ChartMeta(currency: self.recivedStock.chart.result[0].meta.currency,
                                        symbol: self.recivedStock.chart.result[0].meta.symbol,
                                        regularMarketPrice: Double(self.recivedStock.chart.result[0].meta.regularMarketPrice),
                                        previousClose: nil,
                                        gmtOffset: self.recivedStock.chart.result[0].meta.gmtoffset,
                                        regularTradingPeriodStartDate: Date(timeIntervalSince1970: TimeInterval(first)),
                                        regularTradingPeriodEndDate: Date(timeIntervalSince1970: TimeInterval(last))),
                        indicators: indicators2))
                } else {
                    self.testChart = self.transformChartViewData(ChartData(
                        meta: ChartMeta(currency: self.recivedStock.chart.result[0].meta.currency,
                                        symbol: self.recivedStock.chart.result[0].meta.symbol,
                                        regularMarketPrice: Double(self.recivedStock.chart.result[0].meta.regularMarketPrice),
                                        previousClose: nil,
                                        gmtOffset: self.recivedStock.chart.result[0].meta.gmtoffset,
                                        regularTradingPeriodStartDate: Date(timeIntervalSince1970: TimeInterval(self.recivedStock.chart.result[0].meta.regularMarketTime)),
                                        regularTradingPeriodEndDate: Date(timeIntervalSince1970: TimeInterval(self.recivedStock.chart.result[0].meta.regularMarketTime))),
                        indicators: indicators2))
                }
                
                
                
                
                
            } else {
                self.testChart = self.transformChartViewData(ChartData(
                    meta: ChartMeta(currency: self.recivedStock.chart.result[0].meta.currency,
                                    symbol: self.recivedStock.chart.result[0].meta.symbol,
                                    regularMarketPrice: Double(self.recivedStock.chart.result[0].meta.regularMarketPrice),
                                    previousClose: nil,
                                    gmtOffset: self.recivedStock.chart.result[0].meta.gmtoffset,
                                    regularTradingPeriodStartDate: Date(timeIntervalSince1970: TimeInterval(self.recivedStock.chart.result[0].meta.regularMarketTime)),
                                    regularTradingPeriodEndDate: Date(timeIntervalSince1970: TimeInterval(self.recivedStock.chart.result[0].meta.regularMarketTime))),
                    indicators: indicators2))
            }
        }
        self.isFixingTestChart = false
    }
    
    var chartXAxis2: some AxisContent {
        AxisMarks(values: .stride(by: testChart.xAxisData.strideBy)) { value in
            if let text = self.tupleArray.first(where: { $0.0 == String(value.index) }) {
                let text2 = text.1.capitalized
                if self.selectedRange == .twoYears || self.selectedRange == .threeYears {
                    let text3 = text2.dropLast(5)
                    AxisGridLine(stroke: .init(lineWidth: 0.3))
                    AxisTick(stroke: .init(lineWidth: 0.3))
                    if !self.isShowingRSI {
                        AxisValueLabel(collisionResolution: .greedy(priority: 1)) {
                            Text(text3)
                                .foregroundColor(Color(uiColor: .label))
                                .font(.caption.bold())
                        }
                    }
                } else if self.selectedRange == .oneDay {
                    let text3 = text2.prefix(2).replacingOccurrences(of: " ", with: "")
                    AxisGridLine(stroke: .init(lineWidth: 0.3))
                    AxisTick(stroke: .init(lineWidth: 0.3))
                    AxisValueLabel(collisionResolution: .greedy(priority: 1)) {
                        Text(text3)
                            .foregroundColor(Color(uiColor: .label))
                            .font(.caption.bold())
                    }
                } else {
                    AxisGridLine(stroke: .init(lineWidth: 0.3))
                    AxisTick(stroke: .init(lineWidth: 0.3))
                    if !self.isShowingRSI {
                        AxisValueLabel(collisionResolution: .greedy(priority: 1)) {
                            Text(text2)
                                .foregroundColor(Color(uiColor: .label))
                                .font(.caption.bold())
                        }
                    }
                }
            }
        }
    }
    
    var chartXAxis2RSI: some AxisContent {
        AxisMarks(values: .stride(by: testChart.xAxisData.strideBy)) { value in
            if let text = self.tupleArray.first(where: { $0.0 == String(value.index) }) {
                let text2 = text.1.capitalized
                if self.selectedRange == .twoYears || self.selectedRange == .threeYears {
                    let text3 = text2.dropLast(5)
                    AxisGridLine(stroke: .init(lineWidth: 0.3))
                    AxisTick(stroke: .init(lineWidth: 0.3))
                    AxisValueLabel(collisionResolution: .greedy(priority: 1)) {
                        Text(text3)
                            .foregroundColor(Color(uiColor: .label))
                            .font(.caption.bold())
                    }
                    
                } else if self.selectedRange == .oneDay {
                    let text3 = text2.prefix(2).replacingOccurrences(of: " ", with: "")
                    AxisGridLine(stroke: .init(lineWidth: 0.3))
                    AxisTick(stroke: .init(lineWidth: 0.3))
                    AxisValueLabel(collisionResolution: .greedy(priority: 1)) {
                        Text(text3)
                            .foregroundColor(Color(uiColor: .label))
                            .font(.caption.bold())
                    }
                } else {
                    AxisGridLine(stroke: .init(lineWidth: 0.3))
                    AxisTick(stroke: .init(lineWidth: 0.3))
                    AxisValueLabel(collisionResolution: .greedy(priority: 1)) {
                        Text(text2)
                            .foregroundColor(Color(uiColor: .label))
                            .font(.caption.bold())
                    }
                    
                }
            }
        }
    }
    
    var chartYAxis: some AxisContent {
        AxisMarks(preset: .extended, values: self.yAxisArray) { value in
            if let y = value.as(Double.self) {
                if y > self.testChart.yAxisData.axisStart && y <= self.testChart.yAxisData.axisEnd {
                    AxisGridLine(stroke: .init(lineWidth: 0.3))
                    AxisTick(stroke: .init(lineWidth: 0.3))
                    AxisValueLabel(anchor: .topLeading, collisionResolution: .greedy) {
                        Text("\(y.roundedString)")
                            .foregroundColor(Color(uiColor: .label))
                            .font(.caption.bold())
                            .frame(width: 55)
                    }
                } else if Float(y) == Float(self.testChart.yAxisData.axisStart) {
                    AxisGridLine(stroke: .init(lineWidth: 1))
                        .foregroundStyle(.gray)
                    AxisTick(stroke: .init(lineWidth: 1))
                        .foregroundStyle(.gray)
                }
            }
        }
    }
    
    var chartYAxis2: some AxisContent {
        AxisMarks(preset: .extended, values: self.yAxisArray) { value in
            if let y = value.as(Double.self) {
                AxisGridLine(stroke: .init(lineWidth: 0.3))
                AxisTick(stroke: .init(lineWidth: 0.3))
                AxisValueLabel(anchor: .topLeading, collisionResolution: .greedy) {
                    Text("\(y.roundedString)")
                        .foregroundColor(Color(uiColor: .label))
                        .font(.caption.bold())
                        .frame(width: 55)
                }
            }
        }
    }
    
    var chartYAxisRSI: some AxisContent {
        AxisMarks(preset: .extended, values: self.yAxisArrayRSI) { value in
            if let y = value.as(Double.self) {
                if y > self.rsiChart.yAxisData.axisStart && y <= self.rsiChart.yAxisData.axisEnd {
                    AxisGridLine(stroke: .init(lineWidth: 0.3))
                    AxisTick(stroke: .init(lineWidth: 0.3))
                    AxisValueLabel(anchor: .topLeading, collisionResolution: .greedy) {
                        Text("\(y.roundedStringRSI)")
                            .foregroundColor(Color(uiColor: .label))
                            .font(.caption.bold())
                            .frame(width: 55)
                    }
                } else if y == self.rsiChart.yAxisData.axisStart {
                    AxisGridLine(stroke: .init(lineWidth: 1))
                        .foregroundStyle(.gray)
                    AxisTick(stroke: .init(lineWidth: 1))
                        .foregroundStyle(.gray)
                }
            }
        }
    }
    
    func isWeekend(_ date: Date) -> Bool {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date)
        return weekday == 1 || weekday == 7 // Sunday or Saturday
    }
    
    func dateRoundedToNextHour(date: Date) -> Date? {
        let calendar = Calendar.current
        guard let nextHourDate = calendar.date(byAdding: .hour, value: 1, to: date) else {
            return nil // Unable to calculate the next hour
        }
        let components = calendar.dateComponents([.year, .month, .day, .hour], from: nextHourDate)
        return calendar.date(from: components)
    }
    
    func isFiveMinutesApart(date1: Date, date2: Date) -> Bool {
        let fiveMinutes: TimeInterval = 5 * 60 // 5 minutes in seconds
        
        // Calculate the absolute difference between the two dates
        let timeDifference = abs(date1.timeIntervalSince(date2))
        
        // Check if the absolute difference is equal to 5 minutes
        return abs(timeDifference - fiveMinutes) < 0.001 // Tolerance for floating-point comparison
    }
    
    func isMinutesApartAndNotSameDate(date1: Date, date2: Date, minutes: Int) -> Bool {
        let calendar = Calendar.current
        
        // Extract hour, minute, and second components from both dates
        let components1 = calendar.dateComponents([.hour, .minute, .second], from: date1)
        let components2 = calendar.dateComponents([.hour, .minute, .second], from: date2)
        
        // Compare the components to see if they are within 5 minutes of each other
        return abs(components1.hour! - components2.hour!) == 0 &&
        abs(components1.minute! - components2.minute!) <= minutes &&
        abs(components1.second! - components2.second!) <= 5
    }
    
    func isTimeBetween(_ time: Date, start: Date, end: Date) -> Bool {
        let calendar = Calendar.current
        
        // Get time components
        let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: time)
        let startTimeComponents = calendar.dateComponents([.hour, .minute, .second], from: start)
        let endTimeComponents = calendar.dateComponents([.hour, .minute, .second], from: end)
        
        // Create dates with only time components
        let timeDate = calendar.date(from: timeComponents)!
        let startDate = calendar.date(from: startTimeComponents)!
        let endDate = calendar.date(from: endTimeComponents)!
        
        // Check if time is between start and end time
        return timeDate >= startDate && timeDate <= endDate
    }
    
    func weeksFromNewYear(to date: Date) -> Int? {
        let calendar = Calendar.current
        guard let newYear = calendar.date(from: DateComponents(year: calendar.component(.year, from: date))) else {
            return nil // Unable to determine New Year's Day
        }
        
        let components = calendar.dateComponents([.weekOfYear], from: newYear, to: date)
        return components.weekOfYear
    }
    
    func transformChartViewData(_ data: ChartData) -> ChartViewData {
        let (xAxisChartData, items) = xAxisChartDataAndItems(data)
        let yAxisChartData = yAxisChartData(data)
        return ChartViewData(
            xAxisData: xAxisChartData,
            yAxisData: yAxisChartData,
            items: items
        )
    }
    
    func transformChartViewDataRSI(_ data: ChartData) -> ChartViewData {
        let (xAxisChartData, items) = xAxisChartDataAndItems(data)
        let yAxisChartData = yAxisChartDataRSI(data)
        return ChartViewData(
            xAxisData: xAxisChartData,
            yAxisData: yAxisChartData,
            items: items
        )
    }
    
    func xAxisChartDataAndItems(_ data: ChartData) -> (ChartAxisData, [ChartViewItem]) {
        let timezone = TimeZone(secondsFromGMT: data.meta.gmtOffset) ?? .gmt
        dateFormatter.timeZone = timezone
        dateFormatter.locale = Locale(identifier: "nb_NO")
        selectedValueDateFormatter.timeZone = timezone
        
        
        var xAxisDateComponents = Set<DateComponents>()
        if let startTimestamp = data.indicators.first?.timestamp, let last = self.recivedStock.chart.result.last?.meta.currentTradingPeriod.regular.end {
            if selectedRange == .oneDay {
                xAxisDateComponents = selectedRange.getDateComponents(startDate: startTimestamp, endDate: Date(timeIntervalSince1970: TimeInterval(last)), timezone: timezone)
            } else if let endTimestamp = data.indicators.last?.timestamp {
                xAxisDateComponents = selectedRange.getDateComponents(startDate: startTimestamp, endDate: endTimestamp, timezone: timezone)
            }
            
            if selectedRange == .oneDay {
                dateFormatter.dateFormat = "H d"
                
            } else if selectedRange == .oneWeek {
                dateFormatter.dateFormat = "MMM d"
                
            } else if selectedRange == .oneMonth1 || selectedRange == .oneMonth2 || selectedRange == .oneMonth3 || selectedRange == .oneMonth4 || selectedRange == .threeMonths || selectedRange == .sixMonths || selectedRange == .nineMonths || selectedRange == .ytd || selectedRange == .oneYear {
                dateFormatter.dateFormat = "MMM d"
                
            } else if selectedRange == .twoYears || selectedRange == .threeYears {
                dateFormatter.dateFormat = "MMM yyyy"
                
            } else {
                dateFormatter.dateFormat = "yyyy"
                
            }

            
            
            
        }
        
        var map = [String: String]()
        var axisEnd: Int
        
        var items = [ChartViewItem]()
        
        for (index, value) in data.indicators.enumerated() {
            let dc = value.timestamp.dateComponents(timeZone: timezone, rangeType: selectedRange.rawValue)
            
            if !map.contains(where: { $0.value == dateFormatter.string(from: value.timestamp) }) {
                map[String(index)] = dateFormatter.string(from: value.timestamp)
                xAxisDateComponents.remove(dc)
            }
            
            
            
            items.append(ChartViewItem(
                timestamp: value.timestamp,
                value: value.close))
        }
        axisEnd = items.count - 1
        if self.isShowingSnitt50 || self.isShowingSnitt200 || self.isShowingSnittOptional || self.isShowingRSI {
            map = self.testChart.xAxisData.map
        }
        print("map123: \(map)")
        
        
        if selectedRange == .oneDay, var date = items.last?.timestamp, !isLine3Selected {
            print("date: \(date), regular: \(data.meta.regularTradingPeriodEndDate)")
            while date < data.meta.regularTradingPeriodEndDate {
                axisEnd += 1
                date = Calendar.current.date(byAdding: .minute, value: 1, to: date) ?? date
                let dc = date.dateComponents(timeZone: timezone, rangeType: selectedRange.rawValue)
                if !map.contains(where: { $0.value == dateFormatter.string(from: date) }) {
                    map[String(axisEnd)] = dateFormatter.string(from: date)
                    xAxisDateComponents.remove(dc)
                }
            }
        }
        
        if isLine3Selected {
            if selectedRange == .oneDay, var date = items.last?.timestamp, let firstDate = items.first?.timestamp {
                if date < data.meta.regularTradingPeriodEndDate {
                    while date < data.meta.regularTradingPeriodEndDate {
                        axisEnd += 1
                        date = Calendar.current.date(byAdding: .minute, value: 1, to: date) ?? date
                        minutesAdded += 5
                        let dc = date.dateComponents(timeZone: timezone, rangeType: selectedRange.rawValue)
                        if !tupleArrayOfDates.contains(where: { $0.0 == String(axisEnd)} ) {
                            tupleArrayOfDates.append((String(axisEnd), date))
                        }
                        if !map.contains(where: { $0.value == dateFormatter.string(from: date) }) {
                            map[String(axisEnd)] = dateFormatter.string(from: date)
                            xAxisDateComponents.remove(dc)
                        }
                    }
                    if minutesAdded < 180 {
                        
                        var date2: Date
                        let calendar = Calendar.current
                        
                        var nextDay = calendar.date(byAdding: .day, value: 1, to: firstDate) ?? date
                        while isWeekend(nextDay) {
                            nextDay = calendar.date(byAdding: .day, value: 1, to: nextDay) ?? date
                        }
                        let threeHours = calendar.date(byAdding: .hour, value: 3, to: nextDay) ?? date
                        date2 = threeHours
                        print("date2: \(date2)")
                        while date < date2 && minutesAdded < 180 {
                            date = Calendar.current.date(byAdding: .minute, value: 1, to: date) ?? date
                            print("start: \(data.meta.regularTradingPeriodStartDate)")
                            print("end: \(data.meta.regularTradingPeriodEndDate)")
                            if !isWeekend(date) && isTimeBetween(date, start: data.meta.regularTradingPeriodStartDate, end: data.meta.regularTradingPeriodEndDate) {
                                axisEnd += 1
                                minutesAdded += 5
                            }
                            let dc = date.dateComponents(timeZone: timezone, rangeType: selectedRange.rawValue)
                            if !tupleArrayOfDates.contains(where: { $0.0 == String(axisEnd)} ) && !isWeekend(date) && isTimeBetween(date, start: data.meta.regularTradingPeriodStartDate, end: data.meta.regularTradingPeriodEndDate) {
                                tupleArrayOfDates.append((String(axisEnd), date))
                            }
                            if !map.contains(where: { $0.value == dateFormatter.string(from: date) }) && !isWeekend(date) && isTimeBetween(date, start: data.meta.regularTradingPeriodStartDate, end: data.meta.regularTradingPeriodEndDate) {
                                print("dateformatter: \(dateFormatter.string(from: date)), date: \(date), axisEnd: \(axisEnd)")
                                map[String(axisEnd)] = dateFormatter.string(from: date)
                                xAxisDateComponents.remove(dc)
                            }
                        }
                    }
                } else {
                    var date2: Date
                    let calendar = Calendar.current
                    
                    var nextDay = calendar.date(byAdding: .day, value: 1, to: firstDate) ?? date
                    while isWeekend(nextDay) {
                        nextDay = calendar.date(byAdding: .day, value: 1, to: nextDay) ?? date
                    }
                    let threeHours = calendar.date(byAdding: .hour, value: 3, to: nextDay) ?? date
                    date2 = threeHours
                    print("date2: \(date2)")
                    while date < date2 {
                        date = Calendar.current.date(byAdding: .minute, value: 1, to: date)!
                        print("start: \(data.meta.regularTradingPeriodStartDate)")
                        print("end: \(data.meta.regularTradingPeriodEndDate)")
                        if !isWeekend(date) && isTimeBetween(date, start: data.meta.regularTradingPeriodStartDate, end: data.meta.regularTradingPeriodEndDate) {
                            axisEnd += 1
                        }
                        let dc = date.dateComponents(timeZone: timezone, rangeType: selectedRange.rawValue)
                        if !tupleArrayOfDates.contains(where: { $0.0 == String(axisEnd)} ) && !isWeekend(date) && isTimeBetween(date, start: data.meta.regularTradingPeriodStartDate, end: data.meta.regularTradingPeriodEndDate) {
                            tupleArrayOfDates.append((String(axisEnd), date))
                        }
                        if !map.contains(where: { $0.value == dateFormatter.string(from: date) }) && !isWeekend(date) && isTimeBetween(date, start: data.meta.regularTradingPeriodStartDate, end: data.meta.regularTradingPeriodEndDate) {
                            print("dateformatter: \(dateFormatter.string(from: date)), date: \(date), axisEnd: \(axisEnd)")
                            map[String(axisEnd)] = dateFormatter.string(from: date)
                            xAxisDateComponents.remove(dc)
                        }
                    }
                    print("map: \(map)")
                }
                
                
                
                print("nice da, jeg er her!")
                
                
            } else if selectedRange == .oneWeek, var date = items.last?.timestamp {
                var date2: Date
                let calendar = Calendar.current
                var nextThreedays = calendar.date(byAdding: .day, value: 1, to: date) ?? date
                var nextThreedays2 = calendar.date(byAdding: .day, value: 1, to: nextThreedays) ?? date
                var nextThreedays3 = calendar.date(byAdding: .day, value: 1, to: nextThreedays2) ?? date
                
                while isWeekend(nextThreedays) || isWeekend(nextThreedays2) || isWeekend(nextThreedays3) {
                    nextThreedays = calendar.date(byAdding: .day, value: 1, to: nextThreedays) ?? date
                    nextThreedays2 = calendar.date(byAdding: .day, value: 1, to: nextThreedays2) ?? date
                    nextThreedays3 = calendar.date(byAdding: .day, value: 1, to: nextThreedays3) ?? date
                    
                }
                date = dateRoundedToNextHour(date: date) ?? date
//                date = calendar.date(byAdding: .minute, value: 40, to: date) ?? date
                print("date1: \(nextThreedays), date2: \(nextThreedays2), date3: \(nextThreedays3)")
                date2 = nextThreedays3
                print("date2: \(date2)")
                while date < date2 {
                    print("start: \(data.meta.regularTradingPeriodStartDate)")
                    print("end: \(data.meta.regularTradingPeriodEndDate)")
                    if isMinutesApartAndNotSameDate(date1: date, date2: data.meta.regularTradingPeriodEndDate, minutes: 1) {
                        date = Calendar.current.date(byAdding: .minute, value: 1, to: date)!
                    } else {
                        date = Calendar.current.date(byAdding: .minute, value: 2, to: date)!
                    }
                    
                    if !isWeekend(date) && isTimeBetween(date, start: data.meta.regularTradingPeriodStartDate, end: data.meta.regularTradingPeriodEndDate) {
                        axisEnd += 1
                        print("insane2: \(date)")
                    }
                    
                    let dc = date.dateComponents(timeZone: timezone, rangeType: selectedRange.rawValue)
                    if !tupleArrayOfDates.contains(where: { $0.0 == String(axisEnd)} ) && !isWeekend(date) && isTimeBetween(date, start: data.meta.regularTradingPeriodStartDate, end: data.meta.regularTradingPeriodEndDate) {
                        tupleArrayOfDates.append((String(axisEnd), date))
                        print("insane: \(date)")
                    }
                    if !map.contains(where: { $0.value == dateFormatter.string(from: date) }) && !isWeekend(date) && isTimeBetween(date, start: data.meta.regularTradingPeriodStartDate, end: data.meta.regularTradingPeriodEndDate) {
                        map[String(axisEnd)] = dateFormatter.string(from: date)
                        xAxisDateComponents.remove(dc)
                        print("insane2: \(date)")
                    }
                }
                print("map: \(map)")
                print("nice da, jeg er her!")
                
                
            } else if selectedRange == .oneMonth1, var date = items.last?.timestamp {
                var date2: Date
                let calendar = Calendar.current
                let threeHours = calendar.date(byAdding: .day, value: 12, to: date) ?? date
                date2 = threeHours
                print("date2: \(date2)")
                date = dateRoundedToNextHour(date: date) ?? date
                while date < date2 {
                    
                    date = Calendar.current.date(byAdding: .minute, value: 5, to: date)!
                    print("start: \(data.meta.regularTradingPeriodStartDate)")
                    print("end: \(data.meta.regularTradingPeriodEndDate)")
                    if !isWeekend(date) && isTimeBetween(date, start: data.meta.regularTradingPeriodStartDate, end: data.meta.regularTradingPeriodEndDate) {
                        axisEnd += 1
                    }
                    let dc = date.dateComponents(timeZone: timezone, rangeType: selectedRange.rawValue)
                    if !tupleArrayOfDates.contains(where: { $0.0 == String(axisEnd)} ) && !isWeekend(date) && isTimeBetween(date, start: data.meta.regularTradingPeriodStartDate, end: data.meta.regularTradingPeriodEndDate) {
                        tupleArrayOfDates.append((String(axisEnd), date))
                    }
                    if !map.contains(where: { $0.value == dateFormatter.string(from: date) }) {
                        map[String(axisEnd)] = dateFormatter.string(from: date)
                        xAxisDateComponents.remove(dc)
                    }
                }
                
                print("nice da, jeg er her!")
                
                
            } else if selectedRange == .oneMonth2, var date = items.last?.timestamp {
                var date2: Date
                let calendar = Calendar.current
                let threeHours = calendar.date(byAdding: .day, value: 12, to: date) ?? date
                date2 = threeHours
                print("date2: \(date2)")
                date = dateRoundedToNextHour(date: date) ?? date
                while date < date2 {
                    
                    if isMinutesApartAndNotSameDate(date1: date, date2: data.meta.regularTradingPeriodEndDate, minutes: 5) {
                        date = Calendar.current.date(byAdding: .minute, value: 5, to: date)!
                    } else {
                        date = Calendar.current.date(byAdding: .minute, value: 15, to: date)!
                    }
                    print("start: \(data.meta.regularTradingPeriodStartDate)")
                    print("end: \(data.meta.regularTradingPeriodEndDate)")
                    if !isWeekend(date) && isTimeBetween(date, start: data.meta.regularTradingPeriodStartDate, end: data.meta.regularTradingPeriodEndDate) {
                        axisEnd += 1
                    }
                    let dc = date.dateComponents(timeZone: timezone, rangeType: selectedRange.rawValue)
                    if !tupleArrayOfDates.contains(where: { $0.0 == String(axisEnd)} ) && !isWeekend(date) && isTimeBetween(date, start: data.meta.regularTradingPeriodStartDate, end: data.meta.regularTradingPeriodEndDate) {
                        tupleArrayOfDates.append((String(axisEnd), date))
                    }
                    if !map.contains(where: { $0.value == dateFormatter.string(from: date) }) {
                        map[String(axisEnd)] = dateFormatter.string(from: date)
                        xAxisDateComponents.remove(dc)
                    }
                }
                
                print("nice da, jeg er her!")
                
                
            } else if selectedRange == .oneMonth3, var date = items.last?.timestamp {
                var date2: Date
                let calendar = Calendar.current
                let threeHours = calendar.date(byAdding: .day, value: 12, to: date) ?? date
                date2 = threeHours
                print("date2: \(date2)")
                date = dateRoundedToNextHour(date: date) ?? date
                while date < date2 {
                    
                    if isMinutesApartAndNotSameDate(date1: date, date2: data.meta.regularTradingPeriodEndDate, minutes: 20) {
                        date = Calendar.current.date(byAdding: .minute, value: 20, to: date)!
                    } else {
                        date = Calendar.current.date(byAdding: .minute, value: 30, to: date)!
                    }
                    print("start: \(data.meta.regularTradingPeriodStartDate)")
                    print("end: \(data.meta.regularTradingPeriodEndDate)")
                    if !isWeekend(date) && isTimeBetween(date, start: data.meta.regularTradingPeriodStartDate, end: data.meta.regularTradingPeriodEndDate) {
                        axisEnd += 1
                    }
                    let dc = date.dateComponents(timeZone: timezone, rangeType: selectedRange.rawValue)
                    if !tupleArrayOfDates.contains(where: { $0.0 == String(axisEnd)} ) && !isWeekend(date) && isTimeBetween(date, start: data.meta.regularTradingPeriodStartDate, end: data.meta.regularTradingPeriodEndDate) {
                        tupleArrayOfDates.append((String(axisEnd), date))
                    }
                    if !map.contains(where: { $0.value == dateFormatter.string(from: date) }) {
                        map[String(axisEnd)] = dateFormatter.string(from: date)
                        xAxisDateComponents.remove(dc)
                    }
                }
                
                print("nice da, jeg er her!")
                
                
            } else if selectedRange == .oneMonth4, var date = items.last?.timestamp {
                var date2: Date
                let calendar = Calendar.current
                let threeHours = calendar.date(byAdding: .day, value: 12, to: date) ?? date
                date2 = threeHours
                print("date2: \(date2)")
                date = dateRoundedToNextHour(date: date) ?? date
                while date < date2 {
                    
                    if isMinutesApartAndNotSameDate(date1: date, date2: data.meta.regularTradingPeriodEndDate, minutes: 20) {
                        date = Calendar.current.date(byAdding: .minute, value: 20, to: date)!
                    } else {
                        date = Calendar.current.date(byAdding: .hour, value: 1, to: date)!
                    }
                    print("start: \(data.meta.regularTradingPeriodStartDate)")
                    print("end: \(data.meta.regularTradingPeriodEndDate)")
                    if !isWeekend(date) && isTimeBetween(date, start: data.meta.regularTradingPeriodStartDate, end: data.meta.regularTradingPeriodEndDate) {
                        axisEnd += 1
                    }
                    let dc = date.dateComponents(timeZone: timezone, rangeType: selectedRange.rawValue)
                    if !tupleArrayOfDates.contains(where: { $0.0 == String(axisEnd)} ) && !isWeekend(date) && isTimeBetween(date, start: data.meta.regularTradingPeriodStartDate, end: data.meta.regularTradingPeriodEndDate) {
                        tupleArrayOfDates.append((String(axisEnd), date))
                    }
                    if !map.contains(where: { $0.value == dateFormatter.string(from: date) }) {
                        map[String(axisEnd)] = dateFormatter.string(from: date)
                        xAxisDateComponents.remove(dc)
                    }
                }
                
                print("nice da, jeg er her!")
                
                
            } else if selectedRange == .threeMonths, var date = items.last?.timestamp {
                var date2: Date
                let calendar = Calendar.current
                let threeHours = calendar.date(byAdding: .weekOfYear, value: 5, to: date) ?? date
                date2 = threeHours
                print("date2: \(date2)")
                while date < date2 {
                    date = Calendar.current.date(byAdding: .day, value: 1, to: date)!
                    if !isWeekend(date) {
                        axisEnd += 1
                    }
                    let dc = date.dateComponents(timeZone: timezone, rangeType: selectedRange.rawValue)
                    if !tupleArrayOfDates.contains(where: { $0.0 == String(axisEnd)} ) && !isWeekend(date) {
                        tupleArrayOfDates.append((String(axisEnd), date))
                    }
                    if !map.contains(where: { $0.value == dateFormatter.string(from: date) }) {
                        map[String(axisEnd)] = dateFormatter.string(from: date)
                        xAxisDateComponents.remove(dc)
                    }
                }
                
                print("nice da, jeg er her!")
                
                
            } else if selectedRange == .sixMonths, var date = items.last?.timestamp {
                var date2: Date
                let calendar = Calendar.current
                let threeHours = calendar.date(byAdding: .weekOfYear, value: 10, to: date) ?? date
                date2 = threeHours
                print("date2: \(date2)")
                while date < date2 {
                    date = Calendar.current.date(byAdding: .day, value: 1, to: date)!
                    if !isWeekend(date) {
                        axisEnd += 1
                    }
                    let dc = date.dateComponents(timeZone: timezone, rangeType: selectedRange.rawValue)
                    if !tupleArrayOfDates.contains(where: { $0.0 == String(axisEnd)} ) && !isWeekend(date) {
                        tupleArrayOfDates.append((String(axisEnd), date))
                    }
                    if !map.contains(where: { $0.value == dateFormatter.string(from: date) }) {
                        map[String(axisEnd)] = dateFormatter.string(from: date)
                        xAxisDateComponents.remove(dc)
                    }
                }
                
                print("nice da, jeg er her!")
                
                
            } else if selectedRange == .nineMonths, var date = items.last?.timestamp {
                var date2: Date
                let calendar = Calendar.current
                let threeHours = calendar.date(byAdding: .weekOfYear, value: 15, to: date) ?? date
                date2 = threeHours
                print("date2: \(date2)")
                while date < date2 {
                    date = Calendar.current.date(byAdding: .day, value: 1, to: date)!
                    if !isWeekend(date) {
                        axisEnd += 1
                    }
                    let dc = date.dateComponents(timeZone: timezone, rangeType: selectedRange.rawValue)
                    if !tupleArrayOfDates.contains(where: { $0.0 == String(axisEnd)} ) && !isWeekend(date) {
                        tupleArrayOfDates.append((String(axisEnd), date))
                    }
                    if !map.contains(where: { $0.value == dateFormatter.string(from: date) }) {
                        map[String(axisEnd)] = dateFormatter.string(from: date)
                        xAxisDateComponents.remove(dc)
                    }
                }
                
                print("nice da, jeg er her!")
                
                
            } else if selectedRange == .ytd, var date = items.last?.timestamp {
                var date2: Date
                let calendar = Calendar.current
                var threeHours: Date
                if let weeks = weeksFromNewYear(to: date) {
                    let numberOfWeeksAdded = ceil(Double(weeks / 5))
                    threeHours = calendar.date(byAdding: .weekOfYear, value: Int(numberOfWeeksAdded), to: date) ?? date
                } else {
                    threeHours = calendar.date(byAdding: .weekOfYear, value: 2, to: date) ?? date
                }
                
                
                date2 = threeHours
                print("date2: \(date2)")
                while date < date2 {
                    date = Calendar.current.date(byAdding: .day, value: 1, to: date)!
                    if !isWeekend(date) {
                        axisEnd += 1
                    }
                    let dc = date.dateComponents(timeZone: timezone, rangeType: selectedRange.rawValue)
                    if !tupleArrayOfDates.contains(where: { $0.0 == String(axisEnd)} ) && !isWeekend(date) {
                        tupleArrayOfDates.append((String(axisEnd), date))
                    }
                    if !map.contains(where: { $0.value == dateFormatter.string(from: date) }) {
                        map[String(axisEnd)] = dateFormatter.string(from: date)
                        xAxisDateComponents.remove(dc)
                    }
                }
                
                print("nice da, jeg er her!")
                
                
            } else if selectedRange == .oneYear, var date = items.last?.timestamp {
                var date2: Date
                let calendar = Calendar.current
                let threeHours = calendar.date(byAdding: .month, value: 3, to: date) ?? date
                date2 = threeHours
                print("date2: \(date2)")
                while date < date2 {
                    axisEnd += 1
                    date = Calendar.current.date(byAdding: .day, value: 1, to: date)!
                    if !isWeekend(date) {
                        axisEnd += 1
                    }
                    let dc = date.dateComponents(timeZone: timezone, rangeType: selectedRange.rawValue)
                    if !tupleArrayOfDates.contains(where: { $0.0 == String(axisEnd)} ) {
                        tupleArrayOfDates.append((String(axisEnd), date))
                    }
                    if !map.contains(where: { $0.value == dateFormatter.string(from: date) }) {
                        map[String(axisEnd)] = dateFormatter.string(from: date)
                        xAxisDateComponents.remove(dc)
                    }
                }
                
                print("nice da, jeg er her!")
                
                
            } else if selectedRange == .twoYears, var date = items.last?.timestamp {
                var date2: Date
                let calendar = Calendar.current
                let threeHours = calendar.date(byAdding: .month, value: 6, to: date) ?? date
                date2 = threeHours
                print("date2: \(date2)")
                while date < date2 {
                    date = Calendar.current.date(byAdding: .day, value: 1, to: date)!
                    if !isWeekend(date) {
                        axisEnd += 1
                    }
                    let dc = date.dateComponents(timeZone: timezone, rangeType: selectedRange.rawValue)
                    if !tupleArrayOfDates.contains(where: { $0.0 == String(axisEnd)} ) && !isWeekend(date) {
                        tupleArrayOfDates.append((String(axisEnd), date))
                    }
                    if !map.contains(where: { $0.value == dateFormatter.string(from: date) }) {
                        map[String(axisEnd)] = dateFormatter.string(from: date)
                        xAxisDateComponents.remove(dc)
                    }
                }
                
                print("nice da, jeg er her!")
                
                
            } else if selectedRange == .threeYears, var date = items.last?.timestamp {
                var date2: Date
                let calendar = Calendar.current
                let threeHours = calendar.date(byAdding: .month, value: 9, to: date) ?? date
                date2 = threeHours
                print("date2: \(date2)")
                while date < date2 {
                    date = Calendar.current.date(byAdding: .day, value: 1, to: date)!
                    if !isWeekend(date) {
                        axisEnd += 1
                    }
                    let dc = date.dateComponents(timeZone: timezone, rangeType: selectedRange.rawValue)
                    if !tupleArrayOfDates.contains(where: { $0.0 == String(axisEnd)} ) && !isWeekend(date) {
                        tupleArrayOfDates.append((String(axisEnd), date))
                    }
                    if !map.contains(where: { $0.value == dateFormatter.string(from: date) }) {
                        map[String(axisEnd)] = dateFormatter.string(from: date)
                        xAxisDateComponents.remove(dc)
                    }
                }
                
                print("nice da, jeg er her123m!")
                
                
            } else if selectedRange == .fiveYears, var date = items.last?.timestamp {
                var date2: Date
                let calendar = Calendar.current
                let threeHours = calendar.date(byAdding: .year, value: 1, to: date) ?? date
                date2 = threeHours
                print("date2: \(date2)")
                while date < date2 {
                    date = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: date)!
                    axisEnd += 1
                    
                    let dc = date.dateComponents(timeZone: timezone, rangeType: selectedRange.rawValue)
                    if !tupleArrayOfDates.contains(where: { $0.0 == String(axisEnd)} ) {
                        tupleArrayOfDates.append((String(axisEnd), date))
                    }
                    if !map.contains(where: { $0.value == dateFormatter.string(from: date) }) {
                        map[String(axisEnd)] = dateFormatter.string(from: date)
                        xAxisDateComponents.remove(dc)
                    }
                }
                
                print("nice da, jeg er her!")
                
                
            } else if selectedRange == .tenYears, var date = items.last?.timestamp {
                var date2: Date
                let calendar = Calendar.current
                let threeHours = calendar.date(byAdding: .year, value: 2, to: date) ?? date
                date2 = threeHours
                print("date2: \(date2)")
                while date < date2 {
                    date = Calendar.current.date(byAdding: .month, value: 1, to: date) ?? date
                    axisEnd += 1
                    print("date: \(date)")
                    let dc = date.dateComponents(timeZone: timezone, rangeType: selectedRange.rawValue)
                    if !tupleArrayOfDates.contains(where: { $0.0 == String(axisEnd)} ) {
                        tupleArrayOfDates.append((String(axisEnd), date))
                    }
                    if !map.contains(where: { $0.value == dateFormatter.string(from: date) }) {
                        map[String(axisEnd)] = dateFormatter.string(from: date)
                        xAxisDateComponents.remove(dc)
                    }
                }
                print("tupleArrayOfDates: \(tupleArrayOfDates)")
                
                print("nice da, jeg er her!")
                
                
            } else if selectedRange == .max, var date = items.last?.timestamp {
                var date2: Date
                let calendar = Calendar.current
                let threeHours = calendar.date(byAdding: .year, value: 4, to: date) ?? date
                date2 = threeHours
                print("date2: \(date2)")
                while date < date2 {
                    date = Calendar.current.date(byAdding: .weekOfYear, value: 4, to: date) ?? date
                    axisEnd += 1
                    print("date: \(date)")
                    let dc = date.dateComponents(timeZone: timezone, rangeType: selectedRange.rawValue)
                    if !tupleArrayOfDates.contains(where: { $0.0 == String(axisEnd)} ) {
                        tupleArrayOfDates.append((String(axisEnd), date))
                    }
                    if !map.contains(where: { $0.value == dateFormatter.string(from: date) }) {
                        map[String(axisEnd)] = dateFormatter.string(from: date)
                        xAxisDateComponents.remove(dc)
                    }
                }
                print("tupleArrayOfDates: \(tupleArrayOfDates)")
                
                print("nice da, jeg er her!")
                
                
            }
            maxXValue = Float(axisEnd)
        }
        
        //        if !self.isShowingSnitt {
        tupleArray = map.map { (key, value) in
            return (key, value)
        }
        
        tupleArray.sort {
            let number1 = $0.0.filter(\.isNumber)
            let number2 = $1.0.filter(\.isNumber)
            return Int(number1)! < Int(number2)!
        }
        
        myMap = tupleArray
        
        
        if self.selectedRange == .oneWeek {
            let stride2 = tupleArray.count / 3
            if stride2 > 1 {
                var selectedElements: [(String, String)] = []
                for i in stride(from: 0, through: tupleArray.count - 1, by: stride2) {
                    selectedElements.append(tupleArray[i])
                }
                tupleArray = selectedElements
                print("changed tupleArray: \(self.tupleArray)")
            }
        } else {
            let stride2 = tupleArray.count / 4
            if stride2 > 1 {
                var selectedElements: [(String, String)] = []
                for i in stride(from: 0, through: tupleArray.count - 1, by: stride2) {
                    selectedElements.append(tupleArray[i])
                }
                tupleArray = selectedElements
                print("changed tupleArray2: \(self.tupleArray)")
            }
        }
        
        
        
        let xAxisData = ChartAxisData(
            axisStart: 0,
            axisEnd: Double(max(0, axisEnd)),
            strideBy: 1,
            map: map)
        
        let xAxisData2 = ChartAxisData(
            axisStart: 0,
            axisEnd: self.testChart.xAxisData.axisEnd,
            strideBy: 1,
            map: self.testChart.xAxisData.map)
        
        if self.isShowingSnitt50 && !self.isMakingLine && !self.isFixingTestChart || self.isShowingSnitt200 && !self.isMakingLine && !self.isFixingTestChart || self.isShowingSnittOptional && !self.isMakingLine && !self.isFixingTestChart || self.isShowingRSI && !self.isMakingLine && !self.isFixingTestChart {
            return (xAxisData2, items)
        } else {
            return (xAxisData, items)
        }
        
    }
    
    
    func yAxisChartData(_ data: ChartData) -> ChartAxisData {
        let closes = data.indicators.map { $0.close }
        var lowest = closes.min() ?? 0
        var highest = closes.max() ?? 0
        
        let newCloses = self.StockArraySnitt.map { $0.close }
        let newLowest = newCloses.min() ?? 1000000000
        let newHighest = newCloses.max() ?? 0
        
        if let prevClose = data.meta.previousClose, selectedRange == .oneDay {
            if prevClose < lowest {
                lowest = prevClose
            } else if prevClose > highest {
                highest = prevClose
            }
            
            print("prevClose: \(prevClose)")
        }
        
        if !self.isMakingLine && self.isFixingTestChart {
            self.testChart.yAxisData.axisEnd = highest
            self.testChart.yAxisData.axisStart = lowest
        }
        
        if self.isShowingSnitt50 || self.isShowingSnitt200 || self.isShowingSnittOptional {
            print("newLowest: \(newLowest)")
            print("newHeigest: \(newHighest)")
            highest = self.storedYEndValue
            print("saved highest: \(highest)")
            lowest = self.storedYStartValue
            if Double(newLowest) < self.storedYStartValue || Double(newLowest) < self.testChart.yAxisData.axisStart {
                self.testChart.yAxisData.axisStart = Double(newLowest)
                lowest = Double(newLowest)
                print("i got the new lowest: \(lowest)")
            }
            if Double(newHighest) > self.storedYEndValue || Double(newHighest) > self.testChart.yAxisData.axisEnd {
                self.testChart.yAxisData.axisEnd = Double(newHighest)
                highest = Double(newHighest)
                print("i got the new highest: \(highest)")
            }
        }
        
        
        if isLine3Selected {
            if let (selectedX, text) = selectedLineMark1, let (selectedX2, text2) = selectedLineMark2, let number = Float(text), let number2 = Float(text2), let (selectedX3, text3) = selectedLineMark3, let number3 = Float(text3) {
                let xChange = selectedX2 - selectedX
                let yChange = number2 - number
                let stigning = stigning(yChange: yChange, xChange: Float(xChange))
                let _ = print("selectedX3: \(selectedX3)")
                let _ = print("selectedX2: \(selectedX2)")
                let _ = print("Stigning2: \(stigning)")
                let maxX2 = maxXValue
                let yValue = fy(x: Float(maxX2), x1: Float(selectedX), y1: number, stigning: stigning)
                let yValue2 = fy(x: Float(maxX2), x1: Float(selectedX3), y1: number3, stigning: stigning)
                
                if stigning > 0 {
                    if yValue > Float(highest) || yValue2 > Float(highest) {
                        if yValue > yValue2 {
                            highest = Double(yValue)
                            print("Higest yValue: \(yValue)")
                            
                        } else {
                            highest = Double(yValue2)
                            print("Higest yValue2: \(yValue2)")
                        }
                    }
                    
                    
                } else {
                    if yValue < Float(lowest) || yValue2 < Float(lowest) {
                        if yValue > yValue2 {
                            lowest = Double(yValue2)
                            print("Lowest yValue2: \(yValue2)")
                            
                        } else {
                            lowest = Double(yValue)
                            print("Lowest yValue: \(yValue)")
                        }
                    }
                    
                }
            }
        }
        
        if self.selectedRange != .oneDay {
            highest = ceil(highest)
            lowest = floor(lowest)
        }
        
        maxValue2 = Float(highest)
        minValue2 = Float(lowest)
        
        
        
//        let diff = highest - lowest
        
        let numberOfLines: Double = 4
        let shouldCeilIncrement: Bool
        let strideBy: Double
        
//        if diff < (numberOfLines * 2) {
        shouldCeilIncrement = false
        strideBy = 0.01
//        } 
//        else {
//            shouldCeilIncrement = true
//            lowest = floor(lowest)
//            highest = ceil(highest)
//            strideBy = 1.0
//            print("i am here 2")
//        }
        self.yAxisArray.removeAll()
        let increment = ((highest - lowest) / (numberOfLines))
        var map = [String: String]()
        map[highest.roundedString] = formatYAxisValueLabel(value: highest, shouldCeilIncrement: shouldCeilIncrement)
        if let float = Float(highest.roundedString) {
            self.yAxisArray.append(float)
        }
        self.yAxisArray.append(Float(lowest - 0.01))
        
        var current = lowest
        (0..<Int(numberOfLines) - 1).forEach { i in
            current += increment
            map[(shouldCeilIncrement ? ceil(current) : current).roundedString] = formatYAxisValueLabel(value: current, shouldCeilIncrement: shouldCeilIncrement)
            let string = (shouldCeilIncrement ? ceil(current) : current).roundedString
            if let float = Float(string) {
                self.yAxisArray.append(float)
            }
            
            
                                   
        }
        self.yAxisArray.sort()
        print("map2: \(map)")
        print("yAxisArray: \(self.yAxisArray)")
        
        if !self.isMakingLine && !self.isShowingSnitt50 && !self.isShowingSnitt200 && !self.isShowingSnittOptional {
            self.storedMap = map
            
        }
        
        if !self.isShowingSnitt50 && !self.isShowingSnitt200 && !self.isShowingSnittOptional {
            self.storedYEndValue = highest
            self.storedYStartValue = lowest
        }
        
        
        
        if self.isShowingSnitt50 && !self.isMakingLine && !self.isFixingTestChart || self.isShowingSnitt200 && !self.isMakingLine && !self.isFixingTestChart || self.isShowingSnittOptional && !self.isMakingLine && !self.isFixingTestChart {
            self.testChart.yAxisData.map = map
            self.testChart.yAxisData.axisEnd = highest
            self.testChart.yAxisData.axisStart = lowest
            
            return ChartAxisData(
                axisStart: lowest - 0.01,
                axisEnd: highest + 0.01,
                strideBy: strideBy,
                map: self.storedMap)
            
        } else {
            return ChartAxisData(
                axisStart: lowest - 0.01,
                axisEnd: highest + 0.01,
                strideBy: strideBy,
                map: map)
        }
        
        
    }
    
    func yAxisChartDataRSI(_ data: ChartData) -> ChartAxisData {
        let closes = data.indicators.map { $0.close }
        var lowest = closes.min() ?? 0
        var highest = closes.max() ?? 0
        
//        let newCloses = self.StockArraySnitt.map { $0.close }
//        let newLowest = newCloses.min() ?? 1000000000
//        let newHighest = newCloses.max() ?? 0
        
        if let prevClose = data.meta.previousClose {
            if prevClose < lowest {
                lowest = prevClose
            } else if prevClose > highest {
                highest = prevClose
            }
            
            print("prevClose: \(prevClose)")
        }
        
        print("highestRSI: \(highest)")
        
        if highest <= 80 {
            highest = 80
        } else {
            highest = 100
        }
        
        print("highestRSI2: \(highest)")
        
        if lowest >= 20 {
            lowest = 10
        } else if lowest < 20 && lowest >= 5 {
            lowest = 0
        } else {
            lowest = -20
        }
        
        let strideBy: Double
        strideBy = 20

        
        let map = ["0": "0", "20": "20", "40": "40", "60": "60", "80": "80", "100": "100"]
        
        print("axisStart: \(lowest - 10)")
        print("axisEnd: \(highest + 10)")
        return ChartAxisData(
            axisStart: lowest,
            axisEnd: highest,
            strideBy: strideBy,
            map: map)
        
        
        
    }
    
    func formatYAxisValueLabel(value: Double, shouldCeilIncrement: Bool) -> String {
        if shouldCeilIncrement {
            return String(Int(ceil(value)))
        } else {
            return Utils.numberFormatter.string(from: NSNumber(value: value)) ?? value.roundedString
        }
    }
}


