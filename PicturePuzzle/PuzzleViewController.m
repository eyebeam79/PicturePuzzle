//
//  PuzzleViewController.m
//  PicturePuzzle
//
//  Created by SDT1 on 2014. 1. 22..
//  Copyright (c) 2014년 T. All rights reserved.
//

#import "PuzzleViewController.h"

#define IMAGE_WIDTH         320
#define IMAGE_HEIGHT        400
#define PIECE_IMAGE_LENGTH  80

#define BASIC_GAME_PIECE_IMAGE_NUM  20
#define HARD_GAME_PIECE_IMAGE_NUM  80

@interface PuzzleViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIImageView *referenceView;
@property (strong, nonatomic) IBOutlet UIButton *startButton;


@end

@implementation PuzzleViewController
{
    int _gameLevel;
    int imageTag;
    int imagePosBasic[BASIC_GAME_PIECE_IMAGE_NUM];
    int imagePosHard[HARD_GAME_PIECE_IMAGE_NUM];
}


- (void) viewWillAppear:(BOOL)animated

{
    [super viewWillAppear:animated];
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    
    _gameLevel = 1;

    pickerController.delegate = self;
    [self presentViewController:pickerController animated:YES completion:nil];
}

- (void) imagePickerController:(UIImagePickerController *)picker
         didFinishPickingImage:(UIImage *)image
                   editingInfo:(NSDictionary *)editingInfo
{

    CGSize newSize = CGSizeMake(320, 400);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.imageView.image = newImage;
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)changeGameLevel:(id)sender
{
    UISegmentedControl *control = (UISegmentedControl *)sender;
    NSInteger selectedIndex = control.selectedSegmentIndex;
    
    switch (selectedIndex)
    {
        case 0:
            _gameLevel = 1;
            for (int i=0; i<BASIC_GAME_PIECE_IMAGE_NUM; i++) {
                imagePosBasic[i] = 0;
            }
            NSLog(@"Select Basic Level");
            break;
            
        case 1:
             _gameLevel = 2;
            for (int i=0; i<HARD_GAME_PIECE_IMAGE_NUM; i++) {
                imagePosHard[i] = 0;
            }
            NSLog(@"Select Hard Level");
            break;
            
        default:
            break;
    }
}


- (IBAction)startGame:(id)sender
{
    
    [self alignImage];
    self.referenceView.image = self.imageView.image;
    
    [self.startButton setEnabled:NO];
  
}

- (void)alignImage
{
    int pieceLength = PIECE_IMAGE_LENGTH/_gameLevel;
    imageTag = 0;
    
    for(int column=0; column<IMAGE_HEIGHT; column+=pieceLength)
    {
        for(int row=0; row<IMAGE_WIDTH; row+=pieceLength)
        {
            CGRect cropRect = CGRectMake(row, column, pieceLength, pieceLength);
            
            CGImageRef cropped_img = CGImageCreateWithImageInRect([self.imageView.image CGImage], cropRect);
            
            UIImage *newImage = [[UIImage alloc]initWithCGImage:cropped_img];
            CGImageRelease(cropped_img);
            imageTag++;
            

            for(;;){
                int currentPosition = arc4random()%((_gameLevel==1) ? BASIC_GAME_PIECE_IMAGE_NUM : HARD_GAME_PIECE_IMAGE_NUM);
                
                if (_gameLevel==1)
                {
                    if (!imagePosBasic[currentPosition])
                    {
                        int iWidthPos, iHeightPos;
                            
                        UIImageView *imageView = [[UIImageView alloc] initWithImage:newImage];
                        imageView.tag = imageTag;
                        iWidthPos = (currentPosition%4) * PIECE_IMAGE_LENGTH;
                        iHeightPos = (currentPosition/4) * PIECE_IMAGE_LENGTH;
                            
                        [imageView setFrame:CGRectMake(iWidthPos, iHeightPos+63,
                                                           PIECE_IMAGE_LENGTH, PIECE_IMAGE_LENGTH)];
                        imagePosBasic[currentPosition] = imageTag;
                        [[self view] addSubview:imageView];
                            
                        break;
                    }
                }
                else
                {
                    if (!imagePosHard[currentPosition])
                    {
                        int iWidthPos, iHeightPos;
                            
                        UIImageView *imageView = [[UIImageView alloc] initWithImage:newImage];
                        imageView.tag = imageTag;
                        iWidthPos = (currentPosition%8) * PIECE_IMAGE_LENGTH/2;
                        iHeightPos = (currentPosition/8) * PIECE_IMAGE_LENGTH/2;
                            
                        [imageView setFrame:CGRectMake(iWidthPos, iHeightPos+63,
                                                           PIECE_IMAGE_LENGTH/2, PIECE_IMAGE_LENGTH/2)];
                        imagePosBasic[currentPosition] = imageTag;
                        [[self view] addSubview:imageView];
                            
                        break;
                    }
                        
                }
            }
            
        } // for-statements (row)
    } // for-statements (column)
    
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
