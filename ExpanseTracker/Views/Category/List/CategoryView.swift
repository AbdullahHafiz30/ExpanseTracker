import SwiftUI

struct CategoryView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @StateObject private var viewModel: CategoryViewModel
    @State private var showingAddCategory = false
    @State private var selectedType: String = "All"
    @Namespace private var animation
    @Binding var userId: String
    @AppStorage("AppleLanguages") var currentLanguage: String = Locale.current.language.languageCode?.identifier ?? "en"
   // @Environment(\.colorScheme) var colorScheme  // Detect current color scheme (light/dark)

    init(userId: Binding<String>) {
        self._userId = userId
        _viewModel = StateObject(wrappedValue: CategoryViewModel(userId: userId.wrappedValue))
    }

    var body: some View {
<<<<<<< Updated upstream
        ZStack {
            NavigationStack {
                VStack(spacing: 16) {
                    HStack {
                        Text("Categories".localized(using: currentLanguage))
                            .foregroundColor(themeManager.isDarkMode ? .white : .black)
                            .font(.custom("Poppins-Bold", size: 36))
                            .fontWeight(.bold)
                            .padding(.top , 20)
                            .padding(.leading , 20)
                        
                        Spacer()
                        addButton
                            .padding(.top, 20)
                            .padding(.trailing, 20)
=======
        NavigationStack {
            VStack(spacing: 16) {
                HStack {
                    Text("Categories".localized(using: currentLanguage))
                        .foregroundColor(colorScheme == .dark ? .white : .black)
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
                
            }.onChange(of: userId) { _ , newUserId in
                viewModel.userId = newUserId
                viewModel.loadCategories()
            }
            .navigationTitle("Categories".localized(using: currentLanguage))
            .navigationBarTitleDisplayMode(.large)
//            .onAppear {
//                viewModel.loadCategories()
//            }
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
>>>>>>> Stashed changes
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
                    CategoryFunctionallity(id: "", userId: $userId, type: .constant("Add"))
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
            print(viewModel.categories)
        }
    }
       

    // MARK: - Search Bar View
    private var searchBarView: some View {
        CategorySearchBar(searchText: $viewModel.searchText)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(themeManager.isDarkMode ? Color.white.opacity(0.1) : Color.gray.opacity(0.1)) // Adaptive background
            )
    }

    // MARK: - Category Type Filter Buttons
    private var categoryTypeFilter: some View {
        CategoryTypeFilterView(
            types: ["All"] + CategoryType.allCases.map { $0.rawValue.localized(using: currentLanguage) },
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
                        Label("Delete".localized(using: currentLanguage), systemImage: "trash")
                    }
                }
                .swipeActions(edge: .leading) {
                    if let id = category.id {
                        NavigationLink {
                            CategoryFunctionallity(id: id, userId: $userId, type: .constant("Edit"))
                        } label: {
                            Label("Edit".localized(using: currentLanguage), systemImage: "pencil")
                        }
                    }
                }
                .listRowBackground(themeManager.isDarkMode ? Color.black : Color.white) // Adaptive list row
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
                .foregroundColor(themeManager.isDarkMode ? .black : .white) // Adaptive icon color
                .padding(12)
                .background(Circle().fill(themeManager.isDarkMode ? Color.white : Color.black)) // Adaptive circle color
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
   // @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var themeManager: ThemeManager
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
                            .fill(themeManager.isDarkMode ? Color.white.opacity(0.6) : Color.black.opacity(0.05)) // Adaptive background
                    )
                }
            }
            .padding(.horizontal)
        }
    }
}
