
#import <Foundation/Foundation.h>
#import "SMEvent.h"

/**
 A dog event represents an incoming interaction from the dog's perspective.
 Eg, if someone kicks it, it will receive an event with the signal for 
 being kicked.
 */

enum DogEventSignals {
    THROW_BALL_SIG = SM_USER_SIG,
    THROW_BONE_SIG,
    KICK_SIG,
    GIVE_BURRITO_SIG,
    GIVE_WHISKEY_SIG,
    PET_SIG
};

@interface DogEvent : SMEvent {

}

@end
