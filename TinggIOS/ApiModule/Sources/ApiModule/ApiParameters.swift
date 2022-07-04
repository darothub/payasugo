//
//  File.swift
//  
//
//  Created by Abdulrasaq on 30/06/2022.
//

import Foundation
let parameters = [
        "SERVICE": "",
        "MSISDN": "TinggAuth.getInstance().getProfile()?.msisdn",
        "UUID": "DeviceUtils.getGSFID(context)",
        "CLIENT_ID": "TinggAuth.getInstance().getActiveCountry()?.clientId ?: KENYA_CLIENT_ID",
        "DATA_SOURCE": "TinggAuth.getInstance().getActiveCountry()?.name",
        "APP_VERSION": "AppBuildConfig.VERSION_NAME",
        "ORIGIN": "REQUEST_ORIGIN",
        "IS_LIVE_API": "true",
        "DEVICE_NAME": "DeviceUtils.getDeviceName()",
        "API_LEVEL": "Build.VERSION.SDK_INT",
        "OS_VERSION": "Build.VERSION.RELEASE",
        "OS_TYPE": "iOS",
        "IS_MAIN": "1",
        "PARSE_INSTALLATION_ID": "TinggAuth.getInstance().getFCMToken()"
]

enum ParameterValues {
//    case
}
