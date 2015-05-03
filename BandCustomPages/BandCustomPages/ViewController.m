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
        [self output:@"Creating tile..."];
        
        NSString *tileName = @"A tile";
        
        MSBIcon *tileIcon = [MSBIcon iconWithUIImage:[UIImage imageNamed:@"A.png"] error:nil];
        MSBIcon *smallIcon = [MSBIcon iconWithUIImage:[UIImage imageNamed:@"Aa.png"] error:nil];
        
        NSUUID *tileID = [[NSUUID alloc] initWithUUIDString:@"ABCDBA9F-12FD-47A5-83A9-E7270A43BB99"];
        MSBTile *tile = [MSBTile tileWithId:tileID name:tileName tileIcon:tileIcon smallIcon:smallIcon error:nil];
        
        MSBTextBlock *textBlock = [[MSBTextBlock alloc] initWithRect:[MSBRect rectwithX:0 y:0 width:230 height:40] font:MSBTextBlockFontSmall baseline:25];
        textBlock.elementId = 10;
        textBlock.horizontalAlignment = MSBPageElementHorizontalAlignmentLeft;
        textBlock.baselineAlignment = MSBTextBlockBaselineAlignmentAbsolute;
        textBlock.color = [MSBColor colorWithRed:0xff green:0xff blue:0xff];
        
        MSBBarcode *barcode = [[MSBBarcode alloc] initWithRect:[MSBRect rectwithX:0 y:5 width:230 height:95] barcodeType:MSBBarcodeTypeCODE39];
        barcode.elementId = 11;
        barcode.color = [MSBColor colorWithRed:0xff green:0xff blue:0xff];
        
        MSBFlowList *flowList = [[MSBFlowList alloc] initWithRect:[MSBRect rectwithX:15 y:0 width:260 height:105] orientation:MSBFlowListOrientationVertical];
        flowList.margins = [MSBMargins marginsWithLeft:0 top:0 right:0 bottom:0];
        flowList.color = nil;
        [flowList.children addObject:textBlock];
        [flowList.children addObject:barcode];
        
        MSBPageLayout *page = [MSBPageLayout new];
        page.root = flowList;
        [tile.pageLayouts addObject:page];
        
        [self.client.tileManager addTile:tile completionHandler:^(NSError *error) {
            if (!error || error.code == MSBErrorCodeTileAlreadyExist)
            {
                [self output:@"Creating page..."];
                
                NSUUID *pageID = [[NSUUID alloc] initWithUUIDString:@"1234BA9F-12FD-47A5-83A9-E7270A43BB99"];
                NSArray *pageValues = @[[MSBPageBarcodeCode39Data pageBarcodeCode39DataWithElementId:11 value:@"A1 B" error:nil],
                                        [MSBPageTextData pageTextDataWithElementId:10 text:@"Barcode value: A1 B" error:nil]];
                MSBPageData *page = [MSBPageData pageDataWithId:pageID templateIndex:0 value:pageValues];
                
                [self.client.tileManager setPages:@[page] tileId:tile.tileId completionHandler:^(NSError *error) {
                    if (!error)
                    {
                        [self output:@"Successfully Finished!!! You can remove tile via Microsoft Health App."];
                    }
                    else
                    {
                        [self output:error.localizedDescription];
                    }
                }];
            }
            else
            {
                [self output:error.localizedDescription];
            }
        }];
    }
    else
    {
        [self output:@"Band is not connected. Please wait...."];
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
    [self output:error.description];
}

#pragma mark - Class methods

- (IBAction)startHeartRate:(UIButton *)sender {
}
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
