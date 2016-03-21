//
//  VCKeyframeAnimationViewController.m
//  AnimationDemo
//
//  Created by Vic on 16/2/22.
//  Copyright © 2016年 Vic. All rights reserved.
//

#import "VCKeyframeAnimationViewController.h"
#import "VCMacros.h"

@import QuartzCore;

static NSString * const keyframeAnimationCell = @"keyframeAnimationCell";

@interface VCKeyframeAnimationViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UIImageView *ballImageView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *data;

@end

@implementation VCKeyframeAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Init


- (void)initData
{
    _data = @[@"values",@"path",@"keyTimes",@"timingFunctions",@"calculationMode"];
}

- (void)initView
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"CAKeyframeAnimation";
    [self initTableView];
    [self initBallView];
}

- (void)initTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 180, VCScreenHeight)];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:keyframeAnimationCell];
    
    [self.view addSubview:_tableView];
}

- (void)initBallView
{
    _ballImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    _ballImageView.center = CGPointMake(self.view.center.x + 100, self.view.center.y) ;
    _ballImageView.image = [UIImage imageNamed:@"ball8.jpg"];
    
    [self.view addSubview:_ballImageView];
}

#pragma mark - TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:keyframeAnimationCell forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:keyframeAnimationCell];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:13.0];
    cell.textLabel.text = _data[indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self removeAnimate];
    
    NSString *property = _data[indexPath.row];
    
    if ([property isEqualToString:@"values"]) {
        NSValue *position1 = [NSValue valueWithCGPoint:CGPointMake(200, 100)];
        NSValue *position2 = [NSValue valueWithCGPoint:CGPointMake(250, 300)];
        NSValue *position3 = [NSValue valueWithCGPoint:CGPointMake(300, 100)];
        NSArray *values = @[position1,position2,position3];
        [self addAnimateWithKeypath:@"position" property:property value:values];
    } else if ([property isEqualToString:@"path"]) {
        //path只对CALayer的anchorPoint和position起作用。如果你设置了path，那么values将被忽略
        UIBezierPath *path = [UIBezierPath bezierPath];
        // 字母V
        [path moveToPoint:CGPointMake(200, 100)];
        [path addLineToPoint:CGPointMake(250, 300)];
        [path addLineToPoint:CGPointMake(300, 100)];
        // 字母i
        [path moveToPoint:CGPointMake(250, 100)];
        [path moveToPoint:CGPointMake(250, 120)];
        [path addLineToPoint:CGPointMake(250, 300)];
        // 字母c
        [path moveToPoint:CGPointMake(250, 100)];
        [path addArcWithCenter:CGPointMake(250, 150) radius:50 startAngle:3 * M_PI_2 endAngle:M_PI_2 clockwise:NO];
        
        id value = (__bridge id)path.CGPath;
        [self addAnimateWithKeypath:@"position" property:property value:value];
    } else if ([property isEqualToString:@"keyTimes"]) {
        // 可以为对应的关键帧指定对应的时间点,其取值范围为0到1.0,keyTimes中的每一个时间值都对应values中的每一帧.当keyTimes没有设置的时候,各个关键帧的时间是平分的
        NSArray *keyTimes = @[@0,@0.8,@1.0];
        [self addAnimateWithKeypath:@"position" property:property value:keyTimes];
        
    } else if ([property isEqualToString:@"timingFunctions"]) {
        // 如果values有n个，则timingFunctions有n-1个，对应于相应的区间timingFunction
        CAMediaTimingFunction *timingFunction1 = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        CAMediaTimingFunction *timingFunction2 = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
        NSArray *timingFunctions = @[timingFunction1,timingFunction2];
        [self addAnimateWithKeypath:@"position" property:property value:timingFunctions];
    } else if ([property isEqualToString:@"calculationMode"]) {
        // 对anchorPoint 和 position 进行的动画，当在平面座标系中有多个离散的点的时候,可以是离散的,也可以直线相连后进行插值计算,也可以使用圆滑的曲线将他们相连后进行插值计算。
        //kCAAnimationLinear[默认],关键帧之间直接直线相连进行插值计算;
        //kCAAnimationDiscrete,不进行插值计算,所有关键帧直接逐个进行显示
        //kCAAnimationPaced,使得动画均匀进行,而不是按keyTimes设置的或者按关键帧平分时间,此时keyTimes和timingFunctions无效;
        //kCAAnimationCubic,对关键帧为座标点的关键帧进行圆滑曲线相连后插值计算，这里的主要目的是使得运行的轨迹变得圆滑；
        //kCAAnimationCubicPaced,在kCAAnimationCubic的基础上使得动画运行变得均匀,就是系统时间内运动的距离相同,此时keyTimes以及timingFunctions也是无效的
        NSString *calculationMode = kCAAnimationCubicPaced;
        [self addAnimateWithKeypath:@"position" property:property value:calculationMode];
    }
}

#pragma mark - Private

- (void)addAnimateWithKeypath:(NSString *)keypath property:(NSString *)property value:(id)value
{
    CAKeyframeAnimation *keyframeAnimation = [CAKeyframeAnimation animation];
    keyframeAnimation.repeatCount = 1;
    keyframeAnimation.duration = 4.0;
    keyframeAnimation.removedOnCompletion = NO;
    keyframeAnimation.fillMode = kCAFillModeForwards;
    keyframeAnimation.beginTime = CACurrentMediaTime() + 0.01;
    keyframeAnimation.autoreverses = NO;
    keyframeAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    keyframeAnimation.keyPath = keypath;
    [keyframeAnimation setValue:value forKey:property];
    
    if (!([property isEqualToString:@"values"] || [property isEqualToString:@"path"])) {
        NSValue *position1 = [NSValue valueWithCGPoint:CGPointMake(200, 100)];
        NSValue *position2 = [NSValue valueWithCGPoint:CGPointMake(250, 300)];
        NSValue *position3 = [NSValue valueWithCGPoint:CGPointMake(320, 100)];
        NSArray *values = @[position1,position2,position3];
        keyframeAnimation.values = values;
    }
    
    [_ballImageView.layer addAnimation:keyframeAnimation forKey:property];
}

- (void)removeAnimate
{
    [_ballImageView.layer removeAllAnimations];
}

@end
