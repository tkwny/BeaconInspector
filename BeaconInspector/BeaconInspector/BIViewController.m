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

@property (nonatomic,strong) CLLocationManager *locationManager;
@property (nonatomic,strong) CLBeaconRegion *beaconRegion;
@property (nonatomic,strong) CBPeripheralManager *peripheralManager;
@property (nonatomic,strong) NSArray *detectedBeacons;


@end

@implementation BIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.advertiseSwitch addTarget:self action:@selector(changeAdvertisingState:) forControlEvents:UIControlEventValueChanged];
    [self.locateSwitch addTarget:self action:@selector(changeRangingState:) forControlEvents:UIControlEventValueChanged];
}


#pragma mark - Beacon Ranging

-(void)createBeaconRegion{
    if (self.beaconRegion)
        return;
        
        NSUUID *proximityUUID = [[NSUUID alloc] initWithUUIDString:beaconUUID];
        self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:proximityUUID identifier:beaconIdentifier];
        self.beaconRegion.notifyEntryStateOnDisplay = TRUE;
}

-(void)turnRangingOn{
    NSLog(@"Turning on ranging.");
    if(![CLLocationManager isRangingAvailable]){
        NSLog(@"Unable to turn on ranging: Ranging is not availble");
        self.locateSwitch.on = NO;
        return;
    }
    
    if (self.locationManager.rangedRegions.count > 0) {
        NSLog(@"Didn't turn on ranging: Ranging is already on.");
        return;
    }
    
    [self createBeaconRegion];
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
    NSLog(@"Ranging turned on for region: %@", self.beaconRegion);
}

-(void)changeRangingState:sender{
    UISwitch *theSwitch = (UISwitch*)sender;
    
    if (theSwitch.on) {
        [self startRangingForBeacons];
    }
    else {
        [self stopRangingForBeacons];
    }
}

-(void)startRangingForBeacons{
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    self.locationManager.activityType = CLActivityTypeFitness;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [self turnRangingOn];
}

-(void)stopRangingForBeacons{
    if (self.locationManager.rangedRegions.count == 0) {
        NSLog(@"Unable to turn off ranging: Ranging is already off.");
    }
    [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
    self.detectedBeacons = nil;
    [self.beaconsTableView reloadData];
    
    NSLog(@"Turned off ranging.");
}


#pragma mark - Beacon Ranging Delegate Methods
-(void)locationManager:(CLLocationManager *)manager
    didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"Unable to turn on ranging: Location services are not enabled.");
        self.locateSwitch.on = NO;
        return;
    }
    
    if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorized) {
        NSLog(@"Unable to turn on ranging: Location services not authorized.");
        self.locateSwitch.on = NO;
        return;
    }
    self.locateSwitch.on = YES;
}


-(void)locationManager:(CLLocationManager *)manager
       didRangeBeacons:(NSArray *)beacons
       inRegion:(CLBeaconRegion *)region{
    if ([beacons count] == 0) {
        NSLog(@"No beacons found nearby.");
    }
    else{
        NSLog(@"Beacons found.");
    }
    self.detectedBeacons = beacons;
    [self.beaconsTableView reloadData];
}



#pragma mark - Beacon Advertising
-(void)turnAdvertisingOn{
    if (self.peripheralManager.state != 5) {
        NSLog(@"Peripheral Manager is off.");
        self.advertiseSwitch.on = NO;
        return;
    }
    
    time_t t;
    srand((unsigned) time(&t));
    CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:self.beaconRegion.proximityUUID major:pMajor minor:pMinor identifier:self.beaconRegion.identifier];
    NSDictionary *beaconPeripheralData = [region peripheralDataWithMeasuredPower:nil];
    [self.peripheralManager startAdvertising:beaconPeripheralData];
}

-(void)changeAdvertisingState:sender{
    UISwitch  *theSwitch = (UISwitch *)sender;
    if (theSwitch.on) {
        [self startAdvertisingBeacon];
    }
    else{
        [self stopAdvertisingBeacon];
    }
}

-(void)startAdvertisingBeacon{
    NSLog(@"Turning on beacon advertising.");
    [self createBeaconRegion];
    
    if (!self.peripheralManager) {
        self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil options:nil];
        [self turnAdvertisingOn];
    }
}

-(void)stopAdvertisingBeacon{
    [self.peripheralManager stopAdvertising];
    NSLog(@"Turned off beacon advertising.");
}


#pragma mark - Beacon Advertising Delegage Methods
-(void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error{
    if (error) {
        NSLog(@"Cound not turn on iBeacon advertising: %@", error);
        self.advertiseSwitch.on = NO;
        return;
    }
    if (self.peripheralManager.isAdvertising) {
        self.advertiseSwitch.on = YES;
    }
}

-(void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral{
    if(self.peripheralManager.state != 5){
        NSLog(@"Peripheral Manager is off.");
        self.advertiseSwitch.on = NO;
        return;
    }
    NSLog(@"Peripheral manager is on.");
    [self turnAdvertisingOn];
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
            NSLog(@"Beacon found IMMEDIATE proximity");
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
    
    NSString *beaconColor = @"BEACON";
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@ : %@ : %@ : %f : %li",
                                 beaconColor,
                                 beacon.major.stringValue,
                                 beacon.minor.stringValue,
                                 proximityString,
                                 beacon.accuracy,
                                 (long)beacon.rssi];
    
    cell.detailTextLabel.textColor = [UIColor blackColor];
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.detectedBeacons.count;
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
