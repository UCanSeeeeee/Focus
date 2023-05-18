//
//  BNSearchAuthorViewController.h
//  BNSubscribeHelperProject
//
//  Created by chieh on 2022/11/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BNSearchAuthorViewControllerDelegate <NSObject>

@optional
- (void)didCancelSelectSearchAuthor;

@end

@interface BNSearchAuthorViewController : UIViewController

@property (nonatomic, weak) id<BNSearchAuthorViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
