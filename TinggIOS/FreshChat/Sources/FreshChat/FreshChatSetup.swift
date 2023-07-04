import FreshchatSDK

public struct FreshChatSetup {
    public private(set) var text = "Hello, World!"
    public var appID: String
    public var appKey: String
    
    public init(appID: String, appKey: String) {
        self.appID = appID
        self.appKey = appKey
        let freshchatConfig = FreshchatConfig(appID: appID, andAppKey: appKey)
        freshchatConfig.gallerySelectionEnabled = true;
        freshchatConfig.cameraCaptureEnabled = true;
        freshchatConfig.teamMemberInfoVisible = true;
        freshchatConfig.showNotificationBanner = true;
        Freshchat.sharedInstance().initWith(freshchatConfig)
    }
    
    public func setUser(user: TinggFreshChatUser) {
        let user = FreshchatUser.sharedInstance();
        user.firstName = user.firstName
        user.lastName = user.lastName
        user.email = user.email
        user.phoneCountryCode = user.phoneCountryCode
        user.phoneNumber = user.phoneNumber
        Freshchat.sharedInstance().setUser(user)
    }
}


public struct TinggFreshChatUser {
    public var firstName: String
    public var lastName: String
    public var email: String
    public var phoneCountryCode: String
    public var phoneNumber: String
}

