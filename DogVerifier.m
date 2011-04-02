
#import "DogVerifier.h"
#import "DogEvent.h"

@implementation DogVerifier

@synthesize dog;

#pragma mark -
#pragma mark Public Methods
- (BOOL)verify {
	[self.dog initialTransition];
	
	DogEvent *evt = [[DogEvent alloc] init];
	[self.dog dispatch:evt];
	
	return FALSE;
	
}

#pragma mark -
#pragma mark DogObserver

-(void)bark {
	NSLog(@"bark!");
}

-(void)whimper {
	NSLog(@"whimper...");
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
	[super dealloc];
}

@end
