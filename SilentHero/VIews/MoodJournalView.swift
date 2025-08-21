import SwiftUI
import CoreData

struct MoodJournalView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \MoodEntry.createdAt, ascending: false)],
        animation: .default
    ) private var moodEntries: FetchedResults<MoodEntry>

    @StateObject private var viewModel = MoodEntryViewModel()

    @State private var selectedFilter = "All"
    @State private var showAddMood = false

    private let filters = ["All", "Morning", "Afternoon", "Evening"]

    var filteredEntries: [MoodEntry] {
        switch selectedFilter {
        case "Morning":
            return moodEntries.filter { Calendar.current.component(.hour, from: $0.createdAt ?? Date()) < 12 }
        case "Afternoon":
            return moodEntries.filter {
                let hour = Calendar.current.component(.hour, from: $0.createdAt ?? Date())
                return hour >= 12 && hour < 17
            }
        case "Evening":
            return moodEntries.filter { Calendar.current.component(.hour, from: $0.createdAt ?? Date()) >= 17 }
        default:
            return Array(moodEntries)
        }
    }

    var body: some View {
        NavigationView {
            ZStack {
                AppColors.neutralGray.ignoresSafeArea()

                VStack(spacing: 10) {
                    // Filter bar
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(filters, id: \.self) { filter in
                                Text(filter)
                                    .font(.subheadline)
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 6)
                                    .background(selectedFilter == filter ? AppColors.calmBlue : Color.white)
                                    .foregroundColor(selectedFilter == filter ? .white : .black)
                                    .cornerRadius(20)
                                    .onTapGesture {
                                        selectedFilter = filter
                                    }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 10)
                    }

                    // Scrollable content
                    ScrollView {
                        VStack(spacing: 12) {
                            if filteredEntries.isEmpty {
                                VStack(spacing: 12) {
                                    Image(systemName: "face.smiling")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 60, height: 60)
                                        .foregroundColor(.gray.opacity(0.3))

                                    Text("No mood entries found.")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                .padding(.top, 100)
                                .frame(maxWidth: .infinity)
                            } else {
                                ForEach(filteredEntries) { entry in
                                    MoodEntryCard(entry: entry, onDelete: {
                                        delete(entry)
                                    })
                                }
                            }
                        }
                        .padding()
                    }
                }

                // Floating add button
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: { showAddMood = true }) {
                            Image(systemName: "plus")
                                .font(.system(size: 22, weight: .bold))
                                .padding()
                                .background(AppColors.calmBlue)
                                .foregroundColor(.white)
                                .clipShape(Circle())
                                .shadow(radius: 4)
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Mood Journal")
            .onAppear {
                viewModel.syncMoodEntriesWithAPI()
            }
        }
        .sheet(isPresented: $showAddMood) {
            AddMoodEntryView()
                .environment(\.managedObjectContext, viewContext)
        }
    }

    // MARK: - Delete Entry
    private func delete(_ entry: MoodEntry) {
        guard let id = entry.id else { return }

        APIService.shared.deleteMoodEntry(id: id) { success in
            if success {
                DispatchQueue.main.async {
                    viewContext.delete(entry)
                    try? viewContext.save()
                }
            } else {
                print("API delete failed")
            }
        }
    }
}
