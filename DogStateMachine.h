
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


@protocol DogObserver<NSObject>

-(void)bark;
-(void)whimper;

@end

