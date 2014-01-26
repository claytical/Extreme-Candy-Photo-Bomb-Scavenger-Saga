//
//  MainMenuViewController.h
//  snoodyCandyPhotoSaga
//
//  Created by Clay Ewing on 1/25/14.
//
//

#import <UIKit/UIKit.h>
#import "testApp.h"

@interface MainMenuViewController : UIViewController {
    testApp *myApp;
}
- (IBAction)playGame:(id)sender;
- (IBAction)credits:(id)sender;
@end
