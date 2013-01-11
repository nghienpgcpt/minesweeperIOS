//
//  UIBoxContainer.h
//  demineur
//
//  Created by Adrien Guffens on 9/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBoxContainer : UIView <UIScrollViewDelegate>

- (void)setupRecognizer;
- (void)addSubviewToScrollView:(UIView *)view;

@property(nonatomic, strong)IBOutlet UIScrollView *scrollView;

@end
