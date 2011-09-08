
#import "SMEvent.h"

@implementation SMEvent

@synthesize signal;

- (id)initWithSignal:(int)_signal {
	self = [super init];
	if (self) {
		self.signal = _signal;
	}
	return self;
	
}


@end
