//
//  PuzzleViewController.m
//  PicturePuzzle
//
//  Created by SDT1 on 2014. 1. 22..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "PuzzleViewController.h"

@interface PuzzleViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) UIImage *orginalImage;

@end

@implementation PuzzleViewController


- (void) viewWillAppear:(BOOL)animated

{
    [super viewWillAppear:animated];
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    
    pickerController.delegate = self;
    [self presentViewController:pickerController animated:YES completion:nil];
}

- (void) imagePickerController:(UIImagePickerController *)picker
         didFinishPickingImage:(UIImage *)image
                   editingInfo:(NSDictionary *)editingInfo
{
    self.imageView.image = image;
    self.orginalImage = image;
    [self dismissModalViewControllerAnimated:YES];
}


- (IBAction)startGame:(id)sender
{
    
    
    CGRect cropRect = CGRectMake(0, 63, 80, 80);
    CGImageRef cropped_img = CGImageCreateWithImageInRect([self.orginalImage CGImage], cropRect);
    
    UIImage *newImage = [[UIImage alloc]initWithCGImage:cropped_img];
    CGImageRelease(cropped_img);
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:newImage];
    [imageView setFrame:CGRectMake(160, 63, 80, 80)];
    [[self view] addSubview:imageView];


}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
