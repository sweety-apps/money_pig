//
//  ExchangeControllerCell.m
//  wangcai
//
//  Created by 1528 on 13-12-18.
//  Copyright (c) 2013年 1528studio. All rights reserved.
//

#import "ExchangeControllerCell.h"

@implementation ExchangeControllerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 103)];
        [self addSubview:_view];
        
        UIImage* image = [UIImage imageNamed:@"exchange_bkg"];
        [_view setBackgroundImage:image];
        
        _info = nil;
        
        _imageView = [[BeeUIImageView alloc] initWithFrame:CGRectMake(16, 14, 120, 82)];
        [_view addSubview:_imageView];
        
        _imageView.contentMode = UIViewContentModeScaleToFill;
        
        _labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(146, 12, 160, 20)];
        [_view addSubview:_labelTitle];
        _labelTitle.font = [UIFont systemFontOfSize:14];
        _labelTitle.backgroundColor = [UIColor clearColor];
        
        _labelPrice = [[UILabel alloc] initWithFrame:CGRectMake(146, 36, 96, 20)];
        [_view addSubview:_labelPrice];
        _labelPrice.font = [UIFont systemFontOfSize:12];
        [_labelPrice setTextColor:[UIColor colorWithRed:0.0/255 green:114.0/255 blue:197.0/255 alpha:1]];
        _labelPrice.backgroundColor = [UIColor clearColor];
        
        _labelNum = [[UILabel alloc] initWithFrame:CGRectMake(236, 36, 76, 20)];
        [_view addSubview:_labelNum];
        _labelNum.font = [UIFont systemFontOfSize:12];
        [_labelNum setTextColor:[UIColor colorWithRed:0.0/255 green:114.0/255 blue:197.0/255 alpha:1]];
        _labelNum.backgroundColor = [UIColor clearColor];
        
        _imageBtn = [[UIImageView alloc] initWithFrame:CGRectMake(146, 72, 45, 15)];
        [_imageBtn setImage:[UIImage imageNamed:@"exchange_btn2"]];
        [_view addSubview:_imageBtn];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    self.delegate = nil;
    
    if ( _info != nil ) {
        [_info release];
        _info = nil;
    }
    
    [_imageView release];
    _imageView = nil;
    
    [_btnExchange release];
    _btnExchange = nil;
    
    [_labelTitle release];
    _labelTitle = nil;
    
    [_labelNum release];
    _labelNum = nil;
    
    [_labelPrice release];
    _labelPrice = nil;
    
    [_view release];
    _view = nil;
    
    [_imageBtn release];
    [super dealloc];
}

- (IBAction)onClick:(id)sender {
    if ( self.delegate != nil ) {
        [self.delegate onClickExchange:self];
    }
}

- (void)setInfo:(NSDictionary*) info {
    if ( _info != nil ) {
        [_info release];
    }
    
    _info = [info copy];
    
    
    _labelTitle.text = [_info objectAtPath:@"name"];
    
    NSString* icon = [_info objectAtPath:@"icon"];
    NSNumber* price = [_info objectAtPath:@"price"];
    NSNumber* remain = [_info objectAtPath:@"remain"];
    int nPrice = [price intValue];
    
    _labelPrice.text = [[NSString alloc] initWithFormat:@"价格：%.2f元", 1.0*nPrice/100];
    _labelNum.text = [[NSString alloc] initWithFormat:@"剩余：%@", remain];
    
    UIImage* cachedImage = [[BeeImageCache sharedInstance] imageForURL:icon];
    _imageView.layer.cornerRadius = 8.0f;
    if (cachedImage != nil)
    {
        [_imageView setImage:cachedImage];
    }
    else
    {
        [_imageView GET:icon useCache:YES];
    }
}

- (NSDictionary*)getInfo {
    return [[_info copy] autorelease];
}
@end
