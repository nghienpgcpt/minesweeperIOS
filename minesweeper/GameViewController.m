//
//  GameViewController.m
//  minesweeper
//
//  Created by Adrien Guffens on 1/11/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "GameViewController.h"
#import "UIBoxContainer.h"
#import "UIBox.h"
#import "BoxAnnotation.h"
#import "GameInfoMinesweeper.h"

#define SCREEN_WIDTH 320
#define SCREEN_HEIGHT 460

#define GAME_WIDTH 640
#define GAME_HEIGHT 920


#define MARGIN_TOP 100

#define SQUARE_RANGE 3
#define LOOSE_VALUE -1

@interface GameViewController ()

@property (nonatomic, strong) UIView *containerView;

- (void)centerScrollViewContents;

@property (nonatomic, strong)NSMutableArray *boxAnnotationList;
@property (nonatomic, strong)NSMutableArray *boxViewList;
@property (nonatomic, assign)BOOL isStarted;

@end

@implementation GameViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		//self.BoxContainer = [[UIBoxContainer alloc] initWithFrame:CGRectMake(0, MARGIN_TOP, GAME_WIDTH, GAME_HEIGHT)];
		//BoxContainer.delegate = self;
		
		//
		
		UIPanGestureRecognizer* panSwipeRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanSwipe:)];
		panSwipeRecognizer.minimumNumberOfTouches = 2;
		panSwipeRecognizer.maximumNumberOfTouches = 2;
		panSwipeRecognizer.delegate = self;
		
		//[self.boxContainer addGestureRecognizer:panSwipeRecognizer];
		
		//
	}
	return self;
}

- (void)dealloc {
	
}

- (void)awakeFromNib {
	[super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	
	
	self.gameInfoView.delegate = self;
	[self setupGrid];
	
}

- (void)setupGrid {
	
	// Custom initialization
	
	//INFO: define ellement's size
	float gameWidth = 9;
	float gameHeight = 12;
	
	float boxWidth = GAME_WIDTH / gameWidth;
	float boxHeight = (GAME_HEIGHT - MARGIN_TOP) / gameHeight;
	
	//INFO: set the scroll view
	CGSize containerSize = CGSizeMake(gameWidth * boxWidth, (gameHeight + 1) * boxHeight);
    self.containerView = [[UIView alloc] initWithFrame:(CGRect){.origin=CGPointMake(0.0f, 0.0f), .size=containerSize}];
    [self.scrollView addSubview:self.containerView];
	
	//INFO: setup each box of the grid
	self.boxAnnotationList = [[NSMutableArray alloc] init];
	self.boxViewList = [[NSMutableArray alloc] init];

	
	NSLog(@"size of 1 box -> width:%f - height:%f", boxWidth, boxHeight);
	
	for (float y = 0; y <= gameHeight; y++) {
		for (float x = 0; x < gameWidth; x++) {
			CGRect frameBox = CGRectMake(x * boxWidth, y * boxHeight, boxWidth, boxHeight);
			
			
			NSInteger randDifficulty = arc4random() % 4;//INFO: mix modulo value to change level difficulty
			
			NSLog(@"adding x:%f - y:%f", frameBox.origin.x, frameBox.origin.y);
			//
			BoxAnnotation *boxAnnotation = [[BoxAnnotation alloc] init];
			boxAnnotation.value = @"";
			boxAnnotation.x = x;
			boxAnnotation.Y = y;
			boxAnnotation.width = boxWidth;
			boxAnnotation.height = boxHeight;
			boxAnnotation.type = (randDifficulty == 0 ? bomb : empty);
			boxAnnotation.selected = NO;
			//
			[self.boxAnnotationList addObject:boxAnnotation];
			//
			UIBox *box = [[UIBox alloc] initWithFrame:frameBox
										boxAnnotation:boxAnnotation
										  andDelegate:self];
			//
			[self.boxViewList addObject:box];
			//
			[self.containerView addSubview:box];
		}
		NSLog(@"___");
	}
	self.scrollView.contentSize = containerSize;
	[self start];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //INFO: Set up the minimum & maximum zoom scales
    CGRect scrollViewFrame = self.scrollView.frame;
    CGFloat scaleWidth = scrollViewFrame.size.width / self.scrollView.contentSize.width;
    CGFloat scaleHeight = scrollViewFrame.size.height / self.scrollView.contentSize.height;
    CGFloat minScale = MIN(scaleWidth, scaleHeight);
    
    self.scrollView.minimumZoomScale = minScale;
    self.scrollView.maximumZoomScale = 1.0f;
    self.scrollView.zoomScale = minScale;
    
    [self centerScrollViewContents];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    self.scrollView = nil;
    self.containerView = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - BoxAnnotationList

- (BoxAnnotation *)boxAnnotationAtX:(NSInteger)x andY:(NSInteger)y {
	for (BoxAnnotation *boxAnnotation in self.boxAnnotationList) {
		if (boxAnnotation.x == x && boxAnnotation.y == y)
			return boxAnnotation;
	}
	return nil;
}

#pragma mark - BoxViewList

- (UIBox *)boxViewAtX:(NSInteger)x andY:(NSInteger)y {
	for (UIBox *box in self.boxViewList) {
		if (box.annotation.x == x && box.annotation.y == y)
			return box;
	}
	return nil;
}

#pragma mark - Box protocol

- (NSInteger)bombNumberTowardBox:(BoxAnnotation *)boxAnnotation {
	NSInteger res = 0;
	
	NSInteger startX = boxAnnotation.x - 1;
	NSInteger startY = boxAnnotation.y - 1;
	
	for (NSInteger y = startY; y < startY + SQUARE_RANGE; y++) {
		for (NSInteger x = startX; x < startX + SQUARE_RANGE; x++) {
			BoxAnnotation *boxAnnotation = [self boxAnnotationAtX:x andY:y];
			if (boxAnnotation) {
				res += (boxAnnotation.type == bomb ? 1 : 0);
			}
		}
	}
	return res;
}


- (BOOL)showBox:(BoxAnnotation *)boxAnnotation {
	BOOL result = NO;
	if (boxAnnotation.selected == YES)
		return result;
	
	NSInteger bombNumberTowardBox = [self bombNumberTowardBox:boxAnnotation];
	UIBox *box = [self boxViewAtX:boxAnnotation.x andY:boxAnnotation.y];
	
	if (boxAnnotation.type == bomb) {//INFO: loose
		if (box) {
			box.annotation.value = @"-1";
			[box updateBox];
			
			result = NO;
		}
	}
	else if (bombNumberTowardBox == 0) {//INFO: empty Box
		if (box) {
			//TODO:  update progress in gameInfoView
			box.annotation.type = empty;
			[box updateBox];
			
			NSInteger startX = boxAnnotation.x - 1;
			NSInteger startY = boxAnnotation.y - 1;
			
			for (NSInteger y = startY; y < startY + SQUARE_RANGE; y++) {
				for (NSInteger x = startX; x < startX + SQUARE_RANGE; x++) {
					BoxAnnotation *boxAnnotation = [self boxAnnotationAtX:x andY:y];
					if (boxAnnotation)
						[self showBox:boxAnnotation];
				}
			}
			
			result = YES;
		}
	}
	else {
		if (box) { //INFO: bomb toward
				   //TODO:  update progress in gameInfoView
			box.annotation.type = noBomb;
			box.annotation.value = [NSString stringWithFormat:@"%d", bombNumberTowardBox];
			[box updateBox];
			
			result = YES;
		}
	}
	return result;
}

- (BOOL)didSelectBox:(BoxAnnotation *)boxAnnotation {
	NSLog(@"Select box at x:%d - y:%d", boxAnnotation.x, boxAnnotation.y);
	
	return [self showBox:boxAnnotation];
}


#pragma mark - scroll

- (void)centerScrollViewContents {
    CGSize boundsSize = self.scrollView.bounds.size;
    CGRect contentsFrame = self.containerView.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    } else {
        contentsFrame.origin.y = 0.0f;
    }
    
    self.containerView.frame = contentsFrame;
}

#pragma mark - UIScrollViewDelegate

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    // Return the view that we want to zoom
    return self.containerView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    // The scroll view has zoomed, so we need to re-center the contents
    [self centerScrollViewContents];
}

#pragma mark - GameInfoProtocol

- (void)handlePause {
	NSLog(@"Pause");
}

- (void)handleStart {
	NSLog(@"Start");
}

- (void)handleStop {
	NSLog(@"Stop");
	[self stop];
}

#pragma mark - Game

- (BOOL)start {
	//INFO: start the timer
	if (self.isStarted == NO) {
		self.timeTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(handleTimeTimer) userInfo:nil repeats:YES];
		[[NSRunLoop mainRunLoop] addTimer:self.timeTimer forMode:NSRunLoopCommonModes];
		self.isStarted = YES;
		return YES;
	}
	return NO;
}

- (BOOL)pause {
	if (self.isStarted == YES) {
		//TODO: invalidate the timer [OK]
		[self.timeTimer invalidate];
		//TODO: display a choice between stop or restart the game
		//TODO: set self.isStarted = NO; if pause
		return YES;
	}
	return NO;
}

- (BOOL)stop {
	//TODO: display a message --> Do you really want to quit ?
	//TODO: dismiss the current View Controller [OK]
	[self.timeTimer invalidate];
	[self dismissViewControllerAnimated:YES completion:nil];
	return YES;
}

- (void)handleTimeTimer {
	//dispatch_async(dispatch_get_main_queue(), ^{
		[self.gameInfoView performSelectorInBackground:@selector(updateTimer) withObject:nil];
	//});
}


@end
