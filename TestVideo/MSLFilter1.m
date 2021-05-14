//
//  MSLFilter1.m
//  TestVideo
//
//  Created by admin on 14.05.2021.
//  Copyright © 2021 admin. All rights reserved.
//

#import "MSLFilter1.h"
//https://developer.apple.com/metal/CoreImageKernelLanguageReference11.pdf
@implementation MSLFilter1
{
    NSNumber *_arg1Obj;
}
static CIColorKernel *kernel;
//a variant CIWarpKernel
- (id)init{
    if (kernel==nil){

        NSError* error = nil;
        NSURL *URL = [[NSBundle mainBundle] URLForResource:@"default" withExtension:@"metallib"];
        NSData *data = [NSData dataWithContentsOfURL:URL options:NSDataReadingUncached error:&error];
        if (error) {
           NSLog(@"%@", [error localizedDescription]);
        }
        kernel = [CIColorKernel kernelWithFunctionName:@"filter1" fromMetalLibraryData:data error:&error];
        if (error) {
           NSLog(@"%@", [error localizedDescription]);
        }
        
    }
    self.argument1 = 0.0f;
    return [super init];
}
-(CIImage*)outputImage{
    
    return [kernel applyWithExtent:_inputImage.extent arguments:@[_inputImage, _arg1Obj]];
 //   return [kernel applyWithExtent:_inputImage.extent roiCallback:^CGRect(int index,CGRect rect){ return rect;} arguments:@[_inputImage]];
    
}
-(void)setArgument1:(float)arg1{
    _arg1Obj = [NSNumber numberWithFloat:arg1];
}
@end
