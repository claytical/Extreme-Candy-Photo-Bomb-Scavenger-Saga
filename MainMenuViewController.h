//
//  MainMenuViewController.h
//  snoodyCandyPhotoSaga
//
//  Created by Clay Ewing on 1/25/14.
//
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>
#import "testApp.h"

@interface MainMenuViewController : UIViewController <GKLeaderboardViewControllerDelegate> {
    testApp *myApp;
}
- (IBAction)playGame:(id)sender;
- (IBAction)showGamecenter:(id)sender;

@end
