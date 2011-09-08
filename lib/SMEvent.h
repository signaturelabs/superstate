
#import <Foundation/Foundation.h>

/**
 Generic Event.  These are passed to the state machine and are what it reacts to.
 */

enum SMEventSignals {                                                     // standard signals
    EMPTY_SIG = 0,
	INIT_SIG,
    ENTRY_SIG,
    EXIT_SIG,
    USER_SIG
};

@interface SMEvent : NSObject {

	// the signal is the most important trait of the event instance, and defines
	// the main message this event is conveying.  should be a value in either SMEventSignals
	// enum, or in enum defined in subclass
	int signal;

}

@property (nonatomic, assign) int signal; 

- (id)initWithSignal:(int)_signal;

@end
