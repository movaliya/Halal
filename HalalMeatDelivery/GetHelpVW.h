//
//  GetHelpVW.h
//  HalalMeatDelivery
//
//  Created by Mango Lab on 20/08/18.
//  Copyright © 2018 kaushik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HalalMeatDelivery.pch"
#import "ProductDetailCell.h"

@interface GetHelpVW : UIViewController
{
      NSMutableDictionary *FAQArryDic;
    NSMutableArray *QuestionArr,*AnswerArr;
    
}
@property (weak, nonatomic) IBOutlet UITableView *TableVW;

@end
