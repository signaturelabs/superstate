
#import <Foundation/Foundation.h>
#import "SMEvent.h"

/**
 Generic heirarchical state machine.  Your own state machine should subclass this in order to inherit certain behaviors.
 */
@interface StateMachine : NSObject {
	
	// current state
	SEL myState;
	
	// source state during a transition
	SEL mySource;
	
}

// execute the initial transition.  this needs to be done after state machine created, and before dispatch()
// is called.  provides same functionality as init() in the Samek book.  
- (void) executeInitialTransition;  

// dispatch an event to the state machine.
- (void) dispatch:(SMEvent *)event;

@end
