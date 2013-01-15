//
//  GameInfoMinesweeper.h
//  minesweeper
//
//  Created by Adrien Guffens on 1/11/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameInfoProtocol.h"
#import "UIBox.h"
#import "BoxAnnotation.h"

@interface GameInfoMinesweeper : UIView

@property(nonatomic, strong) UIImage *pauseImage;
@property(nonatomic, strong) UIImage *playImage;

@property (nonatomic, strong) IBOutlet UIButton *stopButton;
@property (nonatomic, strong) IBOutlet UIButton *pauseButton;
@property (nonatomic, strong) IBOutlet UILabel *timeLabel;
@property (nonatomic, strong) IBOutlet UIProgressView *mineProgressView; //INFO: for the remaining mine
@property (nonatomic, strong) IBOutlet UIProgressView *boxProgressView;//INFO: for the remaining box

@property (nonatomic, strong) id<GameInfoProtocol> delegate;

@property(nonatomic, assign) int totalBombNumber;
@property(nonatomic, assign) int totalEmptyCaseNumber;

- (void)updateTimer;
- (void)updateInfoWithBox:(UIBox *)box;

@end
