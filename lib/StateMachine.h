
#import <Foundation/Foundation.h>
#import "SMEvent.h"

/**
 Heirarchical state machine superclass.  Your own state machine should subclass this in order to 
 inherit certain behaviors.
 
 This is essentially a port of the heirarchical state machine in C++ from Practical Statecharts in 
 C/C++ by Miro Samek (1st ed.)  Reading that book will not only help explain how a lot of this 
 works, especially some of the gnarlier methods like transition(), but will also confuse the hell 
 out of you.  Highly recommended reading.
 
 A lot of the code from this class has been moved into a category StateMachine+Protected.h/m so it 
 could be encapsulated but still accessed in subclasses.  Eg, poor man's protected methods.
 
 */
@interface StateMachine : NSObject {
	
	// current state
	SEL myState;
	
	// source state during a transition
	SEL mySource;
	
}

// don't call this, call initWithInitialPseudostate instead
- (id)init;

// designated initializer.  expects a pseudostate handler as an object.  the pseudostate should be
// provided by subclass which specifies which top level state to drill down into as its starting state.
// (which may in turn recursively drill down further into a substate to be starting state)
- (id)initWithInitialPseudostate:(SEL)pseudostate;

// execute the initial transition.  this needs to be done after state machine created, and before dispatch()
// is called.  provides same functionality as init() in the Samek book.  
- (void) executeInitialTransition;  

// dispatch an event to the state machine.
- (void) dispatch:(SMEvent *)event;

@end
