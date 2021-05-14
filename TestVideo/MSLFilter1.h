//
//  MSLFilter1.h
//  TestVideo
//
//  Created by admin on 14.05.2021.
//  Copyright © 2021 admin. All rights reserved.
//

#import <CoreImage/CoreImage.h>

NS_ASSUME_NONNULL_BEGIN

@interface MSLFilter1 : CIFilter
@property(nonatomic, retain) CIImage *inputImage;
@property (nonatomic) float argument1;
@end

NS_ASSUME_NONNULL_END
