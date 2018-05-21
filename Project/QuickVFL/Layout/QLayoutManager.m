//
//  QLayoutManager.m
//  LibSourceUser
//
//  Created by 苏第 on 17/11/5.
//  Copyright © 2017年 Su Di. All rights reserved.
//

#import "QLayoutManager.h"
#import "QLayoutResult.h"
#import "UIView+constraint.h"
#import "UIScrollView+constraint.h"
#import "QParseException.h"
#import "QViewProperty.h"
#import "QStayShapedOption.h"
#import "QEqualOption.h"
#import "QAlignOption.h"
#import "QLayoutException.h"
#import "QAutoConfig.h"
#import "QVFLParseResult.h"

#import <objc/runtime.h>

#define GLOBAL_CONFIG_KEY   @":global"

@interface QLayoutManager()
@property (nonatomic, assign) QLayoutMode layoutMode;
@property (nonatomic, strong, readonly) NSDictionary* systemGlobalConfig;
@end

@implementation QLayoutManager
#pragma mark - private methods
+(QLayoutManager*)sharedManager{
    static dispatch_once_t onceToken;
    static QLayoutManager* sharedManager;
    dispatch_once(&onceToken, ^{
        sharedManager = [[QLayoutManager alloc] init];
    });
    
    return sharedManager;
}

-(id)init{
    self = [super init];
    if (self) {
        // set verbose mode as default
        self.layoutMode = QLayoutModeVerbose;
        _systemGlobalConfig = [[NSDictionary alloc] init];
    }
    
    return self;
}

+(void)setupSystemGlobalConfig:(NSDictionary*)config{
    if(config == nil || ![config isKindOfClass:NSDictionary.class]){
        [QParseException throwExceptionForReason:@"Config must be a dictionary."];
        return;
    }
    
    NSDictionary* result = [[self sharedManager] applyGlogalConfigForDict:config changed:nil config:config];
    [self sharedManager]->_systemGlobalConfig = [result copy];
}

-(NSDictionary*)mergeGlobalConfig:(NSDictionary*)config{
    NSDictionary* result;
    if(config == nil || config.count == 0){
        result = [self.systemGlobalConfig copy];
    } else {
        NSMutableDictionary* shadow = [self.systemGlobalConfig mutableCopy];
        [shadow addEntriesFromDictionary:config];
        
        result = [self applyGlogalConfigForDict:shadow changed:nil config:shadow];
    }
    
    return result;
}

+(NSDictionary*)fetchIvarInformationForClass:(Class)targetClass{
    NSMutableDictionary* result = [[NSMutableDictionary alloc] init];
    
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList(targetClass, &count);
    NSCharacterSet* replaceSet = [NSCharacterSet characterSetWithCharactersInString:@"@\""];
    
    NSString *key, *type;
    Ivar ivar;
    for (int i = 0; i<count; i++) {
        // 取出成员变量
        ivar = *(ivars + i);
        key = [NSString stringWithUTF8String:ivar_getName(ivar)];
        type = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
        type = [type stringByTrimmingCharactersInSet:replaceSet];
        [result setValue:type forKey:key];
    }
    
    free(ivars);
    
    return result;
}

-(QViewProperty*)parseLayoutContent:(NSString*)content{
    NSError* error;
    NSString* trimedText = [content stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:[trimedText dataUsingEncoding:NSUTF8StringEncoding]
                                                         options:0
                                                           error:&error];
    if(error){
        [QParseException throwExceptionForReason:@"Failed while parsing layout file: %@", error];
        return nil;
    }
    
    if(![dict isKindOfClass:[NSDictionary class]]){
        [QParseException throwExceptionForReason:@"Top of the layout file must be a dictionary."];
        return nil;
    }
    
    NSDictionary* config = [dict objectForKey:GLOBAL_CONFIG_KEY];
    if(config != nil){
        if(![config isKindOfClass:NSDictionary.class]){
            [QParseException throwExceptionForReason:@"Global configuration must be defined as a dictionary."];
            return nil;
        }
        
        NSMutableDictionary* shadow = [dict mutableCopy];
        [shadow removeObjectForKey:GLOBAL_CONFIG_KEY];
        dict = [shadow copy];
    }
    
    config = [self mergeGlobalConfig:config];
    if(config != nil && config.count > 0){
        dict = [self applyGlogalConfigForDict:dict
                                      changed:nil
                                       config:config];
    }
    
    return [self parseViewPropertyForLayout:dict];
}

+(Class)parseClassName:(NSString*)className{
    Class targetClass = NSClassFromString(className);
    if(targetClass == nil){
        [QParseException throwExceptionForReason:@"Unknown Class: %@.", className];
        return nil;
    }
    
    return targetClass;
}

-(NSDictionary*)applyGlogalConfigForDict:(NSDictionary*)dict
                                 changed:(BOOL*)changed
                                  config:(NSDictionary*)config{
    
    if(dict == nil || ![dict isKindOfClass:NSDictionary.class]){
        [QParseException throwExceptionForReason:@"Failed while applying global config: entry must be an dictionary"];
        return nil;
    }
    
    NSMutableArray* configKeys = [[NSMutableArray alloc] init];
    for (NSString* key in dict.allKeys) {
        if([key hasPrefix:@"+"]) {
            [configKeys addObject:key];
        }
    }
    
    // applying top config for key
    NSMutableDictionary* targetDict = nil;
    if(configKeys.count > 0){
        // sorting config
        if(configKeys.count > 1){
            [configKeys sortUsingComparator:^NSComparisonResult(NSString* obj1, NSString* obj2) {
                return [obj1 compare:obj2];
            }];
        }
        
        NSMutableDictionary* dictNewBorn = [dict mutableCopy];
        
        NSString* configReplaceValue = nil;
        
        for (NSString* plusKey in configKeys) {
            // pop value in target dict
            configReplaceValue = [dictNewBorn objectForKey:plusKey];
            [dictNewBorn removeObjectForKey:plusKey];
            // generate key to config
            NSString* dePlusKey = [plusKey substringFromIndex:1];
            
            if(configReplaceValue.length > 0){
                // expect replacing with value
                [dictNewBorn setObject:[config objectForKey:configReplaceValue] forKey:dePlusKey];
            } else{
                // expect merging
                id configValue = [config objectForKey:dePlusKey];
                
                if(![configValue isKindOfClass:NSDictionary.class]){
                    [QParseException throwExceptionForReason:@"Failed while applying global config: entry must be an dictionary"];
                    return nil;
                }
                
                NSMutableDictionary* configValueNewBorn = [configValue mutableCopy];
                [configValueNewBorn addEntriesFromDictionary:dictNewBorn];
                dictNewBorn = configValueNewBorn;
            }
        }
        
        targetDict = dictNewBorn;
        if(changed != nil){
            *changed = YES;
        }
    } else {
        targetDict = [dict mutableCopy];
    }
    
    
    // applying subitems...
    NSArray* allKeys = [[targetDict allKeys] copy];
    id subitemValue;
    BOOL outputChanged;
    NSDictionary* outputValue;
    for (NSString* key in allKeys) {
        subitemValue = [targetDict objectForKey:key];
        if([subitemValue isKindOfClass:NSDictionary.class]){
            outputChanged = NO;
            outputValue = [self applyGlogalConfigForDict:subitemValue
                                                 changed:&outputChanged
                                                  config:config];
            
            if(outputChanged){
                [targetDict setObject:outputValue forKey:key];
                
                if(changed != nil){
                    *changed = YES;
                }
            }
        }
    }
    
    return [targetDict copy];
}

-(QViewProperty*)parseViewPropertyForLayout:(NSDictionary*)layout{
    NSMutableArray* subViewKeys = [NSMutableArray arrayWithArray:layout.allKeys];
    NSMutableArray* optionKeys = [[NSMutableArray alloc] init];
    
    for (NSString* key in layout.allKeys) {
        if ([key hasPrefix:@":"]) {
            [subViewKeys removeObject:key];
            [optionKeys addObject:key];
        }
    }
    
    QViewProperty* property = [[QViewProperty alloc] init];
    
    // handle subviews
    if(subViewKeys.count > 0){
        NSMutableArray* subviewsProperty = [[NSMutableArray alloc] init];
        
        Class stringClass = [NSString class];
        Class dictClass = [NSDictionary class];
        id value;
        for (NSString* viewName in subViewKeys) {
            value = [layout objectForKey:viewName];
            if([value isKindOfClass:stringClass]){
                Class targetClass = [QLayoutManager parseClassName:value];
                [subviewsProperty addObject:[QViewProperty propertyWithViewName:viewName class:targetClass]];
            } else if([value isKindOfClass:dictClass]){
                QViewProperty* nestedProperty = [self parseViewPropertyForLayout:value];
                nestedProperty.name = viewName;
                [subviewsProperty addObject:nestedProperty];
            }
        }
        
        [subviewsProperty sortUsingComparator:^NSComparisonResult(QViewProperty*  obj1, QViewProperty*  obj2) {
            if(obj1.zIndex > obj2.zIndex){
                return NSOrderedDescending;
            } else {
                return NSOrderedSame;
            }
        }];
        
        property.subviewsProperty = subviewsProperty;
    }
    
    // handle options
    for (NSString* key in optionKeys) {
        id optionValue = [layout objectForKey:key];
        [property parseOptionKey:key value:optionValue];
    }
    
    // any default view is UIView
    if(property.viewClass == nil){
        property.viewClass = [UIView class];
    }
    
    if(!property.isViewContainer && property.isScrollEnabled){
        [QParseException throwExceptionForReason:@"Scroll option is for view container only."];
        return nil;
    }
    
    return property;
}

-(UIScrollView*)handleScrollOption:(QOrientationOption)option withEntrance:(UIView*)entrance{
    UIScrollView* scrollView = QVIEW(entrance, UIScrollView);
    [entrance q_addConstraintsByText:@"H:|[scrollView]|; V:|[scrollView]|;"
                       involvedViews:NSDictionaryOfVariableBindings(scrollView)];
    switch (option) {
        case QOrientationHorizontal:
            [scrollView q_prepareContentViewForOrientation:QScrollOrientationHorizontal];
            break;
        case QOrientationVertical:
            [scrollView q_prepareContentViewForOrientation:QScrollOrientationVertical];
            break;
        default:
            [QParseException throwExceptionWithUserInfo:@{@"entrance": entrance}
                                                 reason:@"Bad scroll option for entrance" ];
            break;
    }
    
    return scrollView;
}

-(void)creatingViewsForLayout:(QViewProperty*)propertyTree
                     entrance:(UIView*)entrance
                    madeViews:(NSMutableDictionary*)views{
    UIView* realEntrance = entrance;
    
    // handling scroll view
    if(propertyTree.isScrollEnabled){
        UIScrollView* scrollView = [self handleScrollOption:propertyTree.scrollOrientation withEntrance:entrance];
        propertyTree.scrollViewShadow = scrollView;
        [views setObject:scrollView forKey:propertyTree.scrollViewName];
        realEntrance = scrollView.q_contentView;
    }
    
    UIView* madeView;
    for (QViewProperty* property in propertyTree.subviewsProperty) {
        madeView = QVIEW(realEntrance, property.viewClass);
        
        [views setObject:madeView forKey:property.name];
        if(property.isViewContainer){
            [self creatingViewsForLayout:property entrance:madeView madeViews:views];
        }
    }
}

-(void)setupViewsForLayout:(QViewProperty*)propertyTree
                  entrance:(UIView*)entrance
                 madeViews:(NSMutableDictionary*)views
                    holder:(id)holder{
    UIView* realEntrance = entrance;
    if(propertyTree.isScrollEnabled){
        UIScrollView* scrollView = (UIScrollView*)propertyTree.scrollViewShadow;
        realEntrance = scrollView.q_contentView;
    }
    
    [realEntrance q_configureWithData:propertyTree.viewData holder:holder];
    
    // subviews
    UIView* madeView;
    for (QViewProperty* property in propertyTree.subviewsProperty) {
        madeView = [views objectForKey:property.name];
        if(property.isViewContainer){
            [self setupViewsForLayout:property entrance:madeView madeViews:views holder:holder];
        } else {
            [madeView q_configureWithData:property.viewData holder:holder];
        }
    }
}

-(void)attachingViewDataForLayout:(QViewProperty*)propertyTree
                        viewsData:(NSMutableDictionary*)data{
    if(propertyTree.viewData != nil){
        [data setObject:propertyTree.viewData forKey:propertyTree.name];
    }
    
    for (QViewProperty* property in propertyTree.subviewsProperty) {
        [self attachingViewDataForLayout:property viewsData:data];
    }
}

-(void)addingConstraintsForLayout:(QViewProperty*)propertyTree
                         entrance:(UIView*)entrance
                        madeViews:(NSDictionary*)views
                 namedConstraints:(NSMutableDictionary*)namedConstraints{
    UIView* realEntrance = entrance;
    
    // handling stay shaped options
    for (QStayShapedOption* stayOption in propertyTree.arrayStayShapeOptions) {
        UILayoutConstraintAxis axis = stayOption.orientation == QOrientationHorizontal ? UILayoutConstraintAxisHorizontal : UILayoutConstraintAxisVertical;
        if(stayOption.isCompressed){
            [realEntrance setContentCompressionResistancePriority:stayOption.priority forAxis:axis];
        } else {
            [realEntrance setContentHuggingPriority:stayOption.priority forAxis:axis];
        }
    }
    
    // handling equal options
    for(QEqualOption* equalOption in propertyTree.arrayEqualOptions) {
        UIView* targetView = nil;
        if([@"super" isEqualToString:equalOption.targetViewName]){
            targetView = realEntrance.superview;
        } else {
            targetView = [views objectForKey:equalOption.targetViewName];
        }
        
        if(targetView == nil){
            [QParseException throwExceptionForReason:@"Can't find target view named %@", equalOption.targetViewName];
            continue;
        }
        
        [QEqualOption equalView:realEntrance
                   forAttrubute:equalOption.firstAttribute
                    toOtherView:targetView
                   forAttrubute:equalOption.secondAttribute
                     multiplier:equalOption.multiplier];
    }
    
    if(propertyTree.isScrollEnabled){
        realEntrance = ((UIScrollView*)propertyTree.scrollViewShadow).q_contentView;
    }
    
    if(propertyTree.VFLText.length > 0){
        QVFLParseResult* result1 = [realEntrance q_addConstraintsByText:propertyTree.VFLText
                               involvedViews:views];
        if(result1.namedConstraints.count > 0){
            if([QLayoutManager layoutMode] < QLayoutModePeaceful){
                for (NSString* name in result1.namedConstraints.allKeys) {
                    if([namedConstraints objectForKey:name] != nil){
                        [QParseException throwExceptionForReason:@"Dunplicated constraint name in VFL: %@", name];
                    }
                }
            }
            
            [namedConstraints addEntriesFromDictionary:result1.namedConstraints];
        }
    }
    
    // handle align option
    if(propertyTree.arrayAlighOptions.count > 0){
        [QAlignOption alignViews:views
                     withOptions:propertyTree.arrayAlighOptions
                    withEntrance:realEntrance];
    }
    
    for (QViewProperty* property in propertyTree.subviewsProperty) {
        [self addingConstraintsForLayout:property
                                entrance:[views objectForKey:property.name]
                               madeViews:views
                        namedConstraints:namedConstraints];
    }
}

-(void)mappingViews:(NSDictionary*)createdViews
        constraints:(NSDictionary*)constraints
          forHolder:(id)holder {
    NSDictionary* ivarInfo = [QLayoutManager fetchIvarInformationForClass:[holder class]];
    
    NSString* name;
    UIView* targetView;
    for (NSString* viewName in createdViews.allKeys) {
        targetView = [createdViews objectForKey:viewName];
        
        name = viewName;
        if([ivarInfo objectForKey:name] == nil){
            name = [NSString stringWithFormat:@"_%@", viewName];
        }
        
        if([ivarInfo objectForKey:name] == nil){
            if(![viewName hasSuffix:@"_"]){
                [QParseException throwExceptionForReason:@"View named %@ is claimed to be mapped. But failed to be done. Have you declared any ivar for it?", viewName];
                continue;
            }
        } else {
            if([holder valueForKey:name]){
                [QLayoutException throwExceptionForReason:@"View named %@ is supposed to be nil before mapping. But now it is not. Quit in case of mis-mapping.", name];
                continue;
            }
            
            Class ivarClass = [QLayoutManager parseClassName:[ivarInfo objectForKey:name]];
            
            if(![[targetView class] isSubclassOfClass:ivarClass]){
                [QLayoutException throwExceptionForReason:@"View named %@ is supposed to be an instance of class or subclass %@. But now it is an instance of %@. Quit in case of mis-mapping.",
                        name, [ivarInfo objectForKey:name], NSStringFromClass([targetView class])];
                continue;
            }
            
            [holder setValue:targetView forKey:name];
        }
    }
    
    
    for (NSString* constraintName in constraints.allKeys){
        name = constraintName;
        if([ivarInfo objectForKey:name] == nil){
            name = [NSString stringWithFormat:@"_%@", constraintName];
        }
        
        if([ivarInfo objectForKey:name] == nil){
            [QParseException throwExceptionForReason:@"Constraint named %@ is claimed to be mapped. But failed to be done. Have you declared any ivar for it?", constraintName];
        } else {
            if([holder valueForKey:name]){
                [QLayoutException throwExceptionForReason:@"Constraint named %@ is supposed to be nil before mapping. But now it is not. Quit in case of mis-mapping.", name];
                continue;
            }
            
            Class ivarClass = [QLayoutManager parseClassName:[ivarInfo objectForKey:name]];
            
            if(![ivarClass isSubclassOfClass:[NSLayoutConstraint class]]){
                [QLayoutException throwExceptionForReason:@"Ivar named %@ is supposed to be an instance of class or subclass NSLayoutConstraint. But now it is an instance of %@. Quit in case of mis-mapping.",
                 name, [ivarInfo objectForKey:name]];
            }
            
            [holder setValue:[constraints objectForKey:constraintName] forKey:name];
        }
        
    }
}

-(QLayoutResult*) _layoutForContent:(NSString*)content
                           entrance:(UIView*)entrance
                             holder:(id)holder{
    
    QLayoutResult* result = [[QLayoutResult alloc] init];
    
    if(entrance == nil){
        [QLayoutException throwExceptionForReason:@"Entrance of layout tree is required."];
        return nil;
    }
    
    if(holder == nil){
        [QLayoutException throwExceptionForReason:@"Holder of the layout tree is required."];
        return nil;
    }
    
    QViewProperty* property = [self parseLayoutContent:content];
    
    NSMutableDictionary* madeViews = [[NSMutableDictionary alloc] init];
    [self creatingViewsForLayout:property
                        entrance:entrance
                       madeViews:madeViews];
    
    NSMutableDictionary* namedConstraints = [[NSMutableDictionary alloc] init];
    [self addingConstraintsForLayout:property
                            entrance:entrance
                           madeViews:madeViews
                    namedConstraints:namedConstraints];
    
    [self setupViewsForLayout:property
                     entrance:entrance
                    madeViews:madeViews
                       holder:holder];
    
    [self mappingViews:madeViews constraints:namedConstraints forHolder:holder];
    
    NSMutableDictionary* viewsData = [[NSMutableDictionary alloc] init];
    [self attachingViewDataForLayout:property viewsData:viewsData];
    
    result.viewsData = viewsData;
    result.createdViews = madeViews;
    result.namedConstraints = namedConstraints;
    
    return result;
}

+(NSString*)contentForFilePath:(NSString*)filePath{
    NSError* error;
    NSString* jsonText = [NSString stringWithContentsOfFile:filePath
                                                   encoding:NSUTF8StringEncoding
                                                      error:&error];
    if(error){
        [QParseException throwExceptionForReason:@"Failed while reading layout file: %@", error];
        return nil;
    }
    
    return jsonText;
}

#pragma mark - public methods
+(QLayoutResult*) layoutForContent:(NSString*)content
                          entrance:(UIView*)entrance
                            holder:(id)holder{
    QLayoutResult* result = [[self sharedManager] _layoutForContent:content
                                          entrance:entrance
                                            holder:holder];
    
    return result;
}

+(QLayoutResult*) layoutForFilePath:(NSString*)filePath
                            entrance:(UIView*)entrance
                              holder:(id)holder{
    return [self layoutForContent:[self contentForFilePath:filePath]
                         entrance:entrance
                           holder:holder];
}

+(QLayoutResult*) layoutForFileName:(NSString*)fileName
                           entrance:(UIView*)entrance
                             holder:(id)holder{
    NSString* filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
    return [self layoutForFilePath:filePath entrance:entrance holder:holder];
}

+(void)setupLayoutMode:(QLayoutMode)mode{
    [self sharedManager].layoutMode = mode;
}

+(QLayoutMode)layoutMode{
    return [self sharedManager].layoutMode;
}
@end
