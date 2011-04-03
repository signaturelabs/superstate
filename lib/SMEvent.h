
#import <Foundation/Foundation.h>

/**
 Generic Event.  These are passed to the state machine and are what it reacts to.
 */

enum SMEventSignals {                                                     // standard signals
    SM_INIT_SIG = 1,
    SM_ENTRY_SIG,
    SM_EXIT_SIG,
    SM_USER_SIG
};

@interface SMEvent : NSObject {

	// the signal is the most important trait of the event instance, and defines
	// the main message this event is conveying.  should be a value in either SMEventSignals
	// enum, or in enum defined in subclass
	int signal;

}

@property (nonatomic, assign) int signal; 

@end
