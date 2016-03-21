//
//  VCBasicAnimationViewController.m
//  AnimationDemo
//
//  Created by Vic on 16/2/22.
//  Copyright © 2016年 Vic. All rights reserved.
//


/**
 *  Wrapping Conventions
 *      C Type                  Class
 *      ------                  -----
 *      CGPoint                 NSValue
 *      CGSize                  NSValue
 *      CGRect                  NSValue
 *      CGAffineTransform       NSAffineTransform
 *      CATransform3D           NSValue
 *      CGFloat                 NSNumber
 
 *     Key-Value Coding Extensions https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/CoreAnimation_guide/Key-ValueCodingExtensions/Key-ValueCodingExtensions.html#//apple_ref/doc/uid/TP40004514-CH12-SW8
 */

/**
 *  keyPath值 https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/CoreAnimation_guide/AnimatableProperties/AnimatableProperties.html
    position,bounds,opacity,hidden,cornerRadius,borderWidth,borderColor,backgroundColor,shadowOpacity,shadowRadius,shadowOffset,shadowColor,shadowPath,zPosition,contents,contentsRect,transform.rotation.(x,y,z),transform.scale.(x,y,z),transform.translation.(x,y,z)
 */


#import "VCBasicAnimationViewController.h"
#import "VCMacros.h"

@import QuartzCore;

static NSString * const basicCellIdentifier = @"basicCellIdentifier";


@interface VCBasicAnimationViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIImageView *ballImageView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *data;

@end

@implementation VCBasicAnimationViewController

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
    _data = @[@"position",@"bounds",@"opacity",@"hidden",@"cornerRadius",
              @"borderWidth",@"borderColor",@"backgroundColor",@"shadowOpacity",@"shadowRadius",
              @"shadowOffset",@"shadowColor",@"shadowPath",@"contents",
              @"contentsRect",@"transform.rotation.x",@"transform.rotation.y",@"transform.rotation.z",
              @"transform.rotation",@"transform.scale.x",@"transform.scale.y",@"transform.scale.z",
              @"transform.scale",@"transform.translation.x",@"transform.translation.y",@"transform.translation.z",
              @"transform.translation",@"transform"];
}

- (void)initView
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"CABasicAnimation";
    [self initTableView];
    [self initBallView];
    
}

- (void)initBallView
{
    _ballImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    _ballImageView.center = CGPointMake(self.view.center.x + 100, self.view.center.y) ;
    _ballImageView.image = [UIImage imageNamed:@"ball8.jpg"];
    
    [self.view addSubview:_ballImageView];
}

- (void)initTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 180, VCScreenHeight)];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:basicCellIdentifier];
    
    [self.view addSubview:_tableView];
}

#pragma mark - TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:basicCellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:basicCellIdentifier];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:13.0];
    cell.textLabel.text = _data[indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *keyPath = _data[indexPath.row];
    [self removeAnimation];
    
    id fromValue = nil;
    id toValue;
    
    if ([keyPath isEqualToString:@"position"]) {
        fromValue = [NSValue valueWithCGPoint:CGPointMake(100, 100)];
        toValue = [NSValue valueWithCGPoint:CGPointMake(200, 200)];
    } else if ([keyPath isEqualToString:@"bounds"]) {
        fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 20, 20)];
        toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 80, 80)];
    } else if ([keyPath isEqualToString:@"opacity"]) {
        fromValue = [NSNumber numberWithFloat:0.2];
        toValue = [NSNumber numberWithFloat:0.8];
    } else if ([keyPath isEqualToString:@"hidden"]) {
        fromValue = [NSNumber numberWithBool:NO];
        toValue = [NSNumber numberWithBool:YES];
    } else if ([keyPath isEqualToString:@"cornerRadius"]) {
        fromValue = [NSNumber numberWithFloat:6.0];
        toValue = [NSNumber numberWithFloat:40.0];
    } else if ([keyPath isEqualToString:@"borderWidth"]) {
        toValue = [NSNumber numberWithFloat:2.0];
    } else if ([keyPath isEqualToString:@"borderColor"]) {
        _ballImageView.layer.borderWidth = 2.0;
        toValue = (__bridge id)[UIColor redColor].CGColor;
    } else if ([keyPath isEqualToString:@"backgroundColor"]) {
        fromValue = (__bridge id)[UIColor blueColor].CGColor;
        toValue = (__bridge id)[UIColor greenColor].CGColor;
        // 对 ballImageView 修改没有效果
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:keyPath];
        animation.fromValue = fromValue;
        animation.toValue = toValue;
        [self.view.layer addAnimation:animation forKey:keyPath];
        return;
    } else if ([keyPath isEqualToString:@"shadowOpacity"]) {
        [self addShadow];
        fromValue = [NSNumber numberWithFloat:0.0];
        toValue = [NSNumber numberWithFloat:1.0];
    } else if ([keyPath isEqualToString:@"shadowRadius"]) {
        [self addShadow];
        fromValue = [NSNumber numberWithFloat:1.0];
        toValue = [NSNumber numberWithFloat:5.0];
    } else if ([keyPath isEqualToString:@"shadowOffset"]) {
        [self addShadow];
        fromValue = [NSValue valueWithCGSize:CGSizeMake(-2, 2)];
        toValue = [NSValue valueWithCGSize:CGSizeMake(2, -2)];
    } else if ([keyPath isEqualToString:@"shadowColor"]) {
        [self addShadow];
        fromValue = (__bridge id)[UIColor redColor].CGColor;
        toValue = (__bridge id)[UIColor greenColor].CGColor;
    } else if ([keyPath isEqualToString:@"shadowPath"]) {
        [self addShadow];
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:_ballImageView.bounds cornerRadius:10.0];
        toValue = (__bridge id)path.CGPath;
    } else if ([keyPath isEqualToString:@"contents"]) {
        UIImage *contentImage = [UIImage imageNamed:@"anonymous-mask"];
        toValue = (__bridge id)contentImage.CGImage;
    } else if ([keyPath isEqualToString:@"contentsRect"]) {
        _ballImageView.layer.contents = (__bridge id)([UIImage imageNamed:@"anonymous-mask"].CGImage);
        fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 0.5, 0.5)];
        toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 1, 1)];
    } else if ([keyPath isEqualToString:@"transform.rotation.x"]) {
        fromValue = [NSNumber numberWithFloat:M_PI_2];
        toValue = [NSNumber numberWithFloat:6 * M_PI];
    } else if ([keyPath isEqualToString:@"transform.rotation.y"]) {
        fromValue = [NSNumber numberWithFloat:M_PI];
        toValue = [NSNumber numberWithFloat:4 * M_PI];
    } else if ([keyPath isEqualToString:@"transform.rotation.z"]) {
        fromValue = [NSNumber numberWithFloat:M_PI_4];
        toValue = [NSNumber numberWithFloat:5 * M_PI];
    } else if ([keyPath isEqualToString:@"transform.rotation"]) {   // 等同于 transform.rotation.z
        toValue = [NSNumber numberWithFloat:4 * M_PI];
    } else if ([keyPath isEqualToString:@"transform.scale.x"] || [keyPath isEqualToString:@"transform.scale.y"] || [keyPath isEqualToString:@"transform.scale.z"]) {
        fromValue = [NSNumber numberWithFloat:0.5];
        toValue = [NSNumber numberWithFloat:1.5];
    } else if ([keyPath isEqualToString:@"transform.scale"]) {  // x,y,z的平均值
        fromValue = [NSNumber numberWithFloat:0.5];
        toValue = [NSNumber numberWithFloat:1.5];
    } else if ([keyPath isEqualToString:@"transform.translation.x"] || [keyPath isEqualToString:@"transform.translation.y"] || [keyPath isEqualToString:@"transform.translation.z"]) {
        fromValue = [NSNumber numberWithFloat:-20.0];
        toValue = [NSNumber numberWithFloat:20.0];
    } else if ([keyPath isEqualToString:@"transform.translation"]) { // 修改x和y方向的位移
        fromValue = [NSValue valueWithCGSize:CGSizeMake(-20, 20)];
        toValue = [NSValue valueWithCGSize:CGSizeMake(20, -20)];
    } else if ([keyPath isEqualToString:@"transform"]) {
        CATransform3D transform3D = CATransform3DMakeRotation(M_PI, 1, 1, 1);
        transform3D = CATransform3DScale(transform3D, 2, 2, 2);
        transform3D = CATransform3DTranslate(transform3D, 10, 10, 10);
        fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        toValue = [NSValue valueWithCATransform3D:transform3D];
    }
    
    [self addAnimationWithKeyPath:keyPath fromValue:fromValue toValue:toValue];
}

#pragma mark - Private

- (void)addAnimationWithKeyPath:(NSString *)keyPath fromValue:(id)fromValue toValue:(id)toValue
{
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.duration = 2;
    animation.repeatCount = 1;
    animation.beginTime = CACurrentMediaTime() + 0.1;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.autoreverses = NO;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    
    animation.keyPath = keyPath;
    animation.fromValue = fromValue;
    animation.toValue = toValue;
    
    [_ballImageView.layer addAnimation:animation forKey:keyPath];
    
}

- (void)removeAnimation
{
    [self.view.layer removeAllAnimations];
    [_ballImageView.layer removeAllAnimations];
}

- (void)addShadow
{
    _ballImageView.layer.shadowRadius = 5.0;
    _ballImageView.layer.shadowColor = [UIColor blueColor].CGColor;
    _ballImageView.layer.shadowOffset = CGSizeMake(0, 0);
    _ballImageView.layer.shadowOpacity = 0.5;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:_ballImageView.bounds];
    _ballImageView.layer.shadowPath = path.CGPath;
}


@end
