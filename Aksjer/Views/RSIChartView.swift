//
//  RSIChartView.swift
//  Aksjer
//
//  Created by Kristoffer Melen on 22/04/2024.
//

import SwiftUI
import Charts

struct RSIChartView: View {
    @AppStorage("defaultRange") private var defaultRange: RangeType = .oneDay
    @AppStorage("selectedInterpolationMethod") private var selectedInterpolationMethod: InterpolationMethod = .linear
    var vm: ViewModel
    
    var body: some View {
        Chart {
            ForEach(vm.newRSIChartTupleArray, id: \.0) { index2, item2 in
                if selectedInterpolationMethod == .cardinal {
                    LineMark(x: .value("Dato", index2), y: .value("Verdi", item2.value), series: .value("20", "20"))
                        .foregroundStyle(vm.foregroundMarkColor)
                        .interpolationMethod(.cardinal)
                    
                    AreaMark(x: .value("Dato", index2), y: .value("Verdi", item2.value), series: .value("20", "20"))
                        .alignsMarkStylesWithPlotArea()
                        .foregroundStyle(LinearGradient(gradient: Gradient(colors: [vm.foregroundMarkColor.opacity(0.6), .clear]),
                                                        startPoint: .top,
                                                        endPoint: .bottom))
                        .interpolationMethod(.linear)
                    
                } else if selectedInterpolationMethod == .linear {
                    LineMark(x: .value("Dato", index2), y: .value("Verdi", item2.value), series: .value("20", "20"))
                        .foregroundStyle(vm.foregroundMarkColor)
                        .interpolationMethod(.linear)
                        .mask { RectangleMark() }
                    
                    AreaMark(x: .value("Dato", index2), y: .value("Verdi", item2.value), series: .value("20", "20"))
                        .alignsMarkStylesWithPlotArea()
                        .foregroundStyle(LinearGradient(gradient: Gradient(colors: [vm.foregroundMarkColor.opacity(0.6), .clear]),
                                                        startPoint: .top,
                                                        endPoint: .bottom))
                        .interpolationMethod(.linear)
                        .mask { RectangleMark() }
                    
                }
            }
            
            RuleMark(y: .value("30", Double(30)))
                .lineStyle(.init(lineWidth: 1, dash: [2]))
                .foregroundStyle(.gray)
                .mask { RectangleMark() }
            
            RuleMark(y: .value("70", Double(70)))
                .lineStyle(.init(lineWidth: 1, dash: [2]))
                .foregroundStyle(.gray)
                .mask { RectangleMark() }
            
            
            if let (selectedX, text) = vm.selectedXRuleMarkRSI {
                
                RuleMark(x: .value("Valgt tidspunkt", selectedX))
                    .lineStyle(.init(lineWidth: 1))
                    .foregroundStyle(.cyan)
                    .annotation(position: .topTrailing, spacing: 5, overflowResolution: .init(x: .fit(to: .chart))) {
                        
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
            
            
            
        }
        .frame(minHeight: 150)
        .chartXAxis {
            if vm.isLine3Selected {
                let _ = print("yup jeg er her")
                vm.chartXAxis2RSI
            } else {
                vm.chartXAxisRSI
            }
        }
        .chartXScale(domain: vm.testChart.xAxisData.axisStart...vm.testChart.xAxisData.axisEnd)
        .chartYAxis { vm.chartYAxisRSI }
        .chartYScale(domain: vm.rsiChart.yAxisData.axisStart...vm.rsiChart.yAxisData.axisEnd)
        .chartOverlay { proxy in
            GeometryReader { gProxy in
                Rectangle().fill(.clear).contentShape(Rectangle())
                    .delaysTouches(for: 0.01) {}
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged {
                                if !vm.isMakingLine {
                                    if !vm.isLine3Selected {
                                        vm.onChangeDrag(value: $0, chartProxy: proxy, geometryProxy: gProxy)
                                        vm.onChangeDragRSI(value: $0, chartProxy: proxy, geometryProxy: gProxy)
                                        
                                        
                                    } else {
                                        vm.onChangeDrag2(value: $0, chartProxy: proxy, geometryProxy: gProxy)
                                        vm.onChangeDragRSI(value: $0, chartProxy: proxy, geometryProxy: gProxy)
                                        
                                    }
                                }
                                
                            }
                            .onEnded { _ in
                                vm.selectedXRSI = nil
                                vm.selectedX = nil
                                vm.selectedXY = nil
                                
                                
                            }
                    )
                
                
            }
        }
        .animation(nil, value: UUID())
        .padding(.top, -8)
        
        
        
    }
}

