
#import <Foundation/Foundation.h>

#import "StateMachine.h"
#import "SMEvent.h"

/**
 Some methods that are available to the statemachine and its subclasses.  
 3rd party users of this library should not be using this stuff.  Please move along..
 */

@interface StateMachine(Protected) 

// accessors
- (void)setMyState:(SEL)state;
- (void)setMySource:(SEL)state;
- (SEL)myState;
- (SEL)mySource;

// send an event with given signal to given state handler
- (SEL)trigger:(SEL)state signal:(int)sig;  

// perform a state transition
- (void)transition:(SEL)state;  

// drill down to correct state.  renamed from Q_INIT in Samek book.
- (void)drillDown:(SEL)state;

// top state handler
- (SEL)top:(SMEvent *)event;


@end
