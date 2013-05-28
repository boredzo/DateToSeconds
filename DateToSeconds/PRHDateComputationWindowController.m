#import "PRHDateComputationWindowController.h"

typedef NS_ENUM(NSUInteger, PRHTimeZoneSelection) {
	PRHTimeZoneLocal,
	PRHTimeZoneGMT,
	PRHTimeZoneCustom,
};

@interface PRHDateComputationWindowController ()

@property NSDate *selectedDate;
@property PRHTimeZoneSelection timeZoneSelection;
@property(copy) NSString *customTimeZoneOffset;
@property(nonatomic, readonly) NSTimeInterval timeIntervalSinceReferenceDate;
@property(nonatomic, readonly) NSTimeInterval timeIntervalSince1970;

@end

@implementation PRHDateComputationWindowController

- (id) initWithWindow:(NSWindow *)window {
	if ((self = [super initWithWindow:window])) {

	}
	return self;
}

- (id) init {
	return [self initWithWindowNibName:NSStringFromClass([self class]) owner:self];
}


- (void) windowDidLoad {
	[super windowDidLoad];

	// Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

+ (NSSet *) keyPathsForValuesAffectingTimeIntervalSinceReferenceDate {
	return [NSSet setWithArray:@[ @"selectedDate", @"timeZoneSelection", @"customTimeZoneOffset" ]];
}
- (NSTimeInterval) timeIntervalSinceReferenceDate {
	return [[self dateInDesiredTimeZone:self.selectedDate] timeIntervalSinceReferenceDate];
}

+ (NSSet *) keyPathsForValuesAffectingTimeIntervalSince1970 {
	return [NSSet setWithArray:@[ @"selectedDate", @"timeZoneSelection", @"customTimeZoneOffset" ]];
}
- (NSTimeInterval) timeIntervalSince1970 {
	return [[self dateInDesiredTimeZone:self.selectedDate] timeIntervalSince1970];
}

- (NSDate *) dateInDesiredTimeZone:(NSDate *)localDate {
	NSDate *date = localDate;
	if (self.timeZoneSelection != PRHTimeZoneLocal) {
		NSDate *dateInLocalTZ = localDate;
		NSTimeZone *localTZ = [NSTimeZone localTimeZone];
		NSInteger secondsFromGMT = [localTZ secondsFromGMTForDate:dateInLocalTZ];
		date = [dateInLocalTZ dateByAddingTimeInterval:secondsFromGMT];

		if (self.timeZoneSelection == PRHTimeZoneCustom) {
			static NSRegularExpression *timeZoneOffsetExp = nil;
			if (!timeZoneOffsetExp) {
				timeZoneOffsetExp = [NSRegularExpression regularExpressionWithPattern:@"([-+])([0-9]{2})([0-9]{2})" options:0 error:NULL];
			}
			NSString *offsetString = self.customTimeZoneOffset;
			if (offsetString != nil) {
				NSTextCheckingResult *result = [timeZoneOffsetExp firstMatchInString:offsetString options:NSMatchingAnchored range:(NSRange){ 0, offsetString.length }];
				NSString *sign = [offsetString substringWithRange:[result rangeAtIndex:1]];
				NSString *hours = [offsetString substringWithRange:[result rangeAtIndex:2]];
				NSString *minutes = [offsetString substringWithRange:[result rangeAtIndex:3]];
				NSInteger offset = (([hours integerValue] * 3600L) + ([minutes integerValue] * 60L)) * ([sign isEqualToString:@"-"] ? -1L : +1L);
				NSTimeZone *timeZone = [NSTimeZone timeZoneForSecondsFromGMT:offset];
				secondsFromGMT = [timeZone secondsFromGMTForDate:date];
				date = [date dateByAddingTimeInterval:-secondsFromGMT];
			}
		}
	}

	return date;
}

@end
