
#import "SMEvent.h"

@implementation SMEvent

@synthesize signal;

- (id)initWithSignal:(int)signal {
	self = [super init];
	if (self) {
		self.signal = signal;
	}
	return self;
	
}


@end
