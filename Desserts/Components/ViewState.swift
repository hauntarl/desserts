//
//  ViewState.swift
//  Desserts
//
//  Created by Sameer Mungole on 3/20/24.
//

import SwiftUI

/**
 A generic ViewState, utilized to show different views depending on the state of this enum.
 */
public enum ViewState<T> {
    case loading
    case success(data: T)
    // The message is of type LocalizedStringKey because Text view supports embedding markdown via LocalizedStringKey.
    case failure(message: LocalizedStringKey)
}
