import SwiftUI

struct CategoryView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @StateObject private var viewModel = CategoryViewModel()
    @State private var showingAddCategory = false
    @State private var selectedType: String = "All"
    @Binding var userId: String

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                HStack {
                    Text("Categories")
                        .foregroundColor(themeManager.textColor)
                        .font(.custom("Poppins-Bold", size: 36))
                        .fontWeight(.bold)
                        .padding(.top , 20)
                        .padding(.leading , 20)
                    
                    Spacer()
                    addButton
                        .foregroundColor(themeManager.textColor)
                        .padding(.top, 20)
                        .padding(.trailing, 20)
                    
                        
                }
                
                // Custom search bar
                searchBarView

                // Category type filter buttons
                categoryTypeFilter

                // List of categories
                categoryList
            }
            .navigationTitle("Categories")
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                viewModel.loadCategories()
            }
            .toolbar {
                // Plus button to add new category
                ToolbarItem(placement: .navigationBarTrailing) {
                    addButton
                }
            }
            .fullScreenCover(isPresented: $showingAddCategory) {
                // Full-screen cover for adding new category
                CategoryFunctionallity(id: "", userId: $userId, type: .constant("Add"))
                    .environmentObject(viewModel)
                    .onDisappear {
                        viewModel.loadCategories()
                    }
            }
            .background(Color.white)
        }
        .preferredColorScheme(.light) // Force light mode
    }

    // MARK: - Search Bar View
    private var searchBarView: some View {
        SearchBar(searchText: $viewModel.searchText)
            .background(Color.white)
            .cornerRadius(12)
    }

    // MARK: - Category Type Filter Buttons
    private var categoryTypeFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(["All"] + CategoryType.allCases.map { $0.rawValue }, id: \.self) { type in
                    CategoryTypeButton(
                        title: LocalizedStringKey(type),
                        isSelected: selectedType == type,
                        action: {
                            selectedType = type
                            if let categoryType = CategoryType(rawValue: type) {
                                viewModel.selectedType = categoryType
                            } else {
                                viewModel.selectedType = nil
                            }
                        }
                    )
                }
            }
            .padding(.horizontal)
        }
    }

    // MARK: - Category List
    private var categoryList: some View {
        List {
            ForEach(viewModel.filteredCategories) { category in
                NavigationLink {
                    // Avoid optional inside destination by fallback to EmptyView
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
                .listRowBackground(Color.white)
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
                .foregroundColor(.white)
                .padding(12)
                .background(Circle().fill(Color.black))
                .shadow(radius: 5)
        }
    }
}

struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryView(userId: .constant("preview-user-id"))
            .environmentObject(ThemeManager()) // Provide necessary environment object
    }
    
    
    
}
