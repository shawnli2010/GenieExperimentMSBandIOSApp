//
//  HeartRateViewController.m
//  BandSensor
//
//  Created by Xueyang Li on 5/2/15.
//  Copyright (c) 2015 Microsoft. All rights reserved.
//

#import "HeartRateViewController.h"

@interface HeartRateViewController ()
{
    NSMutableArray *pickerFeelingArray;
    UIPickerView *feelingPicker;
}
@end

@implementation HeartRateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    pickerFeelingArray = [[NSMutableArray alloc] init];
    [pickerFeelingArray addObject:@""];
    [pickerFeelingArray addObject:@"Good"];
    [pickerFeelingArray addObject:@"Cold"];
    [pickerFeelingArray addObject:@"Cool"];
    [pickerFeelingArray addObject:@"Slightly Cool"];
    [pickerFeelingArray addObject:@"Hot"];
    [pickerFeelingArray addObject:@"Warm"];
    [pickerFeelingArray addObject:@"Slightly Warm"];
    
    [self addFeelingPicker];
    
    
//    [MSBClientManager sharedManager].delegate = self;
//    NSArray	*clients = [[MSBClientManager sharedManager] attachedClients];
//    _client = [clients firstObject];
//    if ( _client == nil )
//    {
//        [self output:@"Failed! No Bands attached."];
//        return;
//    }
//    
//    [[MSBClientManager sharedManager] connectClient:_client];
//    [self output:@"Please wait. Connecting to Band..."];
    
    //keyboard disappear when tapping outside of text field
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
}

# pragma mark - dismissKeyboard
-(void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startHeartRate:(id)sender{
    
    if (self.client && self.client.isDeviceConnected)
    {
        [self output:@"Starting HeartRate detection"];
        [self.client.sensorManager startHearRateUpdatesToQueue:nil errorRef:nil withHandler:^(MSBSensorHeartRateData *heartRateData, NSError *error) {
            NSString *myString = [NSString stringWithFormat:@"q: %d, r: %d", (int)(heartRateData.quality), (int)heartRateData.heartRate];
            NSDate *date = [NSDate date];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
            NSString *timeString = [formatter stringFromDate:date];
            NSString* outString = [NSString stringWithFormat:@"%@:  %@", timeString, myString];
            if (heartRateData.quality != 0) {
                [self output:outString];
            }
        }];
        
        [self.client.sensorManager startBandContactUpdatesToQueue:nil errorRef:nil withHandler:^(MSBSensorBandContactData *contactData, NSError *error) {
            NSString *myString = [NSString stringWithFormat:@"Wear State, %d", (int)(contactData.wornState)];
            NSDate *date = [NSDate date];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"%hh:%mm:%ss"];
            NSString *timeString = [formatter stringFromDate:date];
            NSString* outString = [NSString stringWithFormat:@"%@, %@", myString, timeString];
            [self output:outString];
        }];
        
    }
    else
    {
        [self output:@"Band is not connected. Please wait...."];
    }
}

- (IBAction)stopHeartRate:(id)sender
{
    [self output:@"Stop HeartRate detection"];
    [self.client.sensorManager stopHeartRateUpdatesErrorRef:nil];
}

-(IBAction)addFeeling:(id)sender
{
    NSString *feelingString = self.addFeelingTextField.text;
    NSString *message = [@"I feel " stringByAppendingString:feelingString];
    [self output:message];
}

#pragma mark - Client Manager Delegates

- (void)clientManager:(MSBClientManager *)clientManager clientDidConnect:(MSBClient *)client
{
    [self output:@"Band connected."];
}

- (void)clientManager:(MSBClientManager *)clientManager clientDidDisconnect:(MSBClient *)client
{
    [self output:@"Band disconnected."];
}

- (void)clientManager:(MSBClientManager *)clientManager client:(MSBClient *)client didFailToConnectWithError:(NSError *)error
{
    [self output:@"Failed to connect to Band."];
    [self output:error.description];
}

- (void)output:(NSString *)message
{
    self.HRTxtOutput.text = [NSString stringWithFormat:@"%@\n%@", self.HRTxtOutput.text, message];
    CGPoint p = [self.HRTxtOutput contentOffset];
    [self.HRTxtOutput setContentOffset:p animated:NO];
    [self.HRTxtOutput scrollRangeToVisible:NSMakeRange([self.HRTxtOutput.text length], 0)];
}

/*************************************************************************************/
#pragma mark - Picker View Data source
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component {
    return pickerFeelingArray.count;
}

#pragma mark- Picker View Delegate
-(NSString *)pickerView:(UIPickerView *)pickerView
            titleForRow:(NSInteger)row
           forComponent:(NSInteger)component
{
    return [pickerFeelingArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component
{
    self.addFeelingTextField.text = [NSString stringWithFormat:@"%@", [pickerFeelingArray objectAtIndex:row]];
}

#pragma mark - add picker helper method
// Helper method to add the picker
-(void)addFeelingPicker
{
    feelingPicker = [[UIPickerView alloc] initWithFrame:CGRectZero];
    feelingPicker.delegate = self;
    feelingPicker.dataSource = self;
    [feelingPicker setShowsSelectionIndicator:YES];
    self.addFeelingTextField.inputView = feelingPicker;
    
    // Create done button in UIPickerView
    UIToolbar*  mypickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    mypickerToolbar.barStyle = UIBarStyleBlackOpaque;
    [mypickerToolbar sizeToFit];
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [barItems addObject:flexSpace];
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pickerDoneClicked)];
    [barItems addObject:doneBtn];
    
    [mypickerToolbar setItems:barItems animated:YES];
    self.addFeelingTextField.inputAccessoryView = mypickerToolbar;
}

-(void)pickerDoneClicked
{
    [self.addFeelingTextField resignFirstResponder];
}


@end
