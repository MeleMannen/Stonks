//
//  SlideViewInfo.swift
//  Aksjer
//
//  Created by Kristoffer Melen on 17/01/2024.
//


import SwiftUI


struct SlideViewInfo: View {
    
    @State var selectedRange: RangeType
    @State var geometry: GeometryProxy
    
    var body: some View {
            TabView {
                ForEach(RangeType.allCases, id: \.id) { dateRange in
                    
                    if dateRange == .oneDay {
                        VStack {
                            Spacer()
                            
                            Text("\(dateRange.length) (\(dateRange.realInterval))")
                                .font(.title.bold())
                                .padding(8)
                                .background {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.gray.opacity(0.4))
                                    
                                }
                                .shadow(color: .black, radius: 40, x: 0, y: 0)
                            
                            Spacer()
                            
                            
                            Text("\(dateRange.length) betyr at det er den siste dagen som vises. \(dateRange.realInterval) betyr at det er 5 minutters mellomrom mellom hvert av data punktene.")
                                .font(.headline.bold())
                                .padding(8)
                            
                            Spacer()
                        }
                        
                    } else if dateRange == .oneWeek {
                        VStack {
                            Spacer()
                            
                            Text("\(dateRange.length) (\(dateRange.realInterval))")
                                .font(.title.bold())
                                .padding(8)
                                .background {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.gray.opacity(0.4))
                                    
                                }
                                .shadow(color: .black, radius: 40, x: 0, y: 0)
                            
                            Spacer()
                            
                            Text("\(dateRange.length) betyr at det er den siste uken som vises. \(dateRange.realInterval) betyr at det er 15 minutters mellomrom mellom hvert av data punktene.")
                                .font(.headline.bold())
                                .padding(8)
                            
                            Spacer()
                        }
                        
                    } else if dateRange == .oneMonth1 {
                        VStack {
                            
                            Spacer()
                            
                            Text("\(dateRange.length) (\(dateRange.realInterval))")
                                .font(.title.bold())
                                .padding(8)
                                .background {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.gray.opacity(0.4))
                                    
                                }
                                .shadow(color: .black, radius: 40, x: 0, y: 0)
                            
                            Spacer()
                            
                            Text("\(dateRange.length) betyr at det er den siste måneden som vises. \(dateRange.realInterval) betyr at det er 5 minutters mellomrom mellom hvert av data punktene.")
                                .font(.headline.bold())
                                .padding(8)
                            
                            Spacer()
                        }
                        
                        
                    } else if dateRange == .oneMonth2 {
                        VStack {
                            
                            Spacer()
                            
                            Text("\(dateRange.length) (\(dateRange.realInterval))")
                                .font(.title.bold())
                                .padding(8)
                                .background {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.gray.opacity(0.4))
                                    
                                }
                                .shadow(color: .black, radius: 40, x: 0, y: 0)
                            
                            Spacer()
                            
                            Text("\(dateRange.length) betyr at det er den siste måneden som vises. \(dateRange.realInterval) betyr at det er 15 minutters mellomrom mellom hvert av data punktene.")
                                .font(.headline.bold())
                                .padding(8)
                            
                            Spacer()
                            
                        }
                    } else if dateRange == .oneMonth3 {
                        VStack {
                            Spacer()
                            
                            Text("\(dateRange.length) (\(dateRange.realInterval))")
                                .font(.title.bold())
                                .padding(8)
                                .background {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.gray.opacity(0.4))
                                    
                                }
                                .shadow(color: .black, radius: 40, x: 0, y: 0)
                            
                            Spacer()
                            
                            Text("\(dateRange.length) betyr at det er den siste måneden som vises. \(dateRange.realInterval) betyr at det er 30 minutters mellomrom mellom hvert av data punktene.")
                                .font(.headline.bold())
                                .padding(8)
                            
                            Spacer()
                            
                        }
                    } else if dateRange == .oneMonth4 {
                        VStack {
                            Spacer()
                            
                            Text("\(dateRange.length) (\(dateRange.realInterval))")
                                .font(.title.bold())
                                .padding(8)
                                .background {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.gray.opacity(0.4))
                                    
                                }
                                .shadow(color: .black, radius: 40, x: 0, y: 0)
                            
                            Spacer()
                            
                            Text("\(dateRange.length) betyr at det er den siste måneden som vises. \(dateRange.realInterval) betyr at det er 1 time mellomrom mellom hvert av data punktene.")
                                .font(.headline.bold())
                                .padding(8)
                            
                            Spacer()
                            
                        }
                    } else if dateRange == .threeMonths {
                        VStack {
                            Spacer()
                            
                            Text("\(dateRange.length) (\(dateRange.realInterval))")
                                .font(.title.bold())
                                .padding(8)
                                .background {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.gray.opacity(0.4))
                                    
                                }
                                .shadow(color: .black, radius: 40, x: 0, y: 0)
                            
                            Spacer()
                            
                            Text("\(dateRange.length) betyr at det er de 3 siste månedene som vises. \(dateRange.realInterval) betyr at det er 1 dag mellomrom mellom hvert av data punktene.")
                                .font(.headline.bold())
                                .padding(8)
                            
                            Spacer()
                            
                        }
                    } else if dateRange == .sixMonths {
                        VStack {
                            Spacer()
                            
                            Text("\(dateRange.length) (\(dateRange.realInterval))")
                                .font(.title.bold())
                                .padding(8)
                                .background {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.gray.opacity(0.4))
                                    
                                }
                                .shadow(color: .black, radius: 40, x: 0, y: 0)
                            
                            Spacer()
                            
                            Text("\(dateRange.length) betyr at det er de 6 siste månedene som vises. \(dateRange.realInterval) betyr at det er 1 dag mellomrom mellom hvert av data punktene.")
                                .font(.headline.bold())
                                .padding(8)
                            
                            Spacer()
                            
                        }
                    } else if dateRange == .nineMonths {
                        VStack {
                            Spacer()
                            
                            Text("\(dateRange.length) (\(dateRange.realInterval))")
                                .font(.title.bold())
                                .padding(8)
                                .background {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.gray.opacity(0.4))
                                    
                                }
                                .shadow(color: .black, radius: 40, x: 0, y: 0)
                            
                            Spacer()
                            
                            Text("\(dateRange.length) betyr at det er de 9 siste månedene som vises. \(dateRange.realInterval) betyr at det er 1 dag mellomrom mellom hvert av data punktene.")
                                .font(.headline.bold())
                                .padding(8)
                            
                            Spacer()
                            
                        }
                    } else if dateRange == .ytd {
                        VStack {
                            Spacer()
                            
                            Text("\(dateRange.length) (\(dateRange.realInterval))")
                                .font(.title.bold())
                                .padding(8)
                                .background {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.gray.opacity(0.4))
                                    
                                }
                                .shadow(color: .black, radius: 40, x: 0, y: 0)
                            
                            Spacer()
                            
                            Text("\(dateRange.length) betyr at det er det siste året som vises fram til i dag. \(dateRange.realInterval) betyr at det er 1 dag mellomrom mellom hvert av data punktene.")
                                .font(.headline.bold())
                                .padding(8)
                            
                            Spacer()
                            
                        }
                    } else if dateRange == .oneYear {
                        VStack {
                            
                            Spacer()
                            
                            Text("\(dateRange.length) (\(dateRange.realInterval))")
                                .font(.title.bold())
                                .padding(8)
                                .background {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.gray.opacity(0.4))
                                    
                                }
                                .shadow(color: .black, radius: 40, x: 0, y: 0)
                            
                            Spacer()
                            
                            Text("\(dateRange.length) betyr at det er det siste hele året som vises. \(dateRange.realInterval) betyr at det er 1 dag mellomrom mellom hvert av data punktene.")
                                .font(.headline.bold())
                                .padding(8)
                            
                            Spacer()
                        }
                    } else if dateRange == .twoYears {
                        VStack {
                            
                            Spacer()
                            
                            Text("\(dateRange.length) (\(dateRange.realInterval))")
                                .font(.title.bold())
                                .padding(8)
                                .background {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.gray.opacity(0.4))
                                    
                                }
                                .shadow(color: .black, radius: 40, x: 0, y: 0)
                            
                            Spacer()
                            
                            Text("\(dateRange.length) betyr at det er de siste 2 årene som vises. \(dateRange.realInterval) betyr at det er 1 dag mellomrom mellom hvert av data punktene.")
                                .font(.headline.bold())
                                .padding(8)
                            
                            Spacer()
                        }
                    } else if dateRange == .threeYears {
                        VStack {
                            
                            Spacer()
                            
                            Text("\(dateRange.length) (\(dateRange.realInterval))")
                                .font(.title.bold())
                                .padding(8)
                                .background {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.gray.opacity(0.4))
                                    
                                }
                                .shadow(color: .black, radius: 40, x: 0, y: 0)
                            
                            Spacer()
                            
                            Text("\(dateRange.length) betyr at det er de siste 3 årene som vises. \(dateRange.realInterval) betyr at det er 1 dag mellomrom mellom hvert av data punktene.")
                                .font(.headline.bold())
                                .padding(8)
                            
                            Spacer()
                        }
                    } else if dateRange == .fiveYears {
                        VStack {
                            
                            Spacer()
                            
                            Text("\(dateRange.length) (\(dateRange.realInterval))")
                                .font(.title.bold())
                                .padding(8)
                                .background {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.gray.opacity(0.4))
                                    
                                }
                                .shadow(color: .black, radius: 40, x: 0, y: 0)
                            
                            Spacer()
                            
                            Text("\(dateRange.length) betyr at det er de opptil siste 5 årene som vises. \(dateRange.realInterval) betyr at det er 1 uke mellomrom mellom hvert av data punktene.")
                                .font(.headline.bold())
                                .padding(8)
                            
                            Spacer()
                        }
                    } else if dateRange == .tenYears {
                        VStack {
                            Spacer()
                            
                            Text("\(dateRange.length) (\(dateRange.realInterval))")
                                .font(.title.bold())
                                .padding(8)
                                .background {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.gray.opacity(0.4))
                                    
                                }
                                .shadow(color: .black, radius: 40, x: 0, y: 0)
                            
                            Spacer()
                            
                            Text("\(dateRange.length) betyr at det er opptil de siste 10 årene som vises. \(dateRange.realInterval) betyr at det er 1 måneds mellomrom mellom hvert av data punktene.")
                                .font(.headline.bold())
                                .padding(8)
                                
                            
                            Spacer()
                            
                        }
                    } else if dateRange == .max {
                        VStack {
                            Spacer()
                            
                            Text("\(dateRange.length) (\(dateRange.realInterval))")
                                .font(.title.bold())
                                .padding(8)
                                .background {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.gray.opacity(0.4))
                                    
                                }
                                .shadow(color: .black, radius: 40, x: 0, y: 0)
                            
                            Spacer()
                            
                            Text("\(dateRange.length) betyr alle datane som vises. \(dateRange.realInterval) betyr at det er 3 måneds mellomrom mellom hvert av data punktene.")
                                .font(.headline.bold())
                                .padding(8)
                            
                            
                            Spacer()
                            
                        }
                    }
                    
                    
                    
                    
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))

        
        
    }
}



