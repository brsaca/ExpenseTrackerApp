//
//  ExpenseTrackerAppApp.swift
//  ExpenseTrackerApp
//
//  Created by Brenda Saavedra Cantu on 09/09/23.
//

import SwiftUI

@main
struct ExpenseTrackerAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        
        /// Setting Up the container
        .modelContainer(for: [Expense.self, Category.self])
    }
}
