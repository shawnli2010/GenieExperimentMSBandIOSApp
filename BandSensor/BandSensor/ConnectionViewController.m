//
//  ConnectionViewController.m
//  BandSensor
//
//  Created by Xueyang Li on 5/2/15.
//  Copyright (c) 2015 Microsoft. All rights reserved.
//

#import "ConnectionViewController.h"
#import "HeartRateViewController.h"
#import "SkinTemperatureViewController.h"

@interface ConnectionViewController ()
{
    CGFloat screenHeight;
    CGFloat screenWidth;
    
    UILabel *titleLabel;
    UIButton *startButton;
}
@end

@implementation ConnectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    titleLabel = [[UILabel alloc] init];
    startButton = [[UIButton alloc] init];
    self.hud = [[MBProgressHUD alloc] init];

    
    // Get the current screen height and size
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    screenWidth = screenRect.size.width;
    screenHeight = screenRect.size.height;
    
    [titleLabel setText:@"Genie Microsoft Band Experiment"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self centerSubview:titleLabel withX:20 Y:screenHeight/6 height:30];
    titleLabel.font = [titleLabel.font fontWithSize:35];
    titleLabel.adjustsFontSizeToFitWidth = YES;
    titleLabel.minimumScaleFactor = 0.5;
    
    [startButton setTitle:@"CONNECT TO BAND" forState:UIControlStateNormal];
    [self centerSubview:startButton withX:60 Y:(screenHeight/6) * 4 height:40];
    [startButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [[startButton layer] setBorderWidth:1.0f];
    [[startButton layer] setBorderColor:[[UIColor blackColor] CGColor]];
    [startButton addTarget:self action:@selector(startButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:titleLabel];
    [self.view addSubview:startButton];
    [self.view addSubview:self.hud];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)centerSubview:(UIView *)subView withX:(CGFloat)xCoordinate Y:(CGFloat)yCoordinate height:(CGFloat)height
{
    CGFloat width = screenWidth - 2*xCoordinate;
    subView.frame = CGRectMake(xCoordinate,yCoordinate,width,height);
}

-(void)startButtonPressed
{
    [self.hud show:YES];
    
    [MSBClientManager sharedManager].delegate = self;
    NSArray	*clients = [[MSBClientManager sharedManager] attachedClients];
    _client = [clients firstObject];
    if ( _client == nil )
    {
        [self.hud hide:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed"
                                                        message:@"No Bands Attached"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    [[MSBClientManager sharedManager] connectClient:_client];
//    [self output:@"Please wait. Connecting to Band..."];
    
}

#pragma mark - Client Manager Delegates

- (void)clientManager:(MSBClientManager *)clientManager clientDidConnect:(MSBClient *)client
{
    [self.hud hide:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                    message:@"Band connected!"
                                                   delegate:nil
                                          cancelButtonTitle:@"Start Experiment"
                                          otherButtonTitles:nil];
    [alert show];
    [self performSegueWithIdentifier:@"startExperiment" sender:self];
}

- (void)clientManager:(MSBClientManager *)clientManager clientDidDisconnect:(MSBClient *)client
{
    NSLog(@"in ConnectedViewController disconnected");
}

- (void)clientManager:(MSBClientManager *)clientManager client:(MSBClient *)client didFailToConnectWithError:(NSError *)error
{
    NSLog(@"in ConnectedViewController failed to connect to band");
}

#pragma mark - prepare for segue

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"startExperiment"])
    {
        UITabBarController *dest = (UITabBarController *)segue.destinationViewController;
        SkinTemperatureViewController *sktController = [dest.viewControllers objectAtIndex:0];
        sktController.client = _client;
        HeartRateViewController *hrController = [dest.viewControllers objectAtIndex:1];
        hrController.client = _client;
    }
}


@end
