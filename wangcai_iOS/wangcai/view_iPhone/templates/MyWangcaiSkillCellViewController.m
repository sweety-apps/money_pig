//
//  MyWangcaiSkillCellViewController.m
//  wangcai
//
//  Created by Lee Justin on 14-2-15.
//  Copyright (c) 2014年 1528studio. All rights reserved.
//

#import "MyWangcaiSkillCellViewController.h"


@implementation MyWangcaiSkillCell

@synthesize icon;
@synthesize lockIcon;
@synthesize titleImg;
@synthesize descriptionImg;

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)dealloc
{
    [icon release];
    [lockIcon release];
    [titleImg release];
    [descriptionImg release];
    [super dealloc];
}

@end


@interface MyWangcaiSkillCellViewController ()

@end

@implementation MyWangcaiSkillCellViewController

@synthesize cell;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [cell release];
    [super dealloc];
}

@end
