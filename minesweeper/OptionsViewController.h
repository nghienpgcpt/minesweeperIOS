//
//  OptionsViewController.h
//  minesweeper
//
//  Created by Adrien Guffens on 1/11/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OptionsViewController : UITableViewController
@property (strong, nonatomic) IBOutlet UISegmentedControl *levelSegmentedControl;
@property (strong, nonatomic) IBOutlet UISegmentedControl *sizeSegmentedControl;

@end
