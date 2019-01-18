//
//  TestService.swift
//  Final Project
//
//  Created by 张水鉴 on 8/16/18.
//  Copyright © 2018 张水鉴. All rights reserved.
//

import Foundation
import Firebase


///Mark :Fake User account for UItest

protocol RegisterResult {
    var appUser: AppUser? { get }
}

protocol AppUser {
    var identifier: String { get }
}



///protocol TestService for register a fake account
protocol TestService {
    func Register(email: String, password: String, completionHandler: @escaping (RegisterResult?, Error?) -> Void)
}

///set Error
enum TestServiceError: Error {
    case general
}

//Mark: FakeRegisterResult class for set a Fake user
class FakeRegisterResult: RegisterResult {
    init(appUser: AppUser?) {
        self.appUser = appUser
    }
    
    let appUser: AppUser?
}

///Mark :FakeAppUser class for set identifer as uid
class FakeAppUser: AppUser {
    init(identifier: String) {
        self.identifier = identifier
    }
    
    let identifier: String
}

///Mark: FakeUserService class and responce protocol TestService
class FakeUserService: TestService {
    func Register(email: String, password: String, completionHandler: @escaping (RegisterResult?, Error?) -> Void) {
        if shouldFail{
            completionHandler(nil,TestServiceError.general)
        }
        else{
            let logInResult = FakeRegisterResult(appUser: RegisterResultFakeUser)
            completionHandler(logInResult, nil)
        }
    }
    
    var shouldFail = false
    var RegisterResultFakeUser: FakeAppUser?
}
