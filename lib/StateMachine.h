
#import <Foundation/Foundation.h>
#import "SMEvent.h"

/**
 Generic state machine.  Your own state machine should subclass this in order to inherit certain behaviors.
 */
@interface StateMachine : NSObject {
	
	// current state
	SEL myState;
	
	// source state during a transition
	SEL mySource;

	
}

- (SEL)top:(SMEvent *)event;



@end
