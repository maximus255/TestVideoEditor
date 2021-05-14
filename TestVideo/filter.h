//
//  filter.h
//  TestVideo
//
//  Created by admin on 13.05.2021.
//  Copyright © 2021 admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <AssetsLibrary/AssetsLibrary.h>

NS_ASSUME_NONNULL_BEGIN
@protocol FilterDelegate <NSObject>
@optional
    -(void)finishFilter;
    -(void)errorFilter:(NSString*)error;
@end

@interface Filter : NSObject
@property (nonatomic,weak) id<FilterDelegate> delegate;

- (void)filterVideoURL:(NSURL *)video1URL withFilter:(NSString*)filterName;
@end

NS_ASSUME_NONNULL_END
