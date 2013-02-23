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

@implementation PostCell
@synthesize cellHeight;

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

-(void)setUBBCode:(CCPostEntity*)entity rowNum:(NSInteger)rowNum controller:(PostListTableViewController*)ctrl
{
    //NSLog(@"%d", self.subviews.count);
    cellHeight = 0;
    for (UIView *subview in self.contentView.subviews) {
        [subview removeFromSuperview];
    }
    
    UILabel *author = [[UILabel alloc] initWithFrame:CGRectMake(0, cellHeight, 320, 100)];
    author.text = [NSString stringWithFormat:@"作者：%@", entity.postAuthor];
    author.font = [UIFont boldSystemFontOfSize:14];
    author.textColor = [UIColor blueColor];
    [author sizeToFit];
    [self.contentView addSubview:author];
    cellHeight += author.frame.size.height;
    
    NSString *ubb = entity.postContent;
    //NSLog(@"BEFORE: ==== %@", ubb);
    ubb = [ubb stringByReplacingOccurrencesOfString:@"[\n\r\t]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [ubb length])];
    ubb = [ubb stringByReplacingOccurrencesOfString:@"\\[b\\](.+?)\\[/b\\]" withString:@"<b>$1</b>" options:NSRegularExpressionSearch range:NSMakeRange(0, [ubb length])];
    ubb = [ubb stringByReplacingOccurrencesOfString:@"\\[i\\](.+?)\\[/i\\]" withString:@"<i>$1</i>" options:NSRegularExpressionSearch range:NSMakeRange(0, [ubb length])];
    ubb = [ubb stringByReplacingOccurrencesOfString:@"\\[u\\](.+?)\\[/u\\]" withString:@"<u>$1</u>" options:NSRegularExpressionSearch range:NSMakeRange(0, [ubb length])];
    ubb = [ubb stringByReplacingOccurrencesOfString:@"\\[quotex\\](.+?)\\[/quotex\\]" withString:@"<br>======引用开始======<br>$1<br>======引用结束======<br>" options:NSRegularExpressionSearch range:NSMakeRange(0, [ubb length])];
    ubb = [ubb stringByReplacingOccurrencesOfString:@"\\[upload=jpg\\](.+?)\\[/upload\\]" withString:@"<img src=\"$1\" />" options:NSRegularExpressionSearch range:NSMakeRange(0, [ubb length])];
    ubb = [ubb stringByReplacingOccurrencesOfString:@"(\\[size=.*?\\])|(\\[/size\\])" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [ubb length])];
    ubb = [ubb stringByReplacingOccurrencesOfString:@"(\\[font=.*?\\])|(\\[/font\\])" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [ubb length])];
    ubb = [ubb stringByReplacingOccurrencesOfString:@"\\[color=\\w{1,8}?\\]\\[/color\\]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [ubb length])];
    ubb = [ubb stringByReplacingOccurrencesOfString:@"\\[color=(.*?)\\](.*?)\\[/color\\]" withString:@"<font color=\"$1\">$2</font>" options:NSRegularExpressionSearch range:NSMakeRange(0, [ubb length])];
    //ubb = [ubb stringByReplacingOccurrencesOfString:@"\\[color=(.+?)\\](.+?)\\[/color\\]" withString:@"<span style='color:$1;'>$2</span>" options:NSRegularExpressionSearch range:NSMakeRange(0, [ubb length])];
    ubb = [ubb stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n" options:NSRegularExpressionSearch range:NSMakeRange(0, [ubb length])];
    
    //NSLog(@"AFTER: ==== %@", ubb);

    ubb = [ubb stringByReplacingOccurrencesOfString:@"^(<img.*?/>)(?!$)" withString:@"$1\r" options:NSRegularExpressionSearch range:NSMakeRange(0, [ubb length])];
    ubb = [ubb stringByReplacingOccurrencesOfString:@"(?<!^)(<img.*?/>)$" withString:@"\r$1" options:NSRegularExpressionSearch range:NSMakeRange(0, [ubb length])];
    ubb = [ubb stringByReplacingOccurrencesOfString:@"(?<!^)(<img.*?/>)(?!$)" withString:@"\r$1\r" options:NSRegularExpressionSearch range:NSMakeRange(0, [ubb length])];

    NSArray *array = [ubb componentsSeparatedByString:@"\r"];
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
            htmlLabel.automaticallyAddLinksForType = NSTextCheckingTypeLink;
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
            [self.contentView addSubview:image];
            cellHeight += 130;
        }
    }
}

@end
