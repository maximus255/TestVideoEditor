//
//  ViewController.h
//  TestVideo
//
//  Created by admin on 12.05.2021.
//  Copyright © 2021 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *video1Label;
@property (weak, nonatomic) IBOutlet UILabel *video2Label;
@property (weak, nonatomic) IBOutlet UIButton *transitionButton;
@property (weak, nonatomic) IBOutlet UIButton *filter1Button;
@property (weak, nonatomic) IBOutlet UIButton *filter2Button;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
- (IBAction)video1Pressed:(UIButton *)sender;
- (IBAction)video2Pressed:(UIButton *)sender;
- (IBAction)transitionPressed:(id)sender;
- (IBAction)filter2Pressed:(id)sender;
- (IBAction)filter1Pressed:(id)sender;

-(void) DebugAlert:(NSString*)message;
@end

