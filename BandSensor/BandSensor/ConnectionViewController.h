//
//  ConnectionViewController.h
//  BandSensor
//
//  Created by Xueyang Li on 5/2/15.
//  Copyright (c) 2015 Microsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MicrosoftBandKit_iOS/MicrosoftBandKit_iOS.h>
#import "MBProgressHUD.h"

@interface ConnectionViewController : UIViewController <MSBClientManagerDelegate>

@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, weak) MSBClient *client;


@end
