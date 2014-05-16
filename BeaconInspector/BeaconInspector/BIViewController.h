//
//  BIViewController.h
//  BeaconInspector
//
//  Created by Randy Bradshaw on 5/9/14.
//  Copyright (c) 2014 Click Here Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <AudioToolbox/AudioToolbox.h>

@interface BIViewController : UIViewController <CLLocationManagerDelegate, CBPeripheralManagerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UISwitch *advertiseSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *locateSwitch;
@property (weak, nonatomic) IBOutlet UITableView *beaconsTableView;

@end
