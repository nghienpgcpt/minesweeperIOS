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

@property (nonatomic, strong) IBOutlet UIProgressView *boxProgressView;//INFO: for the remaining box
@property (nonatomic, strong) IBOutlet UIProgressView *flagProgressView;

@property (nonatomic, strong) id<GameInfoProtocol> delegate;

@property(nonatomic, assign) float totalBombNumber;
@property(nonatomic, assign) float totalBoxNumber;

@property (nonatomic, assign)float discoveredFlagNumber;

- (void)updateTimer;
- (void)updateInfoWithBox:(UIBox *)box;

- (void)setup;

@end
