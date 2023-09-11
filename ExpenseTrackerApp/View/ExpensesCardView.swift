//
//  ExpensesCardView.swift
//  ExpenseTrackerApp
//
//  Created by Brenda Saavedra Cantu on 11/09/23.
//

import SwiftUI

struct ExpensesCardView: View {
    @Bindable var expense: Expense
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(expense.title)
                
                Text(expense.subTitle)
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
            .lineLimit(1)
            
            Spacer(minLength: 5)
            
            Text(expense.currencyString)
                .font(.title3.bold())
        }
    }
}
