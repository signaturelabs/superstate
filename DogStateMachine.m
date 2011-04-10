
#import "DogStateMachine.h"

@interface DogStateMachine(Private) 

- (void)transition:(SEL)state;  // todo: move to statemachine.m

// send an event with given signal to given state handler
// todo: move to statemachine.m
- (SEL)trigger:(SEL)state signal:(int)sig;  

// drill down to correct state
- (void)Q_INIT:(SEL)state;

// top state handler -- TODO: move this to statemachine.m
- (SEL)top:(DogEvent *)event;

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

- (id)init
{
    self = [super init];
    if(self) {
		self.mySource = @selector(initial:);  // todo, move to statemachine.m and pass initial pseudostate to its init
		self.myState = @selector(top:);
    }
    return(self);
}

- (void) executeInitialTransition {  // aka "init" in samek book.  TODO: move to statemachine.m
	
	SEL s;
	s = self.myState;
	if ([self respondsToSelector:self.mySource]) {
		[self performSelector:self.mySource withObject:nil];  // top-most initial transition
	}
	s = self.myState;
	
	[self trigger:s signal:ENTRY_SIG];
	
	while ([self trigger:s signal:INIT_SIG] == nil) {
		s = self.myState;
		[self trigger:s signal:ENTRY_SIG];
	}
	
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

- (void)transition:(SEL)target {
	
	SEL entry[7];
	SEL *e, *lca;
	SEL s, t, p, q;
	
	// exit all states from the currently active state (myState) up to the level in which the 
	// transition is devined (mySource) to cover the case of an inherited state transition. 
	for (s = self.myState; s != self.mySource;) {
		t = [self trigger:s signal:EXIT_SIG];
		if (t) {
			// exit action unhandled, t points to superstate
			s = t;
		}
		else {
			// exit action handled, elicit superstate
			s = [self trigger:s signal:EMPTY_SIG];
		}
	}

	// execute all actions associated with change of state configuration
	
	*(e = &entry[0]) = 0;
	*(++e) = target;
	
	// A. self-transition can be checked directly without probing any superstates.
	// Involves exit from source and entry to target
	if (self.mySource == target) {
		[self trigger:self.mySource signal:EXIT_SIG];
		goto inLca;
	}
	
	// B. source == target->super Requires probing the superstate of the target state
	// Involves only entry to source but no exit from target
	p = [self trigger:target signal:EMPTY_SIG];
	if (self.mySource == p) {
		goto inLca;
	}
	
	// C. source->super == target->super (Most common transition topology) Requires 
	// additional probing of the superstate of the source state.  Involves exit from 
	// source and entry to target
	q = [self trigger:self.mySource signal:EMPTY_SIG];
	if (q == p) {
		[self trigger:self.mySource signal:EXIT_SIG];
		goto inLca;
	}
	
	// D. source->super == target Does not require additional probing.  Involves only exit
	// from source but not entry to target.
	if (q == target) {
		[self trigger:self.mySource signal:EXIT_SIG];
		--e; // do not enter the LCA
		goto inLca;
	}
	
	// E. source == any of target->super .. Requires probing the superstates of the target
	// until a match is found or unitl the top state is reached. 
	*(++e) = p;
	for (s = [self trigger:p signal:EMPTY_SIG]; s; s = [self trigger:s signal:EMPTY_SIG]) {
		if (self.mySource = s) {
			goto inLca;
		}
		*(++e) = s;
	}
	[self trigger:self.mySource signal:EXIT_SIG];  // exit source
	
	// F. source->super == any of target->super ..Requires traversal of the state heirarchy stored
	// in the array entry[] to find the LCA.  
	for (lca = e; *lca; --lca) {
		if (q == *lca) {
			e = lca - 1;
			goto inLca;
		}
	}
	
	// G. any of source->super .. == any of target ..  Requires traversal of the target state heirarchy 
	// stored in the array entry[] for every superstate of source.  Because every scan for a given
	// superstate of the source exhausts all possible matches for the LCA, the source's superstate can be 
	// safely exited.  
	for (s = q; s; s = [self trigger:s signal:EMPTY_SIG]) {
		for (lca = e; *lca; --lca) {
			if (s == *lca) {
				e = lca -1;
				goto inLca;
			}
		}
		[self trigger:s signal:EXIT_SIG];   // exit s
	}
	
inLca:
	
	while (s = *e--) {  // retrace the entry path in the reverse order
		[self trigger:s signal:ENTRY_SIG];
	}
	
	self.myState = target;  // update current state
	
	while ([self trigger:target signal:INIT_SIG] == 0) {
		target = self.myState;
		[self trigger:target signal:ENTRY_SIG];  // enter target
	}
	
}

- (SEL)trigger:(SEL)state signal:(int)sig {
	SEL returnVal;
	SMEvent *evt = [[SMEvent alloc] init];
	evt.signal = sig;
	if ([self respondsToSelector:state]) {
		returnVal = (SEL) [self performSelector:state withObject:evt];
	}
	[evt release];
	return returnVal;
}

- (void)Q_INIT:(SEL)target {
	self.myState = target;
}


- (void)setMyState:(SEL)state { myState = state; } 
- (void)setMySource:(SEL)state { mySource = state; } 
- (SEL)myState { return myState; }
- (SEL)mySource { return mySource; }

- (void)initial:(DogEvent *)event {
	[self Q_INIT:@selector(happy:)];
}

- (SEL)top:(DogEvent *)event {
	return nil;
}

- (SEL)happy:(DogEvent *)event {
	switch (event.signal) {
		case ENTRY_SIG:
			if ([self.delegate respondsToSelector:@selector(bark)])
			{
				[self.delegate performSelector:@selector(bark)];
			}		
			return nil;
		case INIT_SIG:
			[self Q_INIT:@selector(happy_playful:)];		
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
			
		default:
			break;
	}
	
	return @selector(unhappy:);
}



@end
