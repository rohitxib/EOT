//
//  BackgroundTaskManager.m
//
//  Created by Puru Shukla on 20/02/13.
//  Copyright (c) 2013 Puru Shukla. All rights reserved.
//

#import "BackgroundTaskManager.h"

@interface BackgroundTaskManager()
@property (nonatomic, strong)NSMutableArray* bgTaskIdList;
@property (assign) UIBackgroundTaskIdentifier masterTaskId;
@end

@implementation BackgroundTaskManager
+(instancetype)sharedBackgroundTaskManager {
    static BackgroundTaskManager* sharedBGTaskManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedBGTaskManager = [[BackgroundTaskManager alloc] init];
    });
    return sharedBGTaskManager;
}
-(id)init{
    self = [super init];
    if(self){
        _bgTaskIdList = [NSMutableArray array];
        _masterTaskId = UIBackgroundTaskInvalid;
    }
    return self;
}
-(UIBackgroundTaskIdentifier)beginNewBackgroundTask {
    UIApplication* application = [UIApplication sharedApplication];
    __block UIBackgroundTaskIdentifier bgTaskId = UIBackgroundTaskInvalid;
    if([application respondsToSelector:@selector(beginBackgroundTaskWithExpirationHandler:)]){
        
        bgTaskId = [application beginBackgroundTaskWithExpirationHandler:^{
            [self.bgTaskIdList removeObject:@(bgTaskId)];
            [application endBackgroundTask:bgTaskId];
            bgTaskId = UIBackgroundTaskInvalid;
        }];
        
        if ( self.masterTaskId == UIBackgroundTaskInvalid ){
            self.masterTaskId = bgTaskId;
        }
        else{
            [self.bgTaskIdList addObject:@(bgTaskId)];
            [self endBackgroundTasks];
        }
    }
    return bgTaskId;
}
-(void)endBackgroundTasks{
    [self drainBGTaskList:NO];
}
-(void)endAllBackgroundTasks{
    [self drainBGTaskList:YES];
}
-(void)drainBGTaskList:(BOOL)all {
    UIApplication* application = [UIApplication sharedApplication];
    if([application respondsToSelector:@selector(endBackgroundTask:)]){
        NSUInteger count=self.bgTaskIdList.count;
        for ( NSUInteger i=(all?0:1); i<count; i++ )
        {
            UIBackgroundTaskIdentifier bgTaskId = [[self.bgTaskIdList objectAtIndex:0] integerValue];
            [application endBackgroundTask:bgTaskId];
            [self.bgTaskIdList removeObjectAtIndex:0];
        }
        if (all){
            [application endBackgroundTask:self.masterTaskId];
            self.masterTaskId = UIBackgroundTaskInvalid;
        }
    }
}
@end
