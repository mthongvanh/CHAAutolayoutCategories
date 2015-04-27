//
//  ViewController.m
//  CHAAutolayoutCategories
//
//  Created by Michael Thongvanh on 4/25/15.
//  Copyright (c) 2015 ChiselApps. All rights reserved.
//

#import "ViewController.h"
#import "UIView+AutoLayoutHelper.h"

#pragma mark - CHAHeaderView
@interface CHAHeaderView : UIView <UITextViewDelegate>

@property (nonatomic, strong) UIImageView *profilePicture;
@property (nonatomic, strong) UIView *userDetailsContainer;
@property (nonatomic, strong) UILabel *fullnameLabel;
@property (nonatomic, strong) UITextView *biographyTextView;
@property (nonatomic, assign) BOOL laidOutConstraints;
- (void)setupConstraints;
@end

@implementation CHAHeaderView

const CGFloat defaultMargin = 10.f;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.translatesAutoresizingMaskIntoConstraints = false;
        
        _profilePicture = [[UIImageView alloc] init];
        _profilePicture.translatesAutoresizingMaskIntoConstraints = false;
        _profilePicture.backgroundColor = [UIColor greenColor];
        [self addSubview:_profilePicture];
        
        _userDetailsContainer = [UIView new];
        _userDetailsContainer.translatesAutoresizingMaskIntoConstraints = false;
        _userDetailsContainer.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:_userDetailsContainer];
        
        _fullnameLabel = [UILabel new];
        _fullnameLabel.translatesAutoresizingMaskIntoConstraints = false;
        _fullnameLabel.backgroundColor = [UIColor brownColor];
        _fullnameLabel.text = @"Chisel Apps";
        [_userDetailsContainer addSubview:_fullnameLabel];
        
        _biographyTextView = [UITextView new];
        _biographyTextView.translatesAutoresizingMaskIntoConstraints = false;
        _biographyTextView.delegate = self;
        _biographyTextView.backgroundColor = [UIColor yellowColor];
        _biographyTextView.text = @"Your favorite app studio on both sides of the Atlantic! Your favorite app studio on both sides of the Atlantic! Your favorite app studio on both sides of the Atlantic! Your favorite app studio on both sides of the Atlantic! Your favorite app studio on both sides of the Atlantic! Your favorite app studio on both sides of the Atlantic!";
        [_userDetailsContainer addSubview:_biographyTextView];
    }
    return self;
}

- (void)updateConstraints
{
    if (!self.laidOutConstraints)
    {
        self.laidOutConstraints = true;
        [self setupConstraints];
    }
    else
    {
        [self modifyConstraints];
    }
    [super updateConstraints];
}

- (void)setupConstraints
{
    [self addConstraints:[self profilePictureConstraints]];
    [self addConstraints:[self userDetailsContainerConstraints]];
    [self addConstraints:[self fullnameLabelConstraints]];
    [self addConstraints:[self biographyTextViewConstraints]];
}

- (void)modifyConstraints
{
    NSLog(@"%s\n[%s]: Line %i] %@",__FILE__,__PRETTY_FUNCTION__,__LINE__,
          @"Modify existing constraints here");
}

- (NSArray *)profilePictureConstraints
{
    NSMutableArray *profileConstraints = [NSMutableArray new];
    NSLayoutConstraint *leading = [self.profilePicture pinLeading:defaultMargin];
    [profileConstraints addObject:leading];
    
    NSLayoutConstraint *centerY = [self.profilePicture alignCenterVerticalSuperview];
    [profileConstraints addObject:centerY];
    
    NSLayoutConstraint *aspectRatio = [self.profilePicture aspectRatio];
    [profileConstraints addObject:aspectRatio];
    
    NSLayoutConstraint *heightMax = [self.profilePicture height:NSLayoutRelationEqual multiplier:0.35f];
    [profileConstraints addObject:heightMax];
    
    NSLayoutConstraint *top = [self.profilePicture pinSide:NSLayoutAttributeTop
                                                  relation:NSLayoutRelationGreaterThanOrEqual
                                                  constant:10.f];
    [profileConstraints addObject:top];
    
    return profileConstraints;
}

- (NSArray *)userDetailsContainerConstraints
{
    return [[self.userDetailsContainer pinSides:@[@(NSLayoutAttributeTrailing)] constant:defaultMargin]
            arrayByAddingObjectsFromArray:@[[self.userDetailsContainer pinSide:NSLayoutAttributeLeading
                                                                        toView:self.profilePicture
                                                                secondViewSide:NSLayoutAttributeTrailing
                                                                      constant:defaultMargin],
                                            [self.userDetailsContainer alignSide:NSLayoutAttributeTop
                                                                          toView:self.profilePicture
                                                                      secondSide:NSLayoutAttributeTop
                                                                        constant:0],
                                            [self.userDetailsContainer alignSide:NSLayoutAttributeBottom
                                                                          toView:self.profilePicture
                                                                      secondSide:NSLayoutAttributeBottom
                                                                        constant:0]]];
}

- (NSArray *)fullnameLabelConstraints
{
    return [[self.fullnameLabel pinSides:@[@(NSLayoutAttributeLeading),@(NSLayoutAttributeTop),@(NSLayoutAttributeTrailing)] constant:0]
            arrayByAddingObjectsFromArray:@[[self.fullnameLabel equalHeight:0.33f]]];
}

- (NSArray *)biographyTextViewConstraints
{
    return [[self.biographyTextView pinSides:@[@(NSLayoutAttributeLeading),@(NSLayoutAttributeTrailing),@(NSLayoutAttributeBottom)] constant:0]
            arrayByAddingObject:[self.biographyTextView
                                 pinSide:NSLayoutAttributeTop
                                 toView:self.fullnameLabel
                                 secondViewSide:NSLayoutAttributeBottom]];
}

@end

#pragma mark - ViewController
@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setupMainContainers];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)setupMainContainers
{
    CHAHeaderView *headerView = [self headerView];
    [self.view addSubview:headerView];
    [self.view addConstraints:[self headerViewConstraints:headerView]];
    
    UIView *contentView = [self contentView];
    [self.view addSubview:contentView];
    [self.view addConstraint:[contentView pinSide:NSLayoutAttributeTop
                                           toView:headerView
                                   secondViewSide:NSLayoutAttributeBottom]];
    [self.view addConstraints:[contentView pinLeadingTrailing]];
    [self.view addConstraint:[contentView pinToBottomSuperview]];
}

- (CHAHeaderView *)headerView
{
    CHAHeaderView *customHeaderView = [[CHAHeaderView alloc] initWithFrame:CGRectZero];
    customHeaderView.backgroundColor = [UIColor orangeColor];
    return customHeaderView;
}

- (NSArray *)headerViewConstraints:(UIView *)headerView
{
    NSMutableArray *headerConstraints = [NSMutableArray new];
    
    [headerConstraints addObjectsFromArray:[headerView pinLeadingTrailing]];
    [headerConstraints addObject:[headerView pinToTopSuperview]];
    [headerConstraints addObject:[headerView equalHeight:(1.f/3.f)]];
    
    return headerConstraints;
}

- (UIView *)contentView
{
    UIView *contentView = [UIView new];
    contentView.translatesAutoresizingMaskIntoConstraints = false;
    contentView.backgroundColor = [UIColor redColor];
    
    return contentView;
}

@end
