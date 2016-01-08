//
//  ViewController.m
//  01-石头剪刀布
//
//  Created by 赵康 on 15-8-6.
//  Copyright (c) 2015年 赵康. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

#define kImageAnimationDuration 0.5
#define kActionViewDuration 0.6


@interface ViewController ()
{
    // 胜利、失败、平局、点击的音效
    SystemSoundID _winSound;
    SystemSoundID _faildSound;
    SystemSoundID _drewSound;
    SystemSoundID _clickSound;
}
// 图片列表
@property (nonatomic, strong) NSArray *imageList;

// 背景音乐播放器
@property (nonatomic, strong) AVAudioPlayer *BGMPlayer;




@end

@implementation ViewController
/**
 1. 让计算机和玩家的图片播放序列帧动画
    提示：序列帧动画的图像顺序，最好和界面上的tag保持一致
 2. 等待玩家出拳，判定游戏结果
 3. 。。。
 
 播放声音的顺序
 1. 引入AVFoudation框架头文件
 2. 定义、初始化声音播放器
 3. 设置声音播放器的属性
 4. 开始播放
 
 不知道为什么音效没声音
 
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化图片列表
    self.imageList = @[[UIImage imageNamed:@"石头.png"],
                           [UIImage imageNamed:@"剪刀.png"],
                           [UIImage imageNamed:@"布.png"],
                           ];
    // 开始动画
    [self beginAnimating];
    
    // 初始化背景音乐
    self.BGMPlayer = [self loadBGMPlayer:@"背景音乐.caf"];
    // 播放
    [self.BGMPlayer play];
    
    // 初始化音效
    _winSound = [self loadSound:@"胜利.aiff"];
    _faildSound = [self loadSound:@"失败.aiff"];
    _drewSound = [self loadSound:@"和局.aiff"];
    _clickSound = [self loadSound:@"点击按钮.aiff"];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions
#pragma mark 继续游戏
- (IBAction)resumeGame:(UIButton *)sender {
    self.resumeButton.enabled = NO;
    
    // 播放音效
    AudioServicesPlaySystemSound(_clickSound);
    
    // 清空文字消息
    self.messageLabel.text = @"";
    
    // 开始动画
    [self beginAnimating];
    
    // 显示actionView
    [UIView animateWithDuration:kActionViewDuration animations:^{
        self.actionView.center = CGPointMake(_actionView.center.x, _actionView.center.y - _actionView.bounds.size.height);
    }];
    
}

#pragma mark 玩家出拳
- (IBAction)playAction:(UIButton *)sender {
    self.resumeButton.enabled = YES;
    
    // 玩家的选择
    NSInteger playerResult = sender.tag;
    // 电脑的选择
    NSInteger computerResult = arc4random_uniform(3);
    
    
    NSInteger result = playerResult - computerResult;
    // 即将显示到messageLabel上的信息
    NSString * string;
    
    // 判定胜负结果
    switch (result) {
        case 0:
            
            // 播放音效
            AudioServicesPlaySystemSound(_drewSound);
            
            string = @"平局";
            break;
        case -1:
        case 2:
            
            // 播放音效
            AudioServicesPlaySystemSound(_winSound);
            
            string = @"你赢了！";
            [self scorePlus:_playerScoreLabel];
            break;
        default:
            
            // 播放音效
            AudioServicesPlaySystemSound(_faildSound);
            
            string = @"你输了！";
            [self scorePlus:_computerScoreLabel];
            break;
    }
    
    // 改变messageLabel
    self.messageLabel.text = string;
    
    // 停止动画
    [self.computerImageView stopAnimating];
    [self.playerImageView stopAnimating];
    
    // 设置与结果相对应的图片
    self.computerImageView.image = _imageList[computerResult];
    self.playerImageView.image = _imageList[playerResult];
    
    // 隐藏actionView
    [UIView animateWithDuration:kActionViewDuration animations:^{
        self.actionView.center = CGPointMake(_actionView.center.x, _actionView.center.y + _actionView.bounds.size.height);
    }];
    
}

#pragma mark - 辅助的方法
#pragma mark 比分+1
- (void)scorePlus:(UILabel *)label {
    NSInteger score = [label.text integerValue];
    score++;
    [label setText:[NSString stringWithFormat:@"%ld", (long)score]];
}

#pragma mark 开始动画
- (void)beginAnimating {
    // 1. 设置图像的动画数组
    [_computerImageView setAnimationImages:_imageList];
    [_playerImageView setAnimationImages:_imageList];
    // 2. 设置图像的动画时长
    [_computerImageView setAnimationDuration:kImageAnimationDuration];
    [_playerImageView setAnimationDuration:kImageAnimationDuration];
    // 3. 开始动画
    [_computerImageView startAnimating];
    [_playerImageView startAnimating];
    
}

#pragma mark 初始化背景音乐播放器
- (AVAudioPlayer *)loadBGMPlayer:(NSString *)BGMName{
    //  初始化背景音乐播放器
    // 1. 音乐文件的路径
//    NSString *path = [[NSBundle mainBundle] pathForResource:BGMName ofType:nil];
    // 2. 将路径字符串转化为URL
//    NSURL *url = [NSURL fileURLWithPath:path];
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:BGMName withExtension:nil];
    
    // 3. 初始化音频播放器
    AVAudioPlayer * player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    
    // 设置播放器的属性
    // 1. 设置循环播放的次数
    player.numberOfLoops = -1;
    // 2. 设置音量
    player.volume = 0.05;
    // 3. 准备播放
    [player prepareToPlay];
    
    return player;
}

#pragma mark 加载音效
- (SystemSoundID)loadSound:(NSString *)soundFileName {
    // 声音文件URL
    NSURL *url = [[NSBundle mainBundle] URLForResource:soundFileName withExtension:nil];
    
    // 初始化音效
    SystemSoundID soundID; // 注：SystemSoundID 即 UInt32, 所以不需要 *
    
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &soundID);
//    NSLog(@"%d", soundID);
    return soundID;
}
@end


