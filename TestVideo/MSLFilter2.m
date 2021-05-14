//
//  MSLFilter2.m
//  TestVideo
//
//  Created by admin on 14.05.2021.
//  Copyright © 2021 admin. All rights reserved.
//

#import "MSLFilter2.h"

@implementation MSLFilter2
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
        kernel = [CIColorKernel kernelWithFunctionName:@"filter2" fromMetalLibraryData:data error:&error];
        if (error) {
           NSLog(@"%@", [error localizedDescription]);
        }
        
    }
    return [super init];
}
-(CIImage*)outputImage{
    
    return [kernel applyWithExtent:_inputImage.extent arguments:@[_inputImage ]];
    
}
@end
