import SwiftUI

struct CategoryView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @StateObject private var viewModel: CategoryViewModel
    @State private var showingAddCategory = false
    @State private var selectedType: String = "All"
    @Namespace private var animation
    var userId: String
    @AppStorage("AppleLanguages") var currentLanguage: String = Locale.current.language.languageCode?.identifier ?? "en"

    init(userId: String) {
        self.userId = userId
        _viewModel = StateObject(wrappedValue: CategoryViewModel(userId: userId))
    }
    
    var body: some View {
        ZStack {
            NavigationStack {
                VStack(spacing: 16) {
                    HStack {
                        Text("Categories".localized(using: currentLanguage))
                            .foregroundColor(themeManager.isDarkMode ? .white : .black)
                            .font(.title.bold())
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
                        
                    
                }.onChange(of: userId) { _ , newUserId in
                    viewModel.userId = newUserId
                    viewModel.loadCategories()
                }
                .navigationTitle("Categories".localized(using: currentLanguage))
                .navigationBarTitleDisplayMode(.large)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        addButton
                    }
                }
                .fullScreenCover(isPresented: $showingAddCategory) {
                    CategoryFunctionallity(id: "", userId: userId, type: "Add")

                        .environmentObject(viewModel)
                        .onDisappear {
                            viewModel.loadCategories()
                        }
                }
                .background(themeManager.isDarkMode ? Color.black : Color.white) // Dynamic background
            }
        }
        .onAppear {
            viewModel.loadCategories()
        }

        .environment(\.layoutDirection, currentLanguage == "ar" ? .rightToLeft : .leftToRight)
        
    }
    
    // MARK: - Search Bar View
    private var searchBarView: some View {
        SearchBar(searchText: $viewModel.searchText)
    }
    
    // MARK: - Category Type Filter Buttons
    private var categoryTypeFilter: some View {
        CategoryTypeFilterView(
            types: ["All"] + CategoryType.allCases.map { $0.rawValue},
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
                    ListOfSpecificCategoryView(category: category, userId: userId)
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
                        Label("Delete".localized(using: currentLanguage), systemImage: "trash")
                    }.tint(.gray.opacity(0.2))
                }
                .swipeActions(edge: .leading) {
                    if let id = category.id {
                        NavigationLink {
                            CategoryFunctionallity(id: id, userId: userId, type: "Edit")
                        } label: {
                            Label("Edit".localized(using: currentLanguage), systemImage: "pencil")
                        }.tint(.gray.opacity(0.2))
                    }
                    
                }
                .listRowBackground(themeManager.isDarkMode ? Color.black : Color.white) // Adaptive list row
                
                Divider()
                    .background(themeManager.isDarkMode ? .white : .gray.opacity(0.3))

            }
            .listRowSeparator(.hidden)
        }
        .id(currentLanguage)
        .scrollIndicators(.hidden)
        .listStyle(.plain)
        .padding(.bottom, 20)
    }
    
    // MARK: - Add Button
    private var addButton: some View {
        Button {
            showingAddCategory = true
        } label: {
            Image(systemName: "plus.circle")
                .font(.title)
                .foregroundColor(themeManager.isDarkMode ? .white : .black) // Adaptive icon color
        }
    }
}

// MARK: - Category Type Filter View (Horizontal scroll)
private struct CategoryTypeFilterView: View {
    let types: [String]
    @Binding var selectedType: String
    @Binding var selectedCategoryType: CategoryType?
    var animation: Namespace.ID
    @AppStorage("AppleLanguages") var currentLanguage: String = Locale.current.language.languageCode?.identifier ?? "en"
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(types, id: \.self) { type in
                    CategoryTypeButton(
                        title: type.localized(using: currentLanguage) ,
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
                            .fill(themeManager.isDarkMode ? Color.white.opacity(0.6) : Color.black.opacity(0.05)) // Adaptive background
                    )
                }
            }
            .padding(.horizontal)
        }
    }
}
