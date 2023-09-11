//
//  ExpensesView.swift
//  ExpenseTrackerApp
//
//  Created by Brenda Saavedra Cantu on 09/09/23.
//

import SwiftUI
import SwiftData

struct ExpensesView: View {
    /// Grouped Expenses Properties
    @Query(sort:[
        SortDescriptor(\Expense.date, order: .reverse)
    ], animation: .snappy) private var allExpenses: [Expense]
    /// Grouped Expenses
    @State private var groupedExpenses: [GroupedExpenses] = [GroupedExpenses]()
    /// Properties
    @State private var addExpense: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(groupedExpenses) { group in
                    Section(group.groupTitle) {
                        ForEach(group.expenses) { expense in
                            /// Card View
                            ExpensesCardView(expense: expense)
                        }
                    }
                }
            }
            .navigationTitle("Expenses")
            .overlay {
                if allExpenses.isEmpty || groupedExpenses.isEmpty {
                    ContentUnavailableView {
                        Label("No Expenses", systemImage: "tray.fill")
                    }
                }
            }
            /// New Category Add Button
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        addExpense.toggle()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                    }
                }
            }
        }
        .onChange(of: allExpenses, initial: true) { oldValue, newValue in
            if newValue.count > oldValue.count || groupedExpenses.isEmpty {
                createGroupedExpenses(newValue)
            }
        }
        .sheet(isPresented: $addExpense) {
            AddExpenseView()
        }
    }
    
    func createGroupedExpenses(_ expenses: [Expense]) {
        Task.detached(priority: .high) {
            let groupedDict = Dictionary(grouping: expenses) {
                expense in
                let dateComponents = Calendar.current.dateComponents([.day, .month, .year], from: expense.date)
                return dateComponents
            }
            
            /// Sorting Dictionary in Descending Order
            let sortedDict = groupedDict.sorted {
                let calendar = Calendar.current
                let date1 = calendar.date(from: $0.key) ?? .init()
                let date2 = calendar.date(from: $1.key) ?? .init()
                
                return calendar.compare(date1, to: date2, toGranularity: .day) == .orderedDescending
            }
            
            /// Adding to the Grouped Expenses Array
            /// UI Must be Updated on Main Thread
            await MainActor.run {
                groupedExpenses = sortedDict.compactMap({ dict in
                    let date = Calendar.current.date(from: dict.key) ?? .init()
                    return .init(date: date, expenses: dict.value)
                })
            }
        }
    }
}

#Preview {
    ExpensesView()
}
