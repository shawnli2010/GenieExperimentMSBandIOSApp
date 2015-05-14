//
//  SkinTemperatureViewController.h
//  BandSensor
//
//  Created by Xueyang Li on 5/2/15.
//  Copyright (c) 2015 Microsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MicrosoftBandKit_iOS/MicrosoftBandKit_iOS.h>
#import "AFNetworking.h"


@interface SkinTemperatureViewController : UIViewController <MSBClientManagerDelegate,UIPickerViewDelegate,UIPickerViewDataSource,NSURLConnectionDelegate,NSURLConnectionDataDelegate>


// Skin temperature output
@property (weak, nonatomic) IBOutlet UITextView *SKTTxtOutput;
@property (nonatomic, weak) MSBClient *client;

- (IBAction)startTemperature:(id)sender;
- (IBAction)stopTemperature:(id)sender;

- (IBAction)addFeeling:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *addFeelingTextField;

@end
