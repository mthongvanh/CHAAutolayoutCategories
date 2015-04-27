# CHAAutolayoutCategories
A custom UIView category that implements auto layout convenience methods 


How to create constraints
---------------------------------------
```objective-c
[self.view addSubview:self.profilePicture];

const CGFloat defaultOffset = 10.f;

NSLayoutConstraint *leading = [self.profilePicture pinLeading:defaultOffset];
NSLayoutConstraint *centerY = [self.profilePicture alignCenterVerticalSuperview];
NSLayoutConstraint *aspectRatio = [self.profilePicture aspectRatio];
NSLayoutConstraint *heightMax = [self.profilePicture height:NSLayoutRelationEqual multiplier:0.35f];
NSLayoutConstraint *top = [self.profilePicture pinSide:NSLayoutAttributeTop relation:NSLayoutRelationGreaterThanOrEqual constant:defaultOffset];

[self.profilePicture.superview addConstraints:@[leading,centerY,aspectRatio,heightMax,top]];
```
