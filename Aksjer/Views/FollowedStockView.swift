//
//  FollowedStockView.swift
//  Aksjer
//
//  Created by Kristoffer Melen on 30/12/2023.
//

import SwiftUI
import Charts


struct FollowedStockView: View {
    @AppStorage("defaultRange") private var defaultRange: RangeType = .oneDay
    @AppStorage("selectedInterpolationMethod") private var selectedInterpolationMethod: InterpolationMethod = .cardinal
    @ObservedObject var vm: ViewModel
    
    
    var body: some View {
        GeometryReader { geomtery in
            ZStack {
                VStack(alignment: .leading) {
                    
                    HStack {
                        VStack(alignment: .leading) {
                            HStack {
                                Text(vm.stock.symbol)
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5))
                                    .textSelection(.enabled)
                                
                                Text(vm.stock.exchDisp)
                                    .foregroundStyle(LinearGradient(colors: [.teal, .indigo], startPoint: .topLeading, endPoint: .bottomTrailing))
                                    .font(.title3)
                                    .textSelection(.enabled)
                                
                                Spacer()
                                
                            }
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 2, trailing: 0))
                            
                            
                            
                            Text(vm.stock.name)
                                .font(.callout)
                                .textSelection(.enabled)
                            
                        }
                        
                        Spacer()
                        
                        
                        
                    }
                    .listRowSeparator(.hidden)
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                    
                    Divider()
                        .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 0))
                    
                    if vm.isLoadingFirst {
                        VStack(alignment: .center) {
                            Spacer()
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                                .scaleEffect(2)
                            
                            Spacer()
                        }
                        .frame(width: geomtery.size.width, height: geomtery.size.height - 70)
                        
                        
                        
                    } else {
                        if !vm.shouldShowError {
                            List {
                                VStack(alignment: .leading) {
                                    HStack {
                                        VStack(alignment: .leading) {
                                            HStack {
                                                TextAnimations1(number: vm.number1)
                                                    .font(.title)
                                                    .fontWeight(.bold)
                                                    .lineLimit(1)
                                                    .textSelection(.enabled)
                                                    .padding(.trailing, 5)
                                                
                                                
                                                
                                                TextAnimations2(number: vm.number2, isUp: vm.isUp)
                                                    .font(.title2)
                                                    .fontWeight(.bold)
                                                    .lineLimit(1)
                                                    .textSelection(.enabled)
                                                    .foregroundStyle(vm.isUp ? .green : .red)
                                                
                                                
                                                
                                                
                                            }
                                            .onAppear {
                                                vm.updateNumbers()
                                                
                                            }
                                            .onChange(of: vm.isRefreshing) {
                                                vm.updateNumbers()
                                                
                                            }
                                            
                                            .onChange(of: vm.isLoadingOther) {
                                                vm.updateNumbers()
                                                
                                            }
                                            
                                            HStack {
                                                Text("\(vm.stock.exchDisp)")
                                                    .font(.subheadline)
                                                    .textSelection(.enabled)
                                                Text("·")
                                                    .font(.subheadline)
                                                    .textSelection(.enabled)
                                                Text("\(vm.recivedStock.chart.result[0].meta.currency)")
                                                    .font(.subheadline)
                                                    .textSelection(.enabled)
                                            }
                                            .foregroundStyle(LinearGradient(colors: [.teal, .indigo], startPoint: .topLeading, endPoint: .bottomTrailing))
                                            .font(.subheadline)
                                            
                                            
                                            if vm.isShowingOldData {
                                                Text("Viser sist lagret data")
                                                    .font(.headline)
                                                    .fontWeight(.semibold)
                                                    .textSelection(.enabled)
                                                    .padding(.top, 0.005)
                                                
                                            }
                                            
                                            
                                            
                                            
                                            
                                        }
                                        
                                        if vm.selectedRange == .oneWeek || vm.selectedRange == .oneMonth1 || vm.selectedRange == .oneMonth2 || vm.selectedRange == .oneMonth3 || vm.selectedRange == .oneMonth4 || vm.selectedRange == .threeMonths || vm.selectedRange == .sixMonths || vm.selectedRange == .nineMonths || vm.selectedRange == .ytd || vm.selectedRange == .oneYear || vm.selectedRange == .twoYears || vm.selectedRange == .threeYears || vm.selectedRange == .fiveYears {
                                            
                                            Spacer()
                                            VStack(alignment: .trailing) {
                                                Menu {
                                                    Toggle(isOn: $vm.isMakingLine, label: {
                                                        Text("Lag Linjer")
                                                    })
                                                    
                                                    Toggle(isOn: $vm.isShowingRSI, label: {
                                                        Text("Vis RSI Verdier (14d)")
                                                    })
                                                    Toggle(isOn: $vm.isShowingSnitt50, label: {
                                                        Text("Vis Glidendesnitt (50d)")
                                                    })
                                                    Toggle(isOn: $vm.isShowingSnitt200, label: {
                                                        Text("Vis Glidendesnitt (200d)")
                                                    })
                                                    Toggle(isOn: $vm.isShowingSnittOptional, label: {
                                                        Text("Vis Glidendesnitt (Valgfri)")
                                                    })
                                                    
                                                    
                                                    
                                                    
                                                } label: {
                                                    Image(systemName: "ellipsis.circle")
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fit)
                                                        .frame(width: 30, height: 30)
                                                        .foregroundStyle(LinearGradient(colors: [.teal, .indigo], startPoint: .topLeading, endPoint: .bottomTrailing))
                                                    
                                                }
                                                
                                            }
                                            .padding(.trailing, 10)
                                            
                                        } else {
                                            Spacer()
                                            
                                            VStack(alignment: .trailing) {
                                                Menu {
                                                    Toggle(isOn: $vm.isMakingLine, label: {
                                                        Text("Lag Linjer")
                                                    })
                                                } label: {
                                                    Image(systemName: "ellipsis.circle")
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fit)
                                                        .frame(width: 30, height: 30)
                                                        .foregroundStyle(LinearGradient(colors: [.teal, .indigo], startPoint: .topLeading, endPoint: .bottomTrailing))
                                                    
                                                }
                                                
                                            }
                                            .padding(.trailing, 10)
                                        }
                                        
                                        
                                    }
                                    .padding(.bottom, 5)
                                    Divider()
                                }
                                .padding(.bottom, -10)
                                
                                VStack(alignment: .leading) {
                                    ZStack {
                                        SlideView(selectedRange: vm.selectedRange) { newSelectedRange in
                                            
                                            DispatchQueue.main.async {
                                                vm.isLoadingOther = true
                                            }
                                            
                                            vm.selectedRange = newSelectedRange
                                            
                                            if vm.isFirst {
                                                vm.isFirst = false
                                                vm.shouldShowError = false
                                                print("i am first and am now calling for newStockChart2")
                                                await vm.getNewStockChartAsync()
                                                
                                            } else {
                                                print("why tho!?")
                                            }
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.0001) {
                                                withAnimation {
                                                    vm.isMakingLine = false
                                                    vm.isShowingSnitt50 = false
                                                    vm.isShowingSnitt200 = false
                                                    vm.isShowingSnittOptional = false
                                                    vm.isShowingRSI = false
                                                    vm.hasChosenAmount = false
                                                    vm.StockArraySnitt = []
                                                    
                                                }
                                            }
                                            
                                            
                                            
                                            
                                            
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.0001) {
                                                withAnimation {
                                                    vm.hasShownSnitt50 = false
                                                    vm.hasShownSnitt200 = false
                                                    vm.hasShownSnittOptional = false
                                                    vm.hasShownRSI = false
                                                    vm.hasChosenAmount = false
                                                }
                                            }
                                            
                                            
                                            print("Selected Range in SlideView Changed: \(newSelectedRange.rawValue)")
                                        }
                                        .opacity(vm.selectedXOpacity)
                                        
                                        Text(vm.selectedXDateText)
                                            .font(.headline)
                                            .padding(.horizontal)
                                            .padding(.vertical, 4)
                                            .padding(.top, -20)
                                        
                                        
                                    }
                                    if vm.isLoadingOther {
                                        VStack(alignment: .trailing) {
                                            Spacer()
                                            ProgressView()
                                                .progressViewStyle(CircularProgressViewStyle())
                                                .scaleEffect(2)
                                            
                                            Spacer()
                                        }
                                        .frame(width: geomtery.size.width - 30, height: 300)
                                    } else {
                                        ChartView
                                        
                                        
                                        if vm.isShowingRSI {
                                            RSIChartView(vm: vm)
                                        }
                                    }
                                    
                                    
                                    
                                    Divider()
                                    
                                }
                                .padding(.top, 5)
                                .listRowSeparator(.hidden)
                                
                                

                                
                                
                                
                                VStack(alignment: .leading) {
                                    
                                    ScrollView(.horizontal) {
                                        HStack {
                                            VStack(alignment: .leading) {
                                                
                                                HStack {
                                                    Text("Åpning:")
                                                        .font(.title3)
                                                        .textSelection(.enabled)
                                                    Spacer(minLength: 50)
                                                    TextAnimations3(number: vm.firstClose)
                                                        .foregroundStyle(LinearGradient(colors: [.teal, .indigo], startPoint: .topLeading, endPoint: .bottomTrailing))
                                                        .font(.title2)
                                                        .textSelection(.enabled)
                                                    
                                                    
                                                }
                                                .padding(EdgeInsets(top: 10, leading: 4, bottom: 10, trailing: 4))
                                                
                                                HStack {
                                                    Text("Stenging:")
                                                        .font(.title3)
                                                        .textSelection(.enabled)
                                                    Spacer(minLength: 50)
                                                    TextAnimations3(number: vm.lastClose)
                                                        .foregroundStyle(LinearGradient(colors: [.teal, .indigo], startPoint: .topLeading, endPoint: .bottomTrailing))
                                                        .font(.title2)
                                                        .textSelection(.enabled)
                                                }
                                                .padding(EdgeInsets(top: 10, leading: 4, bottom: 10, trailing: 4))
                                                
                                            }
                                            .onAppear {
                                                vm.updateCloseNumbers()
                                                
                                            }
                                            .onChange(of: vm.isRefreshing) {
                                                vm.updateCloseNumbers()
                                                
                                            }
                                            
                                            .onChange(of: vm.isLoadingOther) {
//                                                if !vm.isLoadingOther {
                                                    vm.updateCloseNumbers()
//                                                }
                                                
                                                
                                            }
                                            
                                            
                                            
                                            
                                            Divider()
                                            
                                            VStack(alignment: .leading) {
                                                HStack {
                                                    Text("Høyest:")
                                                        .font(.title3)
                                                        .textSelection(.enabled)
                                                    Spacer(minLength: 50)
                                                    Text(String(format: "%.2f", vm.maxValue).replacingOccurrences(of: ".", with: ","))
                                                        .foregroundStyle(LinearGradient(colors: [.teal, .indigo], startPoint: .topLeading, endPoint: .bottomTrailing))
                                                        .font(.title2)
                                                        .textSelection(.enabled)
                                                }
                                                .padding(EdgeInsets(top: 10, leading: 4, bottom: 10, trailing: 4))
                                                
                                                HStack {
                                                    Text("Lavest:")
                                                        .font(.title3)
                                                        .textSelection(.enabled)
                                                    Spacer(minLength: 50)
                                                    Text(String(format: "%.2f", vm.minValue).replacingOccurrences(of: ".", with: ","))
                                                        .foregroundStyle(LinearGradient(colors: [.teal, .indigo], startPoint: .topLeading, endPoint: .bottomTrailing))
                                                        .font(.title2)
                                                        .textSelection(.enabled)
                                                }
                                                .padding(EdgeInsets(top: 10, leading: 4, bottom: 10, trailing: 4))
                                                
                                                
                                            }
                                            
                                            
                                            Divider()
                                            
                                            VStack(alignment: .leading) {
                                                let combinedVolume = vm.StockArray.map(\.volume).reduce(0, +)
                                                let formattedVolume = vm.formatLargeNumber(combinedVolume)
                                                HStack {
                                                    Text("Volum:")
                                                        .font(.title3)
                                                        .textSelection(.enabled)
                                                    Spacer(minLength: 50)
                                                    Text("\(formattedVolume)")
                                                        .foregroundStyle(LinearGradient(colors: [.teal, .indigo], startPoint: .topLeading, endPoint: .bottomTrailing))
                                                        .font(.title2)
                                                        .textSelection(.enabled)
                                                }
                                                .padding(EdgeInsets(top: 10, leading: 4, bottom: 10, trailing: 4))
                                                
                                                HStack {
                                                    Text("Tidssone:")
                                                        .font(.title3)
                                                        .textSelection(.enabled)
                                                    Spacer(minLength: 50)
                                                    Text("\(vm.recivedStock.chart.result[0].meta.timezone)")
                                                        .foregroundStyle(LinearGradient(colors: [.teal, .indigo], startPoint: .topLeading, endPoint: .bottomTrailing))
                                                        .font(.title2)
                                                        .textSelection(.enabled)
                                                }
                                                .padding(EdgeInsets(top: 10, leading: 4, bottom: 10, trailing: 4))
                                                
                                            }
                                            
                                            Divider()
                                            
                                            VStack(alignment: .leading) {
                                                
                                                HStack {
                                                    Text("Børs:")
                                                        .font(.title3)
                                                        .textSelection(.enabled)
                                                    Spacer(minLength: 50)
                                                    Text("\(vm.recivedStock.chart.result[0].meta.exchangeName)")
                                                        .foregroundStyle(LinearGradient(colors: [.teal, .indigo], startPoint: .topLeading, endPoint: .bottomTrailing))
                                                        .font(.title2)
                                                        .textSelection(.enabled)
                                                }
                                                .padding(EdgeInsets(top: 10, leading: 4, bottom: 10, trailing: 4))
                                                
                                                HStack {
                                                    Text("Børs Sted:")
                                                        .font(.title3)
                                                        .textSelection(.enabled)
                                                    Spacer(minLength: 50)
                                                    Text("\(vm.recivedStock.chart.result[0].meta.exchangeTimezoneName)")
                                                        .foregroundStyle(LinearGradient(colors: [.teal, .indigo], startPoint: .topLeading, endPoint: .bottomTrailing))
                                                        .font(.title2)
                                                        .textSelection(.enabled)
                                                }
                                                .padding(EdgeInsets(top: 10, leading: 4, bottom: 10, trailing: 4))
                                                
                                            }
                                            
                                        }
                                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 3, trailing: 0))
                                    }
                                    .frame(height: 100)
                                    .scrollIndicators(.hidden)
                                    
                                    
                                    
                                }
                                
                                if vm.StockNews.isEmpty {
                                    Divider()
                                        .listRowSeparator(.hidden)
                                        .padding(.top, -20)
                                }
                                
                                
                                if !vm.StockNews.isEmpty {
                                    ForEach(vm.StockNews, id: \.self) { news in
                                        if let url = URL(string: news.link), let index = vm.StockNews.firstIndex(of: news) {
                                            VStack(alignment: .leading) {
                                                Text("\(news.title)")
                                                    .font(.title2)
                                                    .fontWeight(.semibold)
                                                    .padding(EdgeInsets(top: 0, leading: 5, bottom: 5, trailing: 5))
                                                    .lineLimit(3)
                                                
                                                Text("\(news.description)")
                                                    .font(.callout)
                                                    .padding(5)
                                                    .lineLimit(2)
                                                    .fixedSize(horizontal: false, vertical: true)
//                                                    .foregroundStyle(Color("ColorGray"))
                                                
                                                Text("\(vm.formattedTimeAgo(from: news.pubDate))")
                                                    .padding(EdgeInsets(top: 5, leading: 5, bottom: 0, trailing: 5))
                                                    .font(.subheadline)
                                                    .foregroundStyle(LinearGradient(colors: [.teal, .indigo], startPoint: .topLeading, endPoint: .bottomTrailing))
//                                                    .foregroundStyle(Color.gray)
                                            }
                                            .fixedSize(horizontal: false, vertical: true)
                                            .onTapGesture {
                                                vm.isShowingNewsArray[index] = true
                                            }
                                            
                                            .fullScreenCover(isPresented: $vm.isShowingNewsArray[index]) {
                                                SafariWebView(url: url)
                                                    .ignoresSafeArea()
                                            }
                                            
                                            
                                            .contextMenu {
                                                Button(action: {
                                                    UIPasteboard.general.string = news.link
                                                }) {
                                                    Text("Kopier lenke")
                                                    Image(systemName: "link")
                                                }
                                                
                                            } preview: {
                                                SafariWebView(url: url)
                                                    
                                            }
                                            
                                            
                                        } else {
                                            VStack(alignment: .leading) {
                                                Text("\(news.title)")
                                                    .font(.title2)
                                                    .fontWeight(.semibold)
                                                    .padding(5)
                                                    .lineLimit(3)
                                                    .foregroundStyle(LinearGradient(colors: [.teal, .indigo], startPoint: .topLeading, endPoint: .bottomTrailing))
                                                
                                                Text("\(news.description)")
                                                    .font(.callout)
                                                    .padding(5)
                                                    .lineLimit(2)
                                                    .fixedSize(horizontal: false, vertical: true)
//                                                    .foregroundStyle(Color("ColorGray"))
                                                
                                                Text("\(news.pubDate)")
                                                    .padding(5)
                                                    .font(.subheadline)
                                                    .foregroundStyle(LinearGradient(colors: [.teal, .indigo], startPoint: .topLeading, endPoint: .bottomTrailing))
//                                                    .foregroundStyle(Color.gray)
                                            }
                                            .fixedSize(horizontal: false, vertical: true)
                                        }
                                        
                                    }
                                } else {
                                    HStack {
                                        Spacer()
                                        Text("Ingen nylige nyheter")
                                            .font(.title2.bold())
                                        
                                        Spacer()
                                    }
                                    .padding(.top, -15)
                                    .padding(.bottom, 30)
                                    .listRowSeparator(.hidden)
                                }
                                
                                
                            }
                            .listStyle(.plain)
                            .padding(EdgeInsets(top: -5, leading: 0, bottom: 0, trailing: -15))
                            .scrollIndicators(.hidden)
                            .refreshable {
                                vm.isRefreshing = true
                                vm.isMakingLine = false
                                vm.isShowingRSI = false
                                vm.isLine3Selected = false
                                vm.isLine1Selected = false
                                vm.isLine2Selected = false
                                vm.isShowingSnittOptional = false
                                vm.isShowingSnitt50 = false
                                vm.isShowingSnitt200 = false
                                vm.hasShownSnittOptional = false
                                vm.hasShownSnitt50 = false
                                vm.hasShownSnitt200 = false
                                vm.hasChosenAmount = false
                                vm.getStockNews()
                                await vm.getNewStockChartAsync()
                                
                                
                                
                            }

                            
                        } else {
                            
                            ContentUnavailableView(label: {
                                VStack(spacing: 20) {
                                    Image(systemName: "exclamationmark.magnifyingglass")
                                        .resizable()
                                        .frame(width: 100, height: 100)
                                    
                                    Text("Det skjedde en feil!")
                                        .bold()
                                }
                            }, description: {
                                VStack {
                                    Text("Send denne feilmeldingen til utvikleren:")
                                    
                                    Text("\(vm.errorMessage)")
                                        .contextMenu {
                                            Button(action: {
                                                UIPasteboard.general.string = vm.errorMessage
                                            }) {
                                                Text("Kopier")
                                                Image(systemName: "doc.on.doc")
                                            }
                                        }
                                }
                                
                                
                            }, actions: {
                                Button("Prøv på nytt") {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                        withAnimation {
                                            vm.isLoadingFirst = true
                                        }
                                    }
                                    Task {
                                        await vm.getNewStockChartAsync()
                                    }
                                    
                                }
                                .buttonStyle(.borderedProminent)
                            })
                        }
                            
                    }
                        
                    
                }
                .overlay(alignment: .center) {
                    if vm.isShowingOverlay {
                        let _ = print("isShowingOverlay: \(vm.isShowingOverlay)")
                        withAnimation {
                            if UIDevice.current.userInterfaceIdiom == .phone {
                                detailView
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .edgesIgnoringSafeArea(.all)
                                    .transition(.move(edge: .trailing))
                                    .zIndex(1)
                                    .padding(.bottom, 40)
                                    .padding(.top, 62)
                                    .padding([.leading, .trailing], 30)
                                
                                    .onTapBackground(enabled: vm.isShowingOverlay) {
                                        withAnimation {
                                            vm.isShowingOverlay = false
                                            let _ = print("isShowingOverlay: \(vm.isShowingOverlay)")
                                        }
                                        
                                    }
                            } else {
                                detailView
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .edgesIgnoringSafeArea(.all)
                                    .transition(.move(edge: .trailing))
                                    .zIndex(1)
                                    .padding(.bottom, 140)
                                    .padding(.top, 162)
                                    .padding([.leading, .trailing], 100)
                                
                                    .onTapBackground(enabled: vm.isShowingOverlay) {
                                        withAnimation {
                                            vm.isShowingOverlay = false
                                            let _ = print("isShowingOverlay: \(vm.isShowingOverlay)")
                                        }
                                        
                                    }
                            }
                            
                        }
                        
                    }
                    
                    if vm.isShowingOptionalView {
                        let _ = print("isShowingOptionalView: \(vm.isShowingOptionalView)")
                        withAnimation {
                            if UIDevice.current.userInterfaceIdiom == .phone {
                                optionalView
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .edgesIgnoringSafeArea(.all)
                                    .transition(.move(edge: .trailing))
                                    .zIndex(1)
                                    .padding(.bottom, 140)
                                    .padding(.top, 142)
                                    .padding([.leading, .trailing], 30)
                                
                                    .onTapBackground(enabled: vm.isShowingOptionalView) {
                                        withAnimation {
                                            vm.isShowingOptionalView = false
                                            let _ = print("isShowingOverlay: \(vm.isShowingOptionalView)")
                                        }
                                        
                                    }
                            } else {
                                optionalView
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .edgesIgnoringSafeArea(.all)
                                    .transition(.move(edge: .trailing))
                                    .zIndex(1)
                                    .padding(.bottom, 150)
                                    .padding(.top, 102)
                                    .padding([.leading, .trailing], 100)
                                
                                    .onTapBackground(enabled: vm.isShowingOptionalView) {
                                        withAnimation {
                                            vm.isShowingOptionalView = false
                                            let _ = print("isShowingOverlay: \(vm.isShowingOptionalView)")
                                        }
                                        
                                    }
                            }
                            
                        }
                        
                    }
                    
                }
                
            }
            .onAppear {
                if !vm.isViewLoaded {
                    vm.selectedRange = defaultRange
                    vm.isViewLoaded = true
                    
                }
                
            }
            
            .task {
                if !vm.isViewLoaded2 {
                    await vm.getNewStockChartAsync()
                    vm.isViewLoaded2 = true
                    
                }
            }
            
            .task {
                if !vm.isViewLoaded3 {
                    vm.getStockNews()
                    vm.isViewLoaded3 = true
                    print("Ferdig hentet nyheter!")
                    
                }
            }
            
            
            
            .onChange(of: vm.isMakingLine) {
                vm.selectedXLine1 = nil
                vm.selectedXLine2 = nil
                vm.selectedXLine3 = nil
                vm.isLine1Selected = false
                vm.isLine2Selected = false
                vm.isLine3Selected = false
                
            }
            
            .onChange(of: vm.isShowingSnitt50) {
                if vm.isShowingSnitt50 && vm.isShowingSnitt200 || vm.isShowingSnittOptional && vm.isShowingSnitt50 {
                    vm.isShowingSnitt200 = false
                    vm.isShowingSnittOptional = false
                    vm.hasChosenAmount = false
                    vm.hasShownSnitt50 = false
                }
                if !vm.isShowingSnitt200 && !vm.isShowingSnitt50 && !vm.isShowingSnittOptional {
                    vm.fixTestChart()
                    vm.hasChosenAmount = false
                    vm.hasShownSnittOptional = false
                }
                if !vm.hasShownSnitt50 {
                    vm.getNewStockSnitt(days: 50)
                    print("henter nytt snitt")
                    vm.hasShownSnitt50 = true
                    
                } else {
                    vm.hasShownSnitt50 = false
                }
            }
            
            .onChange(of: vm.isShowingSnitt200) {
                if vm.isShowingSnitt200 && vm.isShowingSnitt50 || vm.isShowingSnittOptional && vm.isShowingSnitt200 {
                    vm.isShowingSnitt50 = false
                    vm.isShowingSnittOptional = false
                    vm.hasChosenAmount = false
                    vm.hasShownSnitt200 = false
                    print("i am now false")
                }
                
                if !vm.isShowingSnitt200 && !vm.isShowingSnitt50 && !vm.isShowingSnittOptional {
                    vm.fixTestChart()
                    vm.hasChosenAmount = false
                    vm.hasShownSnittOptional = false
                }
                
                if !vm.hasShownSnitt200 {
                    vm.getNewStockSnitt(days: 200)
                    print("henter nytt snitt")
                    vm.hasShownSnitt200 = true
                    
                } else {
                    vm.hasShownSnitt200 = false
                }
            }
            
            .onChange(of: vm.isShowingSnittOptional) {
                if vm.isShowingSnittOptional {
                    withAnimation {
                        vm.isShowingOptionalView.toggle()
                        print("isShowingOptionalView: \(vm.isShowingOptionalView)")
                    }
                }
                
                if !vm.isShowingSnitt200 && !vm.isShowingSnitt50 && !vm.isShowingSnittOptional {
                    vm.fixTestChart()
                    vm.hasChosenAmount = false
                    vm.hasShownSnittOptional = false
                }
                
            }
            
            .onChange(of: vm.hasChosenAmount) {
                if vm.hasChosenAmount {
                    if vm.isShowingSnittOptional && vm.isShowingSnitt50 || vm.isShowingSnittOptional && vm.isShowingSnitt200 {
                        vm.isShowingSnitt50 = false
                        vm.isShowingSnitt200 = false
                        vm.hasShownSnittOptional = false
                    }
                    
                    if !vm.isShowingSnitt200 && !vm.isShowingSnitt50 && !vm.isShowingSnittOptional {
                        vm.fixTestChart()
                        vm.hasShownSnittOptional = false
                    }
                    if !vm.hasShownSnittOptional {
                        vm.getNewStockSnitt(days: vm.chosenAmount)
                        print("henter nytt snitt")
                        vm.hasShownSnittOptional = true
                        
                    } else {
                        vm.hasShownSnittOptional = false
                    }
                }
                
            }
            
            .onChange(of: vm.isShowingRSI) {
                if !vm.hasShownRSI {
                    vm.getNewStockRSI()
                    print("henter ny RSI")
                    vm.hasShownRSI = true
                    
                } else {
                    vm.hasShownRSI = false
                }
            }
            
            .onChange(of: vm.isLine3Selected) {
                vm.fixViewForLines()
            }
            
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        withAnimation {
                            vm.isShowingOverlay.toggle()
                            let _ = print("isShowingOverlay: \(vm.isShowingOverlay)")
                        }
                    }, label: {
                        Image(systemName: "info.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 35, height: 35)
                            .foregroundStyle(LinearGradient(colors: [.teal, .indigo], startPoint: .topLeading, endPoint: .bottomTrailing))
                        
                        
                        
                        
                    })
                    .padding(15)
                    
                    
                }
            }
            
            
            
        }
        .padding(EdgeInsets(top: -50, leading: 0, bottom: 0, trailing: 0))
        
    }
    
    
    
    var detailView: some View {
        
        VStack {
            HStack {
                Text("Info om Perioder")
                    .font(.title)
                    .bold()
                
                Spacer()
                
                Button(action: {
                    withAnimation {
                        vm.isShowingOverlay.toggle()
                    }
                }, label: {
                    Image(systemName: "xmark.circle.fill")
                        //                        .resizable()
                        .font(.largeTitle)
                        .imageScale(.large)
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.white, Color("ColorGray"))
                        //                        .foregroundColor(.gray)
                        //                        .background(
                        //                            Circle()
                        //                                .fill(.white)
                        //                        )
                })
                
                
                
                .shadow(radius: 5)
            }
            
            Spacer()
            
            GeometryReader { geometry in
                SlideViewInfo(selectedRange: vm.selectedRange, geometry: geometry)
                    .frame(width: geometry.size.width, height: geometry.size.height)
            }
            
            
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThickMaterial)
        )
        .shadow(radius: 50)
        
        
    }
    
    
    var optionalView: some View {
        VStack {
            HStack {
                Text("Velg mengde dager")
                    .font(.title)
                    .bold()
                
                Spacer()
                
                Button(action: {
                    withAnimation {
                        vm.isShowingOptionalView.toggle()
                        vm.isShowingSnittOptional = false
                        vm.hasChosenAmount = false
                    }
                }, label: {
                    Image(systemName: "xmark.circle.fill")
                    //                        .resizable()
                        .font(.largeTitle)
                        .imageScale(.large)
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.white, Color("ColorGray"))
                    //                        .foregroundColor(.gray)
                    //                        .background(
                    //                            Circle()
                    //                                .fill(.white)
                    //                        )
                })
                //                .padding()
                
                
                
                .shadow(radius: 5)
            }
            
            Spacer()
            
            GeometryReader { geometry in
                
                
                
                VStack(alignment: .center) {
                    Spacer()
                    
                    Picker("Velg et tall", selection: $vm.chosenAmount) {
                        ForEach(vm.numbersArray, id: \.self) { number in
                            Text("\(number) Dager")
                            
                        }
                    }
                    .pickerStyle(.wheel)
                    
                    Spacer()
                    
                    Button("Bekreft", action: {
                        withAnimation {
                            vm.isShowingOptionalView.toggle()
                            vm.hasChosenAmount = true
                        }
                    })
                    .buttonStyle(.borderedProminent)
                    .font(.title2)
                    .buttonBorderShape(.roundedRectangle(radius: 10))
                    .shadow(radius: 5)
                    .padding(.bottom, 40)
                }
                .onAppear() {
                    vm.fixNumbersArray()
                }
                
                
                
                
                
            }
            
            
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThickMaterial)
        )
        .shadow(radius: 50)
        
        
    }
    
    var ChartView: some View {
        Chart {
            ForEach(Array(zip(vm.testChart.items.indices, vm.testChart.items)), id: \.0) { index, item in
                if item.value != 0 {
                    if selectedInterpolationMethod == .cardinal {
                        LineMark(x: .value("Dato", index), y: .value("Verdi", item.value), series: .value("1", "1"))
                            .foregroundStyle(vm.foregroundMarkColor)
                            .interpolationMethod(.cardinal)
                        
                        
                        AreaMark(x: .value("Dato", index), y: .value("Verdi", item.value), series: .value("1", "1"))
                            .alignsMarkStylesWithPlotArea()
                            .foregroundStyle(LinearGradient(gradient: Gradient(colors: [vm.foregroundMarkColor.opacity(0.6), .clear]),
                                                            startPoint: .top,
                                                            endPoint: .bottom))
                            .interpolationMethod(.cardinal)
                        
                    } else if selectedInterpolationMethod == .linear {
                        LineMark(x: .value("Dato", index), y: .value("Verdi", item.value), series: .value("1", "1"))
                            .foregroundStyle(vm.foregroundMarkColor)
                            .interpolationMethod(.linear)
                            .mask { RectangleMark() }
                        
                        
                        
                        
                        AreaMark(x: .value("Dato", index), y: .value("Verdi", item.value), series: .value("1", "1"))
                            .alignsMarkStylesWithPlotArea()
                            .foregroundStyle(LinearGradient(gradient: Gradient(colors: [vm.foregroundMarkColor.opacity(0.6), .clear]),
                                                            startPoint: .top,
                                                            endPoint: .bottom))
                            .interpolationMethod(.linear)
                            .mask { RectangleMark() }
                        
                    }
                    
                }
                
                
                
                
                
            }
            if vm.isShowingSnitt50 || vm.isShowingSnitt200 || vm.isShowingSnittOptional {
                ForEach(vm.newSnittChartTupleArray, id: \.0) { index, item in
                    if item.value != 0 {
                        if selectedInterpolationMethod == .cardinal {
                            LineMark(x: .value("Dato", index), y: .value("Verdi", item.value), series: .value("10", "10"))
                                .foregroundStyle(vm.foregroundMarkColor)
                                .interpolationMethod(.cardinal)
                            
                            
                        } else if selectedInterpolationMethod == .linear {
                            
                            LineMark(x: .value("Dato", index), y: .value("Verdi", item.value), series: .value("10", "10"))
                                .foregroundStyle(vm.foregroundMarkColor)
                                .interpolationMethod(.linear)
                                .mask { RectangleMark() }
                            
                            
                        }
                        
                    }
                    
                    
                    
                }
            }
            
            
            if vm.selectedRange == .oneDay {
                if let last = vm.recivedStock.chart.result.first?.meta.chartPreviousClose {
                    RuleMark(y: .value("Forrige", last))
                        .foregroundStyle(.gray)
                        .lineStyle(StrokeStyle(lineWidth: 1, dash: [2]))
                        .mask { RectangleMark() }
                    
                } else if let firstClose = vm.StockArray.first?.close {
                    
                    RuleMark(y: .value("Forrige", firstClose))
                        .foregroundStyle(.gray)
                        .lineStyle(StrokeStyle(lineWidth: 1, dash: [2]))
                        .mask { RectangleMark() }
                    
                } else {
                    let _ = print("wtf: \(vm.StockArray)")
                    let _ = print("wtf2: \(vm.StockArray2)")
                }
                
            }
            
            
            
            if let (selectedX, text) = vm.selectedLineMark1, let (selectedX2, text2) = vm.selectedLineMark2, let number = Float(text), let number2 = Float(text2) {
                let xChange = selectedX2 - selectedX
                let yChange = number2 - number
                let stigning = vm.stigning(yChange: yChange, xChange: Float(xChange))
                let _ = print("selectedX: \(selectedX)")
                let _ = print("selectedX2: \(selectedX2)")
                let _ = print("Stigning: \(stigning)")
                
                let maxY: Float = vm.maxValue
                
                
                let yValue = vm.fy(x: 0, x1: Float(selectedX), y1: number, stigning: stigning)
                let xValue = vm.fx(y: maxY, x1: Float(selectedX), y1: number, stigning: stigning)
                let _ = print("yValueFirst: \(yValue)")
                let _ = print("xValueFirst: \(xValue)")
                
                let yValue2 = vm.fy(x: Float(10000), x1: Float(selectedX), y1: number, stigning: stigning)
                let xValue2 = vm.fx(y: Float(yValue2), x1: Float(selectedX), y1: number, stigning: stigning)
                
                LineMark(x: .value("Dato", 0), y: .value("Verdi", yValue), series: .value("2", "2"))
                    .foregroundStyle(vm.foregroundMarkColor)
                    .interpolationMethod(.cardinal)
                    .mask { RectangleMark() }
                
                LineMark(x: .value("Dato", selectedX), y: .value("Verdi", number), series: .value("2", "2"))
                    .foregroundStyle(vm.foregroundMarkColor)
                    .interpolationMethod(.cardinal)
                
                
                LineMark(x: .value("Dato", selectedX2), y: .value("Verdi", number2), series: .value("2", "2"))
                    .foregroundStyle(vm.foregroundMarkColor)
                    .interpolationMethod(.cardinal)
                
                
                
                
                if xValue.isInfinite {
                    LineMark(x: .value("Dato", 10000), y: .value("Verdi", number2), series: .value("2", "2"))
                        .foregroundStyle(vm.foregroundMarkColor)
                        .interpolationMethod(.cardinal)
                } else {
                    LineMark(x: .value("Dato", xValue2), y: .value("Verdi", yValue2), series: .value("2", "2"))
                        .foregroundStyle(vm.foregroundMarkColor)
                        .interpolationMethod(.cardinal)
                    let _ = print("yValue2: \(yValue2)")
                }
                
                
                
                
                
                
                
                
                
                PointMark(x: .value("Valgt tidspunkt", selectedX), y: .value("Valgt tidspunkt", number))
                    .symbolSize(100)
                    .shadow(color: .black, radius: 4)
                    .foregroundStyle(.cyan)
                
                PointMark(x: .value("Valgt tidspunkt", selectedX2), y: .value("Valgt tidspunkt", number2))
                    .symbolSize(100)
                    .shadow(color: .black, radius: 4)
                    .foregroundStyle(.cyan)
                
                
                
            } else if let (selectedX, text) = vm.selectedLineMark1, let number = Float(text) {
                PointMark(x: .value("Valgt tidspunkt", selectedX), y: .value("Valgt tidspunkt", number))
                    .symbolSize(100)
                    .shadow(color: .black, radius: 4)
                    .foregroundStyle(.cyan)
            }
            
            if let (selectedX, text) = vm.selectedLineMark1, let (selectedX2, text2) = vm.selectedLineMark2, let number = Float(text), let number2 = Float(text2), let (selectedX3, text3) = vm.selectedLineMark3, let number3 = Float(text3) {
                let xChange = selectedX2 - selectedX
                let yChange = number2 - number
                let stigning = vm.stigning(yChange: yChange, xChange: Float(xChange))
                let maxY: Float = vm.maxValue
                
                
                let yValue = vm.fy(x: 0, x1: Float(selectedX3), y1: number3, stigning: stigning)
                let xValue = vm.fx(y: maxY, x1: Float(selectedX3), y1: number3, stigning: stigning)
                
                let yValue2 = vm.fy(x: Float(10000), x1: Float(selectedX3), y1: number3, stigning: stigning)
                let xValue2 = vm.fx(y: Float(yValue2), x1: Float(selectedX3), y1: number3, stigning: stigning)
                
                
                
                LineMark(x: .value("Dato", 0), y: .value("Verdi", yValue), series: .value("3", "3"))
                    .foregroundStyle(vm.foregroundMarkColor)
                    .interpolationMethod(.cardinal)
                    .mask { RectangleMark() }
                
                LineMark(x: .value("Dato", selectedX3), y: .value("Verdi", number3), series: .value("3", "3"))
                    .foregroundStyle(vm.foregroundMarkColor)
                    .interpolationMethod(.cardinal)
                
                
                
                
                if xValue.isInfinite {
                    LineMark(x: .value("Dato", 10000), y: .value("Verdi", number2), series: .value("3", "3"))
                        .foregroundStyle(vm.foregroundMarkColor)
                        .interpolationMethod(.cardinal)
                } else {
                    LineMark(x: .value("Dato", xValue2), y: .value("Verdi", yValue2), series: .value("3", "3"))
                        .foregroundStyle(vm.foregroundMarkColor)
                        .interpolationMethod(.cardinal)
                }
                
                
                
                if xValue.isInfinite {
                    LineMark(x: .value("Dato", 10000), y: .value("Verdi", number2), series: .value("3", "3"))
                        .foregroundStyle(vm.foregroundMarkColor)
                        .interpolationMethod(.cardinal)
                } else {
                    LineMark(x: .value("Dato", xValue2), y: .value("Verdi", yValue2), series: .value("3", "3"))
                        .foregroundStyle(vm.foregroundMarkColor)
                        .interpolationMethod(.cardinal)
                }
                
                
                
                
                PointMark(x: .value("Valgt tidspunkt", selectedX3), y: .value("Valgt tidspunkt", number3))
                    .symbolSize(100)
                    .shadow(color: .black, radius: 4)
                    .foregroundStyle(.cyan)
                
                
                
                
                
            } else if let (selectedX, text) = vm.selectedLineMark3, let number = Float(text) {
                PointMark(x: .value("Valgt tidspunkt", selectedX), y: .value("Valgt tidspunkt", number))
                    .symbolSize(100)
                    .shadow(color: .black, radius: 4)
                    .foregroundStyle(.cyan)
            }
            
            
            
            if let (selectedX, text) = vm.selectedXRuleMark {
                
                RuleMark(x: .value("Valgt tidspunkt", selectedX))
                    .lineStyle(.init(lineWidth: 1))
                    .foregroundStyle(.cyan)
                    .annotation(overflowResolution: .init(x: .fit(to: .chart))) {
                        
                        Text(text.replacingOccurrences(of: ".", with: ","))
                            .font(.headline)
                            .overlay(
                                LinearGradient(gradient: Gradient(colors: [.teal, .indigo]), startPoint: .topLeading, endPoint: .bottomTrailing)
                                    .mask(Text(text.replacingOccurrences(of: ".", with: ","))
                                        .font(.headline))
                            )
                    }
                
                
                if let number = Float(text) {
                    PointMark(x: .value("Valgt tidspunkt", selectedX), y: .value("Valgt tidspunkt", number))
                        .symbolSize(250)
                        .shadow(color: .black, radius: 4)
                    
                        .foregroundStyle(.cyan)
                    
                    RuleMark(y: .value("Valgt tidspunkt", number))
                        .lineStyle(.init(lineWidth: 1))
                    
                        .foregroundStyle(.cyan)
                }
                
                
            }
            
            if let (selectedX, selectedY) = vm.selectedXRuleMark2 {
                let text = String(selectedY.roundedString)
                RuleMark(x: .value("Valgt tidspunkt", selectedX))
                    .lineStyle(.init(lineWidth: 1))
                    .foregroundStyle(.cyan)
                    .annotation(overflowResolution: .init(x: .fit(to: .chart))) {
                        Text(text.replacingOccurrences(of: ".", with: ","))
                            .font(.headline)
                            .overlay(
                                LinearGradient(gradient: Gradient(colors: [.teal, .indigo]), startPoint: .topLeading, endPoint: .bottomTrailing)
                                    .mask(Text(text.replacingOccurrences(of: ".", with: ","))
                                        .font(.headline))
                            )
                    }
                
                
                PointMark(x: .value("Valgt tidspunkt", selectedX), y: .value("Valgt tidspunkt", selectedY))
                    .symbolSize(100)
                    .shadow(color: .black, radius: 4)
                    .foregroundStyle(.cyan)
                
                RuleMark(y: .value("Valgt tidspunkt", selectedY))
                    .lineStyle(.init(lineWidth: 1))
                    .foregroundStyle(.cyan)
                    .mask { RectangleMark() }
                
            }
            
        }
        .frame(minHeight: 300)
        .chartXAxis {
            if vm.isLine3Selected {
                vm.chartXAxis2
            } else {
                vm.chartXAxis
            }
        }
        .chartXScale(domain: vm.testChart.xAxisData.axisStart...vm.testChart.xAxisData.axisEnd)
        .chartYAxis { vm.chartYAxis }
        .chartYScale(domain: vm.testChart.yAxisData.axisStart...vm.testChart.yAxisData.axisEnd)
        .chartOverlay { proxy in
            GeometryReader { gProxy in
                Rectangle().fill(.clear).contentShape(Rectangle())
                    .delaysTouches(for: 0.01) {}
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged {
                                if !vm.isLine3Selected {
                                    if vm.isMakingLine {
                                        vm.onChangeDragLine(value: $0, chartProxy: proxy, geometryProxy: gProxy)
                                        
                                    }
                                    
                                    vm.onChangeDrag(value: $0, chartProxy: proxy, geometryProxy: gProxy)
                                    if vm.isShowingRSI && !vm.isMakingLine {
                                        vm.onChangeDragRSI(value: $0, chartProxy: proxy, geometryProxy: gProxy)
                                    }
                                    
                                } else {
                                    vm.onChangeDrag2(value: $0, chartProxy: proxy, geometryProxy: gProxy)
                                    if vm.isShowingRSI && !vm.isMakingLine {
                                        vm.onChangeDragRSI(value: $0, chartProxy: proxy, geometryProxy: gProxy)
                                    }
                                }
                                
                                
                                
                            }
                            .onEnded { _ in
                                if vm.isMakingLine {
                                    if !vm.isLine1Selected {
                                        vm.isLine1Selected = true
                                    } else if !vm.isLine2Selected {
                                        vm.isLine2Selected = true
                                    } else if !vm.isLine3Selected {
                                        vm.isLine3Selected = true
                                    }
                                }
                                vm.selectedXRSI = nil
                                vm.selectedX = nil
                                vm.selectedXY = nil
                                
                                
                            }
                    )
                
                
            }
        }
        .animation(nil, value: UUID())
    }
    
    
}




extension View {
    @ViewBuilder
    private func onTapBackgroundContent(enabled: Bool, _ action: @escaping () -> Void) -> some View {
        if enabled {
            Color.clear
                .frame(width: UIScreen.main.bounds.width * 2, height: UIScreen.main.bounds.height * 2)
                .contentShape(Rectangle())
                .onTapGesture(perform: action)
        }
    }
    
    func onTapBackground(enabled: Bool, _ action: @escaping () -> Void) -> some View {
        background(
            onTapBackgroundContent(enabled: enabled, action)
        )
    }
}

extension View {
    func delaysTouches(for duration: TimeInterval = 0.25, onTap action: @escaping () -> Void = {}) -> some View {
        modifier(DelaysTouches(duration: duration, action: action))
    }
}

fileprivate struct DelaysTouches: ViewModifier {
    @State private var disabled = false
    @State private var touchDownDate: Date? = nil
    
    var duration: TimeInterval
    var action: () -> Void
    
    func body(content: Content) -> some View {
        Button(action: action) {
            content
        }
        .buttonStyle(DelaysTouchesButtonStyle(disabled: $disabled, duration: duration, touchDownDate: $touchDownDate))
        .disabled(disabled)
    }
}

fileprivate struct DelaysTouchesButtonStyle: ButtonStyle {
    @Binding var disabled: Bool
    var duration: TimeInterval
    @Binding var touchDownDate: Date?
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .onChange(of: configuration.isPressed) {
                handleIsPressed(isPressed: configuration.isPressed)
            }
    }
    
    private func handleIsPressed(isPressed: Bool) {
        if isPressed {
            let date = Date()
            touchDownDate = date
            
            DispatchQueue.main.asyncAfter(deadline: .now() + max(duration, 0)) {
                if date == touchDownDate {
                    disabled = true
                    
                    DispatchQueue.main.async {
                        disabled = false
                    }
                }
            }
        } else {
            touchDownDate = nil
            disabled = false
        }
    }
}


struct FollowedStockView_Previews: PreviewProvider {
    static var previews: some View {
        let stock = Aksjer.SearchResults(symbol: "MPCC.OL", name: "MPC Container Ships ASA", exch: "OSL", type: "S", exchDisp: "Oslo", typeDisp: "Equity", isFollowed: true)
        @StateObject var viewModel = ViewModel(stock: Aksjer.SearchResults(symbol: "\(stock.symbol)", name: "\(stock.name)", exch: "\(stock.exch)", type: "\(stock.type)", exchDisp: "\(stock.exchDisp)", typeDisp: "\(stock.typeDisp)", isFollowed: stock.isFollowed), recivedStock: Aksjer.Stock(chart: Aksjer.ChartResult(result: [StockResult(meta: Meta(currency: "", symbol: "", exchangeName: "", fullExchangeName: "", instrumentType: "", regularMarketTime: 0, hasPrePostMarketData: false, gmtoffset: 0, timezone: "", exchangeTimezoneName: "", regularMarketPrice: 0, fiftyTwoWeekHigh: 0, fiftyTwoWeekLow: 0, regularMarketDayHigh: 0, regularMarketDayLow: 0, regularMarketVolume: 0, chartPreviousClose: 0, priceHint: 0, currentTradingPeriod: CurrentTradingPeriod(pre: TradingPeriod(timezone: "", start: 0, end: 0, gmtoffset: 0), regular: TradingPeriod(timezone: "", start: 0, end: 0, gmtoffset: 0), post: TradingPeriod(timezone: "", start: 0, end: 0, gmtoffset: 0)), dataGranularity: "", range: "", validRanges: [""], tradingPeriods: [[TradingPeriod(timezone: "", start: 0, end: 0, gmtoffset: 0)]]), timestamp: [1], indicators: Indicators(quote: [Quote(close: [0], low: [0], volume: [0], open: [0], high: [0])]))], error: "")), testChart: ChartViewData(xAxisData: ChartAxisData(axisStart: 0, axisEnd: 100, strideBy: 5, map: ["": ""]), yAxisData: ChartAxisData(axisStart: 0, axisEnd: 100, strideBy: 1, map: ["": ""]), items: [ChartViewItem(timestamp: Date(), value: 100)]), snittChart: ChartViewData(xAxisData: ChartAxisData(axisStart: 0, axisEnd: 100, strideBy: 5, map: ["": ""]), yAxisData: ChartAxisData(axisStart: 0, axisEnd: 100, strideBy: 1, map: ["": ""]), items: [ChartViewItem(timestamp: Date(), value: 100)]), rsiChart: ChartViewData(xAxisData: ChartAxisData(axisStart: 0, axisEnd: 100, strideBy: 5, map: ["": ""]), yAxisData: ChartAxisData(axisStart: 0, axisEnd: 100, strideBy: 1, map: ["": ""]), items: [ChartViewItem(timestamp: Date(), value: 100)]))
        FollowedStockView(vm: viewModel)
    }
    
}


