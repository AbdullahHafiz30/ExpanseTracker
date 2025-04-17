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
                addButton
                searchBarView
                categoryTypeFilter
                categoryList
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
            .sheet(isPresented: $showingAddCategory) {
                AddCategory(userId : $userId)
                    .environmentObject(viewModel)
                    .onDisappear {
                                            viewModel.loadCategories()
                                        }
            }
            .background(Color.white)
        }
        .preferredColorScheme(.light)
    }

    private var searchBarView: some View {
        SearchBar(searchText: $viewModel.searchText)
            .padding(.horizontal)
            .padding(.top)
            .background(Color.white)
            .cornerRadius(12)
            //.shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 3)
    }

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

    private var categoryList: some View {
        List {
            ForEach(viewModel.filteredCategories) { category in
                // NavigationLink to move to ListOfSpecificCategoryView when tapping on a category
                NavigationLink {
                    if let categoryName = category.name {
                        ListOfSpecificCategoryView(categoryName: categoryName)
                    }
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
                            EditCategory(id: id, userId: userId)
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
