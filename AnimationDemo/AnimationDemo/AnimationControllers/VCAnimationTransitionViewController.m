//
//  VCAnimationTransactionsViewController.m
//  AnimationDemo
//
//  Created by Vic on 16/2/22.
//  Copyright © 2016年 Vic. All rights reserved.
//

#import "VCAnimationTransitionViewController.h"
#import "VCMacros.h"
#import "ViewController.h"

@import QuartzCore;

static int count = 0;

@interface VCAnimationTransitionViewController ()
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) NSArray *types;
@property (nonatomic, strong) NSArray *subtypes;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *subtypeLabel;
@end

@implementation VCAnimationTransitionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initView];
    [self addAnimate];
}

- (void)dealloc
{
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self stopRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initData
{
    _types = @[kCATransitionFade,       //交叉淡化过渡(不支持过渡方向)
               kCATransitionPush,       //新视图把旧视图推出去
               kCATransitionReveal,     //新视图移到旧视图上面
               kCATransitionMoveIn,     //将旧视图移开,显示下面的新视图
               @"cube",                 //立方体翻滚效果[私有API]
               @"suckEffect",           //收缩效果，如一块布被抽走(不支持过渡方向)[私有API]
               @"rippleEffect",         //滴水效果(不支持过渡方向)[私有API]
               @"pageCurl",             //向上翻页效果[私有API]
               @"pageUnCurl",           //向下翻页效果[私有API]
               @"cameraIrisHollowOpen", //相机镜头打开效果(不支持过渡方向)[私有API]
               @"cameraIrisHollowClose",//相机镜头关上效果(不支持过渡方向)[私有API]
               @"oglFlip"               //上下左右翻转效果[私有API]
               ];
    
    _subtypes = @[kCATransitionFromRight,
                  kCATransitionFromLeft,
                  kCATransitionFromTop,
                  kCATransitionFromBottom];
}

- (void)initView
{
    self.title = @"CATransition";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initImageView];
    [self initToolView];
    [self initNavigationItem];
    [self logFrame:NSStringFromSelector(_cmd)];
}

- (void)logFrame:(NSString *)selector
{
    NSLog(@"self.view.frame--%@----%@",selector,[NSValue valueWithCGRect:self.view.frame]);
    NSLog(@"uiscreen.bounds--%@----%@",selector,[NSValue valueWithCGRect:[UIScreen mainScreen].bounds]);

}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self logFrame:NSStringFromSelector(_cmd)];
}

- (void)initImageView
{
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    _imageView.center = self.view.center;
    _imageView.image = [UIImage imageNamed:@"anonymous-mask"];
    
    [self.view addSubview:_imageView];
}

- (void)initToolView
{
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, VCScreenHeight - 44, VCScreenWidth, 44)];
    toolBar.backgroundColor = [UIColor lightGrayColor];
    _typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, VCScreenWidth / 2, 44)];
    _subtypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, VCScreenWidth / 2, 44)];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:_typeLabel];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithCustomView:_subtypeLabel];
    toolBar.items = @[item1,item2];
    [self.view addSubview:toolBar];
}

- (void)initNavigationItem
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"VC Transition" style:UIBarButtonItemStylePlain target:self action:@selector(vcTransition:)];
    self.navigationItem.rightBarButtonItem = item;
}


- (void)addAnimate
{
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(refresh:)];
    _displayLink.frameInterval = 120;
    [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    
}

- (void)refresh:(id)sender
{

    CATransition *transition = [CATransition animation];
    transition.type = _types[count % _types.count];
    transition.subtype = _subtypes[count % _subtypes.count];
    transition.duration = 3.0;
    [_imageView.layer addAnimation:transition forKey:@"transition"]; // 每次都要使用添加CATransition
    
    _typeLabel.text = [NSString stringWithFormat:@"type:%@%@",transition.type,(count % _types.count >= 4 ? @"[私有API]" : @"")];
    _subtypeLabel.text = [NSString stringWithFormat:@"subtype:%@",transition.subtype];
    
    NSArray *images = @[[UIImage imageNamed:@"anonymous-mask"],[UIImage imageNamed:@"ball8.jpg"]];
    _imageView.image = images[(count) % 2];
    
    count ++;
}

- (void)stopRefresh
{
    [_displayLink invalidate];
    _displayLink = nil;
    [_imageView.layer removeAllAnimations];
    count = 0;
}

- (void)vcTransition:(id)sender
{
    CATransition *transition = [CATransition animation];
    transition.type = _types[rand() % _types.count];
    transition.subtype = _subtypes[rand() % _subtypes.count];
    transition.duration = 0.25;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];

    
    [self.navigationController.view.layer addAnimation:transition forKey:@"vcTransition"];
    
    ViewController *vc = [[ViewController alloc] init];
    vc.title = [NSString stringWithFormat:@"type:%@ subtype:%@",transition.type,transition.subtype];
    vc.view.backgroundColor = [UIColor colorWithRed:((rand() % 255) / 255.0) green:((rand() % 255) / 255.0) blue:((rand() % 255) / 255.0) alpha:1];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
