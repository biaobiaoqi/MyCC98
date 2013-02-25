//
//  webViewController.h
//  MyCC98
//
//  Created by Yan Chen on 2/25/13.
//  Copyright (c) 2013 YANN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, retain) IBOutlet UIWebView *webview;

@end
