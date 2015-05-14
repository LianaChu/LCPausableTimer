//
//  LCPausableTimer.h
//  LCPausableTimer
//
//  Created by Liana Chu on 5/7/15.
//  Copyright (c) 2015 Liana Chu. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LCPausableTimer : NSObject

@property (readonly) NSTimeInterval usersTimeInterval;

@property (nonatomic, strong, readonly) NSTimer *timer;

/* Init Methods */

+ (LCPausableTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)seconds invocation:(NSInvocation *)invocation repeats:(BOOL)repeats;

+ (LCPausableTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)seconds target:(id)target selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)repeats;

/* The following three init methods require you to manually add the NStimer to the run loop. You may so do by passing in the "timer" property on your instance of LCPausableTimer. For example: [[NSRunLoop currentRunLoop] addTimer:myLCPausableTimerInstance.timer forMode:NSDefaultRunLoopMode] */

+ (LCPausableTimer *)timerWithTimeInterval:(NSTimeInterval)seconds invocation:(NSInvocation *)invocation repeats:(BOOL)repeats;


+ (LCPausableTimer *)timerWithTimeInterval:(NSTimeInterval)seconds target:(id)target selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)repeats;

- (instancetype)initWithFireDate:(NSDate *)date interval:(NSTimeInterval)seconds target:(id)target selector:(SEL)aSelector userInfo:(id)userinfo repeats:(BOOL)repeats;

/* Timer management methods */

- (void)fire;

-(void)pauseTimer;

/* Note: If you created your timer using one of the three init methods that require you to add the timer to the run loop manually, then after you call unpauseTimer on your  instance of LCPausableTimer, you must add the timer to the run loop annually. You may do so by passing in the "timer" property on your instance of LCPausableTimer. */
-(void)unpauseTimer;

- (void)invalidate;


@end
