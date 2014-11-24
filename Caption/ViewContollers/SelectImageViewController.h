//
//  SelectImageViewController.h
//  Caption
//
//  Created by Nandpal Jethanand on 11/18/14.
//  Copyright (c) 2014 SoftwebSolutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectImageViewController : UIViewController <UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,UIScrollViewDelegate,UIDocumentInteractionControllerDelegate>
{
    __weak IBOutlet UIScrollView *scrBackGround;
    __weak IBOutlet UIView *vwBackGround;
    __weak IBOutlet UIImageView *ivBackGround;
    __weak IBOutlet UITextView *twCaption;
    UIImage *ProfileImage;
}

@property (nonatomic, assign) int rotationAngle;
@property(nonatomic,strong) UIDocumentInteractionController *documentInteractionController;

-(IBAction) btnCropProfilePressed:(id)sender;
-(IBAction) btnRoateLeftPressed:(id)sender;
-(IBAction) btnRoateRightPressed:(id)sender;
-(IBAction) btnShareProfilePressed:(id)sender;

@end
