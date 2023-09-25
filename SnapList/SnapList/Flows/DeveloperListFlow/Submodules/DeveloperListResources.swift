//
//  DeveloperListResources.swift
//  SnapList
//
//  Created by Vlad Katsubo on 23.09.23.
//

import UIKit

struct DeveloperListResources {
    // MARK: - Handlers
    struct Handlers {
        
    }

    // MARK: - States
    enum State {
        case onInitialTableViewSetup([DeveloperListTableViewCell.Model], ImageManagerProtocol)
        case onLoadMoreElements([DeveloperListTableViewCell.Model])
        case onSnap
        case onShowUploadCompletionAlert(String)
    }

    // MARK: - Constants
    enum Constants {

        enum UI {
            static let title = "SnapList"
            static let alertTitle = "Success"
            static let okActionTitle = "OK"
        }

        enum Mocks {
            
        }
    }
}
