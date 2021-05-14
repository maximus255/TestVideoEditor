//
//  MSLFilter2.h
//  TestVideo
//
//  Created by admin on 14.05.2021.
//  Copyright © 2021 admin. All rights reserved.
//

#import <CoreImage/CoreImage.h>

NS_ASSUME_NONNULL_BEGIN

@interface MSLFilter2 : CIFilter
@property(nonatomic, retain) CIImage *inputImage;
@end

NS_ASSUME_NONNULL_END
