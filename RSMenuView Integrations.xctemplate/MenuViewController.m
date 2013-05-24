//
//  ___FILENAME___
//  ___PACKAGENAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//___COPYRIGHT___
//

#import "___VARIABLE_classPrefix:identifier___MenuViewController.h"
#import <objc/message.h>
#import "RSRowBackgroundView.h"

@interface ___VARIABLE_classPrefix:identifier___MenuController () <RSMenuPanEnabledProtocol>

@property (nonatomic, copy) NSMutableDictionary *itemAttributes;

@end

@implementation ___VARIABLE_classPrefix:identifier___MenuController
{
	NSCache *rootViewControllersCache;
	NSString *selectedIdentifier;
}

- (BOOL)panEnabledOnTouch:(UITouch *)touch
{
	return NO;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	rootViewControllersCache = [[NSCache alloc] init];
	_itemAttributes = [@{} mutableCopy];
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:<#menu pattern image#>]];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	if (selectedIdentifier) {
		[_menuView setItemSelectedWithIdentifier:selectedIdentifier];
		selectedIdentifier = nil;
	}
}

- (void)didReceiveMemoryWarning
{
	[rootViewControllersCache removeAllObjects];
	[super didReceiveMemoryWarning];
}

- (UIViewController *)controllerFromIdentifier:(NSString *)identifier
{
	NSRange dotRange = [identifier rangeOfString:@"."];
	NSUInteger location = dotRange.location == NSNotFound ? identifier.length : dotRange.location;
	NSString *controllerId = [identifier substringToIndex:location];
	NSString *perspective = [identifier substringFromIndex:MIN(location + 1, identifier.length)];
	id controller = [rootViewControllersCache objectForKey:controllerId];
	if (!controller) {
		NSString *className = [NSString stringWithFormat:@"___VARIABLE_classPrefix:identifier___%@ViewController", [controllerId capitalizedString]];
		className = [className stringByReplacingOccurrencesOfString:@" " withString:@""];
		controller = [[NSClassFromString(className) alloc] init];
		if (controller) [rootViewControllersCache setObject:controller forKey:controllerId];
		else NSLog(@"%@ does not exist.", className);
	}
	SEL selector = NSSelectorFromString([NSString stringWithFormat:@"show%@", [perspective capitalizedString]]);
	if ([controller respondsToSelector:selector]) {
		objc_msgSend(controller, selector);
	} else if ([controller respondsToSelector:@selector(setPerspective:)]) {
		objc_msgSend(controller, @selector(setPerspective:), perspective);
	}
	return controller;
}

- (UIViewController *)showControllerWithIdentifer:(NSString *)identifier animated:(BOOL)animated
{
	if (!_menuView) {
		selectedIdentifier = identifier;
	} else {
		[_menuView setItemSelectedWithIdentifier:identifier];
	}
	UIViewController *controller = [self controllerFromIdentifier:identifier];
	if (controller) {
		if ([identifier rangeOfString:@".modal"].location == identifier.length - 6 || [identifier rangeOfString:@"web."].location == 0) {
			[self.menuController.rootViewController presentModalViewController:[[UINavigationController alloc] initWithRootViewController:controller] animated:animated];
		} else {
			[self.menuController setRootViewControllers:@[controller] animated:animated];
		}
	}
	return controller;
}

- (void)setAttributes:(NSDictionary *)attribute forItemIdentifier:(NSString *)identifier
{
	_itemAttributes[identifier] = attribute;
	[[NSNotificationCenter defaultCenter] postNotificationName:identifier object:attribute];
}

- (NSDictionary *)attributesForItemWithIdentifier:(NSString *)identifier
{
	return _itemAttributes[identifier];
}

- (NSDictionary *)menuView:(RSMenuView *)menuView attributesForItemWithIdentifier:(NSString *)identifier
{
	return _itemAttributes[identifier];
}

@end
