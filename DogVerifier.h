
#import <Foundation/Foundation.h>
#import "DogStateMachine.h"

/**
 If I wasn't too lazy to read about how to make a unit test in objective c, this
 would be a unit test.  As it stands, its just some loose code posing to be a 
 unit test.
 
 Oh yeah, what does it do?  It tries to see if the passed in dog is actually a dog.
 It does that by sending it events (eg, interacting with it), and then checks if 
 it reacts/behaves as expected.
 */
@interface DogVerifier : NSObject <DogObserver> {
	DogStateMachine *dog;
	NSMutableDictionary *actionTracker;
	int totalActionsReceived;
}

@property (nonatomic, retain) DogStateMachine *dog;
@property (nonatomic, retain) NSDictionary *actionTracker;
@property (nonatomic, assign) int totalActionsReceived;

// excercise the dog, make sure its behaves as a real dog should
- (BOOL)verify;

@end
