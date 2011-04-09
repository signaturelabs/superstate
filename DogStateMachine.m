
#import "DogStateMachine.h"

@interface DogStateMachine(Private) 

// state handlers
- (SEL)happy:(DogEvent *)event;
- (SEL)happy_playful:(DogEvent *)event;
- (SEL)happy_tired:(DogEvent *)event;
- (SEL)unhappy:(DogEvent *)event;

// accessors
- (void)setMyState:(SEL)state;
- (void)setMySource:(SEL)state;
- (SEL)myState;
- (SEL)mySource;

@end

@implementation DogStateMachine

@synthesize delegate;

#pragma mark -
#pragma mark Public

- (void) initialTransition {
	self.myState = @selector(happy_playful:);
}

- (void) dispatch:(DogEvent *)event {
	
	self.mySource = self.myState;
	while (self.mySource != nil) {		
		if ([self respondsToSelector:self.myState]) {
			self.mySource = (SEL) [self performSelector:self.mySource withObject:event];
		}	
	}
	
}

#pragma mark -
#pragma mark Private

- (void)transition:(SEL)state {
	
	// TODO: walk up to LCA, send exit events, then drill down to state and send entry events..
	
	self.myState = state;
	
}

- (void)setMyState:(SEL)state { 
	myState = state; 
} 

- (void)setMySource:(SEL)state { 
	mySource = state; 
} 

- (SEL)myState { 
	return myState; 
}

- (SEL)mySource { 
	return mySource; 
}

- (SEL)happy:(DogEvent *)event {
	switch (event.signal) {
		case GIVE_BURRITO_SIG:
			if ([self.delegate respondsToSelector:@selector(lay_down)])
			{
				[self.delegate performSelector:@selector(lay_down)];
			}	
			
			// transition to tired state
			[self transition:@selector(happy_tired:)];
			
			return nil;			
		default:
			break;
	}
	
	return @selector(top:);
}


- (SEL)happy_tired:(DogEvent *)event {
	switch (event.signal) {
		case THROW_BALL_SIG:
			// do nothing..
			return nil;
		case KICK_SIG:
			if ([self.delegate respondsToSelector:@selector(whimper)])
			{
				[self.delegate performSelector:@selector(whimper)];
			}
			
			// transition to tired state
			[self transition:@selector(unhappy:)];
			
			return nil;		
		default:
			break;
	}
	
	return @selector(happy:);
	
	
}

- (SEL)happy_playful:(DogEvent *)event {
	switch (event.signal) {
		case THROW_BALL_SIG:
			if ([self.delegate respondsToSelector:@selector(play)])
			{
				[self.delegate performSelector:@selector(play)];
			}		
			return nil;
		case KICK_SIG:
			if ([self.delegate respondsToSelector:@selector(bark)])
			{
				[self.delegate performSelector:@selector(bark)];
			}		
			return nil;		
		default:
			break;
	}
	
	return @selector(happy:);
	
	
}

- (SEL)unhappy:(DogEvent *)event {
	switch (event.signal) {
		case THROW_BALL_SIG:
			if ([self.delegate respondsToSelector:@selector(whimper)])
			{
				[self.delegate performSelector:@selector(whimper)];
			}				
			return nil;			
		default:
			break;
	}
	
	return @selector(top:);
}


@end
