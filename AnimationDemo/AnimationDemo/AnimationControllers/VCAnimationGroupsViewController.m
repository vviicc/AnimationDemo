//
//  VCAnimationGroupsViewController.m
//  AnimationDemo
//
//  Created by Vic on 16/2/22.
//  Copyright © 2016年 Vic. All rights reserved.
//

#import "VCAnimationGroupsViewController.h"

@import QuartzCore;

@interface VCAnimationGroupsViewController ()
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation VCAnimationGroupsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self startAnimateGroup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initView
{
    self.title = @"CAAnimationGroup";
    [self initNavigationItem];
    self.view.backgroundColor = [UIColor whiteColor];
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    _imageView.center = self.view.center;
    _imageView.image = [UIImage imageNamed:@"anonymous-mask"];
    
    [self.view addSubview:_imageView];
}

- (void)initNavigationItem
{
    UIBarButtonItem *pauseItem = [[UIBarButtonItem alloc] initWithTitle:@"暂停" style:UIBarButtonItemStylePlain target:self action:@selector(pauseAnimate:)];
    UIBarButtonItem *startItem = [[UIBarButtonItem alloc] initWithTitle:@"启动" style:UIBarButtonItemStylePlain target:self action:@selector(startAnimateGroup)];
    self.navigationItem.rightBarButtonItems = @[pauseItem,startItem];
}

- (void)startAnimateGroup
{
    CAAnimationGroup *animateGroup = [CAAnimationGroup animation];
    animateGroup.animations = @[[self rotationAnimate],[self positionAnimate]];
    animateGroup.duration = 5.0;
    animateGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animateGroup.fillMode = kCAFillModeForwards;
    animateGroup.removedOnCompletion = NO;
    animateGroup.beginTime = CACurrentMediaTime() + 0.01;
    
    [_imageView.layer addAnimation:animateGroup forKey:@"animateGroup"];
}

- (void)pauseAnimate:(id)sender
{
    [_imageView.layer removeAllAnimations];
}

- (CAAnimation *)positionAnimate
{
    CAKeyframeAnimation *positionAnimate = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimate.values = @[[NSValue valueWithCGPoint:CGPointZero],
                               [NSValue valueWithCGPoint:CGPointMake(150, -60)],
                               [NSValue valueWithCGPoint:CGPointZero]];
    positionAnimate.duration = 5;
    positionAnimate.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    positionAnimate.fillMode = kCAFillModeForwards;
    positionAnimate.removedOnCompletion = NO;
    positionAnimate.additive = YES; // 在原来的keypath值基础上增加
    return positionAnimate;
}

- (CAAnimation *)rotationAnimate
{
    CAKeyframeAnimation *rotationAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.values = @[@0,@(2* M_PI),@0];
    rotationAnimation.duration = 5.0;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    rotationAnimation.fillMode = kCAFillModeForwards;
    rotationAnimation.removedOnCompletion = NO;
    return rotationAnimation;
}
@end
