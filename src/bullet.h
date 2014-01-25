//
//  bullet.h
//  snoodyCandyPhotoSaga
//
//  Created by Clay Ewing on 1/24/14.
//
//


#include "ofMain.h"

class Bullet {
    
public:
	
	void display();
    void create(float x, float y, int w, int h, ofColor c);

    bool beingShot;
    ofColor color;
    ofPoint position;
    int width;
    int height;
    float speed;
    
    
};
