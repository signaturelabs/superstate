
#import "DogVerifier.h"
#import "DogEvent.h"

@interface DogVerifier()

- (void)incrementActionsReceived:(NSString *)actionName;
- (void)assertActionsReceivedFor:(NSString *)actionName is:(int)numTimesExpected;

@end


@implementation DogVerifier

@synthesize dog, actionTracker;

#pragma mark -
#pragma mark Private Methods

- (void)incrementActionsReceived:(NSString *)actionName {
		
	// get the existing number of times this action has been called, increment it, and set new value
	NSNumber *numTimesActionCalled = [NSNumber numberWithInt:1];
	if ([self.actionTracker objectForKey:actionName] != nil) {
		int prevNumTimesActionCalled = [[self.actionTracker objectForKey:actionName] intValue];
		prevNumTimesActionCalled += 1;
		numTimesActionCalled = [NSNumber numberWithInt:prevNumTimesActionCalled];
	}
	[self.actionTracker setValue:numTimesActionCalled forKey:actionName];

}

- (void)assertActionsReceivedFor:(NSString *)actionName is:(int)numTimesExpected {
	
	if ([self.actionTracker objectForKey:actionName] != nil) {
		int numTimesActionCalled = [[self.actionTracker objectForKey:actionName] intValue];
		if (numTimesActionCalled != numTimesExpected) {
			NSLog(@"assertActionsReceivedFor ASSERTION FAILED");
			exit(1);			
		}
	}
	else {
		if (numTimesExpected != 0) {
			NSLog(@"assertActionsReceivedFor ASSERTION FAILED");
			exit(1);
		}
	}
	
}

#pragma mark -
#pragma mark Public Methods

- (BOOL)verify {
	
	// reset the actiontracker
	self.actionTracker = [[NSMutableDictionary alloc] init];
	
	// do initial transition (by default the dog should go into the happy / playful state) 	
	[self.dog initialTransition];
	
	// verify dog is in happy / playful state by throwing it a ball and making sure that
	// it plays with it.
	DogEvent *evt = [[DogEvent alloc] init];
	evt.signal = THROW_BALL_SIG;
	[self.dog dispatch:evt];

	// did the dog play?
	[self assertActionsReceivedFor:@"play" is:1];

	// lets kick the dog, but since he's playing, he will just bark
	evt.signal = KICK_SIG;  // recycle event, too much trouble to create a new one..
	[self.dog dispatch:evt];
	
	// did the dog bark?
	[self assertActionsReceivedFor:@"bark" is:1];
	
	// lets give the dog a burrito, which will make him tired
	evt.signal = GIVE_BURRITO_SIG;  
	[self.dog dispatch:evt];

	// did the dog lay down?
	[self assertActionsReceivedFor:@"lay_down" is:1];
	
	// now lets kick him again, but this time since he's laying down, instead of barking he will whimper and go into unhappy state
	evt.signal = KICK_SIG;  
	[self.dog dispatch:evt];
	[self assertActionsReceivedFor:@"whimper" is:1];
	
	[evt release];
	
	
	return FALSE;
	
}

#pragma mark -
#pragma mark DogObserver

-(void)play {
	NSLog(@"play!");
	[self incrementActionsReceived:@"play"];
}

-(void)bark {
	NSLog(@"bark!");
	[self incrementActionsReceived:@"bark"];
}

-(void)whimper {
	NSLog(@"whimper...");	
	[self incrementActionsReceived:@"whimper"];
}

-(void)lay_down {
	NSLog(@"dog lays down...");	
	[self incrementActionsReceived:@"lay_down"];
}


#pragma mark -
#pragma mark Accessors

- (void)setDog:(DogStateMachine *)theDog {
	dog = theDog;
	dog.delegate = self;
}


#pragma mark -
#pragma mark Object Lifecycle

- (void)dealloc {
	self.dog = nil;
	self.actionTracker = nil;
	[super dealloc];
}

@end
