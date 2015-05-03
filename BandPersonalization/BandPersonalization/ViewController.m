/*---------------------------------------------------------------------------------------------------
 *
 * Copyright (c) Microsoft Corporation All rights reserved.
 *
 * MIT License:
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
 * associated documentation files (the  "Software"), to deal in the Software without restriction,
 * including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial
 * portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED ""AS IS"", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
 * NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
 * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 * ------------------------------------------------------------------------------------------------*/

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, weak) MSBClient *client;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [MSBClientManager sharedManager].delegate = self;
    NSArray	*clients = [[MSBClientManager sharedManager] attachedClients];
    _client = [clients firstObject];
    if ( _client == nil )
    {
        [self output:@"Failed! No Bands attached."];
        return;
    }
    
    [[MSBClientManager sharedManager] connectClient:_client];
    [self output:@"Please wait. Connecting to Band..."];
}

- (IBAction)runExampleCode:(id)sender
{
    if (self.client && self.client.isDeviceConnected)
    {
        [self output:@"Updating MeTile image..."];
        MSBImage *image = [[MSBImage alloc] initWithUIImage:[UIImage imageNamed:@"SampleMeTileImage.jpg"]];
        [self.client.personalizationManager updateMeTileImage:image completionHandler:^(NSError *error) {
            if (!error) {
                [self output:@"Successfully Finished!!!"];
            }
            else
            {
                [self output:error.localizedDescription];
            }
        }];
    }
    else
    {
        [self output:@"Band is not connected. Wait...."];
    }
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
    [self output:error.localizedDescription];
}

#pragma mark - Class methods

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)output:(NSString *)message
{
    self.txtOutput.text = [NSString stringWithFormat:@"%@\n%@", self.txtOutput.text, message];
    CGPoint p = [self.txtOutput contentOffset];
    [self.txtOutput setContentOffset:p animated:NO];
    [self.txtOutput scrollRangeToVisible:NSMakeRange([self.txtOutput.text length], 0)];
}

@end
