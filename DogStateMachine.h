
#import <Foundation/Foundation.h>
#import "StateMachine.h"
#import "DogEvent.h"

@protocol DogObserver;

/**
 A state machine which models a dog
 
 - happy;
    - playful
    - tired
    - wasted
 - unhappy
    - hurt
    - sick

 */
@interface DogStateMachine : StateMachine {
	
	id <DogObserver> delegate;

}

@property(nonatomic, assign) id <DogObserver> delegate;

- (id) init;

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
-(void)yawn;

@end

