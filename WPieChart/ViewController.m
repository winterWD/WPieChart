//
//  ViewController.m
//  WPieChart
//
//  Created by winter on 16/1/25.
//  Copyright © 2016年 winter. All rights reserved.
//

#import "ViewController.h"
#import "WPieChartView.h"

@interface ViewController ()
@property (weak, nonatomic)  WPieChartView *pieChartView;
@end

static int chartNum = 4;
static int chartIndex = 0;

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    WPieChartView *pieChartView = [[WPieChartView alloc] initWithFrame:CGRectMake(100, 40, 160, 160)];
    [self.view addSubview:pieChartView];
    pieChartView.concentric = YES;
    self.pieChartView = pieChartView;
    
    CGFloat angleValue = 1.0/chartNum;
    [pieChartView addAngleValue:angleValue color:[UIColor redColor]];
    [pieChartView addAngleValue:angleValue color:[UIColor yellowColor]];
    [pieChartView addAngleValue:angleValue color:[UIColor orangeColor]];
    [pieChartView addAngleValue:angleValue color:[UIColor blueColor]];
    pieChartView.amplifyPieChartIndex = chartIndex;
    chartIndex++;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(120, 300, 100, 40);
    [button setTitle:@"next" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)buttonClicked
{
    NSInteger index = chartIndex%chartNum;
    chartIndex++;
    self.pieChartView.amplifyPieChartIndex = index;
}

@end
