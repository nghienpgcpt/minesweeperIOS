//
//  UIBox.h
//  demineur
//
//  Created by Adrien Guffens on 9/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BoxProtocol.h"

@class BoxAnnotation;

typedef enum DirectionType {
	horizontal,
	vertical
} DirectionType;


@interface UIBox : UIView

//@property(nonatomic, strong)UITextView *Text;
@property(nonatomic, strong)UILabel *textLabel;
@property(nonatomic, strong)BoxAnnotation *annotation;
@property(nonatomic, assign)CGPoint initialCenter;
@property(nonatomic, strong)id<BoxProtocol> delegate;

- (id)initWithFrame:(CGRect)frame boxAnnotation:(BoxAnnotation *)boxAnnotation andDelegate:(id<BoxProtocol>)delegate;
- (void)updateBox;

- (void)setupRecognizer;

@end
