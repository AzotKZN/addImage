//
//  ViewController.m
//  PhotoAdd
//
//  Created by Азат on 13.02.15.
//  Copyright (c) 2015 Azat Minvaliev. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void) printPictureAndDescription:(NSMutableArray*)photo and: (NSMutableArray*) photoDescription {
    NSLog(@"%@", photo);
    NSLog(@"Теперь их описания:");
    NSLog(@"%@", photoDescription);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
