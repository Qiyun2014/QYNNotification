//
//  QYNNotificationManager.h
//  QYNNotificationManager
//
//  Created by qiyun on 16/4/11.
//  Copyright © 2016年 ProDrone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QYNNotificationManager : NSObject{
    
    @private
    NSNotification  *notification;
    UInt8           notCount;
    NSString        *name;
    
    @public
    NSMutableArray  *names;
    NSMutableArray  *objects;
    NSMutableArray  *userInfos;
}


+ (QYNNotificationManager *)shareInstanceManager;


//add observer with observer keyname
- (void)addObserver:(id)observer name:(NSString *)aName;
- (void)addObserver:(id)observer name:(NSString *)aName object:(id)aObject response:(void (^)(NSDictionary *))response;

//remove the observer use notification name
- (void)removeObserverOfName:(NSString *)aName;

/**
 *  notification name
 *
 *  @param notificationName   The name of the notification.
 *  @param notificationSender The object posting the notification.
 *  @param userInfo           Information about the the notification. May be nil.
 */
- (void)postNotificationName:(NSString *)notificationName
                      object:(id)notificationSender
                    userInfo:(NSDictionary *)userInfo;

@end
