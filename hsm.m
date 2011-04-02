#import <Foundation/Foundation.h>
#import "DogStateMachine.h"
#import "DogVerifier.h"

/**
 Stubbing out a test framework for the StateMachine framework..
 */

int main (int argc, const char * argv[]) {

    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

	// lets create a hypothetical "dog state machine" that represents a complex
	// canine reactive system (aka, a dog)	
    DogStateMachine *dog = [[DogStateMachine alloc] init];
	
	// now lets create a DogVerifier that checks this behaves as a real dog should
	DogVerifier *doggyChecker = [[DogVerifier alloc] init];
	doggyChecker.dog = dog;
	BOOL isReallyADog = [doggyChecker verify];
	
	// report result
	if (isReallyADog) {
		NSLog(@"Its really a dog!");
	}
	else {
		NSLog(@"Hah, this is NOT a real dog!  Its probably a cat wearing a dogsuit");
	}
	
	[pool drain];
    return 0;

}
