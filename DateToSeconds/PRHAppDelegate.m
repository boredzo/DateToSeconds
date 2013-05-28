#import "PRHAppDelegate.h"
#import "PRHDateComputationWindowController.h"

@implementation PRHAppDelegate
{
	PRHDateComputationWindowController *_wc;
}

- (void)applicationWillFinishLaunching:(NSNotification *)notification {
	_wc = [[PRHDateComputationWindowController alloc] init];
	[_wc showWindow:nil];
}

- (void) applicationWillTerminate:(NSNotification *)notification {
	[_wc close];
	_wc = nil;
}

@end
