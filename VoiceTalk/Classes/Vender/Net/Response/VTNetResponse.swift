//
//  VTNetResponse.swift
//  VoiceTalk
//
//  Created by 刘冉 on 2021/12/10.
//  Copyright © 2021 macos. All rights reserved.
//

import Foundation

func handleNetResponse(_ response: Moya.Response) throws -> Any {
    do {
        let json = try response.mapJSON();
        return json
    } catch (let error as Moya.MoyaError) {
        throw VTNetworkError.init(error: error)
    } catch {
        throw VTNetworkError.underlying(NSError(domain: "UnderlyingDomain", code: 200, userInfo: nil), nil)
    }
}
