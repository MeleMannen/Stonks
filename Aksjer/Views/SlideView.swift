    //
    //  SlideView.swift
    //  Aksjer
    //
    //  Created by Kristoffer Melen on 06/01/2024.
    //

import SwiftUI


struct SlideView: View {
//    @AppStorage("monthRange") private var monthRange: ViewOptionMonth = .oneMonth3
    @AppStorage("selectedRanges") private var storedSelectedRanges: Data?
    
    @State var selectedRange: RangeType
    @State var isFirst = true
    var onSelectedRangeChange: ((RangeType) async -> Void)?
    
    @State var defaultSelectedRanges: [RangeType] = [.oneDay, .oneWeek, .oneMonth3, .threeMonths, .sixMonths, .nineMonths, .ytd, .oneYear, .twoYears, .threeYears, .fiveYears, .tenYears, .max]
    @State var selectedRanges: [RangeType] = []
    
    var body: some View {
        ScrollViewReader { scrollViewProxy in
            ScrollView(.horizontal) {
                LazyHStack(spacing: 16) {
                    ForEach(selectedRanges, id: \.self) { dateRange in
                        Button {
                            if UIDevice.current.userInterfaceIdiom == .phone {
                                withAnimation {
                                    scrollViewProxy.scrollTo(dateRange, anchor: .center)
                                    
                                }
                            }
                            
                            selectedRange = dateRange
                        } label: {
                            if selectedRanges.contains(dateRange) {
                                Text("\(dateRange.length) (\(dateRange.realInterval))")
                                    .font(.callout.bold())
                                    .padding(8)
                            }
                            
                        }
                        .buttonStyle(.plain)
                        .contentShape(Rectangle())
                        .background {
                            if dateRange == selectedRange {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.gray.opacity(0.4))
                            } else {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.clear)
                            }
                        }
                        .id(dateRange)
                        .onAppear {
                            if isFirst {
                                scrollViewProxy.scrollTo(selectedRange, anchor: .center)
                                isFirst = false
                            }
                        }
                        .onChange(of: storedSelectedRanges) {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                withAnimation {
                                    scrollViewProxy.scrollTo(selectedRange, anchor: .center)
                                    print("Jeg scroller")
                                }
                            }
                        }
                        
                    }
                    
                    
                    
                }
                .padding(.horizontal)
                
                .onChange(of: selectedRange) { oldValue, newSelectedRange in
                    Task {
                        await onSelectedRangeChange?(newSelectedRange)
                    }
                }
                
                
            }
            .scrollIndicators(.hidden)
        }
        .onAppear {
            checkStorage()
            print("selectedRanges: \(selectedRanges)")
        }
        
        
    }
    
    func checkStorage() {
        
        if let storedData = storedSelectedRanges {
            if let decodedData = try? JSONDecoder().decode([RangeType].self, from: storedData) {
                if !decodedData.isEmpty {
                    selectedRanges = decodedData
//                    print("Hentet lagrede perioder: \(selectedRanges)")
                } else {
                    print("wtf idk man")
                }
            } else {
                print("Error: Kunne ikke hente lagrede perioder!")
                if let decodedData = try? JSONDecoder().decode([RangeType].self, from: storedData) {
                    if !decodedData.isEmpty {
                        selectedRanges = decodedData
                        print("Hentet lagrede perioder2")
                    } else {
                        print("wtf idk man")
                    }
                } else {
                    print("Error: Kunne ikke hente lagrede perioder2!")
                    print("Du er doomed!")
                }
            }
            
        } else {
            if let encodedData = try? JSONEncoder().encode(defaultSelectedRanges) {
                storedSelectedRanges = encodedData
                if let storedData = storedSelectedRanges {
                    if let decodedData = try? JSONDecoder().decode([RangeType].self, from: storedData) {
                        if !decodedData.isEmpty {
                            selectedRanges = decodedData
                            print("Ny bruker uten lagrede perioder")
                        }
                    } else {
                        print("Error: Kunne ikke hente stadard perioder")
                    }
                    
                }
            } else {
                print("Error: Kunne ikke hente stadard perioder for å lagre de")
            }
        }
        
        
    }
}


struct SlideView_Previews: PreviewProvider {
    
//    @State static var dateRange = Item(amount: "5m", length: "1 Måned")
    
    static var previews: some View {
        SlideView(selectedRange: .oneMonth1)
            .padding(.vertical)
            .previewLayout(.sizeThatFits)
    }
}
