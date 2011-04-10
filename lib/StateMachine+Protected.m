
#import "StateMachine+Protected.h"

@implementation StateMachine(Protected)

- (void)setMyState:(SEL)state { myState = state; } 
- (void)setMySource:(SEL)state { mySource = state; } 
- (SEL)myState { return myState; }
- (SEL)mySource { return mySource; }

- (SEL)trigger:(SEL)state signal:(int)sig {
	SEL returnVal;
	SMEvent *evt = [[SMEvent alloc] init];
	evt.signal = sig;
	if ([self respondsToSelector:state]) {
		returnVal = (SEL) [self performSelector:state withObject:evt];
	}
	[evt release];
	return returnVal;
}

- (void)transition:(SEL)target {
	
	SEL entry[7];
	SEL *e, *lca;
	SEL s, t, p, q;
	
	// exit all states from the currently active state (myState) up to the level in which the 
	// transition is devined (mySource) to cover the case of an inherited state transition. 
	for (s = self.myState; s != self.mySource;) {
		t = [self trigger:s signal:EXIT_SIG];
		if (t) {
			// exit action unhandled, t points to superstate
			s = t;
		}
		else {
			// exit action handled, elicit superstate
			s = [self trigger:s signal:EMPTY_SIG];
		}
	}
	
	// execute all actions associated with change of state configuration
	
	*(e = &entry[0]) = 0;
	*(++e) = target;
	
	// A. self-transition can be checked directly without probing any superstates.
	// Involves exit from source and entry to target
	if (self.mySource == target) {
		[self trigger:self.mySource signal:EXIT_SIG];
		goto inLca;
	}
	
	// B. source == target->super Requires probing the superstate of the target state
	// Involves only entry to source but no exit from target
	p = [self trigger:target signal:EMPTY_SIG];
	if (self.mySource == p) {
		goto inLca;
	}
	
	// C. source->super == target->super (Most common transition topology) Requires 
	// additional probing of the superstate of the source state.  Involves exit from 
	// source and entry to target
	q = [self trigger:self.mySource signal:EMPTY_SIG];
	if (q == p) {
		[self trigger:self.mySource signal:EXIT_SIG];
		goto inLca;
	}
	
	// D. source->super == target Does not require additional probing.  Involves only exit
	// from source but not entry to target.
	if (q == target) {
		[self trigger:self.mySource signal:EXIT_SIG];
		--e; // do not enter the LCA
		goto inLca;
	}
	
	// E. source == any of target->super .. Requires probing the superstates of the target
	// until a match is found or unitl the top state is reached. 
	*(++e) = p;
	for (s = [self trigger:p signal:EMPTY_SIG]; s; s = [self trigger:s signal:EMPTY_SIG]) {
		if (self.mySource = s) {
			goto inLca;
		}
		*(++e) = s;
	}
	[self trigger:self.mySource signal:EXIT_SIG];  // exit source
	
	// F. source->super == any of target->super ..Requires traversal of the state heirarchy stored
	// in the array entry[] to find the LCA.  
	for (lca = e; *lca; --lca) {
		if (q == *lca) {
			e = lca - 1;
			goto inLca;
		}
	}
	
	// G. any of source->super .. == any of target ..  Requires traversal of the target state heirarchy 
	// stored in the array entry[] for every superstate of source.  Because every scan for a given
	// superstate of the source exhausts all possible matches for the LCA, the source's superstate can be 
	// safely exited.  
	for (s = q; s; s = [self trigger:s signal:EMPTY_SIG]) {
		for (lca = e; *lca; --lca) {
			if (s == *lca) {
				e = lca -1;
				goto inLca;
			}
		}
		[self trigger:s signal:EXIT_SIG];   // exit s
	}
	
inLca:
	
	while (s = *e--) {  // retrace the entry path in the reverse order
		[self trigger:s signal:ENTRY_SIG];
	}
	
	self.myState = target;  // update current state
	
	while ([self trigger:target signal:INIT_SIG] == 0) {
		target = self.myState;
		[self trigger:target signal:ENTRY_SIG];  // enter target
	}
	
}


- (void)Q_INIT:(SEL)target {
	self.myState = target;
}


- (SEL)top:(SMEvent *)event {
	return nil;
}


@end
