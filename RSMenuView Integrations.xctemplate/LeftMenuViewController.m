//
//  ___FILENAME___
//  ___PACKAGENAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//___COPYRIGHT___
//

#import "___VARIABLE_classPrefix:identifier___LeftMenuViewController.h"
#import "RSRowBackgroundView.h"

@interface ___VARIABLE_classPrefix:identifier___LeftMenuViewController () <UISearchBarDelegate, RSMenuViewDelegate>

@end

@implementation ___VARIABLE_classPrefix:identifier___LeftMenuViewController
{
	BOOL searching;
	BOOL needUpdate;
	UIView *searchMaskView;
	UISearchBar *_searchBar;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	needUpdate = YES;
	CGSize size = self.view.bounds.size;
	CGFloat searchHeight = 44.f;
	
	RSMenuView *menuView = [[RSMenuView alloc] initWithFrame:CGRectMake(0, searchHeight, size.width, size.height - searchHeight)];
	menuView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	menuView.delegate = self;
	[self.view addSubview:menuView];
	self.menuView = menuView;
	
	RSRowBackgroundView *searchWrapperView = [[RSRowBackgroundView alloc] initWithFrame:CGRectMake(0, 0, size.width, searchHeight)];
	searchWrapperView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
	searchWrapperView.alsoShowTopSeperator = YES;
	UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, size.width - MENU_MARGIN, searchHeight)];
	searchBar.delegate = self;
	searchBar.placeholder = @"Search";
	[searchWrapperView addSubview:_searchBar = searchBar];
	[self.view addSubview:searchWrapperView];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	if (needUpdate) {
		needUpdate = NO;
		[self.menuView setItems:@[@{@"title":@"Home", @"identifier":@"home.main", @"leftview":@"icon"}] forSection:0 sectionHeader:nil];
	}
}

- (void)goOutSearchMode
{
    [self.menuController showRootViewController:YES completion:^{
		searching = NO;
        _searchBar.text = nil;
	}];
	[_searchBar setShowsCancelButton:NO animated:YES];
	[UIView animateWithDuration:.25 animations:^{
		CGRect frame = _searchBar.frame;
		frame.size.width = self.view.bounds.size.width - MENU_MARGIN;
		_searchBar.frame = frame;
		searchMaskView.alpha = 0;
	}];
    [_searchBar resignFirstResponder];
}

#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
	if (searching) {
		return YES;
	}
	searching = YES;
	[self.menuController hideRootViewController:YES];
	[searchBar setShowsCancelButton:YES animated:YES];
	if (!searchMaskView) {
		searchMaskView = [[UIView alloc] initWithFrame:self.menuView.frame];
		searchMaskView.backgroundColor = [UIColor blackColor];
		searchMaskView.alpha = 0;
		[searchMaskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goOutSearchMode)]];
		[self.view addSubview:searchMaskView];
	}
	
	[UIView animateWithDuration:.25 animations:^{
		CGRect frame = searchBar.frame;
		frame.size.width = self.view.bounds.size.width;
		searchBar.frame = frame;
		searchMaskView.alpha = .5;
	}];
	return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
	[self goOutSearchMode];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
	NSString *term = searchBar.text;
	term = [term stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	if (term.length == 0) return [self goOutSearchMode];
	[self showControllerWithIdentifer:[NSString stringWithFormat:@"search.%@", term] animated:YES];
}

#pragma mark - RSMenuViewDelegate
- (void)menuView:(RSMenuView *)menuView didSelectItemWithIdentifier:(NSString *)identifier
{
	[self showControllerWithIdentifer:identifier animated:YES];
}

@end
