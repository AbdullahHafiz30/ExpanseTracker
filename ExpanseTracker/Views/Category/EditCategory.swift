import SwiftUI

// View to edit an existing category
struct EditCategory: View {
    @State var viewModel = IconModel()
    @StateObject var categoryViewModel = CategoryViewModel()

    // Binding to receive the category ID from the parent view
    @Binding var id: String

    // Form states
    @State private var categoryName: String = ""
    @State private var selectedIcon: String = "star"
    @State private var color: Color = .black
    @State private var limit: Double = 1
    @State private var categoryType: CategoryType = .other

    // Flags for sheet presentation
    @State private var showIcons: Bool = false
    @State private var showColorPicker: Bool = false

    @EnvironmentObject var themeManager: ThemeManager
    @Namespace private var animation

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                titleBar

                formSection

                Spacer()

                // Save button
                CustomButton(title: "Save") {
                    let category = Category(
                        id: id,
                        name: categoryName,
                        color: UIColor(color).toHexString(),
                        icon: selectedIcon,
                        categoryType: categoryType,
                        budgetLimit: limit
                    )
                    categoryViewModel.saveEditedCategory(category: category)
                }
            }
            .padding()
            // Show icon picker sheet
            .sheet(isPresented: $showIcons) {
                IconPicker(selectedIcon: $selectedIcon, color: $color)
            }
            // Show color picker sheet
            .sheet(isPresented: $showColorPicker) {
                ColorsPicker(selectedColor: $color)
            }
            // Load category details when view appears
            .onAppear {
                if let category = categoryViewModel.fetchCategoryFromCoreDataWithId(id: id) {
                    categoryName = category.name ?? ""
                    selectedIcon = category.icon ?? "star"
                    color = colorFromHexString(category.color ?? "#000000")
                    categoryType = category.categoryType ?? .other
                    limit = category.budgetLimit ?? 0
                }
            }
        }
    }

    // Title bar at the top
    private var titleBar: some View {
        ZStack {
            Rectangle()
                .fill(themeManager.isDarkMode && color == .black ? .white.opacity(0.3) : themeManager.isDarkMode ? color.opacity(0.3) : color.opacity(0.1))
                .frame(width: 220, height: 10)
                .cornerRadius(5)
                .offset(y: 10)

            Text("Edit Category")
                .foregroundColor(themeManager.isDarkMode ? .white : .black)
                .font(.largeTitle)
        }
    }

    // Main form section
    private var formSection: some View {
        VStack(spacing: 25) {
            // Icon preview and category name input
            HStack {
                iconPreview
                CustomTextField(placeholder: "Category Name", text: $categoryName, isSecure: .constant(false))
            }

            // Row to pick icon
            row(title: "Category Icon", trailingView: Image(systemName: selectedIcon)) {
                showIcons.toggle()
            }

            // Row to pick color
            row(title: "Category Color", trailingView: colorPreview) {
                showColorPicker.toggle()
            }

            // Category type selection
            Text("Category Type")
                .font(.headline)
                .padding(.top)

            categoryTypeSelector

            // Budget limit slider
            Text("Budget Limit")
                .font(.headline)

            HStack {
                Slider(value: $limit, in: 1...100)
                    .tint(themeManager.isDarkMode && color == .black ? .white.opacity(0.3) : color)
                Text("\(Int(limit))%")
                    .frame(width: 40)
            }
        }
    }

    // Preview for the selected icon
    private var iconPreview: some View {
        ZStack {
            Rectangle()
                .fill(themeManager.isDarkMode && color == .black ? .white.opacity(0.3) : themeManager.isDarkMode ? color.opacity(0.3) : color.opacity(0.1))
                .frame(width: 75, height: 75)
                .cornerRadius(10)

            Image(systemName: selectedIcon)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .foregroundColor(themeManager.isDarkMode && color == .black ? .white.opacity(0.3) : color)
        }
        .padding(5)
    }

    // Color preview circle
    private var colorPreview: some View {
        ZStack {
            Circle()
                .stroke(LinearGradient(colors: [.red, .yellow, .green, .cyan, .blue, .purple, .pink], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 3)
                .frame(width: 27, height: 27)

            Circle()
                .fill(themeManager.isDarkMode && color == .black ? .white.opacity(0.3) : color)
                .frame(width: 20, height: 20)
        }
    }

    // Row UI element with tap action
    private func row<Content: View>(title: String, trailingView: Content, action: @escaping () -> Void) -> some View {
        HStack {
            Text(title)
            Spacer()
            trailingView
        }
        .padding(.horizontal)
        .onTapGesture {
            action()
        }
    }

    // Category type selection UI
    private var categoryTypeSelector: some View {
        let rows = CategoryType.allCases.chunked(into: 2)

        return VStack(spacing: 10) {
            ForEach(rows.indices, id: \.self) { rowIndex in
                HStack(spacing: 5) {
                    ForEach(rows[rowIndex], id: \.self) { type in
                        Text(LocalizedStringKey(type.rawValue))
                            .font(.callout)
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(categoryType == type ? (themeManager.isDarkMode ? .black : .white) : (themeManager.isDarkMode ? .white : .black))
                            .background(
                                ZStack {
                                    if categoryType == type {
                                        Capsule()
                                            .fill(themeManager.isDarkMode && color == .black ? .white.opacity(0.3) : color)
                                            .matchedGeometryEffect(id: "Type", in: animation)
                                    } else {
                                        Capsule()
                                            .stroke(.gray)
                                    }
                                }
                            )
                            .contentShape(Capsule())
                            .onTapGesture {
                                withAnimation {
                                    categoryType = type
                                }
                            }
                    }
                }
            }
        }
        .padding(.horizontal)
    }
}


// Convert a hex color string to a SwiftUI Color
func colorFromHexString(_ hex: String) -> Color {
    var hexFormatted = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

    if hexFormatted.hasPrefix("#") {
        hexFormatted.remove(at: hexFormatted.startIndex)
    }

    guard hexFormatted.count == 6,
          let rgbValue = UInt64(hexFormatted, radix: 16) else {
        return .gray
    }

    let red = Double((rgbValue & 0xFF0000) >> 16) / 255.0
    let green = Double((rgbValue & 0x00FF00) >> 8) / 255.0
    let blue = Double(rgbValue & 0x0000FF) / 255.0

    return Color(red: red, green: green, blue: blue)
}
