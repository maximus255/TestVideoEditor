//
//  transition.m
//  TestVideo
//
//  Created by admin on 12.05.2021.
//  Copyright © 2021 admin. All rights reserved.
//

#import "transition.h"
#import <Photos/Photos.h>

@implementation Transition

- (void)transiteVideoURL:(NSURL *)video1URL andVideo2URL:(NSURL *)video2URL{
    if (video1URL==nil || video2URL==nil){
        if (_delegate!=nil && [_delegate respondsToSelector:@selector(errorTransite:)]){
            [_delegate errorTransite:@"video1 or video2 URL is nil!"];
        }
        return;
    }
    AVAsset *Asset1, *Asset2;
    Asset1 = [AVAsset assetWithURL:video1URL];
    Asset2 = [AVAsset assetWithURL:video2URL];
    
    if (Asset1==nil || Asset2==nil){
        if (_delegate!=nil && [_delegate respondsToSelector:@selector(errorTransite:)]){
            [_delegate errorTransite:@"AVAsset for video1 or video2 is nil!"];
        }
        return;
    }
        
    AVMutableComposition *mixComposition;
    
   mixComposition = [[AVMutableComposition alloc] init];
   
   AVMutableCompositionTrack *Track1 = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo                     preferredTrackID:kCMPersistentTrackID_Invalid];
   
   [Track1 insertTimeRange:CMTimeRangeMake(kCMTimeZero, Asset1.duration) ofTrack:[[Asset1 tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:kCMTimeZero error:nil];
   
    /////////
    //calc time ranges for tracks
    const int64_t kTransitionDuration = 60;
    CMTime TransitionTime = CMTimeMake(kTransitionDuration, 60);
    if (CMTimeGetSeconds(Asset1.duration) < CMTimeGetSeconds(TransitionTime)){
        TransitionTime = Asset1.duration;
    }
    CMTime StartTime = CMTimeSubtract(Asset1.duration, TransitionTime);
    CMTimeRange TransitionRange = CMTimeRangeMake(StartTime, TransitionTime);
    /////////
    
    
   AVMutableCompositionTrack *Track2 = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
   
   [Track2 insertTimeRange:CMTimeRangeMake(kCMTimeZero, Asset2.duration) ofTrack:[[Asset2 tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:StartTime error:nil];
    
    
    
    AVMutableVideoCompositionLayerInstruction *layerInstruction1 = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:Track1];
    
    [layerInstruction1 setOpacityRampFromStartOpacity:1.0f toEndOpacity:0.0f timeRange:TransitionRange ];
    
    
    AVMutableVideoCompositionLayerInstruction *layerInstruction2 = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:Track2];
    [layerInstruction2 setOpacity:1.0 atTime:StartTime];
    
    
    AVMutableVideoCompositionInstruction *mainInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    mainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero,CMTimeAdd(StartTime,Asset2.duration));
    mainInstruction.layerInstructions = [NSArray arrayWithObjects:layerInstruction1,layerInstruction2, nil];
    
    
    AVMutableVideoComposition *mainComposition = [AVMutableVideoComposition videoComposition];
    mainComposition.instructions = [NSArray arrayWithObjects:mainInstruction,nil];
    mainComposition.frameDuration = CMTimeMake(1, 30);
    mainComposition.renderSize = Track1.naturalSize;
    
    //////////EXPORT
    const NSString* kExportName = @"transition_result.mov";
    
    NSString *exportPath =  [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent: [NSString stringWithFormat:@"%@", kExportName]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:exportPath error:NULL];
    
    NSURL *url = [NSURL fileURLWithPath:exportPath];
    
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetHighestQuality];
    
    exporter.outputURL = url;
    exporter.outputFileType = AVFileTypeQuickTimeMovie;
    exporter.shouldOptimizeForNetworkUse = YES;
    exporter.videoComposition = mainComposition;
    
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
                            if (self->_delegate!=nil && [self->_delegate respondsToSelector:@selector(errorTransite:)]){
                                [self->_delegate errorTransite:[NSString stringWithFormat: @"Error to save in library %@",error.localizedDescription]];
                            }
                        }else{
                            if (self->_delegate!=nil && [self->_delegate respondsToSelector:@selector(finishTransite)])
                                [self->_delegate finishTransite];
                        }
                    }];

                } );
            }
            else {
                if (self->_delegate!=nil && [self->_delegate respondsToSelector:@selector(errorTransite:)]){
                    [self->_delegate errorTransite:@"You havent permission to Media Library!"];
                }
            }
        }];
        /*
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:outputURL])  {
            [library writeVideoAtPathToSavedPhotosAlbum:outputURL completionBlock:^(NSURL *assetURL, NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error) {
                        if (self->_delegate!=nil && [self->_delegate respondsToSelector:@selector(errorTransite:)]){
                            [self->_delegate errorTransite:[NSString stringWithFormat: @"Error to save in library %@",error.localizedDescription]];
                        }
                    }else {
                        
                        if (self->_delegate!=nil && [self->_delegate respondsToSelector:@selector(finishTransite)])
                            [self->_delegate finishTransite];
                    }
                });
            }];
        }*/
    }
    else{
        if (_delegate!=nil && [_delegate respondsToSelector:@selector(errorTransite:)]){
            [_delegate errorTransite:@"Error! Export status!=AVAssetExportSessionStatusCompleted"];
        }
    }
         
}



@end
