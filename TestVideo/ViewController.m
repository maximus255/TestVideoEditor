//
//  ViewController.m
//  TestVideo
//
//  Created by admin on 12.05.2021.
//  Copyright © 2021 admin. All rights reserved.
//

#import "ViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "transition.h"
#import "filter.h"

@interface ViewController () <FilterDelegate,TransitionDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIImagePickerController *_picker;
    NSURL *_video1URL, *_video2URL;
    int _videoButtonNumber;
    Transition *_transition;
    Filter *_filter1;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.activityIndicator.hidden = YES;
}


- (IBAction)transitionPressed:(id)sender {
    
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
    
    _transition = [[Transition alloc] init];
    _transition.delegate = self;
    [_transition transiteVideoURL:_video1URL andVideo2URL:_video2URL];
}

- (IBAction)video2Pressed:(UIButton *)sender {
    _videoButtonNumber = 2;
    [self showPicker];
}

- (IBAction)video1Pressed:(UIButton *)sender {
    _videoButtonNumber = 1;
    [self showPicker];
}
#pragma mark -TransitionDelegate
-(void)finishTransite
{
    
    dispatch_async( dispatch_get_main_queue(), ^{
        [self.activityIndicator stopAnimating];
        self.activityIndicator.hidden = YES;
        
        [self DebugAlert: @"Transition has finished"];
    });
}
-(void)errorTransite:(NSString*)error{
    dispatch_async( dispatch_get_main_queue(), ^{
        [self.activityIndicator stopAnimating];
        self.activityIndicator.hidden = YES;
        
        [self DebugAlert: [@"Transition has Error " stringByAppendingString: error]];
    });
}
#pragma mark -FilterDelegate
-(void)finishFilter
{
    
    dispatch_async( dispatch_get_main_queue(), ^{
        [self.activityIndicator stopAnimating];
        self.activityIndicator.hidden = YES;
        
        [self DebugAlert: @"Filter has finished"];
    });
}
-(void)errorFilter:(NSString*)error{
    dispatch_async( dispatch_get_main_queue(), ^{
        [self.activityIndicator stopAnimating];
        self.activityIndicator.hidden = YES;
        
        [self DebugAlert: [@"Filter has Error " stringByAppendingString: error]];
    });
}

- (BOOL)showPicker {
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO){
        return NO;
    }
    
    _picker = [[UIImagePickerController alloc] init];
    _picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    _picker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie, nil];
    _picker.allowsEditing = YES;
    _picker.delegate = self;
    [self presentViewController:_picker animated:YES completion:nil];
    
    return YES;
}

#pragma mark - ImagePicker Delegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    //dissmis ImagePickerController
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    //handle Movie capture
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeMovie ]) {
        
        NSLog(@"Matching Success");
        
        if (_videoButtonNumber ==1){
            _video1URL = [info objectForKey:UIImagePickerControllerMediaURL];
            _video1Label.text = [_video1URL lastPathComponent];
        }
        else if (_videoButtonNumber==2){
            _video2URL = [info objectForKey:UIImagePickerControllerMediaURL];
            _video2Label.text = [_video2URL lastPathComponent];
        }else{
            [self DebugAlert:@"Unknown button was pressed"];
        }
    }
    
    _transitionButton.enabled = (_video1URL!=nil && _video2URL!=nil)? YES : NO;
    _filter1Button.enabled = (_video1URL!=nil);
    _filter2Button.enabled = (_video1URL!=nil);
    _blurButton.enabled = (_video1URL!=nil);

}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [_picker dismissViewControllerAnimated:YES completion:nil];
}

-(void) DebugAlert:(NSString*)message {
    //dispatch_async( dispatch_get_main_queue(), ^{
        
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
    //});
}

- (IBAction)blurPressed:(id)sender {
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
    
    _filter1 = [[Filter alloc] init];
    _filter1.delegate = self;
    [_filter1 filterVideoURL:_video1URL withFilter:@"CIGaussianBlur"];
}

- (IBAction)filter1Pressed:(id)sender {
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
    
    _filter1 = [[Filter alloc] init];
    _filter1.delegate = self;
    [_filter1 filterVideoURL:_video1URL withFilter:@"MSLFilter1"];
}

- (IBAction)filter2Pressed:(id)sender {
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
    
    _filter1 = [[Filter alloc] init];
    _filter1.delegate = self;
    [_filter1 filterVideoURL:_video1URL withFilter:@"MSLFilter2"];
}
@end
