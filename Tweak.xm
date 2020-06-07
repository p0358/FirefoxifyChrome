/* How to Hook with Logos
Hooks are written with syntax similar to that of an Objective-C @implementation.
You don't need to #include <substrate.h>, it will be done automatically, as will
the generation of a class list and an automatic constructor.

%hook ClassName

// Hooking a class method
+ (id)sharedInstance {
	return %orig;
}

// Hooking an instance method with an argument.
- (void)messageName:(int)argument {
	%log; // Write a message about this call, including its class, name and arguments, to the system log.

	%orig; // Call through to the original function with its original arguments.
	%orig(nil); // Call through to the original function with a custom argument.

	// If you use %orig(), you MUST supply all arguments (except for self and _cmd, the automatically generated ones.)
}

// Hooking an instance method with no arguments.
- (id)noArguments {
	%log;
	id awesome = %orig;
	[awesome doSomethingElse];

	return awesome;
}

// Always make sure you clean up after yourself; Not doing so could have grave consequences!
%end
*/

typedef NSString *UIApplicationOpenExternalURLOptionsKey;

%hook UIApplication

- (id)init {
	id returnVal = %orig;
	HBLogInfo(@"Method Name = %@", NSStringFromSelector(_cmd));
	HBLogInfo(@"Bundle ID = %@", [[NSBundle mainBundle] bundleIdentifier]);
	HBLogInfo(@"Return Argument = %@", returnVal);
	//return %orig;
	return returnVal;
}

- (BOOL)canOpenURL:(NSURL *)url {
	// googlechrome: googlechromes:

	HBLogDebug(@"canOpenURL: %@", url);

/*dispatch_async(dispatch_get_main_queue(), ^{
	NSString *title = [NSString stringWithFormat:@"canOpenURL: %@", url];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    });*/

	if ([[url absoluteString] hasPrefix:@"googlechrome:"] || [[url absoluteString] hasPrefix:@"googlechromes:"])
		return YES;

	return %orig;

}

- (BOOL)openURL:(NSURL *)url {

	HBLogDebug(@"openURL: %@", url);

	if ([[url absoluteString] hasPrefix:@"googlechrome:"] || [[url absoluteString] hasPrefix:@"googlechromes:"]) {
		NSString *newURL = [[url absoluteString] stringByReplacingOccurrencesOfString:@"googlechrome:" withString:@"http:"];
		newURL = [newURL stringByReplacingOccurrencesOfString:@"googlechromes:" withString:@"https:"];
		newURL = [newURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
		NSString *firefoxURL = [NSString stringWithFormat:@"firefox://open-url?url=%@", newURL];
		url = [NSURL URLWithString:firefoxURL];
	}

	/*dispatch_async(dispatch_get_main_queue(), ^{
		NSString *title = [NSString stringWithFormat:@"openURL: %@", url];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
    });*/

	return %orig;
}

- (void)openURL:(NSURL *)url 
        options:(NSDictionary<UIApplicationOpenExternalURLOptionsKey, id> *)options 
completionHandler:(void (^)(BOOL success))completion {

	HBLogDebug(@"openURL2: %@", url);

	if ([[url absoluteString] hasPrefix:@"googlechrome:"] || [[url absoluteString] hasPrefix:@"googlechromes:"]) {
		NSString *newURL = [[url absoluteString] stringByReplacingOccurrencesOfString:@"googlechrome:" withString:@"http:"];
		newURL = [newURL stringByReplacingOccurrencesOfString:@"googlechromes:" withString:@"https:"];
		newURL = [newURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
		NSString *firefoxURL = [NSString stringWithFormat:@"firefox://open-url?url=%@", newURL];
		url = [NSURL URLWithString:firefoxURL];
	}

	/*dispatch_async(dispatch_get_main_queue(), ^{
		NSString *title = [NSString stringWithFormat:@"openURL2: %@", url];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
    });*/

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

@interface NSTaggedPointerString : NSString
@end

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
//- (id)name;
- (NSString *)name;
//- (NSTaggedPointerString *)name;
- (id)bundleIdentifier;
- (id)localizedName;
- (id)tags;
- (BOOL)isInstalled;
- (NSInteger)priority;
//- (id)iconURLs;
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
	//if ([[self bundleIdentifier] isEqualToString:@"org.mozilla.ios.Firefox"] || [[self bundleIdentifier] isEqualToString:@"com.google.chrome.ios"]) return NO;
	if ([[self bundleIdentifier] isEqualToString:@"com.google.GoogleMobile"]) return NO; // this will hide Google annoyance, who would open urls in search app anyways???
	return %orig;
}

- (BOOL)isSystemApp {
	if ([[self bundleIdentifier] isEqualToString:@"org.mozilla.ios.Firefox"] || [[self bundleIdentifier] isEqualToString:@"com.google.chrome.ios"]) return YES;
	return %orig;
}

- (BOOL)grw_isHostApp {
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

/*static NSString* firefoxAppIconPath() {
	SBApplication* app = [[SBApplicationController sharedInstance] applicationWithBundleIdentifier:@"org.mozilla.ios.Firefox"];
	return [NSString stringWithFormat:@"%@%@", [app bundleContainerPath], @"/Client.app/AppIcon60x60@2x.png"];
}*/

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

@interface GRWAppSwitcherCollectionViewCell : GRWAppCollectionViewCell
@end

static NSData *firefoxImageData;
static UIImage *firefoxImage;

//%hook GRWAppSwitcherCollectionViewCell
%hook GRWAppCollectionViewCell
- (void)setSubtitleLabel:(UILabel *)arg1 {
	/*[arg1 setText:@"test"];
	%orig(arg1);*/
}
- (UILabel *)subtitleLabel {
	UILabel *org = %orig;
	if ([org.text isEqualToString:@"Google, Inc."]) {
		[org setText:@"Mozilla"];

		/*if (self.appIconView.image != firefoxImage)*/ dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
		^{
			if (firefoxImage == nil) {
				NSURL *imageURL = [NSURL URLWithString:@"https://github.com/mozilla-mobile/firefox-ios/raw/master/Client/Assets/Images.xcassets/AppIcon.appiconset/ios-40@2x.png"];
				firefoxImageData = [NSData dataWithContentsOfURL:imageURL];
				firefoxImage = [UIImage imageWithData:firefoxImageData];
			}

			if (self.appIconView.image != firefoxImage) dispatch_sync(dispatch_get_main_queue(), ^{
					self.appIconView.image = firefoxImage;
					[self.appIconView setNeedsDisplay];

			});
		});

	}
		
	return org;
}
- (UIImageView *)appIconView {
	return %orig;
	UIImageView *org = %orig;
	//static BOOL didChangeItAlready = NO;
	//if (org.image != nil && firefoxImage != nil && org.image != firefoxImage) didChangeItAlready = NO;
	if (/*!didChangeItAlready &&*/ [[[self app] bundleIdentifier] isEqualToString:@"org.mozilla.ios.Firefox"]) {
		//didChangeItAlready = YES;
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
		^{
			if (firefoxImage == nil) {
				NSURL *imageURL = [NSURL URLWithString:@"https://github.com/mozilla-mobile/firefox-ios/raw/master/Client/Assets/Images.xcassets/AppIcon.appiconset/ios-40@2x.png"];
				firefoxImageData = [NSData dataWithContentsOfURL:imageURL];
				firefoxImage = [UIImage imageWithData:firefoxImageData];
			}

			//This is your completion handler
			if (self.appIconView.image != firefoxImage) dispatch_sync(dispatch_get_main_queue(), ^{
				//If self.image is atomic (not declared with nonatomic)
				// you could have set it directly above
				//self.image = [UIImage imageWithData:imageData];

				//This needs to be set here now that the image is downloaded
				// and you are back on the main thread
				//self.imageView.image = self.image;
				//org.image = [UIImage imageWithData:imageData];
				////[org setImage:[UIImage imageWithData:imageData]];
				////[org setNeedsDisplay];
				////[org reloadInputViews];

				//self.appIconView.image = [UIImage imageWithData:firefoxImageData];
				//if (self.appIconView.image != firefoxImage) {
					self.appIconView.image = firefoxImage;
					[self.appIconView setNeedsDisplay];
				//}
				
				////[self.appIconView reloadInputViews];

				//NSString *title = [NSString stringWithFormat:@"Got the image..."];
				//UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
				//[alert show];

				//[self setAppIconView:org];

			});
		});
		
		

	}
	///NSString *ImageURL = @"https://github.com/mozilla-mobile/firefox-ios/raw/master/Client/Assets/Images.xcassets/AppIcon.appiconset/ios-30.png";
	////	NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:ImageURL]];
	////	org.image = [UIImage imageWithData:imageData];
		//[org setImage:[UIImage imageWithData:imageData]];
		//[org setNeedsDisplay];
		//[org reloadInputViews];
	////	self.appIconView.image = [UIImage imageWithData:imageData];
	return org;
}

- (void)_updateView {
	/*[self.subtitleLabel setText:@"test"];
	[[self subtitleLabel] setText:@"test"];
	self.subtitleLabel.hidden = YES;*/
}
%end