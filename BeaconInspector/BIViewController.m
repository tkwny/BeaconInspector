//
//  BIViewController.m
//  BeaconInspector
//
//  Created by Randy Bradshaw on 5/9/14.
//  Copyright (c) 2014 Click Here Labs. All rights reserved.
//

#import "BIViewController.h"

static NSString * const beaconUUID = @"B9407F30-F5F8-466E-AFF9-25556B57FE6D";
static NSString * const beaconIdentifier = @"CHL";
static NSString * const beaconCellIdentifier = @"DefaultCell";
static NSInteger pMajor = 15;
static NSInteger pMinor = 2895;


@interface BIViewController ()

@property (strong,nonatomic) CLLocationManager *locationManager;
@property (strong,nonatomic) CLBeaconRegion *beaconRegion;
@property (strong,nonatomic) CBPeripheralManager *peripheralManager;
@property (strong,nonatomic) NSArray *detectedBeacons;


@end

@implementation BIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}


#pragma mark - Beacon Ranging

-(void)createBeaconRegion{

}

-(void)turnRangingOn{
    
}

-(void)changeRangingState:sender{
    
}

-(void)startRangingForBeacons{
    
}

-(void)stopRangingForBeacons{
    
}


#pragma mark - Beacon Ranging Delegate Methods
-(void)locationManager:(CLLocationManager *)manager
    didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    
}

-(void)locationManager:(CLLocationManager *)manager
       didRangeBeacons:(NSArray *)beacons
       inRegion:(CLBeaconRegion *)region{
    
}


#pragma mark - Beacon Advertising
-(void)turnAdvertisingOn{
    
}

-(void)changeAdvertisingState:sender{
    
}

-(void)startAdvertisingBeacon{
    
}

-(void)stopAdvertisingBeacon{
    
}


#pragma mark - Beacon Advertising Delegage Methods
-(void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error{
    
}

-(void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral{
    
}


#pragma mark - Table View Functionality
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CLBeacon *beacon = self.detectedBeacons[indexPath.row];
    
    //create the cell
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:beaconCellIdentifier];
    
    
    cell.textLabel.text = beacon.proximityUUID.UUIDString;
    
    NSString *proximityString;
    
    switch (beacon.proximity) {
        case CLProximityImmediate:
            proximityString = @"IMMEDIATE";
            cell.backgroundColor = [UIColor redColor];
            break;
        case CLProximityNear:
            proximityString = @"NEAR";
            cell.backgroundColor = [UIColor yellowColor];
            break;
        case CLProximityFar:
            proximityString = @"FAR";
            cell.backgroundColor = [UIColor blueColor];
            break;
        case CLProximityUnknown:
            proximityString = @"UNKNOWN";
            cell.backgroundColor = [UIColor grayColor];
            break;
    }
    
    
    
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"Detected Beacons";
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
