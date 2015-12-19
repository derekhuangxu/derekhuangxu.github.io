//
//  ViewController.m
//  StopWatchDemo
//
//  Created by 潘松彪 on 15/5/7.
//  Copyright (c) 2015年 PSB. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
{
    UILabel * _secLabel;    //秒
    UILabel * _mSecLabel;   //100毫秒
    
    NSUInteger _h, _m, _s, _ms;
                            //时间单位，时分秒和100毫秒
    
    NSTimer * _timer;       //定时器
    
    BOOL _isRunning;        //记录下当前计时器是否在运行
}

- (void)dealloc
{
    if (_timer) {
        [_timer invalidate];
    }
    [_secLabel release];
    [_mSecLabel release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self createLabels];
    [self createButtons];
    [self createTimer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI部分
//创建label
- (void)createLabels
{
    _secLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 50, 280, 80)];
    _secLabel.font = [UIFont boldSystemFontOfSize:80];
    _secLabel.adjustsFontSizeToFitWidth = YES;
    _secLabel.text = @"00:00:00";
    
    [self.view addSubview:_secLabel];
    [_secLabel release];
  
    
    _mSecLabel = [[UILabel alloc] initWithFrame:CGRectMake(290, 90, 30, 40)];
    _mSecLabel.font = [UIFont boldSystemFontOfSize:30];
    _mSecLabel.textColor = [UIColor redColor];
    _mSecLabel.text = @"0";
    
    [self.view addSubview:_mSecLabel];
    [_mSecLabel release];
    
}

//创建button
- (void)createButtons
{
    NSArray * buttonTitles = @[@"【开始】", @"【停止】", @"【复位】"];
    
    for (NSUInteger i = 0; i < buttonTitles.count; i++) {
        UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(100, 200 + i * 70, 120, 60)];
        //设置标题
        [button setTitle:buttonTitles[i] forState:UIControlStateNormal];
        //设置文字颜色
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor yellowColor] forState:UIControlStateHighlighted];
        //设置字体
        button.titleLabel.font = [UIFont systemFontOfSize:30];
        
        //绑定事件
        //设置tag
        button.tag = 100 + i;
        
        [button addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchDown];
        
        [self.view addSubview:button];
        [button release];
    }
}

#pragma mark - Button事件的响应
//事件分发
- (void)action:(UIButton *)button
{
    switch (button.tag - 100) {
        case 0:
            //开始键
            [self startButtonOnClick:button];
            break;
        case 1:
            //停止键
            [self stopButtonOnClick:button];
            break;
        case 2:
            //复位键
            [self resetButtonOnClick:button];
            break;
            
        default:
            break;
    }
}

//点击开始键
- (void)startButtonOnClick:(UIButton *)button
{
    if (_isRunning == NO) {
        //启动定时器
        _timer.fireDate = [NSDate distantPast];
        [button setTitle:@"【暂停】" forState:UIControlStateNormal];
        _isRunning = YES;
    } else {
        _timer.fireDate = [NSDate distantFuture];
        [button setTitle:@"【继续】" forState:UIControlStateNormal];
        _isRunning = NO;
    }
}

//点击停止键
- (void)stopButtonOnClick:(UIButton *)button
{
    _timer.fireDate = [NSDate distantFuture];
    _h = _m = _s = _ms = 0;
    _isRunning = NO;
    
    UIButton * startButton = (id)[self.view viewWithTag:100];
    [startButton setTitle:@"【开始】" forState:UIControlStateNormal];
    
}

//点击复位键
- (void)resetButtonOnClick:(UIButton *)button
{
    [self stopButtonOnClick:nil];
    _ms = -1;
    [self refresh];
}


#pragma mark - 定时器
//启动定时器
- (void)createTimer
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(refresh) userInfo:nil repeats:YES];
    _timer.fireDate = [NSDate distantFuture];
}

//刷新
- (void)refresh
{
    _ms++;
    if (_ms == 10) {
        _ms = 0;
        _s++;
        if (_s == 60) {
            _s = 0;
            _m++;
            if (_m == 60) {
                _m = 0;
                _h++;
                if (_h == 100) {
                    _h = 0;
                }
            }
        }
    }
    
    _secLabel.text = [NSString stringWithFormat:@"%.2d:%.2d:%.2d", _h, _m, _s];
    _mSecLabel.text = [NSString stringWithFormat:@"%d", _ms];
}

@end

















