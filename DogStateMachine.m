
#import "DogStateMachine.h"

@implementation DogStateMachine

@synthesize delegate;

- (void) initialTransition {
	
}

- (void) dispatch:(DogEvent *)event {
	
	/*
	if ([self.delegate respondsToSelector:@selector(bark)])
	{
		[self.delegate performSelector:@selector(bark)];
	}
	*/
	
}

@end
