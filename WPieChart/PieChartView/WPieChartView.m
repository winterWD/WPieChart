//
//  WPieChartView.m
//  WPieChart
//
//  Created by winter on 16/1/25.
//  Copyright © 2016年 winter. All rights reserved.
//

#import "WPieChartView.h"
#import <math.h>

#define ANGLE(val)      DEG2RAD(270 + (val))
#define DEG2RAD(val)    (M_PI / 180) * (val)
#define RADIUS_MARGIN   10

@interface WPieChartView ()

/** 图表 值 颜色 */
@property (nonatomic, strong) NSMutableArray *valuesAndColors;

@end

@implementation WPieChartView
{
    CGPoint _center;
    CGFloat _radius;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self bootstrap];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self bootstrap];
    }
    return self;
}

- (void)bootstrap
{
    self.backgroundColor = [UIColor clearColor];
    self.valuesAndColors = [NSMutableArray array];
}

- (void)setConcentric:(BOOL)concentric
{
    _concentric = concentric;
    
    // 空心白色半径 = 彩色图表半径 - 10
    self.concentricRadius = (MIN(self.bounds.size.width, self.bounds.size.height) / 2) - RADIUS_MARGIN - 10;
    self.concentricColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
}

- (void)setAmplifyPieChartIndex:(NSInteger)amplifyPieChartIndex
{
    _amplifyPieChartIndex = amplifyPieChartIndex;
    
    if (amplifyPieChartIndex > self.valuesAndColors.count -1) {
        NSLog(@"error : %s -- index %ld beyond bounds array",__func__, (long)amplifyPieChartIndex);
        return;
    }
    
    [self.valuesAndColors enumerateObjectsUsingBlock:^(WArcValueClass * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == amplifyPieChartIndex) {
            obj.amplifyValue = 10;
        }
        else {
            obj.amplifyValue = 0;
        }
    }];
    
    [self setNeedsDisplay];
}

#pragma mark -
#pragma mark - add pie method

- (void)addAngleValue:(CGFloat)angle color:(UIColor *)color
{
    WArcValueClass *value = [[WArcValueClass alloc] init];
    value.angle = angle;
    value.color = color;
    
    [self.valuesAndColors addObject:value];
    [self setNeedsDisplay];
}

- (void)insertAngleValue:(CGFloat)angle color:(UIColor *)color atIndex:(NSInteger)index
{
    WArcValueClass *value = [[WArcValueClass alloc] init];
    value.angle = angle;
    value.color = color;
    
    [self.valuesAndColors insertObject:value atIndex:index];
    [self setNeedsDisplay];
}

- (void)amplifyPieChartWithIndex:(NSInteger)index amplifyValue:(CGFloat)amplifyValue
{
    if (index > self.valuesAndColors.count -1) {
        NSLog(@"error : %s -- index %ld beyond bounds array",__func__, (long)index);
        return;
    }
    
    [self.valuesAndColors enumerateObjectsUsingBlock:^(WArcValueClass * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == index) {
            obj.amplifyValue = amplifyValue;
        }
        else {
            obj.amplifyValue = 0;
        }
    }];
    
    [self setNeedsDisplay];
}

#pragma mark -
#pragma mark - drawing method

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    _center = CGPointMake(self.center.x - self.frame.origin.x, self.center.y - self.frame.origin.y);
    _radius = (MIN(self.bounds.size.width, self.bounds.size.height) / 2) - RADIUS_MARGIN;
    
    // chart backgroung color
    if (self.chartBackgroundColor) {
        CGMutablePathRef path = creatArc(_center, _radius, ANGLE(0), ANGLE(360));
        creatAndFillArc(context, path, self.chartBackgroundColor.CGColor);
    }
    
    // chart
    __block CGFloat startAngle = 0;
    [self.valuesAndColors enumerateObjectsUsingBlock:^(WArcValueClass *obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        CGColorRef color = obj.color.CGColor;
        CGFloat angle = obj.angle;
        CGFloat radius = _radius + obj.amplifyValue;
        
        CGFloat angleValue = 360 * angle;
        CGFloat endAngle = startAngle + angleValue;
        
        CGMutablePathRef path = creatArc(_center, radius, ANGLE(startAngle), ANGLE(endAngle));
        creatAndFillArc(context, path, color);
        
        startAngle += angleValue;
    }];
    
    // whether concentric circle
    if (self.isConcentric && self.concentricRadius > 0 && self.concentricColor) {
        CGMutablePathRef path = creatArc(_center, _concentricRadius, ANGLE(0), ANGLE(360));
        creatAndFillArc(context, path, self.concentricColor.CGColor);
    }
}

void creatAndFillArc (CGContextRef context, CGPathRef path, CGColorRef color)
{
    CGContextSetFillColor(context, CGColorGetComponents(color));
    CGContextAddPath(context, path);
    CGContextDrawPath(context, kCGPathFill);
    CGPathRelease(path);
}

CGMutablePathRef creatArc (CGPoint center, CGFloat radius, CGFloat startAngle, CGFloat endAngle)
{
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathAddArc(path, NULL, center.x, center.y, radius, startAngle, endAngle, 0);
    CGPathAddLineToPoint(path, NULL, center.x, center.y);
    CGPathCloseSubpath(path);
    return path;
}

@end

@implementation WArcValueClass

@end