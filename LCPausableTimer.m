//
//  LCPausableTimer.m
//  LCPausableTimer
//
//  Created by Liana Chu on 5/7/15.
//  Copyright (c) 2015 Liana Chu. All rights reserved.
//

#import "LCPausableTimer.h"

@interface LCPausableTimer ()

@property (nonatomic) BOOL isInvalidated;
@property (nonatomic, assign) SEL usersSelector;
@property (nonatomic, strong, readwrite) NSTimer *timer;
@property (nonatomic) BOOL wasTimerAutomaticallyScheduledOnRunLoop;
@property (nonatomic, strong) NSInvocation *usersInvocation;
@property (nonatomic) BOOL repeats;
@property (nonatomic, readwrite) NSTimeInterval usersTimeInterval;
@property (nonatomic) id usersTarget;
@property (nonatomic) id usersUserInfo;
@property (nonatomic, strong) NSDate *usersFireDate;

@end


@implementation LCPausableTimer

- (instancetype)initWithFireDate:(NSDate *)date interval:(NSTimeInterval)seconds target:(id)target selector:(SEL)aSelector userInfo:(id)userinfo repeats:(BOOL)repeats;
{
    self = [super init];
    if (self) {
        NSTimer *timer = [[NSTimer alloc] initWithFireDate:date interval:seconds target:target selector:aSelector userInfo:userinfo repeats:repeats];
        self.timer = timer;
        self.wasTimerAutomaticallyScheduledOnRunLoop = NO;
        self.repeats = repeats;
        self.usersSelector = aSelector;
        self.usersTimeInterval = seconds;
        self.usersTarget = target;
        self.usersUserInfo = userinfo;
        self.usersFireDate = date;
    }
    return self;
}

+(LCPausableTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)seconds invocation:(NSInvocation *)invocation repeats:(BOOL)repeats
{
    LCPausableTimer *LCTimer = [[LCPausableTimer alloc] initWithFireDate:nil interval:seconds target:invocation.target selector:invocation.selector userInfo:nil repeats:repeats];
    LCTimer.wasTimerAutomaticallyScheduledOnRunLoop = YES;
    LCTimer.usersInvocation = invocation;
    LCTimer.timer = [NSTimer scheduledTimerWithTimeInterval:seconds invocation:invocation repeats:repeats];
    return LCTimer;
}

+ (LCPausableTimer *)timerWithTimeInterval:(NSTimeInterval)seconds invocation:(NSInvocation *)invocation repeats:(BOOL)repeats;
{
    LCPausableTimer *LCTimer = [[LCPausableTimer alloc] initWithFireDate:nil interval:seconds target:invocation.target selector:invocation.selector userInfo:nil repeats:repeats];
    LCTimer.wasTimerAutomaticallyScheduledOnRunLoop = NO;
    LCTimer.usersInvocation = invocation;
    LCTimer.timer = [NSTimer timerWithTimeInterval:seconds invocation:invocation repeats:repeats];
    return LCTimer;
}

+ (LCPausableTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)seconds target:(id)target selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)repeats;
{
    LCPausableTimer *LCTimer = [[LCPausableTimer alloc] initWithFireDate:nil interval:seconds target:target selector:aSelector userInfo:userInfo repeats:repeats];
    LCTimer.wasTimerAutomaticallyScheduledOnRunLoop = YES;
    LCTimer.timer = [NSTimer scheduledTimerWithTimeInterval:seconds target:target selector:aSelector userInfo:userInfo repeats:repeats];
    return LCTimer;
}

+ (LCPausableTimer *)timerWithTimeInterval:(NSTimeInterval)seconds target:(id)target selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)repeats;
{
    LCPausableTimer *LCTimer = [[LCPausableTimer alloc] initWithFireDate:nil interval:seconds target:target selector:aSelector userInfo:userInfo repeats:repeats];
    LCTimer.wasTimerAutomaticallyScheduledOnRunLoop = NO;
    LCTimer.timer = [NSTimer timerWithTimeInterval:seconds target:target selector:aSelector userInfo:userInfo repeats:repeats];
    return LCTimer;
}

-(void)fire
{
    [self.timer fire];
}

-(void)invalidate
{
    [self.timer invalidate];
}

-(void)pauseTimer
{
    if (!self.isInvalidated)
    {
        self.isInvalidated = YES;
        [self.timer invalidate];
    }
}

-(void)unpauseTimer
{
    if (self.isInvalidated == YES);
    {
        if (self.wasTimerAutomaticallyScheduledOnRunLoop == NO)
        {
            if (self.usersFireDate)
            {
                NSTimer *timer = [[NSTimer alloc] initWithFireDate:self.usersFireDate interval:self.usersTimeInterval target:self.usersTarget selector:self.usersSelector userInfo:self.usersUserInfo repeats:self.repeats];
                self.isInvalidated = NO;
                self.timer = timer;
            }
            else if (self.usersInvocation)
            {
                NSTimer *timer = [NSTimer timerWithTimeInterval:self.usersTimeInterval invocation:self.usersInvocation repeats:self.repeats];
                self.isInvalidated = NO;
                self.timer = timer;
            }
            else if ((!self.usersFireDate) && (!self.usersInvocation))
            {
                NSTimer *timer = [NSTimer timerWithTimeInterval:self.usersTimeInterval target:self.usersTarget selector:self.usersSelector userInfo:self.usersUserInfo repeats:self.repeats];
                self.isInvalidated = NO;
                self.timer = timer;
            }
        }
        else if (self.wasTimerAutomaticallyScheduledOnRunLoop == YES)
        {
            if (self.usersInvocation)
            {
                NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.usersTimeInterval invocation:self.usersInvocation repeats:self.repeats];
                self.isInvalidated = NO;
                self.timer = timer;
            }
            else
            {
                NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.usersTimeInterval target:self.usersTarget selector:self.usersSelector userInfo:self.usersUserInfo repeats:self.repeats];
                self.isInvalidated = NO;
                self.timer = timer;
            }
        }
    }
}

@end