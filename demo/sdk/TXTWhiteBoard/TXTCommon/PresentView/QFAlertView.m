//
//  QFAlertView.m
//  KYH
//
//  Created by 尚振兴 on 2020/6/5.
//  Copyright © 2020 AIA. All rights reserved.
//

#import "QFAlertView.h"
#import "UIButton+Extension.h"
#import "UIImage+Triangle.h"
#import "UIView+QFExtension.h"
#import "ZYSuspensionManager.h"

//MARK: Colors
#define GREENCOLOR  [UIColor colorWithRed:0.443 green:0.765 blue:0.255 alpha:1]
#define REDCOLOR    [UIColor colorWithRed:0.906 green:0.296 blue:0.235 alpha:1]
#define BLUECOLOR  [UIColor colorWithRed:0.203 green:0.596 blue:0.858 alpha:1]
#define GrayCOLOR  PJColor(203,204,205)
#define KunitTime 0.25
#define kDesLabelLineSpacing kWidthScale(10)
#define BtnHeight 90;

typedef void(^animateBlock)(void);

@interface QFAlertView()
{
    UIView *contentView;
    UIView*bgView;
    UILabel *titleLb;
    UIImageView *titleIconImgView;
    NSString *titleIcon;
    UILabel*desLb;
    UILabel *msgLb;
    UIButton *sureBtn;//left
    UIButton *cancelBtn;//right
    CGFloat lineSpacing;
    //animateBlock Arr
    NSMutableArray * _animateArr;
   
    float kdesLabelW;
    float kcontentW;
    float topMargin;
    NSInteger btnCount;
}

@property(nonatomic,copy)UIColor *tintColor;

//blocks which is not invoked on main thread
@property(nonatomic,copy)void(^cancelClick)(void);
@property(nonatomic,copy)void(^sureClick)(void);
@property(nonatomic,copy)void(^bgClick)(QFAlertView * view);

@end

@implementation QFAlertView

+(instancetype _Nullable )alertViewTitle:(NSString *_Nullable)title
                                     des:(NSString *_Nullable)des
                               leftTitle:(NSString *_Nullable)leftTitle
                              rightTitle:(NSString *_Nullable)rightTitle
                         leftAction:(void(^ _Nullable)(void))leftAction
                       rightAction:(void(^ _Nullable)(void))rightAction{
    
    return [QFAlertView alertViewTitle:title titleIcon:nil des:des leftTitle:leftTitle rightTitle:rightTitle leftAction:leftAction rightAction:rightAction];;
}

+(instancetype _Nullable )alertViewTitle:(NSString *_Nullable)title
                                     des:(NSString *_Nullable)des
                                btnTitle:(NSString *_Nullable)btnTitle
                               btnAction:(void(^ _Nullable)(void))btnAction{
    
    return [self alertViewTitle:title des:des leftTitle:nil rightTitle:btnTitle leftAction:nil rightAction:btnAction];
}


+(instancetype _Nullable )alertViewTitle:(NSString *_Nullable)title
                                     des:(NSString *_Nullable)des
                                 btnIcon:(NSString *_Nullable)btnIcon
                               btnTitle:(NSString *_Nullable)btnTitle
                               btnAction:(void(^ _Nullable)(void))btnAction{
    
    return [self alertViewTitle:title titleIcon:nil des:des leftTitle:nil rightIcon:btnIcon rightTitle:btnTitle leftAction:nil rightAction:btnAction];
}

+(instancetype _Nullable )alertViewTitle:(NSString *_Nullable)title
                               titleIcon:(NSString *_Nullable)titleIcon
                                     des:(NSString *_Nullable)des
                                btnTitle:(NSString *_Nullable)btnTitle
                               btnAction:(void(^ _Nullable)(void))btnAction{
    return [self alertViewTitle:title titleIcon:titleIcon des:des leftTitle:nil rightTitle:btnTitle leftAction:nil rightAction:btnAction];
    
}

+(instancetype _Nullable )alertViewTitle:(NSString *_Nullable)title
                               titleIcon:(NSString *_Nullable)titleIcon
                                     des:(NSString *_Nullable)des
                               leftTitle:(NSString *_Nullable)leftTitle
                              rightTitle:(NSString *_Nullable)rightTitle
                              leftAction:(void(^ _Nullable)(void))leftAction
                             rightAction:(void(^ _Nullable)(void))rightAction{
    
    return  [self alertViewTitle:title titleIcon:titleIcon des:des leftTitle:leftTitle rightIcon:nil rightTitle:rightTitle leftAction:leftAction rightAction:rightAction];
}


+(instancetype _Nullable )alertViewTitle:(NSString *_Nullable)title
                               titleIcon:(NSString *_Nullable)titleIcon
                                     des:(NSString *_Nullable)des
                               leftTitle:(NSString *_Nullable)leftTitle
                               rightIcon:(NSString *_Nullable)rightIcon
                              rightTitle:(NSString *_Nullable)rightTitle
                              leftAction:(void(^ _Nullable)(void))leftAction
                             rightAction:(void(^ _Nullable)(void))rightAction{
    
    QFAlertView* view = [[QFAlertView alloc]init];
    view->titleLb.text=title;
    //0x757575
     view->msgLb.text = des;
    view->titleIcon = titleIcon;
    view->titleIconImgView.image = [UIImage imageNamed:titleIcon];
    [view->sureBtn setTitle:leftTitle forState:UIControlStateNormal];
    [view->cancelBtn setTitle:rightTitle forState:UIControlStateNormal];
    
    if(rightIcon.length != 0){
        [view->cancelBtn setImage:[UIImage imageNamed:rightIcon] forState:UIControlStateNormal];
        [view->cancelBtn edgePosition:ButtonPositionWithLeftImageRightTitle gap:8];
    }
    
    if (leftTitle.length>0) {
        view->btnCount ++;
    }
    
    if (rightTitle.length>0) {
        view->btnCount ++;
    }
    
    if (leftTitle.length != 0) {
        view.sureClick = leftAction;
        
    }
    
    if(rightTitle.length != 0){
        view.cancelClick = rightAction;
    }
    
    return view;
    
}


+(instancetype _Nullable )alertViewTitle:(NSString *_Nullable)title
                                     msg:(NSString *_Nullable)msg
                                     des:(NSString *_Nullable)des
                                btnTitle:(NSString *_Nullable)btnTitle
                               btnAction:(void(^ _Nullable)(void))btnAction{
    
    return [self alertViewTitle:title msg:msg des:des leftTitle:nil rightTitle:btnTitle leftAction:nil rightAction:btnAction];
}

+(instancetype _Nullable )alertViewTitle:(NSString *_Nullable)title
                                     msg:(NSString *_Nullable)msg
                                     des:(NSString *_Nullable)des
                               leftTitle:(NSString *_Nullable)leftTitle
                              rightTitle:(NSString *_Nullable)rightTitle
                              leftAction:(void(^ _Nullable)(void))leftAction
                             rightAction:(void(^ _Nullable)(void))rightAction{
    
    NSString *rightIcon = nil;
    NSString *titleIcon = nil;
    
    QFAlertView* view = [[QFAlertView alloc]init];
    view->titleLb.text=title;
    
    NSString *desText = [NSString stringWithFormat:@"%@\n\n%@",msg,des];
    //757575
    NSMutableAttributedString *attDes = [self attStringWithString:desText ParagraphLineSpeace:view->lineSpacing color:COLOR_WITH_HEX(0x757575) textFont:[UIFont systemFontOfSize:Adapt(18)]];
    
    NSRange range = [desText rangeOfString:des];
    [attDes addAttribute:NSForegroundColorAttributeName value:COLOR_WITH_HEX(0xF87D26) range:range];
    [attDes addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:Adapt(18)] range:range];
    
    view->desLb.attributedText = attDes;
    
    view->titleIcon = titleIcon;
    view->titleIconImgView.image = [UIImage imageNamed:titleIcon];
    [view->sureBtn setTitle:leftTitle forState:UIControlStateNormal];
    [view->cancelBtn setTitle:rightTitle forState:UIControlStateNormal];
    
    if(rightIcon.length != 0){
        [view->cancelBtn setImage:[UIImage imageNamed:rightIcon] forState:UIControlStateNormal];
        [view->cancelBtn edgePosition:ButtonPositionWithLeftImageRightTitle gap:8];
    }
    
    if (leftTitle.length>0) {
        view->btnCount ++;
    }
    
    if (rightTitle.length>0) {
        view->btnCount ++;
    }
    
    if (leftTitle.length != 0) {
        view.sureClick = leftAction;
        
    }
    
    if(rightTitle.length != 0){
        view.cancelClick = rightAction;
    }
    
    return view;
}

//倒计时
+(instancetype _Nullable )alertViewTitle:(NSString *_Nullable)title
                                     msg:(NSString *_Nullable)msg
                                     des:(NSString *_Nullable)des
                               leftTitle:(NSString *_Nullable)leftTitle
                              rightTitle:(NSString *_Nullable)rightTitle
                                    time:(NSInteger)time
                              leftAction:(void(^ _Nullable)(void))leftAction
                             rightAction:(void(^ _Nullable)(void))rightAction{
    
    QFAlertView* view = [[QFAlertView alloc]init];
    view->titleLb.text=title;
    view->msgLb.text = msg;
    view->desLb.text = des;
//    NSString *desText = [NSString stringWithFormat:@"%@\n\n%@",msg,des];
//    NSMutableAttributedString *attDes = [self attStringWithString:desText ParagraphLineSpeace:view->lineSpacing color:COLOR_WITH_HEX(0x4D4D4D) textFont:[UIFont systemFontOfSize:Adapt(18)]];
//
//    NSRange range = [desText rangeOfString:des];
//    [attDes addAttribute:NSForegroundColorAttributeName value:COLOR_WITH_HEX(0xF87D26) range:range];
//    [attDes addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:Adapt(12)] range:range];
//
//    view->desLb.attributedText = attDes;
    [view->sureBtn setTitle:leftTitle forState:UIControlStateNormal];
    [view->cancelBtn setTitle:rightTitle forState:UIControlStateNormal];
    __block NSInteger timeout = time +1;
    __block NSString *cancelTitle = @"";
    __weak typeof(self) weakSelf = self;
        dispatch_source_t _timer;
           dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
           _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
           dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC, 0);//每秒执行
           dispatch_source_set_event_handler(_timer, ^{
               if (timeout == 0) {
                   dispatch_source_cancel(_timer);
                   dispatch_async(dispatch_get_main_queue(), ^{
                       NSLog(@"计时结束");
                       
//                       [UIView animateWithDuration:KunitTime delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
//                           view.alpha=0;
//                       } completion:^(BOOL finished) {
//                           [view removeFromSuperview];
//                       }];
                   });
               }else {
                   timeout--;
                   cancelTitle = [NSString stringWithFormat:@"结束会话(%ds)",timeout];
                   dispatch_async(dispatch_get_main_queue(), ^{
                      [view->sureBtn setTitle:cancelTitle forState:UIControlStateNormal];
                   });
               }
           });
           dispatch_resume(_timer);
    
    if (leftTitle.length>0) {
        view->btnCount ++;
    }
    
    if (rightTitle.length>0) {
        view->btnCount ++;
    }
    
    if (leftTitle.length != 0) {
        view.sureClick = leftAction;
        
    }
    
    if(rightTitle.length != 0){
        view.cancelClick = rightAction;
    }
    
    return view;
}

- (void)secondsCountUP{
    
}

//+(instancetype _Nullable )alertSystemViewTitle:(NSString *_Nullable)title
//                                     msg:(NSString *_Nullable)msg
//                                     des:(NSString *_Nullable)des
//                                     leftTitle:(NSString *_Nullable)leftTitle
//                                    rightTitle:(NSString *_Nullable)rightTitle
//                                    leftAction:(void(^ _Nullable)(void))leftAction
//                                   rightAction:(void(^ _Nullable)(void))rightAction{
//    QFAlertView* view = [[QFAlertView alloc]init];
//}


- (void)setRightBtnColor:(UIColor *)rightBtnColor{
    _rightBtnColor = rightBtnColor;
    self->cancelBtn.backgroundColor = rightBtnColor;
}

#pragma mark - Life Circle
- (instancetype)init{
    self = [super init];
    if (self) {
        //default values
        _tintColor=GREENCOLOR;
        _animateArr=@[].mutableCopy;
        if (Screen_Width>Screen_Height) {
            kcontentW = Screen_Height-48;
        }else{
            kcontentW = Screen_Width-48;
        }
        kdesLabelW = kcontentW-Adapt(60);
        topMargin=Adapt(50);
        
        lineSpacing = 3;
        self.frame=[[UIScreen mainScreen]bounds];
        
        //add blur effect view
        UIView* bgV =[[UIView alloc] init];
        bgV.frame=self.frame;
        [self addSubview:bgV];
        
        bgV.userInteractionEnabled=YES;
        UITapGestureRecognizer* tapBg=[[UITapGestureRecognizer  alloc]initWithTarget:self action:@selector(bgTap)];
        [bgV addGestureRecognizer:tapBg];
        bgView=bgV;
        bgView.alpha = 0.5;
        bgView.backgroundColor = [UIColor blackColor];
        
        UIView *contentV=[UIView new];
        contentV.backgroundColor=[UIColor whiteColor];
        [self addSubview: contentV];
        contentV.layer.cornerRadius=8;
        contentView=contentV;
        
        UILabel* tLb = [[UILabel alloc]init];
        tLb.textColor=[UIColor colorWithHexString:@"#666666"];
        tLb.font= [UIFont systemFontOfSize:Adapt(13)];
        tLb.numberOfLines=0;
        tLb.textAlignment=NSTextAlignmentCenter;
        [contentView addSubview:tLb];
        titleLb = tLb;
        
        UILabel* msgb = [[UILabel alloc]init];
        msgb.textColor=[UIColor colorWithHexString:@"#666666"];
        msgb.font= [UIFont systemFontOfSize:Adapt(13)];
        msgb.numberOfLines=0;
        msgb.textAlignment=NSTextAlignmentCenter;
        [contentView addSubview:msgb];
        msgLb = msgb;
        
        UILabel* dLb = [[UILabel alloc]init];
        dLb.textColor=[UIColor redColor];
        dLb.font= [UIFont systemFontOfSize:Adapt(13)];
        dLb.numberOfLines=0;
        dLb.textAlignment=NSTextAlignmentCenter;
        [contentView addSubview:dLb];
        desLb = dLb;
        
        UIButton* sureB  = [[UIButton alloc]init];
        sureB.backgroundColor=[UIColor whiteColor];//_tintColor;
        [sureB setTitleColor:[UIColor colorWithHexString:@"#E6B980"] forState:UIControlStateNormal];
        sureB.titleLabel.font=[UIFont systemFontOfSize:Adapt(16)];
        sureB.tag=0;
        [sureB addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:sureB];
        sureBtn=sureB;
        sureB.layer.borderWidth = 0.5;
        sureB.layer.borderColor = [UIColor colorWithHexString:@"#666666"].CGColor;
        
        UIButton* cancelB  = [[UIButton alloc]init];
        cancelB.backgroundColor = [UIColor whiteColor];
        [cancelB setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        cancelB.titleLabel.font=[UIFont systemFontOfSize:Adapt(16)];
        cancelB.tag=1;
        [cancelB addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:cancelB];
        cancelBtn=cancelB;
        cancelB.layer.borderWidth = 0.5;
        cancelB.layer.borderColor = [UIColor colorWithHexString:@"#666666"].CGColor;
        
        //add shadow
        contentView.layer.shadowColor=[UIColor blackColor].CGColor;
        contentView.layer.shadowOffset=CGSizeZero;
        contentView.layer.shadowRadius=20.f;
        contentView.layer.shadowOpacity=0.4f;
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];

    float btnW=Adapt(120),btnH=Adapt(60),statusBarH=Adapt(18);
    float titleMarginT=topMargin/2 + 5, desMarginT=0,btnMarginT=0,btnMarginB=0;
    if (btnCount == 0) {
        btnH = 0;
        btnMarginT = 0;
    }
   
    float spaceBtn=0;//space between surebtn and cancelbtn
    float titleH=[self getLbSize:titleLb].height;
    float titleW=[self getLbSize:titleLb].width;
    if (titleLb.text.length == 0) {
        msgLb.font = FontRegular(Adapt(18));
        msgLb.textColor = COLOR_WITH_HEX(0x4D4D4D);
    }
    float msgH=[self getMsgLbSize:msgLb].height + 5;
    float desH=[self getDesLbSize:desLb].height + 20;
    float contentH = titleMarginT+titleH+msgH+desH+btnMarginT+btnH+btnMarginB,contentW=kcontentW;
    contentView.frame = CGRectMake(0, 0, contentW, contentH);
    contentView.center=self.center;
   
    titleLb.frame=CGRectMake(0, titleMarginT, titleW, titleH);
    
    if (msgLb.text.length && titleLb.text.length) {
        msgLb.frame=CGRectMake(0, CGRectGetMaxY(titleLb.frame)+desMarginT, contentW, msgH);
    }else{
        msgLb.frame=CGRectMake(0, Adapt(30), contentW, msgH);
    }
    titleLb.qf_centerX = contentW/2;
    
    if (desLb.text.length) {
        desLb.frame=CGRectMake(0, CGRectGetMaxY(msgLb.frame), contentW, desH);
    }
    
    float btnY;
    if (desLb.text.length) {
        btnY=CGRectGetMaxY(desLb.frame)+btnMarginT + 5;
    }else{
        btnY= contentH-btnH;
    }

    if (sureBtn.titleLabel.text.length>8) {
        sureBtn.qf_size = CGSizeMake(btnW+30, btnH);
    }
    
    if (btnCount == 1) {
        if(cancelBtn.titleLabel.text.length != 0 ){
            btnW = contentW;
            cancelBtn.frame=CGRectMake(contentW/2+spaceBtn/2, btnY, btnW, btnH);
            sureBtn.frame=CGRectZero;
            cancelBtn.qf_centerX = contentW/2;
        }
        else{
            sureBtn.frame=CGRectMake((contentW-btnW*2)/2, btnY, btnW, btnH);
            cancelBtn.frame=CGRectZero;
            sureBtn.qf_centerX = contentW/2;
        }
    }else if (btnCount == 2){
        sureBtn.frame=CGRectMake(0, btnY, contentW/2, btnH);
        cancelBtn.frame=CGRectMake(contentW/2, btnY, contentW/2, btnH);
    }else{
        cancelBtn.frame=CGRectZero;
        sureBtn.frame = CGRectZero;
    }
//    sureBtn.layer.cornerRadius = sureBtn.qf_height/2;
//    cancelBtn.layer.cornerRadius = cancelBtn.qf_height/2;
}

//MARK: Private Methods
-(CGSize)getLbSize:(UILabel*)lb{
    CGSize size =[lb.text boundingRectWithSize:CGSizeMake(kcontentW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:lb.font} context:nil].size;
    return size;
}

-(CGSize)getMsgLbSize:(UILabel*)lb{
    NSString * des = lb.text;
    if (des.length) {
        // 调整行间距
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
        /** 行高 */
        paraStyle.lineSpacing = lineSpacing;
        // NSKernAttributeName字体间距
        NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:Adapt(18)], NSParagraphStyleAttributeName:paraStyle};

        CGSize size = [des boundingRectWithSize:CGSizeMake(kdesLabelW,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
        
        return size;
    }
    return CGSizeMake(0, 0);
}

-(CGSize)getDesLbSize:(UILabel*)lb{
    NSString * des = lb.text;
    if (des.length) {
        // 调整行间距
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
        /** 行高 */
        paraStyle.lineSpacing = lineSpacing;
        // NSKernAttributeName字体间距
        NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:Adapt(14)], NSParagraphStyleAttributeName:paraStyle};

        CGSize size = [des boundingRectWithSize:CGSizeMake(kdesLabelW,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
        
        return size;
    }
    return CGSizeMake(0, 0);
}


+(NSMutableAttributedString *)attStringWithString:(NSString *)string
                       ParagraphLineSpeace:(CGFloat)lineSpacing
                                     color:(UIColor *)color
                                  textFont:(UIFont *)font {
    // 设置段落
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    paragraphStyle.lineSpacing = lineSpacing;
    
    NSDictionary *attributes = @{NSParagraphStyleAttributeName:paragraphStyle};
    NSMutableAttributedString * attriStr = [[NSMutableAttributedString alloc] initWithString:string attributes:attributes];
    // 创建文字属性
    NSDictionary * attriBute = @{NSForegroundColorAttributeName:color,NSFontAttributeName:font};
    [attriStr addAttributes:attriBute range:NSMakeRange(0, string.length)];
    return attriStr;
}

-(CGSize)getTextViewSize:(UITextView*)lb{
    CGSize size =[lb.text boundingRectWithSize:CGSizeMake(kcontentW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:lb.font} context:nil].size;
    return size;
}

-(void)nextAnimate{
    if (_animateArr.count == 0) {
        return;
    }
    animateBlock ani= [_animateArr firstObject];
    ani();
}

-(void)removeAni{
    if(_animateArr.count > 0){
        [_animateArr removeObjectAtIndex:0];
    }
    [self nextAnimate];
}


//MARK: Action
-(void)btnClick:(UIButton*)btn{
    [self dismiss];
    dispatch_async(dispatch_get_main_queue(), ^(void){
        switch (btn.tag) {
            case 0://sure
                if (self.sureClick) {
                    self.sureClick();
                }
                break;
            case 1://cancel
                
                if (self.cancelClick) {
                    self.cancelClick();
                }
                break;
            default:
                break;
        }
    });
}

-(void)bgTap{
    if (btnCount==0) {
        [self dismiss];
        if (self.cancelClick) {
            self.cancelClick();
        }
    }
}

-(void)dismiss{
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        
        [UIView animateWithDuration:KunitTime delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.alpha=0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
            
        }];
    });
}


////MARK: External Methods
- (void)showInView:(UIView *)view{

    [view addSubview:self];

    __weak __typeof(self) weakSelf = self;

        animateBlock fadeBG = ^(){
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            self->bgView.alpha=0;//0.5;
            self->contentView.alpha=0;
            __weak __typeof(self) weakSelf = self;
            [UIView animateWithDuration:KunitTime delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                __strong __typeof(weakSelf) strongSelf = weakSelf;
                self->bgView.alpha=0.5;//1;
            } completion:^(BOOL finished) {
                __strong __typeof(weakSelf) strongSelf = weakSelf;
                [self removeAni];
            }];
        };

        [_animateArr addObject:fadeBG];
        animateBlock fade = ^(){
            [UIView animateWithDuration:KunitTime delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                __strong __typeof(weakSelf) strongSelf = weakSelf;
                self->contentView.alpha=1;
            } completion:^(BOOL finished) {
                __strong __typeof(weakSelf) strongSelf = weakSelf;
                [self removeAni];

            }];
        };

        [_animateArr addObject:fade];
    [self nextAnimate];
}

  - (void)show{
      self.alpha = 1;
      //videowindow
      [self showInView:[ZYSuspensionManager windowForKey:@"videowindow"]];
 }


@end
