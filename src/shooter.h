//
//  shooter.h
//  snoodyCandyPhotoSaga
//
//  Created by Clay Ewing on 1/24/14.
//
//

#include "ofMain.h"
#include "bullet.h"
#define RED_TYPE    0
#define GREEN_TYPE  1
#define BLUE_TYPE   2

class Shooter {
    
public:
	
	void display();
    void create(float x, float y, int w, int h);
    void shoot();
    void move(float x, float y);
    void reload();
    
    ofColor color;
    ofPoint position;
    ofImage candyImages[3];
    ofImage staff;
    int bullet_width;
    float bulletBeingShot;
    vector<Bullet> bullets;
    vector<ofPoint> crates;
    
};
