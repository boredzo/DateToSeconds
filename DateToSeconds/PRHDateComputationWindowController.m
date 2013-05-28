#import "PRHDateComputationWindowController.h"

@interface PRHDateComputationWindowController ()

@property NSDate *selectedDate;
@property bool shouldConvertDateToGMT;
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
	return [NSSet setWithArray:@[ @"selectedDate", @"shouldConvertDateToGMT" ]];
}
- (NSTimeInterval) timeIntervalSinceReferenceDate {
	return [[self dateInDesiredTimeZone:self.selectedDate] timeIntervalSinceReferenceDate];
}

+ (NSSet *) keyPathsForValuesAffectingTimeIntervalSince1970 {
	return [NSSet setWithArray:@[ @"selectedDate", @"shouldConvertDateToGMT" ]];
}
- (NSTimeInterval) timeIntervalSince1970 {
	return [[self dateInDesiredTimeZone:self.selectedDate] timeIntervalSince1970];
}

- (NSDate *) dateInDesiredTimeZone:(NSDate *)date {
	if (self.shouldConvertDateToGMT) {
		NSDate *dateInLocalTZ = date;
		NSTimeZone *localTZ = [NSTimeZone localTimeZone];
		NSInteger secondsFromGMT = [localTZ secondsFromGMTForDate:dateInLocalTZ];
		date = [dateInLocalTZ dateByAddingTimeInterval:secondsFromGMT];
	}
	return date;
}

@end
