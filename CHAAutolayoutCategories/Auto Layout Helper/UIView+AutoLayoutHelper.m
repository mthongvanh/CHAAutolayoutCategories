//
//  UIView+AutoLayoutHelper.m
//  ScrollViewMap
//
//  Created by Michael Thongvanh on 3/25/15.
//  Copyright (c) 2015 Chisel Apps. All rights reserved.
//

#import "UIView+AutoLayoutHelper.h"

@implementation UIView (AutoLayoutHelper)

- (NSLayoutConstraint *)pinLeading
{
    return [self pinLeading:0];
}

- (NSLayoutConstraint *)pinLeading:(CGFloat)constant
{
    return [self pinSide:NSLayoutAttributeLeading constant:constant];
}


- (NSLayoutConstraint *)pinTrailing
{
    return [self pinTrailing:0];
}

- (NSLayoutConstraint *)pinTrailing:(CGFloat)constant
{
    return [self pinSide:NSLayoutAttributeTrailing constant:constant];
}


- (NSArray *)pinLeadingTrailing
{
    return [self pinLeadingTrailing:0];
}

- (NSArray *)pinLeadingTrailing:(CGFloat)constant
{
    return @[[self pinLeading:constant],
             [self pinTrailing:-constant]];
}

- (NSLayoutConstraint *)pinToTopLayoutGuide:(UIViewController *)containerViewController
{
    if (!containerViewController) return nil;
    
    NSLayoutConstraint *topLayoutGuide = [NSLayoutConstraint
                                          constraintWithItem:self
                                          attribute:NSLayoutAttributeTop
                                          relatedBy:NSLayoutRelationEqual
                                          toItem:containerViewController.topLayoutGuide
                                          attribute:NSLayoutAttributeBottom
                                          multiplier:1
                                          constant:0];
    return topLayoutGuide;
}

- (NSLayoutConstraint *)pinToTopSuperview
{
    return [self pinSide:NSLayoutAttributeTop constant:0];
}

- (NSLayoutConstraint *)pinToBottomLayoutGuide:(UIViewController *)containerViewController
{
    if (!containerViewController) return nil;
    
    NSLayoutConstraint *topLayoutGuide = [NSLayoutConstraint
                                          constraintWithItem:self
                                          attribute:NSLayoutAttributeBottom
                                          relatedBy:NSLayoutRelationEqual
                                          toItem:containerViewController.bottomLayoutGuide
                                          attribute:NSLayoutAttributeTop
                                          multiplier:1
                                          constant:0];

    return topLayoutGuide;
}

- (NSLayoutConstraint *)pinToBottomSuperview
{
    return [self pinSide:NSLayoutAttributeBottom constant:0];
}

- (NSArray *)pinToSuperviewBounds
{
    return [self pinToSuperviewBounds:0];
}

- (NSArray *)pinToSuperviewBounds:(CGFloat)constant
{
    NSMutableArray *constraints = [NSMutableArray array];
    
    NSArray *constraintTypes = @[[NSNumber numberWithInteger:NSLayoutAttributeTop],
                                 [NSNumber numberWithInteger:NSLayoutAttributeBottom],
                                 [NSNumber numberWithInteger:NSLayoutAttributeLeft],
                                 [NSNumber numberWithInteger:NSLayoutAttributeRight]];
    
    for (NSNumber *constraintValue in constraintTypes) {
        NSLayoutConstraint *constraint = [NSLayoutConstraint
                                          constraintWithItem:self
                                          attribute:constraintValue.integerValue
                                          relatedBy:NSLayoutRelationEqual
                                          toItem:self.superview
                                          attribute:constraintValue.integerValue
                                          multiplier:1
                                          constant:constant];
        [constraints addObject:constraint];
    }
    return constraints;
}

- (NSLayoutConstraint *)pin:(UIView *)firstView
                       side:(NSLayoutAttribute)viewSide
                     toView:(UIView *)secondView
                 secondSide:(NSLayoutAttribute)secondSide
                   constant:(CGFloat)constant
                 multiplier:(CGFloat)multiplier
{
    if (!firstView) return nil;
    if (!secondView) return nil;
    
    NSLayoutConstraint *pinningConstraint = [NSLayoutConstraint
                                             constraintWithItem:firstView
                                             attribute:viewSide
                                             relatedBy:NSLayoutRelationEqual
                                             toItem:secondView
                                             attribute:secondSide
                                             multiplier:multiplier
                                             constant:constant];
    return pinningConstraint;
}

- (NSLayoutConstraint *)pinSide:(NSLayoutAttribute)viewSide constant:(CGFloat)constant
{
    if (!self.superview) return nil;
    
    return [self pin:self side:viewSide toView:self.superview secondSide:viewSide constant:constant multiplier:1];
}

- (NSLayoutConstraint *)pinSide:(NSLayoutAttribute)viewSide
                         toView:(UIView *)secondView
                 secondViewSide:(NSLayoutAttribute)secondViewSide
{
    return [self pin:self side:viewSide toView:secondView secondSide:secondViewSide constant:0 multiplier:1];
}

#pragma mark - Alignment
- (NSLayoutConstraint *)alignCenterHorizontalSuperview
{
    if (!self.superview) return nil;
    return [[self alignCenterHorizontal:@[self] referenceView:self.superview] firstObject];
}

- (NSLayoutConstraint *)alignCenterVerticalSuperview
{
    if (!self.superview) return nil;
    return [[self alignCenterVertical:@[self] referenceView:self.superview] firstObject];
}

- (NSLayoutConstraint *)alignLeftSuperview
{
    if (!self.superview) return nil;
    return [self align:self side:NSLayoutAttributeLeft constant:0];
    
}

- (NSLayoutConstraint *)alignRightSuperview
{
    if (!self.superview) return nil;
    return [self align:self side:NSLayoutAttributeRight constant:0];
}

- (NSLayoutConstraint *)alignTopSuperview
{
    if (!self.superview) return nil;
    return [self align:self side:NSLayoutAttributeTop constant:0];
}

- (NSLayoutConstraint *)alignTopLayoutGuide:(UIViewController *)containerViewController
{
    if (!containerViewController) return nil;
    
    return [self align:self
                  side:NSLayoutAttributeTop
                toView:containerViewController.topLayoutGuide
            secondSide:NSLayoutAttributeBottom
              constant:0
            multiplier:1];
}

- (NSLayoutConstraint *)alignBottomSuperview
{
    if (!self.superview) return nil;
    return [self align:self side:NSLayoutAttributeBottom constant:0];
}

- (NSLayoutConstraint *)alignBottomLayoutGuide:(UIViewController *)containerViewController
{
    if (!containerViewController) return nil;
    
    return [self align:self
                  side:NSLayoutAttributeTop
                toView:containerViewController.bottomLayoutGuide
            secondSide:NSLayoutAttributeTop
              constant:0
            multiplier:1];
}

- (NSArray *)alignCenterHorizontal:(NSArray *)viewsForCenterHorizontalAlignment
                     referenceView:(UIView *)referenceView
{
    return [self alignCenter:NSLayoutAttributeCenterX
                       views:viewsForCenterHorizontalAlignment
               referenceView:referenceView];
}

- (NSArray *)alignCenterVertical:(NSArray *)viewsForCenterVerticalAlignment
                   referenceView:(UIView *)referenceView
{
    return [self alignCenter:NSLayoutAttributeCenterY
                       views:viewsForCenterVerticalAlignment
               referenceView:referenceView];
}

- (NSArray *)alignCenter:(NSLayoutAttribute)centerType
              views:(NSArray *)viewsForAlignment
      referenceView:(UIView *)referenceView
{
    NSMutableArray *constraints = [NSMutableArray array];
    
    for (UIView *alignmentView in viewsForAlignment) {
        if ([alignmentView isEqual:referenceView]) return nil;
        
        NSLayoutConstraint *alignCenter = [NSLayoutConstraint
                                           constraintWithItem:alignmentView
                                           attribute:centerType
                                           relatedBy:NSLayoutRelationEqual
                                           toItem:referenceView
                                           attribute:centerType
                                           multiplier:1
                                           constant:0];
        
        [constraints addObject:alignCenter];
    }
    return constraints;
}

- (NSLayoutConstraint *)align:(UIView *)firstView
                         side:(NSLayoutAttribute)firstSide
                     constant:(CGFloat)constant
{
    return [self pin:firstView side:firstSide toView:firstView.superview secondSide:firstSide constant:constant multiplier:1];
}

- (NSLayoutConstraint *)align:(UIView *)firstView
                         side:(NSLayoutAttribute)firstSide
                       toView:(UIView *)secondView
                   secondSide:(NSLayoutAttribute)secondSide
                     constant:(CGFloat)constant
                   multiplier:(CGFloat)multiplier
{
    return [self pin:firstView
                side:firstSide
              toView:secondView
          secondSide:secondSide
            constant:constant
          multiplier:multiplier];
}

#pragma mark - Width and Height
- (NSLayoutConstraint *)height:(CGFloat)constant
{
    return [NSLayoutConstraint
            constraintWithItem:self
            attribute:NSLayoutAttributeHeight
            relatedBy:NSLayoutRelationEqual
            toItem:nil
            attribute:NSLayoutAttributeNotAnAttribute
            multiplier:1
            constant:constant];
}

- (NSLayoutConstraint *)width:(CGFloat)constant
{
    return [NSLayoutConstraint
            constraintWithItem:self
            attribute:NSLayoutAttributeWidth
            relatedBy:NSLayoutRelationEqual
            toItem:nil
            attribute:NSLayoutAttributeNotAnAttribute
            multiplier:1
            constant:constant];
}

- (NSLayoutConstraint *)equalWidth
{
    if (!self.superview) return nil;
    return [self equalWidth:1];
}

- (NSLayoutConstraint *)equalWidth:(CGFloat)multiplier
{
    if (!self.superview) return nil;
    return [[self equalWidths:@[self] referenceView:self.superview multiplier:multiplier] firstObject];
}

- (NSLayoutConstraint *)equalHeight
{
    if (!self.superview) return nil;
    return [self equalHeight:1];
}

- (NSLayoutConstraint *)equalHeight:(CGFloat)multiplier
{
    if (!self.superview) return nil;
    return [[self equalHeights:@[self] referenceView:self.superview multiplier:multiplier] firstObject];
}

- (NSArray *)equalWidths:(NSArray *)viewsForAlignment
           referenceView:(UIView *)referenceView
              multiplier:(CGFloat)multiplier
{
    if (viewsForAlignment.count == 0) return nil;
    if (!referenceView) return nil;
    
    NSMutableArray *constraints = [NSMutableArray array];
    
    for (UIView *alignmentView in viewsForAlignment) {
        if (![alignmentView isEqual:referenceView]) {
            NSLayoutConstraint *dimensionConstraint =
            [NSLayoutConstraint constraintWithItem:alignmentView
                                         attribute:NSLayoutAttributeWidth
                                         relatedBy:NSLayoutRelationEqual
                                            toItem:referenceView
                                         attribute:NSLayoutAttributeWidth
                                        multiplier:multiplier
                                          constant:0];
            
            [constraints addObject:dimensionConstraint];
        }
    }
    
    return constraints;
}

- (NSArray *)equalHeights:(NSArray *)viewsForAlignment
            referenceView:(UIView *)referenceView
               multiplier:(CGFloat)multiplier
{
    if (viewsForAlignment.count == 0) return nil;
    if (!referenceView) return nil;
 
    NSMutableArray *constraints = [NSMutableArray array];
    
    for (UIView *alignmentView in viewsForAlignment) {
        if (![alignmentView isEqual:referenceView]) {
            NSLayoutConstraint *dimensionConstraint =
            [NSLayoutConstraint constraintWithItem:alignmentView
                                         attribute:NSLayoutAttributeHeight
                                         relatedBy:NSLayoutRelationEqual
                                            toItem:referenceView
                                         attribute:NSLayoutAttributeHeight
                                        multiplier:multiplier
                                          constant:0];
            
            [constraints addObject:dimensionConstraint];
        }
    }
    
    return constraints;
}

- (NSLayoutConstraint *)proportionalWidth
{
    if (!self.superview) return nil;
    return [[self equalWidths:@[self]
                referenceView:self.superview
                   multiplier:(self.bounds.size.width/self.superview.bounds.size.width)]
            firstObject];
    
}

- (NSLayoutConstraint *)proportionalHeight
{
    if (!self.superview) return nil;
    return [[self equalHeights:@[self]
                 referenceView:self.superview
                    multiplier:(self.bounds.size.height/self.superview.bounds.size.height)]
            firstObject];
}

- (NSLayoutConstraint *)aspectRatio
{
    NSLayoutConstraint *aspectRatio = [NSLayoutConstraint
                                       constraintWithItem:self
                                       attribute:NSLayoutAttributeHeight
                                       relatedBy:NSLayoutRelationEqual
                                       toItem:self
                                       attribute:NSLayoutAttributeWidth
                                       multiplier:(MAX(1,self.bounds.size.height)/MAX(1,self.bounds.size.width))
                                       constant:0];
    return aspectRatio;
}


#pragma mark - Constraint Removal
+ (void)removeSuperviewConstraintsForViews:(NSArray *)views
{
    [views enumerateObjectsUsingBlock:^(UIView *mainView, NSUInteger idx, BOOL *stop)
    {
        NSArray *constraints = [mainView.superview constraints];
        for (NSLayoutConstraint *constraint in constraints)
        {
            if (constraint.firstItem == mainView || constraint.secondItem == mainView)
            {
                [mainView.superview removeConstraint:constraint];
            }
        }
    }];
}













@end
