//
//  SelectImageViewController.m
//  Caption
//
//  Created by Nandpal Jethanand on 11/18/14.
//  Copyright (c) 2014 SoftwebSolutions. All rights reserved.
//

#import "SelectImageViewController.h"
#import "YKImageCropperViewController.h"

#define MAX_LENGTH 60
#define isiPhone5  ([[UIScreen mainScreen] bounds].size.height == 568)?TRUE:FALSE
#define DegreesToRadians(angle) ((angle) / 180.0 * M_PI)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface SelectImageViewController ()

@end

@implementation SelectImageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addUIBarButtonItem];
    [self hideAllsubViews:YES];
    [self addtwCaptionProperties];
    [self addUITapGestureRecognizerForHideKeyboard];
}

- (void)addUIBarButtonItem
{
    UIButton *btnGallery =  [UIButton buttonWithType:UIButtonTypeCustom];
    [btnGallery setImage:[UIImage imageNamed:@"Gallery.png"] forState:UIControlStateNormal];
    [btnGallery addTarget:self action:@selector(openPhotoGallery) forControlEvents:UIControlEventTouchUpInside];
    [btnGallery setFrame:CGRectMake(5, 8, 24, 18.5)];

    UIButton *btnCamera =  [UIButton buttonWithType:UIButtonTypeCustom];
    [btnCamera setImage:[UIImage imageNamed:@"Camera.png"] forState:UIControlStateNormal];
    [btnCamera addTarget:self action:@selector(openCamera) forControlEvents:UIControlEventTouchUpInside];
    [btnCamera setFrame:CGRectMake(48, 8, 24, 18.5)];
    
    UIView *rightBarButtonItems = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 76, 32)];
    [rightBarButtonItems addSubview:btnGallery];
    [rightBarButtonItems addSubview:btnCamera];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButtonItems];
}

- (void)hideAllsubViews:(BOOL)isHide
{
    for (UIView* subViews in self.view.subviews)
        [subViews setHidden:isHide];
}


/*
- (void)OpenActionSheet
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose Photo" delegate:self cancelButtonTitle: @"Cancel" destructiveButtonTitle:nil otherButtonTitles: @"Take a new photo", @"Choose from existing", nil];
    UIWindow* window = [[[UIApplication sharedApplication] delegate] window];
    if ([window.subviews containsObject:self.view]) {
        [actionSheet showInView:self.view];
    } else {
        [actionSheet showInView:window];
    }
}
*/

- (void)addtwCaptionProperties
{
    twCaption.contentInset = UIEdgeInsetsMake(-4,0,0,0);
    twCaption.text = @"Add a caption...";
    twCaption.textColor = [UIColor whiteColor]; //optional
    twCaption.backgroundColor = [UIColor blackColor];
    twCaption.Alpha = 0.5f;
}

- (void)addUITapGestureRecognizerForHideKeyboard
{
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:gestureRecognizer];
    gestureRecognizer.cancelsTouchesInView = NO;  // this prevents the gesture recognizers to 'block' touches
}

- (void)hideKeyboard
{
    [twCaption resignFirstResponder];
}

/*
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch(buttonIndex)
    {
        case 0:
        {
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Device has no camera" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                return;
            }
            [self openCamera];
        }
            break;
        case 1:
        {
            [self openPhotoGallery];
        }
        default:
            break;
    }
}
*/

- (void)openCamera
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Device has no camera" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)openPhotoGallery
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self hideAllsubViews:NO];
    ProfileImage = info[UIImagePickerControllerEditedImage];
    ProfileImage = [self scaleToSize:CGSizeMake(ivBackGround.frame.size.width, ivBackGround.frame.size.height) imageToResize:ProfileImage];
    [ivBackGround setImage:ProfileImage];
    twCaption.frame = CGRectMake(ivBackGround.frame.origin.x, ivBackGround.frame.origin.y+ivBackGround.frame.size.height-twCaption.frame.size.height, ivBackGround.frame.size.width, twCaption.frame.size.height);
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

-(UIImage *) scaleToSize: (CGSize)size imageToResize:(UIImage *)imageToResize
{
    // Scalling selected image to targeted size
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, size.width, size.height, 8, 0, colorSpace,(CGBitmapInfo)kCGImageAlphaPremultipliedLast);
    CGContextClearRect(context, CGRectMake(0, 0, size.width, size.height));
    
    if(imageToResize.imageOrientation == UIImageOrientationRight)
    {
        CGContextRotateCTM(context, -M_PI_2);
        CGContextTranslateCTM(context, -size.height, 0.0f);
        CGContextDrawImage(context, CGRectMake(0, 0, size.height, size.width), imageToResize.CGImage);
    } else if (imageToResize.imageOrientation == UIImageOrientationLeft) {
        CGContextRotateCTM(context, M_PI_2);
        CGContextTranslateCTM(context, 0.0f, -size.width);
        CGContextDrawImage(context, CGRectMake(0, 0, size.height, size.width), imageToResize.CGImage);
    } else if (imageToResize.imageOrientation == UIImageOrientationDown) {
        CGContextRotateCTM(context, M_PI);
        CGContextTranslateCTM(context, -size.width, -size.height);
        CGContextDrawImage(context, CGRectMake(0, 0, size.width, size.height), imageToResize.CGImage);
    } else {
        CGContextDrawImage(context, CGRectMake(0, 0, size.width, size.height), imageToResize.CGImage);
    }
    
    CGImageRef scaledImage=CGBitmapContextCreateImage(context);
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    UIImage *image = [UIImage imageWithCGImage: scaledImage];
    CGImageRelease(scaledImage);
    return image;
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


-(IBAction) btnCropProfilePressed:(id)sender
{
    YKImageCropperViewController *vc = [[YKImageCropperViewController alloc] initWithImage:ProfileImage];
    vc.cancelHandler = ^() {
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    vc.doneHandler = ^(UIImage *editedImage) {
        ProfileImage = editedImage;
        ProfileImage = [self scaleToSize:CGSizeMake(ivBackGround.frame.size.width, ivBackGround.frame.size.height) imageToResize:ProfileImage];
        [ivBackGround setImage:ProfileImage];
        twCaption.frame = CGRectMake(ivBackGround.frame.origin.x, ivBackGround.frame.origin.y+ivBackGround.frame.size.height-twCaption.frame.size.height, ivBackGround.frame.size.width, twCaption.frame.size.height);
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

-(IBAction) btnRoateLeftPressed:(id)sender
{
    self.rotationAngle -= 90.0;
    ivBackGround.image = [self imageRotatedByDegrees:self.rotationAngle ImageToRoate:ProfileImage];
}

-(IBAction) btnRoateRightPressed:(id)sender
{
    self.rotationAngle += 90.0;
    ivBackGround.image = [self imageRotatedByDegrees:self.rotationAngle ImageToRoate:ProfileImage];
}

- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees ImageToRoate:(UIImage *)imageToRotate
{
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,imageToRotate.size.width, imageToRotate.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(DegreesToRadians(degrees));
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    //   // Rotate the image context
    CGContextRotateCTM(bitmap, DegreesToRadians(degrees));
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-imageToRotate.size.width / 2, -imageToRotate.size.height / 2, imageToRotate.size.width, imageToRotate.size.height), [imageToRotate CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(IBAction) btnShareProfilePressed:(id)sender
{
    UIImage *imageShare = [self captureView];
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:@[imageShare] applicationActivities:nil];
    /*if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")){
        controller.popoverPresentationController.sourceView = self.view;
    }*/
    [self presentViewController:controller animated:YES completion:nil];
}

- (UIImage *)captureView
{
    CGRect rect = [vwBackGround bounds];
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [vwBackGround.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [UIScrollView beginAnimations:@"KeyboardMoveAnimation" context:nil];
    [UIScrollView setAnimationDuration:0.3];
    if (isiPhone5)
        [scrBackGround setContentOffset:CGPointMake(0,50)];
    else
        [scrBackGround setContentOffset:CGPointMake(0,140)];
    [UIScrollView commitAnimations];
    if ([textView.text isEqualToString:@"Add a caption..."]) {
        textView.text = @"";
        textView.textColor = [UIColor whiteColor]; //optional
    }
    [textView becomeFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSUInteger newLength = (textView.text.length - range.length) + text.length;
    if(newLength <= MAX_LENGTH)
    {
        return YES;
    } else {
        NSUInteger emptySpace = MAX_LENGTH - (textView.text.length - range.length);
        textView.text = [[[textView.text substringToIndex:range.location]
                          stringByAppendingString:[text substringToIndex:emptySpace]]
                         stringByAppendingString:[textView.text substringFromIndex:(range.location + range.length)]];
        return NO;
    }
}

/*
- (void)textViewDidChange:(UITextView *)textView
{
    CGFloat fixedWidth = textView.frame.size.width;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = textView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    textView.frame = newFrame;
}
*/

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [UIScrollView beginAnimations:@"KeyboardMoveAnimation" context:nil];
    [UIScrollView setAnimationDuration:0.3];
    [scrBackGround setContentOffset:CGPointMake(0,0)];
    [UIScrollView commitAnimations];

    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Add a caption...";
        textView.textColor = [UIColor whiteColor]; //optional
    }
    [textView resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
