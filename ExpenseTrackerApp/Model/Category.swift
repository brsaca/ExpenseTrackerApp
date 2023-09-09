//
//  Category.swift
//  ExpenseTrackerApp
//
//  Created by Brenda Saavedra Cantu on 09/09/23.
//

import SwiftUI
import SwiftData

@Model
class Category {
    var categoryName: String
    /// Category Expenses
    @Relationship(.cascade, inverse: \Expense.category)
    var expenses: [Expense]?
    
    // TODO: add an icon o image
    init(categoryName: String) {
        self.categoryName = categoryName
    }
}
