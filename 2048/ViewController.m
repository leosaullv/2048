//
//  ViewController.m
//  2048
//
//  Created by admin on 14/11/25.
//  Copyright (c) 2014年 admin. All rights reserved.
//

#import "ViewController.h"
#import "MoveTag.h"
#define kCount 16
#define cloumns 4
#define margin 10
#define max_title 1024

@interface ViewController ()<UIAlertViewDelegate>{
    float _width;
    float _height;
    UIColor *_defaultColor;
    UIColor *_selectColor;
    NSMutableArray *_allTag;
    MoveTag *_moveTag;
    UIView *_view;
    int _score;
    BOOL _max;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _width = self.view.frame.size.width;
    _height = self.view.frame.size.height;
    _defaultColor = [UIColor colorWithRed:192/255.0 green:179/255.0 blue:162/255.0 alpha:1];
    _selectColor = [UIColor colorWithRed:233/255.0 green:222/255.0 blue:208/255.0 alpha:1];
    _allTag = [NSMutableArray arrayWithObjects:@1,@2,@3,@4,@5,@6,@7,@8,@9,@10,@11,@12,@13,@14,@15,@16, nil];
    _view = [self.view viewWithTag:100];
    _max = NO;
    _moveTag = [[MoveTag alloc] init];
    //初始化view
    [self createView];
    //生成随机数
    [self atStartCreateRandom];
    //添加手势
    [self addGestureForView];
}
-(void)createView{
    float viewH = _view.frame.size.height;
    float viewW = _view.frame.size.width;
    float width = (viewW - margin)/4 - margin;
    float height = (viewH - margin)/4 -margin;
    for (int i = 0; i < kCount; i++) {
        int row = i % cloumns;
        int col = i / cloumns;
        CGFloat x = (viewW - margin )/4 * row + margin;
        CGFloat y = (viewH - margin)/4 * col + margin;
        UIButton *button = [[UIButton alloc] init];
        button.backgroundColor = _defaultColor;
        button.frame = CGRectMake(x, y, width, height);
        button.tag = i + 1;
        [_view addSubview:button];
    }

}
-(void)atStartCreateRandom{
    NSMutableArray *ss = [[NSMutableArray alloc] init];
    ss = [self newSelectTag:ss];
    [_moveTag moveTagInitWithSelectTag:ss];
}

-(void)addGestureForView{
    UISwipeGestureRecognizer *recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [_view addGestureRecognizer:recognizer];
    
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionUp)];
    [_view addGestureRecognizer:recognizer];
    
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
    [_view addGestureRecognizer:recognizer];
    
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [_view addGestureRecognizer:recognizer];
}


-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer {
    NSMutableArray *allSelectTag = [[NSMutableArray alloc] init];
    NSMutableArray *sTags = [[NSMutableArray alloc] initWithArray:_moveTag.selectTag];
    
    for (int i = 1; i <= 4; i++) {
        NSMutableArray *list = [[NSMutableArray alloc] init];
        NSMutableArray *tagList = [[NSMutableArray alloc] init];
        if (recognizer.direction == UISwipeGestureRecognizerDirectionDown){
            for (int j = i; j <= kCount; j = j + 4) {
                [self createStructWithNum:j withStags:sTags withList:list withTaglist:tagList];
            }
        }
        if (recognizer.direction == UISwipeGestureRecognizerDirectionUp){
            for (int j = kCount + 1 -i ; j > 0; j = j - 4) {
                [self createStructWithNum:j withStags:sTags withList:list withTaglist:tagList];
            }
        }
        if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft){
            for (int j = cloumns * i; j > cloumns * (i - 1); j--) {
                [self createStructWithNum:j withStags:sTags withList:list withTaglist:tagList];
            }
        }
        if (recognizer.direction == UISwipeGestureRecognizerDirectionRight){
            for (int j = cloumns*(i -1) + 1; j < cloumns*i + 1; j++) {
                [self createStructWithNum:j withStags:sTags withList:list withTaglist:tagList];
            }
        }
        allSelectTag = [self updateViewWithTagList:tagList andWithSelectTag:allSelectTag andWithList:list];
    }
    if (_max) {
        [self alertMaxConfirmView];
    }else{
        if ( [self randomFlagWithAllSelectTag:allSelectTag] == 0) {
            allSelectTag = [self newSelectTag:allSelectTag];
        }
        [self setCore];
        [_moveTag moveTagInitWithSelectTag:allSelectTag];
    }
}

-(void)setCore{
    UILabel *label = (UILabel *)[self.view viewWithTag:101];
    NSString *str = [[NSString alloc] initWithFormat:@"%i",_score];
    [label setText:str];
}

-(void)alertMaxConfirmView{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"YOU WIN!" message:@"Congratulating for your success!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    alert.frame = CGRectMake(_width/2, _height/2, _width - 60, 60);
    [alert show];
}

- (int)randomFlagWithAllSelectTag:(NSMutableArray *)allSelectTag{
    if (_moveTag.selectTag.count == allSelectTag.count) {
        for (int i = 0; i < allSelectTag.count; i++) {
            if (![_moveTag.selectTag containsObject:[allSelectTag objectAtIndex:i]]) {
                return 0;
            }
        }
        return 1;
    }
    return 0;
}

-(void)createStructWithNum:(int)j withStags:(NSMutableArray *)sTags withList:(NSMutableArray *)list withTaglist:(NSMutableArray *)tagList{
    NSNumber *nub = [[NSNumber alloc] initWithInt:j];
    if ([sTags containsObject:nub]){
        [list addObject:nub];
    }
    [tagList addObject:nub];
}

-(NSMutableArray *)updateViewWithTagList:(NSMutableArray *)tagList andWithSelectTag:(NSMutableArray *)allSelectTag andWithList:(NSMutableArray *)list{
    
    if (list.count > 0) {
        NSMutableArray *titleList = [[NSMutableArray alloc] init];
        titleList = [self addList:list];
        allSelectTag = [self updateButtonWithTitleList:titleList andWithTagList:tagList andAllSelectTag:allSelectTag];
    }
    return allSelectTag;
}


-(NSMutableArray *)newSelectTag:(NSMutableArray *)havaSelectTag{
    
    NSMutableArray *waitTag = [[NSMutableArray alloc] initWithArray:_allTag];
    if (havaSelectTag.count > 0) {
        for (int i = 0; i < havaSelectTag.count; i++) {
            NSNumber *sel = [havaSelectTag objectAtIndex:i];
            [waitTag removeObject:sel];
        }
        int r = arc4random() % [waitTag count];
        NSNumber *num = [waitTag objectAtIndex:r];
        NSString *showNum = [[NSString alloc] initWithFormat:@"%i",(arc4random() % 2 + 1)*2];
        _score += [showNum intValue];
        [self changeRandomButtonWithTag:num withTitle:showNum withColor:_selectColor];
        [havaSelectTag addObject:num];
    }else{
        NSMutableSet *randomSet = [[NSMutableSet alloc] init];
        while ([randomSet count] < 2) {
            int r = arc4random() % [waitTag count];
            [randomSet addObject:[waitTag objectAtIndex:r]];
        }
        NSMutableArray *randomArray = (NSMutableArray *)[randomSet allObjects];
        for (int j = 0; j < randomArray.count; j++) {
            NSNumber *num = [randomArray objectAtIndex:j];
            NSString *showNum = [[NSString alloc] initWithFormat:@"%i",(arc4random() % 2 + 1)*2];
            [self changeRandomButtonWithTag:num withTitle:showNum withColor:_selectColor];
            _score += [showNum intValue];
            [havaSelectTag addObject:num];
        }
    }
    return havaSelectTag;
}

-(void)changeRandomButtonWithTag:(NSNumber *)tag withTitle:(NSString *)title withColor:(UIColor *)color{
    UIButton *butt = (UIButton *)[_view viewWithTag:[tag intValue]];
    [butt setTitle:title forState:UIControlStateNormal];
    [butt setBackgroundColor:color];
}

-(NSMutableArray *) updateButtonWithTitleList:(NSMutableArray *)titleList andWithTagList:(NSMutableArray *)tagList andAllSelectTag:(NSMutableArray *)allSelectTag{
    int cover = tagList.count - titleList.count;
    for (int i = 0; i < titleList.count; i++) {
        NSString *title = [[NSString alloc] init];
        title = [titleList objectAtIndex:i];
        NSNumber *tag = [[NSNumber alloc] init];
        tag = [tagList objectAtIndex:i + cover];
        [self changeRandomButtonWithTag:tag withTitle:title withColor:_selectColor];
        [allSelectTag addObject:tag];
    }
    for (int j = 0; j < cover; j++) {
        NSNumber *outTag = [[NSNumber alloc] init];
        outTag = [tagList objectAtIndex:j];
        [self changeRandomButtonWithTag:outTag withTitle:nil withColor:_defaultColor];
    }
    return allSelectTag;
}

-(NSMutableArray *)addList:(NSMutableArray *)list{
    NSMutableArray *resultList = [[NSMutableArray alloc] init];
    int count = list.count;
    for (int i = count - 1; i >= 0; i--) {
        if (i  > 0) {
            
            NSString *str1 = [self getButtonTitleWithList:list andWithIndex:i];
            NSString *str2 = [self getButtonTitleWithList:list andWithIndex:i -1];
            
            if ([str1 intValue] == [str2 intValue]) {
                int addR = str1.intValue + str2.intValue;
                NSString *strR = [[NSString alloc] initWithFormat:@"%i",addR];
                if (addR == max_title) {
                    _max = YES;
                }
                [resultList insertObject:strR atIndex:0];
                i = i - 1;
            }else{
                [resultList insertObject:str1 atIndex:0];
            }
            
        }else if(i  == 0){
            NSString *str3 = [self getButtonTitleWithList:list andWithIndex:i];
            [resultList insertObject:str3 atIndex:0];
        }
    }
    return resultList;
}

-(NSString *)getButtonTitleWithList:(NSMutableArray *)list andWithIndex:(int)num{
    UIButton *btn = [[UIButton alloc] init];
    btn = (UIButton *)[_view viewWithTag:[[list objectAtIndex:num] intValue]];
    return [btn titleForState:UIControlStateNormal];
}


- (IBAction)reset:(UIButton *)sender {
    [self reloadView];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self reloadView];
    }
}
-(void)reloadView{
    NSArray *views = [_view subviews];
    for (int i = 0; i < views.count; i++) {
        UIButton *butn = [views objectAtIndex:i];
        if ([butn titleForState:UIControlStateNormal] != nil) {
            NSNumber *num = [[NSNumber alloc]initWithInt:butn.tag];
            [self changeRandomButtonWithTag:num withTitle:nil withColor:_defaultColor];
        }
    }
    
    _score = 0;
    [self setCore];
    [self atStartCreateRandom];
}

-(void)saveMaxScore{

    NSString *str = [[NSString alloc] initWithFormat:@"%i",_score];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSLog(@"documentsDirectory%@",documentsDirectory);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *testDirectory = [documentsDirectory stringByAppendingPathComponent:@"cacheMsg"];
    
    [fileManager createDirectoryAtPath:testDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    
    // 在test目录下创建并写入文件
    NSString *testPath = [testDirectory stringByAppendingPathComponent:@"test00.txt"];
    NSString *cacheMsgTmp = str;
    [fileManager createFileAtPath:testPath contents:[cacheMsgTmp  dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
    
    
}

//-(NSString *)getMaxScore{
//    
//    
//}

@end
