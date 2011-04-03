
#import "DogStateMachine.h"

@implementation DogStateMachine

@synthesize delegate;

- (void) initialTransition {
	
}

- (void) dispatch:(DogEvent *)event {
	
	// NOTE: this is ALL WRONG!!! just fake it to bootstrap the test suite
	
	switch (event.signal) {
		case THROW_BALL_SIG:
			if ([self.delegate respondsToSelector:@selector(play)])
			{
				[self.delegate performSelector:@selector(play)];
			}		
			break;
		case KICK_SIG:
			if ([self.delegate respondsToSelector:@selector(bark)])
			{
				[self.delegate performSelector:@selector(bark)];
			}		
			break;
		case GIVE_BURRITO_SIG:
			if ([self.delegate respondsToSelector:@selector(lay_down)])
			{
				[self.delegate performSelector:@selector(lay_down)];
			}		
			break;
			
		default:
			break;
	}
	
		
}

@end
