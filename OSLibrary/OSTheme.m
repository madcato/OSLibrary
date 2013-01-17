//
//  OSTheme.m
//  reservas-unav
//
//  Created by Daniel Vela on 20/11/12.
//  Copyright (c) 2012 inycom. All rights reserved.
//

#import "OSTheme.h"
#import "OSDefaultTheme.h"
#import "OSSystem.h"


@implementation OSThemeManager

+ (id <OSTheme>)sharedTheme{
    static id <OSTheme> sharedTheme = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // Create and return the theme:
        //      sharedTheme = [[UnavTheme alloc] init];
        //        sharedTheme = [[SSTintedTheme alloc] init];
        //        sharedTheme = [[SSMetalTheme alloc] init];
        sharedTheme = [[OSDefaultTheme alloc] init];
    });
    return sharedTheme;
}

+ (void)customizeAppAppearance {
    if(IOS_VERSION_LESS_THAN(@"5.0")) return;
    id <OSTheme> theme = [self sharedTheme];
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
    [navigationBarAppearance setBackgroundImage:
     [theme navigationBackgroundForBarMetrics:UIBarMetricsDefault]
                                  forBarMetrics:UIBarMetricsDefault];
    [navigationBarAppearance setBackgroundImage:
     [theme navigationBackgroundForBarMetrics:UIBarMetricsLandscapePhone]
                                  forBarMetrics:UIBarMetricsLandscapePhone];
    if(IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0"))
        [navigationBarAppearance setShadowImage:[theme topShadow]];
    UIBarButtonItem *barButtonItemAppearance = [UIBarButtonItem appearance];
    if(IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")) {
        [barButtonItemAppearance setBackgroundImage:
         [theme barButtonBackgroundForState:UIControlStateNormal
                                      style:UIBarButtonItemStyleBordered
                                 barMetrics:UIBarMetricsDefault]
                                           forState:UIControlStateNormal
                                              style:UIBarButtonItemStyleBordered
                                         barMetrics:UIBarMetricsDefault];
        [barButtonItemAppearance setBackgroundImage:
         [theme barButtonBackgroundForState:UIControlStateHighlighted
                                      style:UIBarButtonItemStyleBordered
                                 barMetrics:UIBarMetricsDefault]
                                           forState:UIControlStateHighlighted
                                              style:UIBarButtonItemStyleBordered
                                         barMetrics:UIBarMetricsDefault];
        [barButtonItemAppearance setBackgroundImage:
         [theme barButtonBackgroundForState:UIControlStateNormal
                                      style:UIBarButtonItemStyleBordered
                                 barMetrics:UIBarMetricsLandscapePhone]
                                           forState:UIControlStateNormal
                                              style:UIBarButtonItemStyleBordered
                                         barMetrics:UIBarMetricsLandscapePhone];
        [barButtonItemAppearance setBackgroundImage:
         [theme barButtonBackgroundForState:UIControlStateHighlighted
                                      style:UIBarButtonItemStyleBordered
                                 barMetrics:UIBarMetricsLandscapePhone]
                                           forState:UIControlStateHighlighted
                                              style:UIBarButtonItemStyleBordered
                                         barMetrics:UIBarMetricsLandscapePhone];
        [barButtonItemAppearance setBackgroundImage:
         [theme barButtonBackgroundForState:UIControlStateNormal
                                      style:UIBarButtonItemStyleDone
                                 barMetrics:UIBarMetricsDefault]
                                           forState:UIControlStateNormal
                                              style:UIBarButtonItemStyleDone
                                         barMetrics:UIBarMetricsDefault];
        [barButtonItemAppearance setBackgroundImage:
         [theme barButtonBackgroundForState:UIControlStateHighlighted
                                      style:UIBarButtonItemStyleDone
                                 barMetrics:UIBarMetricsDefault]
                                           forState:UIControlStateHighlighted
                                              style:UIBarButtonItemStyleDone
                                         barMetrics:UIBarMetricsDefault];
        [barButtonItemAppearance setBackgroundImage:
         [theme barButtonBackgroundForState:UIControlStateNormal
                                      style:UIBarButtonItemStyleDone
                                 barMetrics:UIBarMetricsLandscapePhone]
                                           forState:UIControlStateNormal
                                              style:UIBarButtonItemStyleDone
                                         barMetrics:UIBarMetricsLandscapePhone];
        [barButtonItemAppearance setBackgroundImage:
         [theme barButtonBackgroundForState:UIControlStateHighlighted
                                      style:UIBarButtonItemStyleDone
                                 barMetrics:UIBarMetricsLandscapePhone]
                                           forState:UIControlStateHighlighted
                                              style:UIBarButtonItemStyleDone
                                         barMetrics:UIBarMetricsLandscapePhone];
    }
    [barButtonItemAppearance setBackButtonBackgroundImage:
     [theme backBackgroundForState:UIControlStateNormal
                        barMetrics:UIBarMetricsDefault]
                                                 forState:UIControlStateNormal
                                               barMetrics:UIBarMetricsDefault];
    [barButtonItemAppearance setBackButtonBackgroundImage:
     [theme backBackgroundForState:UIControlStateHighlighted
                        barMetrics:UIBarMetricsDefault]
                                                 forState:UIControlStateHighlighted
                                               barMetrics:UIBarMetricsDefault];
    [barButtonItemAppearance setBackButtonBackgroundImage:
     [theme backBackgroundForState:UIControlStateNormal
                        barMetrics:UIBarMetricsLandscapePhone]
                                                 forState:UIControlStateNormal
                                               barMetrics:UIBarMetricsLandscapePhone];
    [barButtonItemAppearance setBackButtonBackgroundImage:
     [theme backBackgroundForState:UIControlStateHighlighted
                        barMetrics:UIBarMetricsLandscapePhone]
                                                 forState:UIControlStateHighlighted
                                               barMetrics:UIBarMetricsLandscapePhone];
    UISegmentedControl *segmentedAppearance = [UISegmentedControl appearance];
    [segmentedAppearance setBackgroundImage:
     [theme segmentedBackgroundForState:UIControlStateNormal
                             barMetrics:UIBarMetricsDefault]
                                   forState:UIControlStateNormal
                                 barMetrics:UIBarMetricsDefault];
    [segmentedAppearance setBackgroundImage:
     [theme segmentedBackgroundForState:UIControlStateSelected
                             barMetrics:UIBarMetricsDefault]
                                   forState:UIControlStateSelected
                                 barMetrics:UIBarMetricsDefault];
    [segmentedAppearance setBackgroundImage:
     [theme segmentedBackgroundForState:UIControlStateNormal
                             barMetrics:UIBarMetricsLandscapePhone]
                                   forState:UIControlStateNormal
                                 barMetrics:UIBarMetricsLandscapePhone];
    [segmentedAppearance setBackgroundImage:
     [theme segmentedBackgroundForState:UIControlStateSelected
                             barMetrics:UIBarMetricsLandscapePhone]
                                   forState:UIControlStateSelected
                                 barMetrics:UIBarMetricsLandscapePhone];
    [segmentedAppearance setDividerImage:
     [theme segmentedDividerForBarMetrics:UIBarMetricsDefault]
                     forLeftSegmentState:UIControlStateNormal
                       rightSegmentState:UIControlStateNormal
                              barMetrics:UIBarMetricsDefault];
    [segmentedAppearance setDividerImage:
     [theme segmentedDividerForBarMetrics:UIBarMetricsLandscapePhone]
                     forLeftSegmentState:UIControlStateNormal
                       rightSegmentState:UIControlStateNormal
                              barMetrics:UIBarMetricsLandscapePhone];
    UITabBar *tabBarAppearance = [UITabBar appearance];
    [tabBarAppearance setBackgroundImage:[theme tabBarBackground]];
    [tabBarAppearance setSelectionIndicatorImage:
     [theme tabBarSelectionIndicator]];
    if(IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0"))
        [tabBarAppearance setShadowImage:[theme bottomShadow]];
    UIToolbar *toolbarAppearance = [UIToolbar appearance];
    [toolbarAppearance setBackgroundImage:
     [theme toolbarBackgroundForBarMetrics:UIBarMetricsDefault]
                       forToolbarPosition:UIToolbarPositionAny
                               barMetrics:UIBarMetricsDefault];
    [toolbarAppearance setBackgroundImage:
     [theme toolbarBackgroundForBarMetrics:UIBarMetricsLandscapePhone]
                       forToolbarPosition:UIToolbarPositionAny
                               barMetrics:UIBarMetricsLandscapePhone];
    if(IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0"))
        [toolbarAppearance setShadowImage:[theme bottomShadow]
                       forToolbarPosition:UIToolbarPositionAny];
    UISearchBar *searchBarAppearance = [UISearchBar appearance];
    [searchBarAppearance setBackgroundImage:[theme searchBackground]];
    [searchBarAppearance setSearchFieldBackgroundImage:[theme searchFieldImage]
                                              forState:UIControlStateNormal];
    [searchBarAppearance setImage:[theme searchImageForIcon:UISearchBarIconSearch
                                                      state:UIControlStateNormal]
                 forSearchBarIcon:UISearchBarIconSearch
                            state:UIControlStateNormal];
    [searchBarAppearance setImage:[theme searchImageForIcon:UISearchBarIconClear
                                                      state:UIControlStateNormal]
                 forSearchBarIcon:UISearchBarIconClear
                            state:UIControlStateNormal];
    [searchBarAppearance setImage:[theme searchImageForIcon:UISearchBarIconClear
                                                state:UIControlStateHighlighted]
                 forSearchBarIcon:UISearchBarIconClear
                            state:UIControlStateHighlighted];
    [searchBarAppearance setScopeBarBackgroundImage:[theme searchBackground]];
    [searchBarAppearance setScopeBarButtonBackgroundImage:
     [theme searchScopeButtonBackgroundForState:UIControlStateNormal]
                                                 forState:UIControlStateNormal];
    [searchBarAppearance setScopeBarButtonBackgroundImage:
     [theme searchScopeButtonBackgroundForState:UIControlStateSelected]
                                                 forState:UIControlStateSelected];
    [searchBarAppearance setScopeBarButtonDividerImage:
     [theme searchScopeButtonDivider]
                                   forLeftSegmentState:UIControlStateNormal
                                     rightSegmentState:UIControlStateNormal];
    UISlider *sliderAppearance = [UISlider appearance];
    [sliderAppearance setThumbImage:
     [theme sliderThumbForState:UIControlStateNormal]
                           forState:UIControlStateNormal];
    [sliderAppearance setThumbImage:
     [theme sliderThumbForState:UIControlStateHighlighted]
                           forState:UIControlStateHighlighted];
    [sliderAppearance setMinimumTrackImage:[theme sliderMinTrack]
                                  forState:UIControlStateNormal];
    [sliderAppearance setMaximumTrackImage:[theme sliderMaxTrack]
                                  forState:UIControlStateNormal];
    UIProgressView *progressAppearance = [UIProgressView appearance];
    [progressAppearance setTrackImage:[theme progressTrackImage]];
    [progressAppearance setProgressImage:[theme progressProgressImage]];
    
    UISwitch *switchAppearance = [UISwitch appearance];
    if(IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")) {
        [switchAppearance setOnImage:[theme onSwitchImage]];
        [switchAppearance setOffImage:[theme offSwitchImage]];
        [switchAppearance setTintColor:[theme switchTintColor]];
        [switchAppearance setThumbTintColor:[theme switchThumbColor]];
    }
    
    [switchAppearance setOnTintColor:[theme switchOnColor]];
    
    UIStepper *stepperAppearance = [UIStepper appearance];
    if(IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")) {
        [stepperAppearance setBackgroundImage:
         [theme stepperBackgroundForState:UIControlStateNormal]
                                     forState:UIControlStateNormal];
        [stepperAppearance setBackgroundImage:
         [theme stepperBackgroundForState:UIControlStateHighlighted]
                                     forState:UIControlStateHighlighted];
        [stepperAppearance setBackgroundImage:
         [theme stepperBackgroundForState:UIControlStateDisabled]
                                     forState:UIControlStateDisabled];
        [stepperAppearance setDividerImage:
         [theme stepperDividerForState:UIControlStateNormal]
                       forLeftSegmentState:UIControlStateNormal
                         rightSegmentState:UIControlStateNormal];
        [stepperAppearance setDividerImage:
         [theme stepperDividerForState:UIControlStateHighlighted]
                       forLeftSegmentState:UIControlStateHighlighted
                         rightSegmentState:UIControlStateNormal];
        [stepperAppearance setDividerImage:
         [theme stepperDividerForState:UIControlStateHighlighted]
                       forLeftSegmentState:UIControlStateNormal
                         rightSegmentState:UIControlStateHighlighted];
        [stepperAppearance setIncrementImage:[theme stepperIncrementImage]
                                    forState:UIControlStateNormal];
        [stepperAppearance setDecrementImage:[theme stepperDecrementImage]
                                    forState:UIControlStateNormal];
    }
    
    NSMutableDictionary *titleTextAttributes = [[NSMutableDictionary alloc] init];
    UIColor *mainColor = [theme mainColor];
    if (mainColor) {
        [titleTextAttributes setObject:mainColor forKey:UITextAttributeTextColor];
    }
    UIColor *shadowColor = [theme shadowColor];
    if (shadowColor) {
        [titleTextAttributes setObject:shadowColor
                                forKey:UITextAttributeTextShadowColor];
        CGSize shadowOffset = [theme shadowOffset];
        [titleTextAttributes setObject:[NSValue valueWithCGSize:shadowOffset]
                                forKey:UITextAttributeTextShadowOffset];
    }
    [navigationBarAppearance setTitleTextAttributes:titleTextAttributes];
    [barButtonItemAppearance setTitleTextAttributes:titleTextAttributes
                                           forState:UIControlStateNormal];
    [barButtonItemAppearance setTitleTextAttributes:titleTextAttributes
                                           forState:UIControlStateHighlighted];
    [segmentedAppearance setTitleTextAttributes:titleTextAttributes
                                       forState:UIControlStateNormal];
    [searchBarAppearance setScopeBarButtonTitleTextAttributes:titleTextAttributes
                                                     forState:UIControlStateNormal];
    
    UILabel *headerLabelAppearance = [UILabel appearanceWhenContainedIn:
                                      [UITableViewHeaderFooterView class], nil];
    UIColor *accentTintColor = [theme accentTintColor];
    if (accentTintColor) {
        [sliderAppearance setMaximumTrackTintColor:accentTintColor];
        [progressAppearance setTrackTintColor:accentTintColor];
        UIBarButtonItem *toolbarBarButtonItemAppearance =
        [UIBarButtonItem appearanceWhenContainedIn:[UIToolbar class], nil];
        [toolbarBarButtonItemAppearance setTintColor:accentTintColor];
        [tabBarAppearance setSelectedImageTintColor:accentTintColor];
    }
    UIColor *baseTintColor = [theme baseTintColor];
    if (baseTintColor) {
        [navigationBarAppearance setTintColor:baseTintColor];
        [barButtonItemAppearance setTintColor:baseTintColor];
        [segmentedAppearance setTintColor:baseTintColor];
        [tabBarAppearance setTintColor:baseTintColor];
        [toolbarAppearance setTintColor:baseTintColor];
        [searchBarAppearance setTintColor:baseTintColor];
        [sliderAppearance setThumbTintColor:baseTintColor];
        [sliderAppearance setMinimumTrackTintColor:baseTintColor];
        [progressAppearance setProgressTintColor:baseTintColor];
        if(IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0"))
            [stepperAppearance setTintColor:baseTintColor];
        [headerLabelAppearance setTextColor:baseTintColor];
    } else if (mainColor) {
        [headerLabelAppearance setTextColor:mainColor];
    }
}

+ (void)customizeView:(UIView *)view {
    id <OSTheme> theme = [self sharedTheme];
    UIColor *backgroundColor = [theme backgroundColor];
    if (backgroundColor) {
        [view setBackgroundColor:backgroundColor];
    }
}

+ (void)customizeTableView:(UITableView *)tableView {
    id <OSTheme> theme = [self sharedTheme];
    UIImage *backgroundImage = [theme tableBackground];
    UIColor *backgroundColor = [theme backgroundColor];
    if (backgroundImage) {
        UIImageView *background = [[UIImageView alloc]
                                   initWithImage:backgroundImage];
        [tableView setBackgroundView:background];
    } else if (backgroundColor) {
        [tableView setBackgroundView:nil];
        [tableView setBackgroundColor:backgroundColor];
    }
}

+ (void)customizeTabBarItem:(UITabBarItem *)item forTab:(NSInteger)tab {
    id <OSTheme> theme = [self sharedTheme];
    UIImage *image = [theme imageForTab:tab];
    if (image) {
        // If we have a regular image, set that
        [item setImage:image];
    } else {
        // Otherwise, set the finished images
        UIImage *selectedImage = [theme finishedImageForTab:tab selected:YES];
        UIImage *unselectedImage = [theme finishedImageForTab:tab selected:NO];
        [item setFinishedSelectedImage:selectedImage
           withFinishedUnselectedImage:unselectedImage];
    }
}

@end
