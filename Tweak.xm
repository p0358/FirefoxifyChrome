typedef NSString *UIApplicationOpenExternalURLOptionsKey;

NSCharacterSet *customCharacterset = [[NSCharacterSet characterSetWithCharactersInString:@"!*'();:@&=+$,/?%#[]\\<>^`{|} "] invertedSet];

%hook UIApplication

- (BOOL)canOpenURL:(NSURL *)url {
	// googlechrome: googlechromes:

	HBLogDebug(@"canOpenURL: %@", url);

	if ([[url absoluteString] hasPrefix:@"googlechrome:"] || [[url absoluteString] hasPrefix:@"googlechromes:"])
		return YES;

	return %orig;

}

- (BOOL)openURL:(NSURL *)url {

	HBLogDebug(@"openURL: %@", url);

	if ([[url absoluteString] hasPrefix:@"googlechrome:"] || [[url absoluteString] hasPrefix:@"googlechromes:"]) {
		NSString *newURL = [[url absoluteString] stringByReplacingOccurrencesOfString:@"googlechrome:" withString:@"http:"];
		newURL = [newURL stringByReplacingOccurrencesOfString:@"googlechromes:" withString:@"https:"];
		//newURL = [newURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
		newURL = [newURL stringByAddingPercentEncodingWithAllowedCharacters:customCharacterset];
		NSString *firefoxURL = [NSString stringWithFormat:@"firefox://open-url?url=%@", newURL];
		url = [NSURL URLWithString:firefoxURL];
	}

	return %orig;
}

- (void)openURL:(NSURL *)url 
        options:(NSDictionary<UIApplicationOpenExternalURLOptionsKey, id> *)options 
completionHandler:(void (^)(BOOL success))completion {

	HBLogDebug(@"openURL2: %@", url);

	if ([[url absoluteString] hasPrefix:@"googlechrome:"] || [[url absoluteString] hasPrefix:@"googlechromes:"]) {
		NSString *newURL = [[url absoluteString] stringByReplacingOccurrencesOfString:@"googlechrome:" withString:@"http:"];
		newURL = [newURL stringByReplacingOccurrencesOfString:@"googlechromes:" withString:@"https:"];
		//newURL = [newURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
		newURL = [newURL stringByAddingPercentEncodingWithAllowedCharacters:customCharacterset];
		NSString *firefoxURL = [NSString stringWithFormat:@"firefox://open-url?url=%@", newURL];
		url = [NSURL URLWithString:firefoxURL];
	}

	%orig;
}

%end

static NSDictionary *firefoxIcons = @{
	/*40: @"https://github.com/mozilla-mobile/firefox-ios/raw/master/Extensions/ShareTo/Images.xcassets/Icon-Small.imageset/icon-40.png",
	80: @"https://github.com/mozilla-mobile/firefox-ios/raw/master/Extensions/ShareTo/Images.xcassets/Icon-Small.imageset/icon-40@2x.png",
	120: @"https://github.com/mozilla-mobile/firefox-ios/raw/master/Extensions/ShareTo/Images.xcassets/Icon-Small.imageset/icon-40@3x.png",*/
	@29: @"https://github.com/mozilla-mobile/firefox-ios/raw/master/Client/Assets/Images.xcassets/AppIcon.appiconset/ios-29.png",
	@58: @"https://github.com/mozilla-mobile/firefox-ios/raw/master/Client/Assets/Images.xcassets/AppIcon.appiconset/ios-29@2x.png",
	@57: @"https://github.com/mozilla-mobile/firefox-ios/raw/master/Client/Assets/Images.xcassets/AppIcon.appiconset/ios-29@2x-1.png",
	@40: @"https://github.com/mozilla-mobile/firefox-ios/raw/master/Client/Assets/Images.xcassets/AppIcon.appiconset/ios-40.png",
	@80: @"https://github.com/mozilla-mobile/firefox-ios/raw/master/Client/Assets/Images.xcassets/AppIcon.appiconset/ios-40@2x.png",
	@79: @"https://github.com/mozilla-mobile/firefox-ios/raw/master/Client/Assets/Images.xcassets/AppIcon.appiconset/ios-40@2x-1.png",
	@20: @"https://github.com/mozilla-mobile/firefox-ios/raw/master/Client/Assets/Images.xcassets/AppIcon.appiconset/ios-20.png",
	@40: @"https://github.com/mozilla-mobile/firefox-ios/raw/master/Client/Assets/Images.xcassets/AppIcon.appiconset/ios-20@2x.png",
	@39: @"https://github.com/mozilla-mobile/firefox-ios/raw/master/Client/Assets/Images.xcassets/AppIcon.appiconset/ios-20@2x-1.png",
	@60: @"https://github.com/mozilla-mobile/firefox-ios/raw/master/Client/Assets/Images.xcassets/AppIcon.appiconset/ios-20@3x.png",
	@30: @"https://github.com/mozilla-mobile/firefox-ios/raw/master/Client/Assets/Images.xcassets/AppIcon.appiconset/ios-30.png",
	@76: @"https://github.com/mozilla-mobile/firefox-ios/raw/master/Client/Assets/Images.xcassets/AppIcon.appiconset/ios-ipad-76.png",
	@152: @"https://github.com/mozilla-mobile/firefox-ios/raw/master/Client/Assets/Images.xcassets/AppIcon.appiconset/ios-ipad-76@2x.png",
	@167: @"https://github.com/mozilla-mobile/firefox-ios/raw/master/Client/Assets/Images.xcassets/AppIcon.appiconset/ios-ipad-pro-83.5@2x.png",
	@1024: @"https://github.com/mozilla-mobile/firefox-ios/raw/master/Client/Assets/Images.xcassets/AppIcon.appiconset/icon-apple-app-store.png"
};

@interface GRWApp : NSObject
{
	BOOL _systemApp;
	BOOL _authUserEnabled;
	BOOL _googleOwnedApp;
	BOOL _isPromoted;
	NSString *_name;
	NSString *_bundleIdentifier; // com.google.chrome.ios => org.mozilla.ios.Firefox
	NSInteger _priority;
	NSString *_storeID; // 535886823 => 989804926
	CGFloat _appRating;
	NSInteger _numberOfAppRatings;
	NSString *_openURLScheme;
	NSString *_appDescription;
	NSDictionary *_iconURLs;
}

- (BOOL)isGoogleOwnedApp;
- (BOOL)grw_isHostApp;
- (BOOL)grw_isChrome;
- (NSString *)name;
- (id)bundleIdentifier;
- (id)localizedName;
- (id)tags;
- (BOOL)isInstalled;
- (NSInteger)priority;
- (NSDictionary *)iconURLs;
- (id)storeID;
- (BOOL)isPromoted;
- (BOOL)isSystemApp;
- (NSUInteger)iconURLsCount;
- (BOOL)isEqualToApp:(id)arg1;
- (id)appDescription;
@end

%hook GRWApp
- (BOOL)isGoogleOwnedApp {
	//if ([[self bundleIdentifier] isEqualToString:@"org.mozilla.ios.Firefox"] || [[self bundleIdentifier] isEqualToString:@"com.google.chrome.ios"]) return NO; // I wanted to hide "Google, Inc.", but apparently changing this from code was hiding the app from the list...
	if ([[self bundleIdentifier] isEqualToString:@"com.google.GoogleMobile"]) return NO; // this will hide Google annoyance, who would open urls in search app anyways???
	return %orig;
}

- (BOOL)isSystemApp {
	if ([[self bundleIdentifier] isEqualToString:@"org.mozilla.ios.Firefox"] || [[self bundleIdentifier] isEqualToString:@"com.google.chrome.ios"]) return YES;
	return %orig;
}

- (BOOL)grw_isHostApp {
	// YES would cause the app to be used regardless of user settings
	//if ([[self bundleIdentifier] isEqualToString:@"org.mozilla.ios.Firefox"] || [[self bundleIdentifier] isEqualToString:@"com.google.chrome.ios"]) return YES;
	return %orig;
}

- (id)storeID {
	NSString *store_id = %orig;
	if ([store_id isEqualToString:@"535886823"]) return [NSString stringWithFormat:@"%@", @"989804926"];
	return %orig;
}

- (id)bundleIdentifier {
	NSString *bundle_id = %orig;
	if ([bundle_id isEqualToString:@"com.google.chrome.ios"]) return [NSString stringWithFormat:@"%@", @"org.mozilla.ios.Firefox"];
	return %orig;
}

- (NSString *)name {
	if ([[self bundleIdentifier] isEqualToString:@"org.mozilla.ios.Firefox"] || [[self bundleIdentifier] isEqualToString:@"com.google.chrome.ios"])
		return [NSString stringWithFormat:@"%@", @"Firefox"];
	return %orig;
}

// these are unused anyways, eh...
- (NSDictionary *)iconURLs {
	if ([[self bundleIdentifier] isEqualToString:@"org.mozilla.ios.Firefox"] || [[self bundleIdentifier] isEqualToString:@"com.google.chrome.ios"])
		return firefoxIcons;
	return %orig;
}

- (NSUInteger)iconURLsCount {
	if ([[self bundleIdentifier] isEqualToString:@"org.mozilla.ios.Firefox"] || [[self bundleIdentifier] isEqualToString:@"com.google.chrome.ios"])
		return 15ul;
	return %orig;
}
%end

// YouTube

@interface GRWAppCollectionViewCell : UIView
{
	UIImageView *_appIconView;
	UIView *_subtitleLabel;
	BOOL _showRecommendedLabel;
	GRWApp *_app;
}
@property (nonatomic, strong, readwrite) UIImageView *appIconView;
@property (nonatomic, strong, readwrite) UILabel *subtitleLabel;
@property (nonatomic, assign, readonly) GRWApp *app;
- (void)setSubtitleLabel:(UILabel *)arg1;
- (UIImageView *)appIconView;
- (void)setAppIconView:(UIImageView *)arg1;
- (UILabel *)subtitleLabel;
- (GRWApp *)app;
@end

// load them from the internet just once
static NSData *firefoxImageData;
static UIImage *firefoxImage;

%hook GRWAppCollectionViewCell
- (void)setSubtitleLabel:(UILabel *)arg1 {
	/*[arg1 setText:@"test"];
	%orig(arg1);*/
}

- (UILabel *)subtitleLabel {
	UILabel *org = %orig;
	if ([org.text isEqualToString:@"Google, Inc."]) {
		[org setText:@"Mozilla"];

		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
		^{
			if (firefoxImage == nil) {
				//NSURL *imageURL = [NSURL URLWithString:@"https://github.com/mozilla-mobile/firefox-ios/raw/master/Client/Assets/Images.xcassets/AppIcon.appiconset/ios-40@2x.png"];
				//firefoxImageData = [NSData dataWithContentsOfURL:imageURL];
				//firefoxImage = [UIImage imageWithData:firefoxImageData];
				firefoxImage = [UIImage imageWithContentsOfFile:@"/var/mobile/Library/Application Support/FirefoxifyChrome/firefox-ios-40@2x.png"];
			}

			if (self.appIconView.image != firefoxImage) // the check cannot be done on before dispatch_async
			dispatch_sync(dispatch_get_main_queue(), ^{
				self.appIconView.image = firefoxImage;
				[self.appIconView setNeedsDisplay];
			});
		});

	}
		
	return org;
}
%end

// Reddit
// inspired by: https://github.com/lint/TFDidThatSay

@interface PostActionSheetViewController : UIViewController
@end

@interface RUIActionSheetItem : NSObject
@property(strong, nonatomic) UIImage *leftIconImage;
@property(strong, nonatomic) NSString *identifier;
- (void)setLeftIconImage:(UIImage *)arg1;
- (void)setAttributedText:(id)arg1;
@end

%hook PostActionSheetViewController

- (void)setItems:(id)arg1 {
	for (RUIActionSheetItem *item in (NSArray *)arg1) {
		if ([[item identifier] isEqualToString:@"kActionOpenInChromeID"]) {

			// Text
			[item setAttributedText:[[NSAttributedString alloc] initWithString:@"Open in Firefox"]];

			// Image
			UIImage* origImage = [UIImage imageWithContentsOfFile:@"/var/mobile/Library/Application Support/FirefoxifyChrome/firefox-256-dark.png"];

			CGSize existingImageSize = [[item leftIconImage] size];
			CGFloat scale = origImage.size.width / existingImageSize.width;

			UIImage *newImage = [UIImage imageWithCGImage:[origImage CGImage] scale:scale orientation:origImage.imageOrientation];
			[item setLeftIconImage:newImage]; // in dark mode it will be automatically inverted by the app (to light icon)
			break;
		}
	}

	%orig;
}
%end
