//
//  AddImageViewController.h
//  PhotoAdd
//
//  Created by Азат on 16.02.15.
//  Copyright (c) 2015 Azat Minvaliev. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface AddImageViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    NSMutableArray *attachPhoto;
    NSMutableArray *descriptionPhoto;
}
@end
