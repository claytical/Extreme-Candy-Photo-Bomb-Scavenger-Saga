#pragma once


#include "ofMain.h"
#include "ofxiPhone.h"
#include "ofxiPhoneExtras.h"
#include "candy.h"
#include "shooter.h"

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
        bool hitTest(Candy candy, Bullet bullet);
        static bool matched(Candy &candy);
        static bool done(Bullet &bullet);
    
    
        void findMatchingColors(Candy &c);
    
        ofVideoGrabber vidGrabber;
        ofxCvColorImage	colorImg;
        Shooter shooter;
    
        float capW;
        float capH;
		int threshold;
		bool bLearnPhoto;
        bool createGrid;
        vector <Candy> candies;
    
};
