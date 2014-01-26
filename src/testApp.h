#pragma once


#include "ofMain.h"
#include "ofxiPhone.h"
#include "ofxiPhoneExtras.h"
#include "ofxOpenALSoundPlayer.h"

#include "candy.h"
#include "shooter.h"
#include "scorepop.h"

//ON IPHONE NOTE INCLUDE THIS BEFORE ANYTHING ELSE
#include "ofxOpenCv.h"

//warning video player doesn't currently work - use live video only
#define _USE_LIVE_VIDEO

class testApp : public ofxiPhoneApp{
	
	public:
		
		void setup();
		void update();
		void draw();
        void exit();
    
        void touchDown(ofTouchEventArgs & touch);
        void touchMoved(ofTouchEventArgs & touch);
        void touchUp(ofTouchEventArgs & touch);
        void touchDoubleTap(ofTouchEventArgs & touch);
        void touchCancelled(ofTouchEventArgs & touch);
	
        void lostFocus();
        void gotFocus();
        void gotMemoryWarning();
        void deviceOrientationChanged(int newOrientation);
    
        void grabImage();
        void randomLevel();
        bool hitTest(Candy candy, Bullet bullet);
    
        static bool matched(Candy &candy);
        static bool done(Bullet &bullet);
        static bool popped(ScorePop &scorepop);
        static bool hanging(Candy &c);
    
        void checkHangers(Candy &c);
        void findMatchingColors(Candy &c);
        //bool removeHangers(Candy &c);
        bool tooManyCandies();
        bool zappedAllCandies();
    
        void play();
        vector<int> getAmmo();
    
        ofVideoGrabber vidGrabber;
        ofxOpenALSoundPlayer wand;
        ofxOpenALSoundPlayer firingWand;
        ofxOpenALSoundPlayer cauldron;
        ofxOpenALSoundPlayer candySounds[7];
        ofxCvColorImage	colorImg;
        ofTrueTypeFont messageText;
        Shooter shooter;
    
        float capW;
        float capH;
        float startTime;
        float endTime;
        int candiesCollected;
        int score;
        int gameState;
        bool bLearnPhoto;
        bool createGrid;
        bool playing;
        ofImage candyImages[3][7];
        ofImage cauldronMask;
        vector <Candy> candies;
        vector<ScorePop> scorePops;
};
