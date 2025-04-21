import SwiftUI

struct CategoryView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @StateObject private var viewModel: CategoryViewModel
    @State private var showingAddCategory = false
    @State private var selectedType: String = "All"
    @Namespace private var animation
    @Binding var userId: String
    @Environment(\.colorScheme) var colorScheme  // Detect current color scheme (light/dark)

    init(userId: Binding<String>) {
        self._userId = userId
        _viewModel = StateObject(wrappedValue: CategoryViewModel(userId: userId.wrappedValue))
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                HStack {
                    Text("Categories")
                        .foregroundColor(colorScheme == .dark ? .white : .black) // Dynamic text color
                        .font(.custom("Poppins-Bold", size: 36))
                        .fontWeight(.bold)
                        .padding(.top , 20)
                        .padding(.leading , 20)

                    Spacer()
                    addButton
                        .padding(.top, 20)
                        .padding(.trailing, 20)
                }

                searchBarView
                categoryTypeFilter
                categoryList
            }
            .onChange(of: userId) { newUserId in
                viewModel.userId = newUserId
                viewModel.loadCategories()
            }
            .navigationTitle("Categories")
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                viewModel.loadCategories()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    addButton
                }
            }
            .fullScreenCover(isPresented: $showingAddCategory) {
                CategoryFunctionallity(id: "", userId: $userId, type: .constant("Add"))
                    .environmentObject(viewModel)
                    .onDisappear {
                        viewModel.loadCategories()
                    }
            }
            .background(colorScheme == .dark ? Color.black : Color.white) // Dynamic background
        }
    }

    // MARK: - Search Bar View
    private var searchBarView: some View {
        CategorySearchBar(searchText: $viewModel.searchText)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(colorScheme == .dark ? Color.white.opacity(0.1) : Color.gray.opacity(0.1)) // Adaptive background
            )
    }

    // MARK: - Category Type Filter Buttons
    private var categoryTypeFilter: some View {
        CategoryTypeFilterView(
            types: ["All"] + CategoryType.allCases.map { $0.rawValue },
            selectedType: $selectedType,
            selectedCategoryType: $viewModel.selectedType,
            animation: animation
        )
    }

    // MARK: - Category List
    private var categoryList: some View {
        List {
            ForEach(viewModel.filteredCategories) { category in
                NavigationLink {
                    ListOfSpecificCategoryView(categoryName: category.name ?? "")
                } label: {
                    CategoryRow(category: category)
                        .environmentObject(themeManager)
                }
                .swipeActions(edge: .trailing) {
                    Button(role: .destructive) {
                        if let id = category.id {
                            viewModel.deleteCategory(withId: id)
                        }
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
                .swipeActions(edge: .leading) {
                    if let id = category.id {
                        NavigationLink {
                            CategoryFunctionallity(id: id, userId: $userId, type: .constant("Edit"))
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                    }
                }
                .listRowBackground(colorScheme == .dark ? Color.black : Color.white) // Adaptive list row
                .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
        .padding(.bottom, 20)
    }

    // MARK: - Add Button
    private var addButton: some View {
        Button {
            showingAddCategory = true
        } label: {
            Image(systemName: "plus")
                .foregroundColor(colorScheme == .dark ? .black : .white) // Adaptive icon color
                .padding(12)
                .background(Circle().fill(colorScheme == .dark ? Color.white : Color.accentColor)) // Adaptive circle color
        }
    }
}

// MARK: - Category Type Filter View (Horizontal scroll)
private struct CategoryTypeFilterView: View {
    let types: [String]
    @Binding var selectedType: String
    @Binding var selectedCategoryType: CategoryType?
    var animation: Namespace.ID
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(types, id: \.self) { type in
                    CategoryTypeButton(
                        title: LocalizedStringKey(type),
                        isSelected: selectedType == type,
                        animation: animation,
                        action: {
                            withAnimation(.spring()) {
                                selectedType = type
                                if let categoryType = CategoryType(rawValue: type) {
                                    selectedCategoryType = categoryType
                                } else {
                                    selectedCategoryType = nil
                                }
                            }
                        }
                    )
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(colorScheme == .dark ? Color.white.opacity(0.6) : Color.black.opacity(0.05)) // Adaptive background
                    )
                }
            }
            .padding(.horizontal)
        }
    }
}
