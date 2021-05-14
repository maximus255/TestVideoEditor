//
//  transition.h
//  TestVideo
//
//  Created by admin on 12.05.2021.
//  Copyright © 2021 admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <AssetsLibrary/AssetsLibrary.h>

NS_ASSUME_NONNULL_BEGIN
@class Transition;

@protocol TransitionDelegate <NSObject>
@optional
-(void)finishTransite;
-(void)errorTransite:(NSString*)error;
@end

@interface Transition : NSObject
@property (nonatomic,weak) id<TransitionDelegate> delegate;

- (void)transiteVideoURL:(NSURL *)video1URL andVideo2URL:(NSURL *)video2URL;
@end

NS_ASSUME_NONNULL_END
