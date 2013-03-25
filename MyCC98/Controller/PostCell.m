//
//  PostCell.m
//  MyCC98
//
//  Created by Yan Chen on 1/28/13.
//  Copyright (c) 2013 YANN. All rights reserved.
//

#import "PostCell.h"
#import "UIImageView+AFNetworking.h"
#import <OHAttributedLabel/OHAttributedLabel.h>
#import <OHAttributedLabel/NSAttributedString+Attributes.h>
#import <OHAttributedLabel/OHASBasicHTMLParser.h>
#import "CC98API.h"
#import "NSDate+CCDateUtil.h"

@implementation PostCell
@synthesize cellHeight;
@synthesize controller;
@synthesize photos;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setUBBCode:(CCPostEntity*)entity rowNum:(NSInteger)rowNum
{
    //NSLog(@"%d", self.subviews.count);
    cellHeight = 0;
    for (UIView *subview in self.contentView.subviews) {
        [subview removeFromSuperview];
    }
    
    UILabel *author = [[UILabel alloc] initWithFrame:CGRectMake(0, cellHeight, 160, 18)];
    author.text = [NSString stringWithFormat:@"作者：%@", entity.postAuthor];
    author.font = [UIFont boldSystemFontOfSize:14];
    author.textColor = [UIColor blueColor];
    [author sizeToFit];
    [self.contentView addSubview:author];
    
    
    NSString *postTimeString = [entity.postTime convertToString];
    UILabel *time = [[UILabel alloc] initWithFrame:CGRectMake(160, cellHeight+2, 150, 14)];
    time.text = postTimeString;
    time.font = [UIFont boldSystemFontOfSize:12];
    time.textColor = [UIColor blueColor];
    time.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:time];
    
    cellHeight += 20;
    
    //NSLog(@"post time: !!!%@", entity.postTime);
    /*
    + (UIColor *)blackColor;      // 0.0 white
    + (UIColor *)darkGrayColor;   // 0.333 white
    + (UIColor *)lightGrayColor;  // 0.667 white
    + (UIColor *)whiteColor;      // 1.0 white
    + (UIColor *)grayColor;       // 0.5 white
    + (UIColor *)redColor;        // 1.0, 0.0, 0.0 RGB
    + (UIColor *)greenColor;      // 0.0, 1.0, 0.0 RGB
    + (UIColor *)blueColor;       // 0.0, 0.0, 1.0 RGB
    + (UIColor *)cyanColor;       // 0.0, 1.0, 1.0 RGB
    + (UIColor *)yellowColor;     // 1.0, 1.0, 0.0 RGB
    + (UIColor *)magentaColor;    // 1.0, 0.0, 1.0 RGB
    + (UIColor *)orangeColor;     // 1.0, 0.5, 0.0 RGB
    + (UIColor *)purpleColor;     // 0.5, 0.0, 0.5 RGB
    + (UIColor *)brownColor;      // 0.6, 0.4, 0.2 RGB
    + (UIColor *)clearColor;      // 0.0 white, 0.0 alpha*/
    
    NSString *ubb = entity.postContent;
    //NSLog(@"BEFORE: ==== %@", ubb);
    ubb = [ubb stringByReplacingOccurrencesOfString:@"[\r\t]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [ubb length])];
    
    ubb = [ubb stringByReplacingOccurrencesOfString:@"\\[b\\]([\\s\\S]+?)\\[/b\\]" withString:@"<b>$1</b>" options:NSRegularExpressionSearch range:NSMakeRange(0, [ubb length])];
    ubb = [ubb stringByReplacingOccurrencesOfString:@"\\[i\\]([\\s\\S]+?)\\[/i\\]" withString:@"<i>$1</i>" options:NSRegularExpressionSearch range:NSMakeRange(0, [ubb length])];
    ubb = [ubb stringByReplacingOccurrencesOfString:@"\\[u\\]([\\s\\S]+?)\\[/u\\]" withString:@"<u>$1</u>" options:NSRegularExpressionSearch range:NSMakeRange(0, [ubb length])];
    //ubb = [ubb stringByReplacingOccurrencesOfString:@"\\[quotex\\]" withString:@"<br><font color=\"blue\">_______________________________________________</font><br>" options:NSRegularExpressionSearch range:NSMakeRange(0, [ubb length])];
    ubb = [ubb stringByReplacingOccurrencesOfString:@"\\[quotex\\]" withString:@"\n" options:NSRegularExpressionSearch range:NSMakeRange(0, [ubb length])];
    ubb = [ubb stringByReplacingOccurrencesOfString:@"\\[quote\\]" withString:@"\n" options:NSRegularExpressionSearch range:NSMakeRange(0, [ubb length])];
    ubb = [ubb stringByReplacingOccurrencesOfString:@"(<b>以下是引用)(.*?)(：</b>)([\\s\\S]*?)\\[/quote\\]" withString:@"$1$2$3$4\n<b>$2引用结束</b>\n" options:NSRegularExpressionSearch range:NSMakeRange(0, [ubb length])];
    ubb = [ubb stringByReplacingOccurrencesOfString:@"(<b>以下是引用)(.*?)(：</b>)([\\s\\S]*?)\\[/quotex\\]" withString:@"$1$2$3$4\n<b>$2引用结束</b>\n" options:NSRegularExpressionSearch range:NSMakeRange(0, [ubb length])];
    ubb = [ubb stringByReplacingOccurrencesOfString:@"\\[/quotex\\]" withString:@"\n" options:NSRegularExpressionSearch range:NSMakeRange(0, [ubb length])];
    ubb = [ubb stringByReplacingOccurrencesOfString:@"\\[/quote\\]" withString:@"\n" options:NSRegularExpressionSearch range:NSMakeRange(0, [ubb length])];
    ubb = [ubb stringByReplacingOccurrencesOfString:@"\\[upload=(jpg|png|gif|jpg,1|png,1|gif,1)\\](.+?)\\[/upload\\]" withString:@"<img src=\"$2\" />" options:NSRegularExpressionSearch range:NSMakeRange(0, [ubb length])];
    
    ubb = [ubb stringByReplacingOccurrencesOfString:@"(\\[size=.*?\\])|(\\[/size\\])" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [ubb length])];
    ubb = [ubb stringByReplacingOccurrencesOfString:@"(\\[font=.*?\\])|(\\[/font\\])" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [ubb length])];
    ubb = [ubb stringByReplacingOccurrencesOfString:@"(\\[url=.*?\\])|(\\[/url\\])" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [ubb length])];
    
    
    ubb = [ubb stringByReplacingOccurrencesOfString:@"\\[color=\\w{1,8}?\\]\\[/color\\]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [ubb length])];
    ubb = [ubb stringByReplacingOccurrencesOfString:@"\\[color=transparent\\]([\\s\\S]*?)\\[/color\\]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [ubb length])];
    ubb = [ubb stringByReplacingOccurrencesOfString:@"\\[color=(black|darkGray|lightGray|white|gray|red|green|blue|cyan|yellow|magenta|orange|purple|brown|clear)\\]([\\s\\S]*?)\\[/color\\]" withString:@"<font color=\"$1\">$2</font>" options:NSRegularExpressionSearch range:NSMakeRange(0, [ubb length])];
    ubb = [ubb stringByReplacingOccurrencesOfString:@"\\[color=(.*?)\\]([\\s\\S]*?)\\[/color\\]" withString:@"<font color=\"purple\">$2</font>" options:NSRegularExpressionSearch range:NSMakeRange(0, [ubb length])];
    ubb = [ubb stringByReplacingOccurrencesOfString:@"(\\[color=.*?\\])|(\\[/color\\])" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [ubb length])];
    //ubb = [ubb stringByReplacingOccurrencesOfString:@"\\[color=(.*?)\\](.*?)\\[/color\\]" withString:@"$2" options:NSRegularExpressionSearch range:NSMakeRange(0, [ubb length])];
    //ubb = [ubb stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n" options:NSRegularExpressionSearch range:NSMakeRange(0, [ubb length])];
    
    //NSLog(@"AFTER: ==== %@", ubb);
    
    //ubb = [ubb stringByReplacingOccurrencesOfString:@"\\[.*?\\]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [ubb length])];

    ubb = [ubb stringByReplacingOccurrencesOfString:@"^(<img.*?/>)(?!$)" withString:@"$1\r" options:NSRegularExpressionSearch range:NSMakeRange(0, [ubb length])];
    ubb = [ubb stringByReplacingOccurrencesOfString:@"(?<!^)(<img.*?/>)$" withString:@"\r$1" options:NSRegularExpressionSearch range:NSMakeRange(0, [ubb length])];
    ubb = [ubb stringByReplacingOccurrencesOfString:@"(?<!^)(<img.*?/>)(?!$)" withString:@"\r$1\r" options:NSRegularExpressionSearch range:NSMakeRange(0, [ubb length])];

    NSArray *array = [ubb componentsSeparatedByString:@"\r"];
    
    self.photos = [NSMutableArray array];
    
    for (NSString *string in array) {
        //NSLog(@"result: %@", string);
        NSRegularExpression *regex = [[NSRegularExpression alloc]
                                      initWithPattern:@"<img.*?/>"
                                      options:NSRegularExpressionCaseInsensitive
                                      error:nil];
        NSRange topicIdRange = [regex rangeOfFirstMatchInString:string options:0 range:NSMakeRange(0, string.length)];
        if (topicIdRange.location == NSNotFound) {
            OHAttributedLabel* htmlLabel = [[OHAttributedLabel alloc] initWithFrame:CGRectMake(0, cellHeight, 320, 1000)];
            htmlLabel.attributedText = [OHASBasicHTMLParser attributedStringByProcessingMarkupInString:string];
            htmlLabel.automaticallyAddLinksForType = nil;
            [htmlLabel sizeToFit];
            [self.contentView addSubview:htmlLabel];
            
            cellHeight += htmlLabel.frame.size.height + 10;
        } else {
            NSRegularExpression *regex1 = [[NSRegularExpression alloc]
                                          initWithPattern:@"(?<=src=\")\\S*(?=\")"
                                          options:NSRegularExpressionCaseInsensitive
                                          error:nil];
            NSRange topicIdRange1 = [regex1 rangeOfFirstMatchInString:string options:0 range:NSMakeRange(0, string.length)];
            NSString *url = [string substringWithRange:topicIdRange1];
            //NSLog(@"%@", url);
            UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, cellHeight, 200, 120)];
            NSURL *imageurl = [[CC98API sharedInstance] urlFromString:url];
            //NSLog(@"%@", imageurl);
            [image setImageWithURL:imageurl];
            image.contentMode = UIViewContentModeScaleAspectFill;
            image.clipsToBounds = YES;
            
            image.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
            [image addGestureRecognizer:tap];
            
            [image setTag:[photos count]];
            [photos addObject:[MWPhoto photoWithURL:imageurl]];
            
            [self.contentView addSubview:image];
            cellHeight += 130;
        }
    }
}

- (void) imageTapped:(UITapGestureRecognizer *)gr
{
    UIImageView *imageview = (UIImageView *)gr.view;
    NSInteger imagetag = [imageview tag];
    /*UIImage *image = imageview.image;
    UIStoryboard *board=[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    ShowImageViewController *nextViewController =[board instantiateViewControllerWithIdentifier:@"ShowImage"];
    nextViewController.image = image;
    nextViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.controller presentViewController:nextViewController animated:YES completion:nil];*/
    
    // Create & present browser
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    // Set options
    browser.wantsFullScreenLayout = YES; // Decide if you want the photo browser full screen, i.e. whether the status bar is affected (defaults to YES)
    browser.displayActionButton = YES; // Show action button to save, copy or email photos (defaults to NO)
    [browser setInitialPageIndex:imagetag]; // Example: allows second image to be presented first
    // Present
    UINavigationController *navBar = [[UINavigationController alloc] initWithRootViewController:browser];
    [self.controller presentViewController:navBar animated:YES completion:nil];
}

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.photos.count;
}

- (MWPhoto *)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < self.photos.count)
        return [self.photos objectAtIndex:index];
    return nil;
}

@end
