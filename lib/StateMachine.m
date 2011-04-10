
#import "StateMachine.h"
#import "StateMachine+Protected.h"

@implementation StateMachine

- (id)init {
	// if you call this, which you are not supposed to, we are gonna blow up.  *kaboom*
	[NSException raise:@"Invalid initializer" format:@"Call initWithInitialPseudostate instead"];
	return nil;
}

- (id)initWithInitialPseudostate:(SEL)pseudostate
{
    self = [super init];
    if(self) {
		self.mySource = pseudostate;  
		self.myState = @selector(top:);
    }
    return(self);
}

- (void) dispatch:(SMEvent *)event {
	
	self.mySource = self.myState;
	while (self.mySource != nil) {		
		if ([self respondsToSelector:self.myState]) {
			self.mySource = (SEL) [self performSelector:self.mySource withObject:event];
		}	
	}
	
}

- (void) executeInitialTransition {  
	
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

@end
