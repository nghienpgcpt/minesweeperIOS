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

#import "Options.h"

#import "ScoreRecord.h"
#import "MinesweeperAppDelegate.h"

#import "Global.h"

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
@property (nonatomic, assign)BOOL isStarted;
@property(nonatomic, assign)BOOL isPaused;

@property (nonatomic, strong) Options *options;

@end

@implementation GameViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {	
	}
	return self;
}

- (void)dealloc {
	
}

- (void)awakeFromNib {
	[super awakeFromNib];
	bombImage = [UIImage imageNamed:@"mine-icon"];
	flagImage = [UIImage imageNamed:@"flag-icon"];
	emptyImage = [UIImage imageNamed:@"empty.png"];
	emptyAutoImage = [UIImage imageNamed:@"empty-auto.png"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	
	self.gameInfoView.delegate = self;
	self.isPaused = NO;
	[self setupGrid];
	[self.scrollView addSubview:self.containerView];
}

- (void)setupGrid {
	
	// Custom initialization
	//INFO: get Option
	NSError *error;
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Options"
											  inManagedObjectContext:[MinesweeperAppDelegate appDelegate].managedObjectContext];
	[fetchRequest setEntity:entity];
	NSArray *fetchedObjects = [[MinesweeperAppDelegate appDelegate].managedObjectContext executeFetchRequest:fetchRequest error:&error];
	self.options = [fetchedObjects lastObject];
	for (Options *item in fetchedObjects) {
		NSLog(@"level: %@", item.level);
		
	}
	NSLog(@"Options -> level: %@ | size: %@", self.options.level, self.options.size);
	
	//INFO: define ellement's size
	float gameWidth = 9;
	float gameHeight = 12;
	
	float boxWidth = 57;//GAME_WIDTH / gameWidth;
	float boxHeight = 57;//(GAME_HEIGHT - MARGIN_TOP) / gameHeight;
	
	//INFO: set the scroll view
	CGSize containerSize = CGSizeMake(gameWidth * boxWidth, (gameHeight + 1) * boxHeight);
    self.containerView = [[UIView alloc] initWithFrame:(CGRect){.origin=CGPointMake(0.0f, 0.0f), .size=containerSize}];
	
	//INFO: remoove subviews if needed
	for (UIView *view in self.scrollView.subviews) {
		if ([view isKindOfClass:[UIView class]])
			for (UIView *boxView in view.subviews)
				if ([boxView isKindOfClass:[UIBox class]]) {
					[boxView removeFromSuperview];
				}
	}
	
	//INFO: setup each box of the grid
		
	[self.boxAnnotationList removeAllObjects];
	
	self.boxAnnotationList = [[NSMutableArray alloc] init];

	//NSLog(@"size of 1 box -> width:%f - height:%f", boxWidth, boxHeight);
	
	float totalBombNumber = 0;
	float totalBoxNumber = 0;
	
	for (float y = 0; y <= gameHeight; y++) {
		for (float x = 0; x < gameWidth; x++) {
			CGRect frameBox = CGRectMake(x * boxWidth, y * boxHeight, boxWidth, boxHeight);
			
			
			NSInteger randDifficulty = arc4random() % [self.options.level intValue];//INFO: mix modulo value to change level difficulty
			
			//NSLog(@"adding x:%f - y:%f", frameBox.origin.x, frameBox.origin.y);
			//
			BoxAnnotation *boxAnnotation = [[BoxAnnotation alloc] init];
			boxAnnotation.value = @"";
			boxAnnotation.x = x;
			boxAnnotation.Y = y;
			boxAnnotation.width = boxWidth;
			boxAnnotation.height = boxHeight;
			boxAnnotation.type = (randDifficulty == 0 ? bomb : empty);
			boxAnnotation.selected = NO;
			boxAnnotation.flagged = NO;
			//
			[self.boxAnnotationList addObject:boxAnnotation];
			
			//
			UIBox *box = [[UIBox alloc] initWithFrame:frameBox
										boxAnnotation:boxAnnotation
										  andDelegate:self];
			//INFO: add object
			[self.containerView addSubview:box];

			//INFO: setup informations
			totalBombNumber += (boxAnnotation.type == bomb ? 1 : 0);
			totalBoxNumber += 1;
		}
		//NSLog(@"___");
	}
	self.scrollView.contentSize = containerSize;
	//INFO: setup GameInfo
	[self.gameInfoView setup];
	[self.gameInfoView setTotalBombNumber:totalBombNumber];
	[self.gameInfoView setTotalBoxNumber:totalBoxNumber];
	
	
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

#pragma mark - BoxView List

- (UIBox *)boxViewAtX:(NSInteger)x andY:(NSInteger)y {
	
	for (UIView *view in self.scrollView.subviews) {
		if ([view isKindOfClass:[UIView class]])
			for (UIBox *boxView in view.subviews)
				if ([boxView isKindOfClass:[UIBox class]]) {
					if (boxView.annotation.x == x && boxView.annotation.y == y)
						return boxView;

				}
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


- (BOOL)showBox:(BoxAnnotation *)boxAnnotation auto:(BOOL)autoEnable {
	BOOL result = NO;
	//	if (boxAnnotation.selected == YES)
	//	return result;
		
	NSInteger bombNumberTowardBox = [self bombNumberTowardBox:boxAnnotation];
	UIBox *box = [self boxViewAtX:boxAnnotation.x andY:boxAnnotation.y];
	
	
	if (boxAnnotation.flagged == YES &&
		box.annotation.selected == YES &&
		autoEnable == NO) {
		
		self.gameInfoView.discoveredFlagNumber = self.gameInfoView.discoveredFlagNumber - 1 ;
		[self.gameInfoView updateInfoWithBox:box];
		box.annotation.selected = NO;
		boxAnnotation.flagged = NO;
		[box setBackgroundImage:nil];
	}
	else if (boxAnnotation.selected == YES)
		return result;
	else if (boxAnnotation.type == bomb) {//INFO: loose
		if (box) {
			[box updateBox];
			[self.gameInfoView updateInfoWithBox:box];
			
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
						[self showBox:boxAnnotation auto:YES];
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
			[self.gameInfoView updateInfoWithBox:box];
			
			result = YES;
		}
	}
	return result;
}

#pragma mark - BoxProtocol

- (BOOL)didSelectBox:(BoxAnnotation *)boxAnnotation {
	NSLog(@"Select box at x:%d - y:%d", boxAnnotation.x, boxAnnotation.y);
	if (self.isPaused == NO) {
		return [self showBox:boxAnnotation auto:NO];
	}
	return NO;
}

- (void)didPushFlag:(UIBox *)box {
	self.gameInfoView.discoveredFlagNumber = self.gameInfoView.discoveredFlagNumber + 1;
	[self.gameInfoView updateInfoWithBox:box];
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

- (BOOL)handlePause {
	NSLog(@"Pause");
	return [self pause];
}

- (BOOL)handleStart {
	NSLog(@"Start");
	return [self restart];
	//	self start
}

- (BOOL)handleStop {
	NSLog(@"Stop");
	return [self stop];
}

- (void)didWinWithTimeInSeconds:(int)time {
	[self.timeTimer invalidate];
	//	if ([self stop]) {
	
	{
		NSString *message;
		UIAlertView *alert;
		
		int forHours = time / 3600;
		int remainder = time % 3600;
		int forMinutes = remainder / 60;
		int forSeconds = remainder % 60;
		

		if (forHours > 0)
			message = [NSString stringWithFormat:@"You WIN in %d Hours %d Minutes %d Seconds. Do you want to play again ?", forHours, forMinutes, forSeconds];
		else if (forMinutes > 0)
			message = [NSString stringWithFormat:@"You WIN in %d Minutes %d Seconds. Do you want to play again ?",  forMinutes, forSeconds];
		else if (forSeconds >= 0)
			message = [NSString stringWithFormat:@"You WIN in %d seconds. Do you want to play again ?", forSeconds];

		alert = [[UIAlertView alloc] initWithTitle:@"You Win!" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
		[alert show];
	}
}

- (void)didLostWithTimeInSeconds:(int)time {
	//if ([self stop]) {
	[self.timeTimer invalidate];
	{
		NSString *message;
		UIAlertView *alert;
		
		int forHours = time / 3600;
		int remainder = time % 3600;
		int forMinutes = remainder / 60;
		int forSeconds = remainder % 60;
		

		if (forHours > 0)
			message = [NSString stringWithFormat:@"You LOST in %d Hours %d Minutes %d Seconds. Do you want to play again ?", forHours, forMinutes, forSeconds];
		else if (forMinutes > 0)
			message = [NSString stringWithFormat:@"You LOST in %d Minutes %d Seconds. Do you want to play again ?",  forMinutes, forSeconds];
		else if (forSeconds >= 0)
			message = [NSString stringWithFormat:@"You LOST in %d seconds. Do you want to play again ?", time];
		
		alert = [[UIAlertView alloc] initWithTitle:@"You LOST !" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
		[alert show];
		
		{
			ScoreRecord *scoreRecord = [NSEntityDescription insertNewObjectForEntityForName:@"ScoreRecord" inManagedObjectContext:[MinesweeperAppDelegate appDelegate].managedObjectContext];
			scoreRecord.date = [NSDate date];
			scoreRecord.level = self.options.level;
			scoreRecord.size = self.options.size;
		
			NSError *error;
			if (![[MinesweeperAppDelegate appDelegate].managedObjectContext save:&error])
				NSLog(@"Saving error: %@", error);
			
			NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
			NSEntityDescription *entity = [NSEntityDescription entityForName:@"ScoreRecord"
													  inManagedObjectContext:[MinesweeperAppDelegate appDelegate].managedObjectContext];
			[fetchRequest setEntity:entity];
			
			NSArray *fetchedObjects = [[MinesweeperAppDelegate appDelegate].managedObjectContext executeFetchRequest:fetchRequest error:&error];
			for (ScoreRecord *item in fetchedObjects) {
				NSLog(@"level: %@", item.level);
				NSLog(@"level: %@", item.score);
				
			}
		}
	}
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

- (BOOL)restart {
	if (self.isStarted == YES) {
		self.timeTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(handleTimeTimer) userInfo:nil repeats:YES];
		[[NSRunLoop mainRunLoop] addTimer:self.timeTimer forMode:NSRunLoopCommonModes];
		self.isPaused = NO;
		return YES;
	}
	return NO;
}

- (BOOL)pause {
	if (self.isStarted == YES) {
		//TODO: invalidate the timer [OK]
		[self.timeTimer invalidate];
		self.isPaused = YES;
		//[self.scrollView setBackgroundColor:[UIColor blackColor]];
		//TODO: display a choice between stop or restart the game
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

#pragma mark - handle Timer

- (void)handleTimeTimer {
	//dispatch_async(dispatch_get_main_queue(), ^{
		[self.gameInfoView performSelectorInBackground:@selector(updateTimer) withObject:nil];
	//});
}


#pragma mark - UIAlertView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
	
    if ([title isEqualToString:@"OK"]) {
		//		self.isStarted = NO;
		[self viewDidLoad];
	}
	else {
		//		[self handleBackHome];
		//[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(handleBackHome) userInfo:nil repeats:NO];
	}
}


@end
