//
//  BIDAu-exViewController.m
//  智巢（最新）
//
//  Created by Ling Zhi on 13-4-30.
//  Copyright (c) 2013年 Ling Zhi. All rights reserved.
//

#import "BIDAu-exViewController.h"
#import "DrawPatternLockView.h"
#import <QuartzCore/QuartzCore.h>
#import <math.h>
@interface BIDAu_exViewController ()

@end

@implementation BIDAu_exViewController
@synthesize drawview;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}





- (void)viewDidLoad
{
    [super viewDidLoad];
    drawview.layer.cornerRadius=10;
    drawview.layer.masksToBounds=YES;
     _paths = [[NSMutableArray alloc] init];
   // [self sendCommand:@"OPEN"];

      	// Do any additional setup after loading the view.
}



- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //[super touchesBegan:touches withEvent:event];
    if ([[self getKey] length]==0) {
        
        NSLog(@"length is %lu",(unsigned long)[[self getKey] length]);
   CGPoint pt = [[touches anyObject] locationInView:self.drawview];
   UIView *touched = [self.drawview hitTest:pt withEvent:event];
    if (touched==self.drawview) {
    DrawPatternLockView *v = (DrawPatternLockView*)self.drawview;
    if (v._dotViews!=nil) {
        
        [v clearDotViews];
        
        for (UIView *view in self.drawview.subviews)
            if ([view isKindOfClass:[UIImageView class]])
                [(UIImageView*)view setHighlighted:NO];
        
        [self.drawview setNeedsDisplay];
    }
    
    }
    }
    else{
        return;
    
    }
    //_paths = [[NSMutableArray alloc] init];
    
}


- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
     

    CGPoint pt = [[touches anyObject] locationInView:self.drawview];//触摸点
    UIView *touched = [self.drawview hitTest:pt withEvent:event];//根据触摸点和触摸事件来确定起始触摸点在哪个view上
    
   DrawPatternLockView *v = (DrawPatternLockView*)self.drawview;
    
    [v drawLineFromLastDotTo:pt];//将某点的信息（CGPoint）转换为Value的格式存入_trackPointValue中，然后再对self.view调用setNeedsDisplay通知视图需要重画(调用drawRect?)
    //记录特定view上的触摸信息
    if (touched.tag!=0) {
        
      
        BOOL found = NO;
        for (NSNumber *tag in _paths) {
            
            found = tag.integerValue==touched.tag;
            if (found)
                break;
        }
        
        if (found)
            return;
        
        [_paths addObject:[NSNumber numberWithInt:touched.tag]];
        [v addDotView:touched];
        
        UIImageView* iv = (UIImageView*)touched;
        iv.highlighted = YES;
    }
   
    
}


- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    // clear up hilite
    //  DrawPatternLockView *v = (DrawPatternLockView*)self.view;
    //  [v clearDotViews];
    
    //  for (UIView *view in self.view.subviews)
    //    if ([view isKindOfClass:[UIImageView class]])
    //      [(UIImageView*)view setHighlighted:NO];
    //
    //  [self.view setNeedsDisplay];
    //
    //   pass the output to target action...
    //if (_target && _action)
    // [_target performSelector:_action withObject:[self getKey]];
   // [super touchesEnded:touches withEvent:event];
    NSLog(@"key: %@", [self getKey]);
    int sum;
    int i=0;
    for (NSNumber *tag in _paths){
        sum=i+tag.intValue;
        i=tag.intValue;
    }
    
    if ([[self getKey] length]!=4&&[[self getKey] length]!=0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"选择错误"
                                                            message:@"请重新选择!"
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"OK", nil];
        [alertView show];
        DrawPatternLockView *v = (DrawPatternLockView*)self.drawview;
        [v clearDotViews];
                for (UIView *view in self.drawview.subviews)
            if ([view isKindOfClass:[UIImageView class]])
                [(UIImageView*)view setHighlighted:NO];
        [self.drawview setNeedsDisplay];
        [_paths removeAllObjects];
    
        
    }
    else{
        
    if(sum%2!=1&&[[self getKey] length]==4){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"选择错误"
                                                            message:@"请重新选择!"
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"OK", nil];
        [alertView show];
        DrawPatternLockView *v = (DrawPatternLockView*)self.drawview;
        [v clearDotViews];
        for (UIView *view in self.drawview.subviews)
            if ([view isKindOfClass:[UIImageView class]])
                [(UIImageView*)view setHighlighted:NO];
        [self.drawview setNeedsDisplay];
      
        [_paths removeAllObjects];
   
    }
       
    }
    
    
    
    
    
}
-(IBAction)command:(id)sender{
    NSString*string=[NSString stringWithFormat:@"AU%@",  [self getKey]];
    NSLog(@"STRING IS %@",string);
    [self sendCommand:string];
    [_paths removeAllObjects];
}

// get key from the pattern drawn
// replace this method with your own key-generation algorithm

- (NSString*)getKey {
    NSMutableString *key;
    key = [NSMutableString string];
    
    // simple way to generate a key
    for (NSNumber *tag in _paths) {
        [key appendFormat:@"%02d", tag.integerValue];
    }
  
    return key;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
