
#import "DogVerifier.h"
#import "DogEvent.h"

@interface DogVerifier() 

- (void)incrementActionsReceived:(NSString *)actionName;
- (void)assertActionsReceivedFor:(NSString *)actionName is:(int)numTimesExpected;
- (int)numActionsReceivedFor:(NSString *)actionName;
- (void)assertTotalActionsReceived:(int)numTimesExpected;

@end


@implementation DogVerifier

@synthesize dog, actionTracker, totalActionsReceived;

#pragma mark -
#pragma mark Private Methods

- (int)numActionsReceivedFor:(NSString *)actionName {
	if ([self.actionTracker objectForKey:actionName] != nil) {
		return [[self.actionTracker objectForKey:actionName] intValue];
	}
	return 0;
}

- (void)incrementActionsReceived:(NSString *)actionName {
		
	// get the existing number of times this action has been called, increment it, and set new value
	NSNumber *numTimesActionCalled = [NSNumber numberWithInt:1];
	if ([self.actionTracker objectForKey:actionName] != nil) {
		int prevNumTimesActionCalled = [[self.actionTracker objectForKey:actionName] intValue];
		prevNumTimesActionCalled += 1;
		numTimesActionCalled = [NSNumber numberWithInt:prevNumTimesActionCalled];
	}
	[self.actionTracker setValue:numTimesActionCalled forKey:actionName];

	self.totalActionsReceived += 1;
	
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

- (void)assertTotalActionsReceived:(int)numTimesExpected {

	if (self.totalActionsReceived != numTimesExpected) {
		NSLog(@"assertTotalActionsReceived ASSERTION FAILED");
		exit(1);			
	}
	
}

#pragma mark -
#pragma mark Public Methods

- (BOOL)verify {
	
	// local vars..
	int curNumTimesPlayed, curNumTimesBarked, curNumTimesLayedDown, curNumTimesWhimpered, curNumTimesYawn = 0;
	int curNumTimesBackflipped, curNumTimesBite, curNumTimesGetUp, curNumTimesVomit, curNumTimesBurp = 0;
	
	// reset the actiontracker
	self.actionTracker = [[NSMutableDictionary alloc] init];
	
	// do initial transition (by default the dog should go into the happy / playful state) 	
	[self.dog executeInitialTransition];
	
	// verify dog is in happy / playful state by throwing it a ball and making sure that
	// it plays with it.
	DogEvent *evt = [[DogEvent alloc] init];
	evt.signal = THROW_BALL_SIG;
	curNumTimesPlayed = [self numActionsReceivedFor:@"play"];
	[self.dog dispatch:evt];
	[self assertActionsReceivedFor:@"play" is:(curNumTimesPlayed+1)];  // did the dog play?

	// lets kick the dog, but since he's playing, he will just bark
	evt.signal = KICK_SIG;  // recycle event, too much trouble to create a new one..
	curNumTimesBarked = [self numActionsReceivedFor:@"bark"];
	[self.dog dispatch:evt];
	[self assertActionsReceivedFor:@"bark" is:(curNumTimesBarked+1)];  
	
	// lets give the dog a burrito, which will make him tired
	evt.signal = GIVE_BURRITO_SIG;  
	curNumTimesLayedDown = [self numActionsReceivedFor:@"lay_down"];
	[self.dog dispatch:evt];
	[self assertActionsReceivedFor:@"lay_down" is:(curNumTimesLayedDown+1)];  
	
	// lets throw the dog a ball, but since he's tired he will do nothing
	evt.signal = THROW_BALL_SIG;  
	int curNumActionsRecevied = self.totalActionsReceived;
	[self.dog dispatch:evt];
	[self assertTotalActionsReceived:curNumActionsRecevied];  
	
	// now lets kick him again, but this time since he's tired, instead of barking he will whimper and go into unhappy state
	evt.signal = KICK_SIG;  
	curNumTimesWhimpered = [self numActionsReceivedFor:@"whimper"];
	[self.dog dispatch:evt];
	[self assertActionsReceivedFor:@"whimper" is:curNumTimesWhimpered+1];
	
	// lets throw the dog a ball, but since he's unhappy, he will just wimper
	evt.signal = THROW_BALL_SIG;  
	curNumTimesWhimpered = [self numActionsReceivedFor:@"whimper"];
	[self.dog dispatch:evt];
	[self assertActionsReceivedFor:@"whimper" is:curNumTimesWhimpered+1];
	
	// ok we had a really bad day and got yelled at by our boss for being THREE WEEKS LATE.  lets
	// take it out on the dog and kick him again.  he will wimper again and go into hurt state
	evt.signal = KICK_SIG;  
	curNumTimesWhimpered = [self numActionsReceivedFor:@"whimper"];
	[self.dog dispatch:evt];
	[self assertActionsReceivedFor:@"whimper" is:curNumTimesWhimpered+1];
	
	// try to give him a burrito, he will look up, ignore it, and go back into the hurt state.  upon 
	// temporarily leaving the hurt state, he will whimper
	evt.signal = GIVE_BURRITO_SIG;  
	curNumTimesWhimpered = [self numActionsReceivedFor:@"whimper"];
	[self.dog dispatch:evt];
	[self assertActionsReceivedFor:@"whimper" is:(curNumTimesWhimpered+1)];  
	
	// lets pet him, which will make him go into the happy+playful state, and whenever he enters the happy state he barks
	// and whenever he enters playful state he gets up.  also when he leaves the hurt state, he will wimper to signify
	// that he's still unhappy
	evt.signal = PET_SIG;  
	curNumTimesGetUp = [self numActionsReceivedFor:@"get_up"];
	curNumTimesBarked = [self numActionsReceivedFor:@"bark"];
	curNumTimesWhimpered = [self numActionsReceivedFor:@"whimper"];
	[self.dog dispatch:evt];
	[self assertActionsReceivedFor:@"whimper" is:(curNumTimesWhimpered+1)];  
	[self assertActionsReceivedFor:@"get_up" is:curNumTimesGetUp+1];
	[self assertActionsReceivedFor:@"bark" is:(curNumTimesBarked+1)];  
		
	// lets give him some whiskey!  this will make him go into the happy/wasted state.  he doesn't do anything upon entering this state
	evt.signal = GIVE_WHISKEY_SIG;  
	[self.dog dispatch:evt];
	
	// now lets throw him a ball, OMG he does a backflip!
	evt.signal = THROW_BALL_SIG;  
	curNumTimesBackflipped = [self numActionsReceivedFor:@"backflip"];
	[self.dog dispatch:evt];
	[self assertActionsReceivedFor:@"backflip" is:curNumTimesBackflipped+1];
	
	// lets give him some more whiskey.  he vomits and goes into the unhappy/sick state
	evt.signal = GIVE_WHISKEY_SIG;  
	curNumTimesVomit = [self numActionsReceivedFor:@"vomit"];
	[self.dog dispatch:evt];
	[self assertActionsReceivedFor:@"vomit" is:curNumTimesVomit+1];
	
	// lets give him a burrito.. he will just whimper since he's unhappy/sick
	evt.signal = GIVE_BURRITO_SIG;  
	curNumTimesWhimpered = [self numActionsReceivedFor:@"whimper"];
	[self.dog dispatch:evt];
	[self assertActionsReceivedFor:@"whimper" is:curNumTimesWhimpered+1];
	
	// ok we get frustrated, lets kick him.  OUCH!  He bites	
	evt.signal = KICK_SIG;  
	curNumTimesBite = [self numActionsReceivedFor:@"bite"];
	[self.dog dispatch:evt];
	[self assertActionsReceivedFor:@"bite" is:curNumTimesBite+1];

	// lets throw him a bone, he should burp as he leaves the unhappy/sick state, and yawns as 
    // he enters the happy/tired state.  oh he also always barks as he enteres the happy state.
	evt.signal = THROW_BONE_SIG;  
    curNumTimesYawn = [self numActionsReceivedFor:@"yawn"];
	curNumTimesBurp = [self numActionsReceivedFor:@"burp"];
    curNumTimesBarked = [self numActionsReceivedFor:@"bark"];
	[self.dog dispatch:evt];
	[self assertActionsReceivedFor:@"burp" is:curNumTimesBurp+1];
	[self assertActionsReceivedFor:@"yawn" is:curNumTimesYawn+1];    
    [self assertActionsReceivedFor:@"bark" is:(curNumTimesBarked+1)];  
    
	[evt release];
	return TRUE;
	
}

#pragma mark -
#pragma mark DogObserver

-(void)play { [self incrementActionsReceived:@"play"]; } 
-(void)bark { [self incrementActionsReceived:@"bark"]; }
-(void)whimper { [self incrementActionsReceived:@"whimper"]; }
-(void)vomit { [self incrementActionsReceived:@"vomit"]; }
-(void)lay_down { [self incrementActionsReceived:@"lay_down"]; }
-(void)get_up { [self incrementActionsReceived:@"get_up"]; }
-(void)jump { [self incrementActionsReceived:@"jump"]; }
-(void)backflip { [self incrementActionsReceived:@"backflip"]; }
-(void)burp { [self incrementActionsReceived:@"burp"]; }
-(void)bite { [self incrementActionsReceived:@"bite"]; }
-(void)yawn { [self incrementActionsReceived:@"yawn"]; }

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
