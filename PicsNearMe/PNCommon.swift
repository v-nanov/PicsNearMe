//
//  PNCommon.swift
//  PicsNearMe
//
//  Created by Derrick Ho on 3/4/16.
//  Copyright © 2016 dnthome. All rights reserved.
//

var ACCESS_TOKEN: String {
	return PNInstagramSessionManager.sharedInstance.sessionID
}

enum PNInstagramConstants: String {
	case LOGOUT = "https://instagram.com/accounts/logout/"
	case BASE_URL = "https://api.instagram.com/"
	case QUERY_TYPE = "v1/media/search"
	case CLIENT_ID = "1677ed07ddd54db0a70f14f9b1435579"
	case REDIRECT_URI = "http://instagram.pixelunion.net"
	case AUTH_URL = "https://instagram.com/oauth/authorize/" 
	case API_URL = "https://api.instagram.com/v1/users/"
	case TimeOut = "30"
}
//https://instagram.com/oauth/authorize/?client_id=1677ed07ddd54db0a70f14f9b1435579&redirect_uri=http://instagram.pixelunion.net&response_type=token

enum PNImages: String {
	case generic_image
	case LoginBackgroundPattern
	case travel
	
	var image: UIImage {
		return UIImage(named: self.rawValue) ?? UIImage()
	}
}

enum PNError: ErrorType {
	case DownloadError
	case DataConversionError
	case CacheFetchError
}

func typeAsString<T>(type: T.Type) -> String {
	return "\(type)".componentsSeparatedByString(".").last!
}
