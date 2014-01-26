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
    void create(int w, int h, int t, ofImage *);
    void shoot(ofPoint pos);
    bool beingShot;
    bool transform;
    bool destroy;
    ofColor color;
    ofPoint position;
    ofImage *image;
    int width;
    int height;
    int type;
    float speed;
    
    
};
