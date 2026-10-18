import SwiftUI
import FamilyControls

public struct AppLimitsView: View {
    @StateObject private var viewModel = AppLimitsViewModel()
    @State private var selectedTab: Int = 0
    @State private var newLimitTitle: String = ""
    @State private var newLimitMinutes: Int = 30
    @State private var newLimitSelection = FamilyActivitySelection()
    @State private var isShowingLimitAppPicker = false
    @State private var isShowingQuickShieldPicker = false
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            VStack {
                Picker("Type", selection: $selectedTab) {
                    Text("App Limits").tag(0)
                    Text("Schedules").tag(1)
                    Text("Instant Shield").tag(2)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .padding(.top, 8)
                
                if selectedTab == 0 {
                    limitsList
                } else if selectedTab == 1 {
                    schedulesList
                } else {
                    instantShieldSettings
                }
            }
            .navigationTitle("Blocking & Limits")
            .background(Color(uiColor: .systemGroupedBackground))
            .sheet(isPresented: $viewModel.isShowingAddLimitSheet) {
                addLimitSheet
            }
            .sheet(isPresented: $viewModel.isShowingAddScheduleSheet) {
                ScheduleConfigView { newSchedule in
                    viewModel.addSchedule(newSchedule)
                }
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        if selectedTab == 0 {
                            viewModel.isShowingAddLimitSheet = true
                        } else if selectedTab == 1 {
                            viewModel.isShowingAddScheduleSheet = true
                        }
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
    
    private var limitsList: some View {
        List {
            if viewModel.appLimits.isEmpty {
                Text("No app limits configured. Tap '+' to set a daily limit.")
                    .foregroundColor(.secondary)
            } else {
                ForEach(viewModel.appLimits) { limit in
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(limit.name)
                                .font(.headline)
                            Text("\(limit.limitMinutes) mins daily limit")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Toggle("", isOn: Binding(
                            get: { limit.isEnabled },
                            set: { _ in viewModel.toggleLimit(limit) }
                        ))
                    }
                }
                .onDelete(perform: viewModel.deleteLimit)
            }
        }
    }
    
    private var schedulesList: some View {
        List {
            if viewModel.blockSchedules.isEmpty {
                Text("No schedules configured. Tap '+' to create a routine.")
                    .foregroundColor(.secondary)
            } else {
                ForEach(viewModel.blockSchedules) { schedule in
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(schedule.title)
                                .font(.headline)
                            Text(schedule.timeRangeString)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Toggle("", isOn: Binding(
                            get: { schedule.isEnabled },
                            set: { _ in viewModel.toggleSchedule(schedule) }
                        ))
                    }
                }
                .onDelete(perform: viewModel.deleteSchedule)
            }
        }
    }
    
    private var instantShieldSettings: some View {
        Form {
            Section(header: Text("Targeted Apps for Instant Block & Focus Mode")) {
                HStack {
                    Text("Blocked Apps")
                    Spacer()
                    Text("\(viewModel.quickShieldSelection.applicationTokens.count) apps")
                        .foregroundColor(.secondary)
                }
                Button("Configure Apps to Block") {
                    isShowingQuickShieldPicker = true
                }
            }
            
            Section(footer: Text("These applications will be instantly shielded when you start a Focus Timer session or toggle the Quick Block switch on the Dashboard.")) {
                EmptyView()
            }
        }
        .sheet(isPresented: $isShowingQuickShieldPicker) {
            AppPickerSheet(selection: Binding(
                get: { viewModel.quickShieldSelection },
                set: { viewModel.updateQuickShieldSelection($0) }
            ))
        }
    }
    
    private var addLimitSheet: some View {
        NavigationStack {
            Form {
                Section(header: Text("Limit Name")) {
                    TextField("e.g. Social Media Limit", text: $newLimitTitle)
                }
                
                Section(header: Text("Daily Allowance")) {
                    Stepper("\(newLimitMinutes) Minutes", value: $newLimitMinutes, in: 5...300, step: 5)
                }
                
                Section(header: Text("Apps to Restrict")) {
                    HStack {
                        Text("Selected Apps")
                        Spacer()
                        Text("\(newLimitSelection.applicationTokens.count) apps")
                            .foregroundColor(.secondary)
                    }
                    Button("Select Apps") {
                        isShowingLimitAppPicker = true
                    }
                }
            }
            .navigationTitle("New App Limit")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $isShowingLimitAppPicker) {
                AppPickerSheet(selection: $newLimitSelection)
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { viewModel.isShowingAddLimitSheet = false }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let limit = AppLimit(
                            name: newLimitTitle.isEmpty ? "App Limit" : newLimitTitle,
                            limitMinutes: newLimitMinutes,
                            selectedApplications: newLimitSelection
                        )
                        viewModel.addLimit(limit)
                        viewModel.isShowingAddLimitSheet = false
                    }
                }
            }
        }
    }
}
