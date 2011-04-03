
#import <Foundation/Foundation.h>
#import "DogEvent.h"

@protocol DogObserver;

/**
 A state machine which models a dog
 */
@interface DogStateMachine : NSObject {
	id <DogObserver> delegate;
}

@property(nonatomic, assign) id <DogObserver> delegate;

- (void) initialTransition;
- (void) dispatch:(DogEvent *)event;

@end

// ------ Dog Observer Delegate Protocol 

// here are the actions which a dog observer may get called back with
// if the dog had a visual representation, it could be updated based on these callbacks
@protocol DogObserver<NSObject>

-(void)play;
-(void)bark;
-(void)whimper;
-(void)lay_down;

@end

