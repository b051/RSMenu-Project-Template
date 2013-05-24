//
//  ___FILENAME___
//  ___PACKAGENAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//___COPYRIGHT___
//

#import <UIKit/UIKit.h>

@interface ___VARIABLE_classPrefix:identifier___MenuViewController : UIViewController

- (UIViewController *)showControllerWithIdentifer:(NSString *)identifier animated:(BOOL)animated;
- (void)setAttributes:(NSDictionary *)attribute forItemIdentifier:(NSString *)identifier;
- (NSDictionary *)attributesForItemWithIdentifier:(NSString *)identifier;

@property (nonatomic, weak) RSMenuView *menuView;

@end
