//
//  filter.m
//  TestVideo
//
//  Created by admin on 13.05.2021.
//  Copyright © 2021 admin. All rights reserved.
//

#import "filter.h"
#import <Photos/Photos.h>
#import "MSLFilter1.h"

@implementation Filter
- (void)filterVideoURL:(NSURL *)videoURL withFilter:(NSString*)filterName
{
   if (videoURL==nil){
        if (_delegate!=nil && [_delegate respondsToSelector:@selector(errorFilter:)]){
            [_delegate errorFilter:@"video URL is nil!"];
        }
        return;
    }
    AVAsset *Asset;
    Asset = [AVAsset assetWithURL:videoURL];
    
    if (Asset==nil){
        if (_delegate!=nil && [_delegate respondsToSelector:@selector(errorFilter:)]){
            [_delegate errorFilter:@"AVAsset for video is nil!"];
        }
        return;
    }
    //CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    //CIFilter *filter = [CIFilter filterWithName:@"CIHueAdjust"];
    CIFilter *filter = [CIFilter filterWithName:filterName];
    AVMutableVideoComposition *videoComposition = [AVMutableVideoComposition videoCompositionWithAsset:Asset applyingCIFiltersWithHandler:^(AVAsynchronousCIImageFilteringRequest * _Nonnull request) {
        // set filter input image
    [filter setDefaults];
        //CIImage *source = [request.sourceImage imageByClampingToExtent];
        [filter setValue:request.sourceImage forKey:kCIInputImageKey];

        // hue
        //NSNumber *angle = [NSNumber numberWithFloat:0.8];
        //[filter setValue:angle forKey:kCIInputAngleKey];
        //NSLog(@"call filetr");
        CIImage *outputImage = filter.outputImage;
        
        // Crop the blurred output to the bounds of the original image
        //CIImage *output = [filter.outputImage imageByCroppingToRect:request.sourceImage.extent];
        
        [request finishWithImage:outputImage context:nil];
    }];
    
    //////////EXPORT
    const NSString* kExportName = @"filter_result.mov";
    
    NSString *exportPath =  [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent: [NSString stringWithFormat:@"%@", kExportName]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:exportPath error:NULL];
    
    NSURL *url = [NSURL fileURLWithPath:exportPath];
    
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:Asset presetName:AVAssetExportPresetHighestQuality];
    exporter.outputURL = url;
    exporter.outputFileType = AVFileTypeQuickTimeMovie;
    exporter.shouldOptimizeForNetworkUse = YES;
    exporter.videoComposition = videoComposition;
    
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            //save to MediaLib
            [self exportDidFinish:exporter];
        });
    }];
}

-(void)exportDidFinish:(AVAssetExportSession*)session {
    
    if (session.status == AVAssetExportSessionStatusCompleted) {
        
        NSURL *outputURL = session.outputURL;
       
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if ( status == PHAuthorizationStatusAuthorized ) {
                dispatch_async( dispatch_get_main_queue(), ^{
                    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                        PHAssetResourceCreationOptions *options = [[PHAssetResourceCreationOptions alloc] init];
                        options.shouldMoveFile = YES;

                        PHAssetCreationRequest *creationRequest = [PHAssetCreationRequest creationRequestForAsset];
                        [creationRequest addResourceWithType:PHAssetResourceTypeVideo fileURL:outputURL options:options];
                    } completionHandler:^( BOOL success, NSError *error ) {
                        if ( ! success ) {
                            if (self->_delegate!=nil && [self->_delegate respondsToSelector:@selector(errorFilter:)]){
                                [self->_delegate errorFilter:[NSString stringWithFormat: @"Error to save in library %@",error.localizedDescription]];
                            }
                        }else{
                            if (self->_delegate!=nil && [self->_delegate respondsToSelector:@selector(finishFilter)])
                                [self->_delegate finishFilter];
                        }
                    }];

                } );
            }
            else {
                if (self->_delegate!=nil && [self->_delegate respondsToSelector:@selector(errorFilter:)]){
                    [self->_delegate errorFilter:@"You havent permission to Media Library!"];
                }
            }
        }];
    }
    else{
        if (_delegate!=nil && [_delegate respondsToSelector:@selector(errorFilter:)]){
            [_delegate errorFilter:@"Error! Export status!=AVAssetExportSessionStatusCompleted"];
        }
    }
         
}

@end
