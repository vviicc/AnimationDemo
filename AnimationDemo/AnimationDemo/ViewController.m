//
//  ViewController.m
//  AnimationDemo
//
//  Created by Vic on 16/2/22.
//  Copyright © 2016年 Vic. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSArray *data;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initData
{
    _data = @[@"VCBasicAnimationViewController",
              @"VCKeyframeAnimationViewController",
              @"VCAnimationGroupsViewController",
              @"VCAnimationTransitionViewController"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VCAnimationListCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"VCAnimationListCell"];
    }
    cell.textLabel.text = _data[indexPath.row];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *controllerName = _data[indexPath.row];
    [self pushViewController:controllerName];
}

- (void)pushViewController:(NSString *)controller
{
    Class c = NSClassFromString(controller);
    id vc = [[c alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
