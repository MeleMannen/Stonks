    //
    //  AksjerView.swift
    //  Aksjer
    //
    //  Created by Kristoffer Melen on 23/12/2023.
    //

import SwiftUI


var searchedStocks: [Quotes] = []


struct AksjerView: View {
    @AppStorage("followedStocksArray") var followedStocksArray: Data?
    @AppStorage("followedStocksArrayStrings") var followedStocksArrayStrings: Data?
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    
    @State private var isSystemImageChanged = false
    @State private var showingSearch = false
    @State private var textInput = ""
    @State private var isEditing = false
    @State private var isFirstTime = true
    
    @State private var displayedStocks: [SearchResults] = []
    
    @State var degreesRotating = 0.0
    
    @State var followedStocks: [SearchResults] = []
    @State var followedStocksStrings: [String] = []
    
    @State private var isLoading = false
    @State var shouldShowError = false
    @State var errorMessage = ""
    @State var isError = false
    
    @State var defaultfollowedStocks: [SearchResults] = [Aksjer.SearchResults(symbol: "MPCC.OL", name: "MPC Container Ships ASA", exch: "OSL", type: "S", exchDisp: "Oslo", typeDisp: "Equity", isFollowed: true), Aksjer.SearchResults(symbol: "AAPL", name: "Apple Inc.", exch: "NAS", type: "S", exchDisp: "NASDAQ", typeDisp: "Equity", isFollowed: true), Aksjer.SearchResults(symbol: "TSLA", name: "Tesla, Inc.", exch: "NAS", type: "S", exchDisp: "NASDAQ", typeDisp: "Equity", isFollowed: true), Aksjer.SearchResults(symbol: "MSFT", name: "Microsoft Corporation", exch: "NAS", type: "S", exchDisp: "NASDAQ", typeDisp: "Equity", isFollowed: true)]
    
    @State var defualtfollowedStocksStrings = ["MPCC.OL", "AAPL", "TSLA", "MSFT"]
    
    var body: some View {
        NavigationView {
            GeometryReader { geomtery in
                if isLoading {
                    VStack(alignment: .center) {
                        Spacer()
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .scaleEffect(2)
                        
                        Spacer()
                    }
                    .frame(width: geomtery.size.width, height: geomtery.size.height - 50)
                    
                    
                    
                } else if shouldShowError {
                    VStack {
                        ContentUnavailableView(label: {
                            VStack(spacing: 20) {
                                if isError {
                                    Image(systemName: "exclamationmark.magnifyingglass")
                                        .resizable()
                                        .frame(width: 100, height: 100)
                                    
                                    Text("Det skjedde en feil!")
                                        .bold()
                                } else {
                                    Image(systemName: "magnifyingglass")
                                        .resizable()
                                        .frame(width: 100, height: 100)
                                    
                                    Text("Ingen Aksjer!")
                                        .bold()
                                }
                            }
                        }, description: {
                            VStack {
                                if isError {
                                    Text("Send denne feilmeldingen til utvikleren:")
                                    
                                    Text("\(errorMessage)")
                                        .contextMenu {
                                            Button(action: {
                                                UIPasteboard.general.string = errorMessage
                                            }) {
                                                Text("Kopier")
                                                Image(systemName: "doc.on.doc")
                                            }
                                        }
                                } else {
                                    Text("\(errorMessage)")
                                        .contextMenu {
                                            Button(action: {
                                                UIPasteboard.general.string = errorMessage
                                            }) {
                                                Text("Kopier")
                                                Image(systemName: "doc.on.doc")
                                            }
                                        }
                                }
                            }
                            
                            
                        })
                    }
                    .frame(width: geomtery.size.width, height: geomtery.size.height - 50)
                    
                } else {
                    List {
                        if isEditing {
                            
//                            if !shouldShowError {
                                
                                ForEach(displayedStocks, id: \.self) { stock in
                                    let viewModel = ViewModel(stock: Aksjer.SearchResults(symbol: "\(stock.symbol)", name: "\(stock.name)", exch: "\(stock.exch)", type: "\(stock.type)", exchDisp: "\(stock.exchDisp)", typeDisp: "\(stock.typeDisp)", isFollowed: stock.isFollowed), recivedStock: Aksjer.Stock(chart: Aksjer.ChartResult(result: [StockResult(meta: Meta(currency: "", symbol: "", exchangeName: "", fullExchangeName: "", instrumentType: "", regularMarketTime: 0, hasPrePostMarketData: false, gmtoffset: 0, timezone: "", exchangeTimezoneName: "", regularMarketPrice: 0, fiftyTwoWeekHigh: 0, fiftyTwoWeekLow: 0, regularMarketDayHigh: 0, regularMarketDayLow: 0, regularMarketVolume: 0, chartPreviousClose: 0, priceHint: 0, currentTradingPeriod: CurrentTradingPeriod(pre: TradingPeriod(timezone: "", start: 0, end: 0, gmtoffset: 0), regular: TradingPeriod(timezone: "", start: 0, end: 0, gmtoffset: 0), post: TradingPeriod(timezone: "", start: 0, end: 0, gmtoffset: 0)), dataGranularity: "", range: "", validRanges: [""], tradingPeriods: [[TradingPeriod(timezone: "", start: 0, end: 0, gmtoffset: 0)]]), timestamp: [1], indicators: Indicators(quote: [Quote(close: [0], low: [0], volume: [0], open: [0], high: [0])]))], error: "")), testChart: ChartViewData(xAxisData: ChartAxisData(axisStart: 0, axisEnd: 100, strideBy: 5, map: ["": ""]), yAxisData: ChartAxisData(axisStart: 0, axisEnd: 100, strideBy: 1, map: ["": ""]), items: [ChartViewItem(timestamp: Date(), value: 100)]), snittChart: ChartViewData(xAxisData: ChartAxisData(axisStart: 0, axisEnd: 100, strideBy: 5, map: ["": ""]), yAxisData: ChartAxisData(axisStart: 0, axisEnd: 100, strideBy: 1, map: ["": ""]), items: [ChartViewItem(timestamp: Date(), value: 100)]), rsiChart: ChartViewData(xAxisData: ChartAxisData(axisStart: 0, axisEnd: 100, strideBy: 5, map: ["": ""]), yAxisData: ChartAxisData(axisStart: 0, axisEnd: 100, strideBy: 1, map: ["": ""]), items: [ChartViewItem(timestamp: Date(), value: 100)]))
                                    NavigationLink(destination: FollowedStockView(vm: viewModel)) {
                                        HStack {
                                            
                                            Button("", systemImage: stock.isFollowed ? "checkmark.circle.fill" : "plus.circle") {
                                                DispatchQueue.main.async {
                                                    
                                                    withAnimation(.spring(response: 0.9, dampingFraction: 0.5, blendDuration: 0)
                                                        .speed(1)) {
                                                            stock.isFollowed.toggle()
                                                            
                                                            if followedStocks.contains(stock) {
                                                                if let index = followedStocks.firstIndex(of: stock) {
                                                                    followedStocks.remove(at: index)
                                                                    followedStocksStrings.remove(at: index)
                                                                }
                                                            } else {
                                                                followedStocks.append(stock)
                                                                followedStocksStrings.append(stock.symbol)
                                                            }
                                                            if let encodedData = try? JSONEncoder().encode(followedStocks), let encodedData2 = try? JSONEncoder().encode(followedStocksStrings) {
                                                                followedStocksArray = encodedData
                                                                followedStocksArrayStrings = encodedData2
                                                                
                                                            }
                                                            print("why: \(stock.isFollowed)")
                                                        }
                                                    
                                                }
                                            }
                                            .scaleEffect(stock.isFollowed ? 1.1 : 1.0)
                                            .rotationEffect(.degrees(stock.isFollowed ? 360 : 0))
                                            
                                            .contentTransition(.symbolEffect(.replace))
                                            .buttonStyle(.plain)
                                            
                                            
                                            .foregroundStyle(LinearGradient(colors: [.teal, .indigo], startPoint: .topLeading, endPoint: .bottomTrailing))
                                            .font(.system(size: 24))
                                            
                                            
                                            
                                            VStack(alignment: .leading) {
                                                HStack {
                                                    Text(stock.symbol)
                                                        .font(.headline.bold())
                                                    
                                                    Text(stock.exchDisp)
                                                        .foregroundStyle(LinearGradient(colors: [.teal, .indigo], startPoint: .topLeading, endPoint: .bottomTrailing))
                                                        .font(.caption)
                                                    
                                                }
                                                .padding(EdgeInsets(top: 2, leading: 0, bottom: 3, trailing: 0))
                                                
                                                Text(stock.name)
                                                    .font(.caption2)
                                            }
                                            
                                            
                                        }
                                    }
                                }
                                
//                            } else {
//                                VStack {
//                                    ContentUnavailableView(label: {
//                                        VStack(spacing: 20) {
//                                            if isError {
//                                                Image(systemName: "exclamationmark.magnifyingglass")
//                                                    .resizable()
//                                                    .frame(width: 100, height: 100)
//                                                
//                                                Text("Det skjedde en feil!")
//                                                    .bold()
//                                            } else {
//                                                Image(systemName: "magnifyingglass")
//                                                    .resizable()
//                                                    .frame(width: 100, height: 100)
//                                                
//                                                Text("Ingen Aksjer!")
//                                                    .bold()
//                                            }
//                                        }
//                                    }, description: {
//                                        VStack {
//                                            if isError {
//                                                Text("Send denne feilmeldingen til utvikleren:")
//                                                
//                                                Text("\(errorMessage)")
//                                                    .contextMenu {
//                                                        Button(action: {
//                                                            UIPasteboard.general.string = errorMessage
//                                                        }) {
//                                                            Text("Kopier")
//                                                            Image(systemName: "doc.on.doc")
//                                                        }
//                                                    }
//                                            } else {
//                                                Text("\(errorMessage)")
//                                                    .contextMenu {
//                                                        Button(action: {
//                                                            UIPasteboard.general.string = errorMessage
//                                                        }) {
//                                                            Text("Kopier")
//                                                            Image(systemName: "doc.on.doc")
//                                                        }
//                                                    }
//                                            }
//                                        }
//                                        
//                                        
//                                    })
//                                }
//                                .frame(width: geomtery.size.width, height: geomtery.size.height - 50)
//                            }
                            
                        } else {
                                //                    List {
                            ForEach(
                                followedStocks
                            ) { stock in
                                let viewModel = ViewModel(stock: Aksjer.SearchResults(symbol: "\(stock.symbol)", name: "\(stock.name)", exch: "\(stock.exch)", type: "\(stock.type)", exchDisp: "\(stock.exchDisp)", typeDisp: "\(stock.typeDisp)", isFollowed: stock.isFollowed), recivedStock: Aksjer.Stock(chart: Aksjer.ChartResult(result: [StockResult(meta: Meta(currency: "", symbol: "", exchangeName: "", fullExchangeName: "", instrumentType: "", regularMarketTime: 0, hasPrePostMarketData: false, gmtoffset: 0, timezone: "", exchangeTimezoneName: "", regularMarketPrice: 0, fiftyTwoWeekHigh: 0, fiftyTwoWeekLow: 0, regularMarketDayHigh: 0, regularMarketDayLow: 0, regularMarketVolume: 0, chartPreviousClose: 0, priceHint: 0, currentTradingPeriod: CurrentTradingPeriod(pre: TradingPeriod(timezone: "", start: 0, end: 0, gmtoffset: 0), regular: TradingPeriod(timezone: "", start: 0, end: 0, gmtoffset: 0), post: TradingPeriod(timezone: "", start: 0, end: 0, gmtoffset: 0)), dataGranularity: "", range: "", validRanges: [""], tradingPeriods: [[TradingPeriod(timezone: "", start: 0, end: 0, gmtoffset: 0)]]), timestamp: [1], indicators: Indicators(quote: [Quote(close: [0], low: [0], volume: [0], open: [0], high: [0])]))], error: "")), testChart: ChartViewData(xAxisData: ChartAxisData(axisStart: 0, axisEnd: 100, strideBy: 5, map: ["": ""]), yAxisData: ChartAxisData(axisStart: 0, axisEnd: 100, strideBy: 1, map: ["": ""]), items: [ChartViewItem(timestamp: Date(), value: 100)]), snittChart: ChartViewData(xAxisData: ChartAxisData(axisStart: 0, axisEnd: 100, strideBy: 5, map: ["": ""]), yAxisData: ChartAxisData(axisStart: 0, axisEnd: 100, strideBy: 1, map: ["": ""]), items: [ChartViewItem(timestamp: Date(), value: 100)]), rsiChart: ChartViewData(xAxisData: ChartAxisData(axisStart: 0, axisEnd: 100, strideBy: 5, map: ["": ""]), yAxisData: ChartAxisData(axisStart: 0, axisEnd: 100, strideBy: 1, map: ["": ""]), items: [ChartViewItem(timestamp: Date(), value: 100)]))
                                NavigationLink(destination: FollowedStockView(vm: viewModel)) {
                                    HStack {
                                        Button("", systemImage: stock.isFollowed ? "checkmark.circle.fill" : "plus.circle") {
                                            DispatchQueue.main.async {
                                                withAnimation(.spring(response: 0.9, dampingFraction: 0.5, blendDuration: 0)
                                                    .speed(1)) {
                                                        stock.isFollowed.toggle()
                                                        
                                                        
                                                        if followedStocks.contains(stock) {
                                                            if let index = followedStocks.firstIndex(of: stock) {
                                                                followedStocks.remove(at: index)
                                                                followedStocksStrings.remove(at: index)
                                                                
                                                            }
                                                        } else {
                                                            followedStocks.append(stock)
                                                            followedStocksStrings.append(stock.symbol)
                                                            
                                                        }
                                                        if let encodedData = try? JSONEncoder().encode(followedStocks), let encodedData2 = try? JSONEncoder().encode(followedStocksStrings) {
                                                            followedStocksArray = encodedData
                                                            followedStocksArrayStrings = encodedData2
                                                        }
                                                        
                                                        print("why: \(stock.isFollowed)")
                                                        
                                                    }
                                                
                                            }
                                        }
                                        .scaleEffect(stock.isFollowed ? 1.1 : 1.0)
                                        .rotationEffect(.degrees(stock.isFollowed ? 360 : 0))
                                        .contentTransition(.symbolEffect(.replace))
                                        .buttonStyle(.plain)
                                        .foregroundStyle(LinearGradient(colors: [.teal, .indigo], startPoint: .topLeading, endPoint: .bottomTrailing))
                                        .font(.system(size: 24))
                                        
                                        VStack(alignment: .leading) {
                                            HStack {
                                                Text(stock.symbol)
                                                    .font(.headline.bold())
                                                
                                                Text(stock.exchDisp)
                                                    .foregroundStyle(LinearGradient(colors: [.teal, .indigo], startPoint: .topLeading, endPoint: .bottomTrailing))
                                                    .font(.caption)
                                                
                                            }
                                            .padding(EdgeInsets(top: 2, leading: 0, bottom: 3, trailing: 0))
                                            
                                            Text(stock.name)
                                                .font(.caption2)
                                        }
                                        
                                        
                                    }
                                }
                            }
                            .onDelete { indexSet in
                                withAnimation {
                                    followedStocks.remove(atOffsets: indexSet)
                                    followedStocksStrings.remove(atOffsets: indexSet)
                                    
                                    
                                    if let encodedData = try? JSONEncoder().encode(followedStocks), let encodedData2 = try? JSONEncoder().encode(followedStocksStrings) {
                                        followedStocksArray = encodedData
                                        followedStocksArrayStrings = encodedData2
                                        
                                    }
                                    
                                }}
                            .onMove { indices, newOffset in
                                if !followedStocks.isEmpty && !followedStocksStrings.isEmpty {
                                    followedStocks.move(fromOffsets: indices, toOffset: newOffset)
                                    followedStocksStrings.move(fromOffsets: indices, toOffset: newOffset)
                                    
                                    if let encodedData = try? JSONEncoder().encode(followedStocks), let encodedData2 = try? JSONEncoder().encode(followedStocksStrings) {
                                        followedStocksArray = encodedData
                                        followedStocksArrayStrings = encodedData2
                                        
                                        
                                    }
                                }
                                
                            }
                            
                        }
                        
                    }
                    .listStyle(.plain)
                    .navigationTitle("Aksjer")
                    .navigationBarItems(trailing: EditButton())
                    
                }
                
            }
            .searchable(text: $textInput, isPresented: $isEditing, prompt: "Søk")
            
            .onChange(of: isEditing) {
                if !isEditing {
                    displayedStocks.removeAll()
                    shouldShowError = false
                    isError = false
                    errorMessage = ""
                    
                    
                }
                
            }
            
            
            .onSubmit(of: .search) {
                getStockDataChartNew()
            }
            .onAppear {
//                if isFirstTime {
                    checkStorage()
//                }
            }
            
        }
        
        
    }
    
    
    
    func getStockDataChartNew() {
        isLoading = true
        
        APIFetch.shared.fetchStockSearch(searchInput: textInput.replacingOccurrences(of: " ", with: ""), completion: { searchResults in
            switch searchResults {
                case .success(let result):
                    
                    displayedStocks.removeAll()
                    for stock in result.quotes {
                        displayedStocks.append(SearchResults(symbol: stock.symbol, name: stock.shortname, exch: stock.exchange, type: stock.typeDisp, exchDisp: stock.exchDisp, typeDisp: stock.typeDisp, isFollowed: followedStocksStrings.contains(stock.symbol) ? true : false))
                    }
                    print(result.quotes)
                    if displayedStocks.isEmpty {
                        shouldShowError = true
                        errorMessage = "Det finnes ingen aksje med navnet: \(textInput)"
                        isError = false
                    } else {
                        shouldShowError = false
                    }
                    
                    
                case .failure(let error):
                    print("failed to search result: \(error)")
                    shouldShowError = true
                    errorMessage = "\(error)"
                    isError = true
                    
            }
            
            isLoading = false
            
        })
    }
    
    
    
    func checkStorage() {
        if let storedData = followedStocksArray {
            if let decodedData = try? JSONDecoder().decode([SearchResults].self, from: storedData) {
                if !decodedData.isEmpty {
                    followedStocks = decodedData
                    print("Hentet lagrede Aksjer")
                } else {
                    print("wtf idk man")
                }
            } else {
                print("Error: Kunne ikke hente lagrede Aksjer!")
//                followedStocks = defaultfollowedStocks
                if let decodedData = try? JSONDecoder().decode([SearchResults].self, from: storedData) {
                    if !decodedData.isEmpty {
                        followedStocks = decodedData
                        print("Hentet lagrede Aksjer2")
                    } else {
                        print("wtf idk man2")
                    }
                } else {
                    print("Error: Kunne ikke hente lagrede Aksjer2!")
                    print("Du er doomed!")
                }
            }
            
        } else {
            if let encodedData = try? JSONEncoder().encode(defaultfollowedStocks) {
                followedStocksArray = encodedData
                if let storedData = followedStocksArray {
                    if let decodedData = try? JSONDecoder().decode([SearchResults].self, from: storedData) {
                        if !decodedData.isEmpty {
                            followedStocks = decodedData
                            print("Ny Aksje bruker uten lagrede Aksjer")
                        }
                    } else {
                        print("Error: Kunne ikke hente stadard Aksjer")
                    }
                    
                }
            } else {
                print("Error: Kunne ikke hente stadard Aksjer for å lagre de")
            }
        }
        
        
        if let storedData = followedStocksArrayStrings {
            if let decodedData = try? JSONDecoder().decode([String].self, from: storedData) {
                if !decodedData.isEmpty {
                    followedStocksStrings = decodedData
                    print("Hentet lagrede Aksje strings")
                }
            } else {
//                followedStocksStrings = defualtfollowedStocksStrings
                print("Error: Kunne ikke hente lagrede Aksje strings!")
                if let decodedData = try? JSONDecoder().decode([String].self, from: storedData) {
                    if !decodedData.isEmpty {
                        followedStocksStrings = decodedData
                        print("Hentet lagrede Aksje strings2")
                    }
                } else {
                    print("Error: Kunne ikke hente lagrede Aksje strings2!")
                    print("Du er doomed2!")
                }
            }
            
        } else {
            if let encodedData = try? JSONEncoder().encode(defualtfollowedStocksStrings) {
                followedStocksArrayStrings = encodedData
                if let storedData = followedStocksArrayStrings {
                    if let decodedData = try? JSONDecoder().decode([String].self, from: storedData) {
                        if !decodedData.isEmpty {
                            followedStocksStrings = decodedData
                            print("Ny Aksje bruker uten lagrede Aksje strings2")
                        }
                    } else {
                        print("Error: Kunne ikke hente stadard Aksje strings")
                    }
                    
                }
            } else {
                print("Error: Kunne ikke hente stadard Aksjer for å lagre de")
            }
            
        }
        
    }
}



#Preview {
    AksjerView()
}
