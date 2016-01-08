//
//  ViewController.h
//  01-石头剪刀布
//
//  Created by 赵康 on 15-8-6.
//  Copyright (c) 2015年 赵康. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *computerImageView;
@property (weak, nonatomic) IBOutlet UIImageView *playerImageView;
@property (weak, nonatomic) IBOutlet UILabel *computerScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerScoreLabel;
@property (weak, nonatomic) IBOutlet UIView *actionView;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIButton *resumeButton;


// 继续游戏
- (IBAction)resumeGame:(UIButton *)sender;
// 玩家出拳
- (IBAction)playAction:(UIButton *)sender;



@end

