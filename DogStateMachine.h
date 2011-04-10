
#import <Foundation/Foundation.h>
#import "DogEvent.h"

@protocol DogObserver;

/**
 A state machine which models a dog
 */
@interface DogStateMachine : NSObject {
	
	id <DogObserver> delegate;
	
	// current state
	SEL myState;
	
	// source state during a transition
	SEL mySource;
}

@property(nonatomic, assign) id <DogObserver> delegate;

- (id) init;
- (void) executeInitialTransition;  // aka "init" in samek book.  TODO: move to statemachine.m
- (void) dispatch:(DogEvent *)event;


@end

// ------ Dog Observer Delegate Protocol 

// here are the actions which a dog observer may get called back with
// if the dog had a visual representation, it could be updated based on these callbacks
@protocol DogObserver<NSObject>

-(void)play;
-(void)bark;
-(void)whimper;
-(void)vomit;
-(void)lay_down;
-(void)get_up;
-(void)jump;
-(void)backflip;
-(void)burp;
-(void)bite;

@end

