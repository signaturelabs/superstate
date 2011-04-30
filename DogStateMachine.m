
#import "DogStateMachine.h"
#import "StateMachine+Protected.h"

@interface DogStateMachine(Private) 

// initial pseudostate handler
- (void)initial:(DogEvent *)event;

// state handlers
- (SEL)happy:(DogEvent *)event;
- (SEL)happy_playful:(DogEvent *)event;
- (SEL)happy_tired:(DogEvent *)event;
- (SEL)happy_wasted:(DogEvent *)event;
- (SEL)unhappy:(DogEvent *)event;
- (SEL)unhappy_hurt:(DogEvent *)event;
- (SEL)unhappy_sick:(DogEvent *)event;

@end

@implementation DogStateMachine

@synthesize delegate;

#pragma mark -
#pragma mark Public

- (id)init
{
    self = [super initWithInitialPseudostate:@selector(initialPseudostate:)];
    if(self) {
		// custom init goes here..
    }
    return(self);
}

#pragma mark -
#pragma mark Initial Pseudostate handler (Private)

- (void)initialPseudostate:(DogEvent *)event {
	[self drillDown:@selector(happy:)];  	// the dog starts out as being happy.
}


#pragma mark -
#pragma mark State handlers (Private)

- (SEL)happy:(DogEvent *)event {
	switch (event.signal) {
		case ENTRY_SIG:
			if ([self.delegate respondsToSelector:@selector(bark)])
			{
				[self.delegate performSelector:@selector(bark)];
			}		
			return nil;
		case INIT_SIG:
			[self drillDown:@selector(happy_playful:)];		
			return nil;
		case GIVE_BURRITO_SIG:
			if ([self.delegate respondsToSelector:@selector(lay_down)])
			{
				[self.delegate performSelector:@selector(lay_down)];
			}	
			
			[self transition:@selector(happy_tired:)];
			
			return nil;			
		case GIVE_WHISKEY_SIG:			
			[self transition:@selector(happy_wasted:)];

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
			
			[self transition:@selector(unhappy:)];
			
			return nil;		
		default:
			break;
	}
	
	return @selector(happy:);
	
	
}

- (SEL)happy_playful:(DogEvent *)event {
	switch (event.signal) {
		case ENTRY_SIG:
			if ([self.delegate respondsToSelector:@selector(get_up)])
			{
				[self.delegate performSelector:@selector(get_up)];
			}		
			return nil;
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

- (SEL)happy_wasted:(DogEvent *)event {
	switch (event.signal) {
		case ENTRY_SIG:
			if ([self.delegate respondsToSelector:@selector(burp)])
			{
				[self.delegate performSelector:@selector(burp)];
			}		
			return nil;
		case THROW_BALL_SIG:
			if ([self.delegate respondsToSelector:@selector(backflip)])
			{
				[self.delegate performSelector:@selector(backflip)];
			}		
			return nil;
		case GIVE_WHISKEY_SIG:
			if ([self.delegate respondsToSelector:@selector(vomit)])
			{
				[self.delegate performSelector:@selector(vomit)];
			}		
			[self transition:@selector(unhappy_sick:)];
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
		case KICK_SIG:
			if ([self.delegate respondsToSelector:@selector(whimper)])
			{
				[self.delegate performSelector:@selector(whimper)];
			}
			
			[self transition:@selector(unhappy_hurt:)];
			
			return nil;	
		case PET_SIG:
			
			[self transition:@selector(happy_playful:)];
			
			return nil;	
			
		default:
			break;
	}
	
	return @selector(top:);
}

- (SEL)unhappy_hurt:(DogEvent *)event {
	switch (event.signal) {
		case EXIT_SIG:
			if ([self.delegate respondsToSelector:@selector(whimper)])
			{
				[self.delegate performSelector:@selector(whimper)];
			}				
			return nil;	
		case GIVE_BURRITO_SIG:
			[self transition:@selector(unhappy_hurt:)];
			return nil;	
		default:
			break;
	}
	
	return @selector(unhappy:);
}

- (SEL)unhappy_sick:(DogEvent *)event {
	switch (event.signal) {
        case EXIT_SIG:
			if ([self.delegate respondsToSelector:@selector(burp)])
			{
				[self.delegate performSelector:@selector(burp)];
			}				
			return nil;	
		case GIVE_BURRITO_SIG:
			if ([self.delegate respondsToSelector:@selector(whimper)])
			{
				[self.delegate performSelector:@selector(whimper)];
			}				
			return nil;	
		case KICK_SIG:
			if ([self.delegate respondsToSelector:@selector(bite)])
			{
				[self.delegate performSelector:@selector(bite)];
			}				
			return nil;	
		case THROW_BONE_SIG:
			
			[self transition:@selector(happy:)];
			
			return nil;	
			
		default:
			break;
	}
	
	return @selector(unhappy:);
}



@end
