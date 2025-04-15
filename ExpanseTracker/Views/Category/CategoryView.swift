//import SwiftUI
//
//struct CategoryView: View {
//    @EnvironmentObject var themeManager: ThemeManager
//    @StateObject private var viewModel = CategoryViewModel()
//    @State private var showingAddCategory = false
//    @State private var selectedType: String = "All"
//    @Binding var userId: String
//    var body: some View {
//        NavigationStack {
//            VStack(spacing: 16) {
//                 //Search Bar
//                SearchBar(searchText: $viewModel.searchText)
//                    .padding(.horizontal)
//                    .padding(.top)
//                    .background(Color.white)
//                    .cornerRadius(12)
//                    .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 3)
//
//                // Category Type Filter
//                ScrollView(.horizontal, showsIndicators: false) {
//                    HStack(spacing: 10) {
//                        ForEach(["All"] + CategoryType.allCases.map { $0.rawValue }, id: \.self) { type in
//                            CategoryTypeButton(
//                                title: LocalizedStringKey(type),
//                                isSelected: selectedType == type,
//                                action: {
//                                    selectedType = type
//                                    viewModel.selectedType = type == "All" ? nil : CategoryType(rawValue: type)
//                                }
//                            )
//                        }
//                    }
//                    .padding(.horizontal)
//                }
//
//                // Categories List
//                List {
//                    ForEach(viewModel.filteredCategories) { category in
//                        CategoryRow(category: category)
//                            .environmentObject(themeManager)
//                            .swipeActions(edge: .trailing) {
//                                Button(role: .destructive) {
//                                    viewModel.deleteCategory(withId: category.id)
//                                } label: {
//                                    Label("Delete", systemImage: "trash")
//                                }
//                            }
//                            .swipeActions(edge: .leading) {
//                                NavigationLink(destination: EditCategory(id: .constant(category.id))) {
//                                    Label("Edit", systemImage: "pencil")
//                                }
//                            }
//                            .listRowBackground(Color.white) // للخلفية البيضاء زي LazyVStack
//                            .listRowSeparator(.hidden) // لإخفاء الفواصل بين الصفوف
//                    }
//                }
//                .listStyle(.plain)
//                .padding(.bottom, 20)
//
//
//
//            }
//            .navigationTitle("Categories")
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button {
//                        showingAddCategory = true
//                    } label: {
//                        Image(systemName: "plus")
//                            .foregroundColor(.white)
//                            .padding(12)
//                            .background(Circle().fill(Color.black))
//                            .shadow(radius: 5)
//                    }
//                }
//            }
//            .sheet(isPresented: $showingAddCategory) {
//                AddCategory(userId: $userId)
//                    .environmentObject(viewModel)
//            }
//            .background(Color.white)
//        }
//        .preferredColorScheme(.light)
//    }
//}
//
//// MARK: - Category Row View
//struct CategoryRow: View {
//    let category: Category
//    @EnvironmentObject var themeManager: ThemeManager
//
//    var body: some View {
//        HStack(spacing: 16) {
//            // Icon with colored circle
//            ZStack {
//                Circle()
//                    .fill(Color(colorFromHexString(category.color ?? "")).opacity(0.2))
//                    .frame(width: 50, height: 50)
//                Image(systemName: category.icon ?? "")
//                    .foregroundColor(Color(colorFromHexString(category.color ?? "")))
//                    .font(.system(size: 20, weight: .medium))
//            }
//
//            // Name and Type
//            VStack(alignment: .leading, spacing: 4) {
//                Text(category.name ?? "")
//                    .font(.headline)
//                    .foregroundColor(.black)
//                Text(LocalizedStringKey(category.categoryType?.rawValue ?? ""))
//                    .font(.caption)
//                    .foregroundColor(.gray)
//            }
//
//            Spacer()
//
//            // Chevron Arrow
//            Image(systemName: "chevron.right")
//                .foregroundColor(.gray)
//        }
//        //.padding()
//        .background(
//            RoundedRectangle(cornerRadius: 20)
//                .fill(Color.white)
//              //  .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
//        )
//    }
//}
//
//
//// MARK: - Category Type Button
//struct CategoryTypeButton: View {
//    let title: LocalizedStringKey
//    let isSelected: Bool
//    let action: () -> Void
//
//    var body: some View {
//        Button(action: action) {
//            Text(title)
//                .font(.subheadline)
//                .padding(.horizontal, 20)
//                .padding(.vertical, 10)
//                .background(
//                    Capsule()
//                        .fill(isSelected ? Color.black : Color.gray.opacity(0.15))
//                )
//                .foregroundColor(isSelected ? .white : .black)
//                .shadow(radius: isSelected ? 3 : 0)
//        }
//    }
//}
//
//// MARK: - Preview
//struct CategoryView_Previews: PreviewProvider {
//    static var previews: some View {
//        CategoryView()
//            .environmentObject(ThemeManager())
//    }
//}
//
