//
//  InstillingerView.swift
//  Aksjer
//
//  Created by Kristoffer Melen on 23/12/2023.
//

import SwiftUI
import Charts


enum InterpolationMethod: String, CaseIterable, Identifiable {
    case cardinal
    case linear
    
    var id: String {
        switch self {
            case .linear:
                return "Rett"
            case .cardinal:
                return "Kurvet"
            
        }
    }
}

struct Settings2: Identifiable {
    let id = UUID()
    let title: String
    var items: [Settings2]?

    
    static let theme = Settings2(title: "Theme")
    static let graph = Settings2(title: "Graph")
    static let standard = Settings2(title: "Standard")
    static let choose = Settings2(title: "Choose")
    
    
    static let appTema = Settings2(title: "App Tema:", items: [theme])
    static let graf = Settings2(title: "Graf Utsende:", items: [graph])
    
    static let standardPeriod = Settings2(title: "Standard Periode:", items: [standard])
    static let choosePeriod = Settings2(title: "Velg Perioder:")
    
    static let version = Settings2(title: "Versjon")
    static let build = Settings2(title: "Bygg")
    static let copyright = Settings2(title: "Opphavsrett")
    
    
    
}



struct InstillingerView: View {
    @AppStorage("appTheme") private var appTheme: AppTheme = .dark
    @AppStorage("defaultRange") private var defaultRange: RangeType = .oneDay
    @AppStorage("selectedInterpolationMethod") private var selectedInterpolationMethod: InterpolationMethod = .linear
    @AppStorage("selectedRanges") private var storedSelectedRanges: Data?
    @State var defaultSelectedRanges: [RangeType] = [.oneDay, .oneWeek, .oneMonth3, .threeMonths, .sixMonths, .nineMonths, .ytd, .oneYear, .twoYears, .threeYears, .fiveYears, .tenYears, .max]
    @State var selectedRanges: [RangeType] = []
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State var paddingValue: CGFloat = 0.00
    let sections: [(title: String, settings: [Settings2])] = [
        ("Generelt", [.appTema, .graf]),
        ("Perioder", [.standardPeriod, .choosePeriod]),
        ("App Info", [.version, .build, .copyright])
    ]
    
    
    
//    @State var settings: [Settings2] = [.appTema, .graf, .standardPeriod, .choosePeriod]
    
    var body: some View {
        GeometryReader { geometry in
            NavigationStack {
                let _ = print("wtf: \(selectedRanges)")

                
                List {
                    ForEach(sections, id: \.0) { sectionTitle, settings2 in
                        Section(header: Text(sectionTitle)) {
                            ForEach(settings2) { setting in
                                if let items = setting.items {
                                    DisclosureGroup {
                                        ForEach(items) { item in
                                            if item.title == "Theme" {
                                                Picker("App Theme", selection: $appTheme) {
                                                    Text("System").tag(AppTheme.system)
                                                    Text("Mørkt").tag(AppTheme.dark)
                                                    Text("Lyst").tag(AppTheme.light)
                                                    
                                                }
                                                .pickerStyle(SegmentedPickerStyle())
                                                .padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
                                            } else if item.title == "Graph" {
                                                Picker("Graf utsende", selection: $selectedInterpolationMethod) {
                                                    ForEach(InterpolationMethod.allCases, id: \.self) { item in
                                                        Text("\(item.id)")
                                                            .font(.callout.bold())
                                                    }
                                                }
                                                .pickerStyle(SegmentedPickerStyle())
                                                .padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
                                            } else if item.title == "Standard" {
                                                
                                                Picker("Periode", selection: $defaultRange) {
                                                    ForEach(RangeType.allCases, id: \.self) { item in
                                                        if selectedRanges.contains(item) {
                                                            Text("\(item.length) (\(item.realInterval))")
                                                                .font(.callout.bold())
                                                            let _ = print("nå er jeg her: \(selectedRanges)")
                                                        }
                                                        let _ = print("nå er jeg her: \(selectedRanges), item: \(item)")
                                                        
                                                    }
                                                }
                                                .pickerStyle(WheelPickerStyle())
                                                .padding([.top, .bottom], -25)
                                                .padding([.leading, .trailing], -10)
                                                .onAppear {
//                                                    print(selectedRanges)
                                                    print("defaultRange: \(defaultRange)")
                                                }
                                            } else {
                                                Text(item.title)
                                                    .font(.headline)
                                            }
                                        }
                                    } label: {
                                        HStack {
                                            Text(setting.title)
                                                .font(.headline)
                                        }
                                    }
                                } else {
                                    HStack {
                                        
                                        if setting.title == "Versjon" {
                                            
                                            HStack {
                                                Text("Versjon:")
                                                    .padding(.leading, 3)
                                                    .font(.headline)
                                                
                                                Spacer()
                                                
                                                Text("\(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0.0")")
                                                //                                .font(.headline)
                                                    .contextMenu {
                                                        Button(action: {
                                                            UIPasteboard.general.string = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0.0"
                                                        }) {
                                                            Text("Kopier")
                                                            Image(systemName: "doc.on.doc")
                                                        }
                                                    }
                                            }
                                        } else if setting.title == "Bygg" {
                                            
                                            HStack {
                                                Text("Bygg:")
                                                    .padding(.leading, 3)
                                                    .font(.headline)
                                                
                                                
                                                Spacer()
                                                
                                                Text("\(Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "0")")
                                                //                                .font(.headline)
                                                    .contextMenu {
                                                        Button(action: {
                                                            UIPasteboard.general.string = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "0"
                                                        }) {
                                                            Text("Kopier")
                                                            Image(systemName: "doc.on.doc")
                                                        }
                                                    }
                                            }
                                        } else if setting.title == "Opphavsrett" {
                                            HStack {
                                                Text("Opphavsrett:")
                                                    .padding(.leading, 3)
                                                    .font(.headline)
                                                
                                                
                                                Spacer()
                                                
                                                Text("© 2024 SwoshEB")
                                                //                                .font(.headline)
                                                    .contextMenu {
                                                        Button(action: {
                                                            UIPasteboard.general.string = "© 2024 SwoshEB"
                                                        }) {
                                                            Text("Kopier")
                                                            Image(systemName: "doc.on.doc")
                                                        }
                                                    }
                                            }
                                            
                                        
                                        } else if setting.title == "Velg Perioder:" {
                                            MultiSelector(
                                                label: Text("Velg Perioder:").padding(.leading, 3).font(.headline.bold()),
                                                options: RangeType.allCases,
                                                optionToString: { $0.length },
                                                selected: $selectedRanges
                                            )
                                            
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .onAppear {
                    checkStorage()
                    print("selectedRanges: \(selectedRanges)")
                }
                .listStyle(.insetGrouped)
                .navigationTitle("Innstillinger")
                .padding([.leading, .trailing], paddingValue)
                .onChange(of: UIDevice.current.orientation) {
                    if UIDevice.current.userInterfaceIdiom == .pad && UIDevice.current.orientation.isPortrait {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0000000000000000000000000000000000000000000001) {
                            paddingValue = geometry.size.width/10
                            print("padding1: \(paddingValue)")
                            
                        }
                    } else if UIDevice.current.userInterfaceIdiom == .pad && UIDevice.current.orientation.isLandscape {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0000000000000000000000000000000000000000000001) {
                            paddingValue = geometry.size.width/7
                            print("padding2: \(paddingValue)")
                            
                        }
                    }
                    
                }
                .onAppear {
                    
                    if UIDevice.current.userInterfaceIdiom == .pad && UIDevice.current.orientation.isPortrait {
                        paddingValue = geometry.size.width/10
                        print("padding3: \(paddingValue)")
                        
                    } else if UIDevice.current.userInterfaceIdiom == .pad && UIDevice.current.orientation.isLandscape {
                        paddingValue = geometry.size.width/8
                        print("padding4: \(paddingValue)")
                        
                    }
                }
                
                //                List(settings, children: \.dropdowns) { setting in
                ////                    Section(content: {
                //                        if setting.title == "Theme" {
//                            Picker("App Theme", selection: $appTheme) {
//                                Text("System").tag(AppTheme.system)
//                                Text("Mørkt").tag(AppTheme.dark)
//                                Text("Lyst").tag(AppTheme.light)
//                                
//                            }
//                            .pickerStyle(SegmentedPickerStyle())
//                        } else if setting.title == "Graph" {
//                            Picker("Graf utsende", selection: $selectedInterpolationMethod) {
//                                ForEach(InterpolationMethod.allCases, id: \.self) { item in
//                                    Text("\(item.id)")
//                                        .font(.callout.bold())
//                                }
//                            }
//                            .pickerStyle(SegmentedPickerStyle())
//                        } else if setting.title == "Standard" {
//                            
//                            Picker("Periode", selection: $defaultRange) {
//                                ForEach(RangeType.allCases, id: \.self) { item in
//                                    if selectedRanges.contains(item) {
//                                        Text("\(item.length) (\(item.realInterval))")
//                                            .font(.callout.bold())
//                                        let _ = print("nå er jeg her: \(selectedRanges)")
//                                    }
//                                    let _ = print("nå er jeg her: \(selectedRanges), item: \(item)")
//                                    
//                                }
//                            }
//                            .pickerStyle(WheelPickerStyle())
//                            .padding([.top, .bottom], -25)
//                            .padding([.leading, .trailing], -10)
//                            .onAppear {
//                                print(selectedRanges)
//                            }
//                        } else if setting.title == "Choose" {
//                            MultiSelector(
//                                label: Text("Velg Perioder:").padding(.leading, 3).font(.headline.bold()),
//                                options: RangeType.allCases,
//                                optionToString: { $0.length },
//                                selected: $selectedRanges
//                            )
//                            
//                        } else if setting.title == "Versjon" {
//                            Section(content: {
//                                HStack {
//                                    Text("Versjon:")
//                                        .padding(.leading, 3)
//                                        .font(.headline)
//                                    
//                                    Spacer()
//                                    
//                                    Text("\(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0.0")")
//                                    //                                .font(.headline)
//                                        .textSelection(.enabled)
//                                }
//                                
//                                HStack {
//                                    Text("Bygg:")
//                                        .padding(.leading, 3)
//                                        .font(.headline)
//                                    
//                                    
//                                    Spacer()
//                                    
//                                    Text("\(Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "0")")
//                                    //                                .font(.headline)
//                                        .textSelection(.enabled)
//                                }
//                                
//                                HStack {
//                                    Text("Opphavsrett:")
//                                        .padding(.leading, 3)
//                                        .font(.headline)
//                                    
//                                    
//                                    Spacer()
//                                    
//                                    Text("© 2024 SwoshEB")
//                                    //                                .font(.headline)
//                                        .textSelection(.enabled)
//                                }
//                            }, header: {
//                                Text("App Info:")
//                            })
//                            
//                        } else {
//                            Text(setting.title)
//                        }
//                        
//                        
//                        
////                    }, header: {
////                        Text("App Info:")
////                    })
//                }
//                .onAppear {
//                    checkStorage()
//                    print("selectedRanges: \(selectedRanges)")
//                }
//                List {
//                    //                        Section(content: {
//                    //                            NavigationLink(destination: GeneralView()) {
//                    //                                HStack {
//                    //                                    Text("Generelt").padding(.leading, 3).font(.headline)
//                    //                                    Spacer()
//                    //
//                    //
//                    //                                }
//                    //                            }
//                    //
//                    //                            NavigationLink(destination: PiriodView()) {
//                    //                                HStack {
//                    //                                    Text("Perioder").padding(.leading, 3).font(.headline)
//                    //                                    Spacer()
//                    //
//                    //
//                    //                                }
//                    //                            }
//                    //                        }, header: {
//                    //                            Text("Generelt:")
//                    //                        })
//                    
//                    Section(content: {
//                        HStack {
//                            Text("Versjon:")
//                                .padding(.leading, 3)
//                                .font(.headline)
//                            
//                            Spacer()
//                            
//                            Text("\(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0.0")")
//                            //                                .font(.headline)
//                                .textSelection(.enabled)
//                        }
//                        
//                        HStack {
//                            Text("Bygg:")
//                                .padding(.leading, 3)
//                                .font(.headline)
//                            
//                            
//                            Spacer()
//                            
//                            Text("\(Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "0")")
//                            //                                .font(.headline)
//                                .textSelection(.enabled)
//                        }
//                        
//                        HStack {
//                            Text("Opphavsrett:")
//                                .padding(.leading, 3)
//                                .font(.headline)
//                            
//                            
//                            Spacer()
//                            
//                            Text("© 2024 SwoshEB")
//                            //                                .font(.headline)
//                                .textSelection(.enabled)
//                        }
//                    }, header: {
//                        Text("App Info:")
//                    })
//                    
//                    
//                    
//
//                    
//                    
//                }
                
                
                
                
                
            }
        }
        
        
    }
    
    func checkStorage() {
        if let storedData = storedSelectedRanges {
            if let decodedData = try? JSONDecoder().decode([RangeType].self, from: storedData) {
                if !decodedData.isEmpty {
                    selectedRanges = decodedData
                    print("Hentet lagrede perioder: \(selectedRanges)")
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

struct PiriodView: View {
    @AppStorage("defaultRange") private var defaultRange: RangeType = .oneDay
    @AppStorage("selectedRanges") private var storedSelectedRanges: Data?
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State var defaultSelectedRanges: [RangeType] = [.oneDay, .oneWeek, .oneMonth3, .threeMonths, .sixMonths, .nineMonths, .ytd, .oneYear, .twoYears, .threeYears, .fiveYears, .tenYears, .max]
    @State var selectedRanges: [RangeType] = []
    @State var paddingValue: CGFloat = 0.00
    var body: some View {
        GeometryReader { geometry in
            List {
                let _ = print("wtf: \(selectedRanges)")
                VStack(alignment: .leading) {
                    Text("Standard Periode:")
                        .padding(.leading, 3)
                        .font(.headline.bold())
                    
                    Picker("Periode", selection: $defaultRange) {
                        ForEach(RangeType.allCases, id: \.self) { item in
                            if selectedRanges.contains(item) {
                                Text("\(item.length) (\(item.realInterval))")
                                    .font(.callout.bold())
                                let _ = print("nå er jeg her: \(selectedRanges)")
                            }
                            let _ = print("nå er jeg her: \(selectedRanges), item: \(item)")
                            
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .padding([.top, .bottom], -25)
                    .padding([.leading, .trailing], -10)
                    .onAppear {
                        print(selectedRanges)
                    }
                    
                    
                }
                
                MultiSelector(
                    label: Text("Velg Perioder:").padding(.leading, 3).font(.headline.bold()),
                    options: RangeType.allCases,
                    optionToString: { $0.length },
                    selected: $selectedRanges
                )
            }
            .navigationTitle("Perioder")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                checkStorage()
                print("selectedRanges: \(selectedRanges)")
            }
            .padding([.leading, .trailing], paddingValue)
            .onChange(of: UIDevice.current.orientation) {
                if UIDevice.current.userInterfaceIdiom == .pad && UIDevice.current.orientation.isPortrait {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.0000000000000000000000000000000000000000000001) {
                        paddingValue = geometry.size.width/10
                        print("padding1: \(paddingValue)")
                        
                    }
                } else if UIDevice.current.userInterfaceIdiom == .pad && UIDevice.current.orientation.isLandscape {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.0000000000000000000000000000000000000000000001) {
                        paddingValue = geometry.size.width/7
                        print("padding2: \(paddingValue)")
                        
                    }
                }
                
            }
            .onAppear {
                
                if UIDevice.current.userInterfaceIdiom == .pad && UIDevice.current.orientation.isPortrait {
                    paddingValue = geometry.size.width/10
                    print("padding3: \(paddingValue)")
                    
                } else if UIDevice.current.userInterfaceIdiom == .pad && UIDevice.current.orientation.isLandscape {
                    paddingValue = geometry.size.width/8
                    print("padding4: \(paddingValue)")
                    
                }
            }
        }
        
    }
    
    func checkStorage() {
        
        if let storedData = storedSelectedRanges {
            if let decodedData = try? JSONDecoder().decode([RangeType].self, from: storedData) {
                if !decodedData.isEmpty {
                    selectedRanges = decodedData
                    print("Hentet lagrede perioder: \(selectedRanges)")
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

struct GeneralView: View {
    @AppStorage("appTheme") private var appTheme: AppTheme = .dark
    @AppStorage("selectedInterpolationMethod") private var selectedInterpolationMethod: InterpolationMethod = .cardinal
    @State var paddingValue: CGFloat = 0.00
    var body: some View {
        GeometryReader { geometry in
            List {
                VStack(alignment: .leading) {
                    Text("App Tema:")
                        .padding(.leading, 3)
                        .font(.headline.bold())
                    
                    Picker("App Theme", selection: $appTheme) {
                        Text("System").tag(AppTheme.system)
                        Text("Mørkt").tag(AppTheme.dark)
                        Text("Lyst").tag(AppTheme.light)
                        
                        
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    
                }
                
                VStack(alignment: .leading) {
                    Text("Graf Utsende:")
                        .padding(.leading, 3)
                        .font(.headline.bold())
                    
                    Picker("Graf utsende", selection: $selectedInterpolationMethod) {
                        ForEach(InterpolationMethod.allCases, id: \.self) { item in
                            Text("\(item.id)")
                                .font(.callout.bold())
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    
                }
            }
            .navigationTitle("Generelt")
            .navigationBarTitleDisplayMode(.inline)
            .padding([.leading, .trailing], paddingValue)
            .onChange(of: UIDevice.current.orientation) {
                if UIDevice.current.userInterfaceIdiom == .pad && UIDevice.current.orientation.isPortrait {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.0000000000000000000000000000000000000000000001) {
                        paddingValue = geometry.size.width/10
                        print("padding1: \(paddingValue)")
                        
                    }
                } else if UIDevice.current.userInterfaceIdiom == .pad && UIDevice.current.orientation.isLandscape {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.0000000000000000000000000000000000000000000001) {
                        paddingValue = geometry.size.width/7
                        print("padding2: \(paddingValue)")
                        
                    }
                }
                
            }
            .onAppear {
                
                if UIDevice.current.userInterfaceIdiom == .pad && UIDevice.current.orientation.isPortrait {
                    paddingValue = geometry.size.width/10
                    print("padding3: \(paddingValue)")
                    
                } else if UIDevice.current.userInterfaceIdiom == .pad && UIDevice.current.orientation.isLandscape {
                    paddingValue = geometry.size.width/8
                    print("padding4: \(paddingValue)")
                    
                }
            }
            
            
        }
    }
}

struct MultiSelector<LabelView: View>: View {
    let label: LabelView
    let options: [RangeType]
    let optionToString: (RangeType) -> String
    
    var selected: Binding<[RangeType]>
    
    private var formattedSelectedListString: String {
        ListFormatter.localizedString(byJoining: selected.wrappedValue.map { optionToString($0) + " (\($0.realInterval))" })
    }
    
    var body: some View {
        NavigationLink(destination: multiSelectionView()) {
            HStack {
                label
                Spacer()
                if !formattedSelectedListString.isEmpty {
                    Text("\(formattedSelectedListString)")
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.trailing)
                } else {
                    Text("Ingen Valgte Perioder")
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.trailing)
                }
                
            }
        }
    }
    
    private func multiSelectionView() -> some View {
        MultiSelectionView(
            options: options,
            optionToString: optionToString,
            selected: selected
        )
    }
}

struct MultiSelectionView: View {
    @AppStorage("selectedRanges") private var storedSelectedRanges: Data?
    let options: [RangeType]
    let optionToString: (RangeType) -> String
    
    @Binding var selected: [RangeType]
    
    var body: some View {
        List {
            
            ForEach(options) { selectable in
                Button(action: { toggleSelection(selectable: selectable) }) {
                    HStack {
                        Text("\(selectable.length) (\(selectable.realInterval))")
                        Spacer()
                        if selected.contains(where: { $0 == selectable }) {
                            Image(systemName: "checkmark").foregroundColor(.accentColor)
                        }
                    }
                }
                .tag(selectable.id)
                .buttonStyle(BorderlessButtonStyle())
                .foregroundColor(.primary)
            }
            
            Button(action: {
                if selected.count == RangeType.allCases.count {
                    selected.removeAll()
                } else {
                    for selectable in options {
                        if !selected.contains(selectable) {
                            selected.append(selectable)
                        }
                        
                    }
                    selected.sort { $0.ranking < $1.ranking }
                    
                }
                if let encodedData = try? JSONEncoder().encode(selected) {
                    storedSelectedRanges = encodedData
                    print("ferdig å legge til perioder")
                }
                
            }, label: {
                if selected.count == RangeType.allCases.count {
                    Text("Fjern Alle")
                } else {
                    Text("Velg Alle")
                }
                
                
            })
        }
        .navigationTitle("Velg Perioder")
        
        
    }
    
    private func toggleSelection(selectable: RangeType) {
        if let existingIndex = selected.firstIndex(where: { $0 == selectable }) {
            selected.remove(at: existingIndex)
        } else {
            selected.append(selectable)
            
        }
        selected.sort { $0.ranking < $1.ranking }
        if let encodedData = try? JSONEncoder().encode(selected) {
            storedSelectedRanges = encodedData
            print("ferdig å legge til perioder2")
        }
    }
}







#Preview {
    InstillingerView()
    
}

