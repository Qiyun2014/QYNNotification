//
//  QYNNotificationManager.m
//  QYNNotificationManager
//
//  Created by qiyun on 16/4/11.
//  Copyright © 2016年 ProDrone. All rights reserved.
//

#import "QYNNotificationManager.h"

typedef void (^notResponse_block)(NSDictionary *);

@interface QYNNotificationManager ()

@property (nonatomic,copy) notResponse_block    notResponse;

@end

@implementation QYNNotificationManager


static QYNNotificationManager *manager = nil;
+ (QYNNotificationManager *)shareInstanceManager{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[QYNNotificationManager alloc] init];
    });
    
    return manager;
}

- (id)init{
    
    if (self = [super init]) {
        
        self->notCount  = 0;
        self->names     = [NSMutableArray arrayWithCapacity:30];
        self->objects   = [NSMutableArray arrayWithCapacity:30];
    }
    return self;
}

- (void)postNotificationName:(NSString *)notificationName
                      object:(id)notificationSender
                    userInfo:(NSDictionary *)userInfo{
    
    dispatch_queue_t defaultQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(defaultQueue, ^{

        [[NSNotificationCenter defaultCenter] postNotificationName:notificationName
                                                            object:notificationSender
                                                          userInfo:userInfo];
    });
}

- (void)addObserver:(id)observer name:(NSString *)aName object:(id)aObject response:(void (^)(NSDictionary *))response{
    
    if (!name) return;
    
    if (!response) self.notResponse = response;
    self->name = aName;
    [self->names    addObject:self->name];
    [self->objects  addObject:observer];
    
    self->notCount += 1;
    [self->userInfos addObject:aObject];
    
    [[NSNotificationCenter defaultCenter] addObserver:observer
                                             selector:@selector(responseWithNotification:)
                                                 name:aName
                                               object:aObject];
}


- (void)addObserver:(id)observer name:(NSString *)aName{
    
    [self addObserver:observer name:aName object:nil response:nil];
}


- (void)responseWithNotification:(NSNotification *)not{
    
    self.notResponse = ^NSDictionary *{
        
        return not.userInfo;
    };
}


- (NSInteger)getIndexFromName:(NSString *)aName{
    
    return [self->names indexOfObject:aName];
}

- (void)removeObserverOfName:(NSString *)aName{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self->objects[[self getIndexFromName:aName]]
                                                    name:aName
                                                  object:self->objects[[self getIndexFromName:aName]]];
}

- (void)dealloc{
    
    [self->names enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        [[NSNotificationCenter defaultCenter] removeObserver:self->objects[MIN(idx, self->objects.count-1)]
                                                        name:(NSString *)obj
                                                      object:self->userInfos[MIN(idx, self->objects.count-1)]];
    }];
    
    if ([NSNotificationCenter defaultCenter]->_impl && ([NSNotificationCenter defaultCenter]->_impl != kCFNull)) {
        
        [self->objects enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
           
            [[NSNotificationCenter defaultCenter] removeObserver:obj];
        }];
    }
}

@end
