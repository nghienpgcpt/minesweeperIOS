//
//  GameViewController.h
//  minesweeper
//
//  Created by Adrien Guffens on 1/11/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BoxProtocol.h"
#import "GameInfoProtocol.h"

@class UIBoxContainer;
@class GameInfoMinesweeper;

@interface GameViewController : UIViewController <UIGestureRecognizerDelegate, UIAlertViewDelegate, BoxProtocol, GameInfoProtocol>

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet GameInfoMinesweeper *gameInfoView;

@property (nonatomic, strong) NSTimer *timeTimer;

@end
