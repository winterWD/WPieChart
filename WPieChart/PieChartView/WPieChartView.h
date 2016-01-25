//
//  WPieChartView.h
//  WPieChart
//
//  Created by winter on 16/1/25.
//  Copyright © 2016年 winter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPieChartView : UIView

/** chartBackgroundColor */
@property (nonatomic, strong) UIColor *chartBackgroundColor;

/** 是否为空心同轴 */
@property (nonatomic, getter=isConcentric) BOOL concentric;
/** 空心半径 默认 小于图表半径 10pt*/
@property (nonatomic, assign) CGFloat concentricRadius;
/** 空心颜色 默认白色*/
@property (nonatomic, strong) UIColor *concentricColor;
/** 放大某个图表 默认放大10pt*/
@property (nonatomic, assign) NSInteger amplifyPieChartIndex;

/** 添加 一个新的 pieChart */
- (void)addAngleValue:(CGFloat)angle color:(UIColor *)color;
/** 插入 一个新的 pieChart */
- (void)insertAngleValue:(CGFloat)angle color:(UIColor *)color atIndex:(NSInteger)index;

/** 放大某一个 pieChart */
- (void)amplifyPieChartWithIndex:(NSInteger)index amplifyValue:(CGFloat)amplifyValue;
@end

@interface WArcValueClass : NSObject

@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) CGFloat angle;
@property (nonatomic, assign) CGFloat amplifyValue;

@end
