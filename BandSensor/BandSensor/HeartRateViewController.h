//
//  HeartRateViewController.h
//  BandSensor
//
//  Created by Xueyang Li on 5/2/15.
//  Copyright (c) 2015 Microsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MicrosoftBandKit_iOS/MicrosoftBandKit_iOS.h>


@interface HeartRateViewController : UIViewController <MSBClientManagerDelegate,UIPickerViewDelegate,UIPickerViewDataSource>


// Skin temperature output
@property (weak, nonatomic) IBOutlet UITextView *HRTxtOutput;
@property (nonatomic, weak) MSBClient *client;


- (IBAction)startHeartRate:(id)sender;
- (IBAction)stopHeartRate:(id)sender;

- (IBAction)addFeeling:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *addFeelingTextField;

@end
