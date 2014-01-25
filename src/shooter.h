//
//  shooter.h
//  snoodyCandyPhotoSaga
//
//  Created by Clay Ewing on 1/24/14.
//
//

#include "ofMain.h"
#include "bullet.h"

class Shooter {
    
public:
	
	void display();
    void create(float x, float y, int w, int h);
    void shoot(float x);
    void reload();
    
    ofColor color;
    ofPoint position;
    int bullet_width;
    int bulletBeingShot;
  //  int height;
    vector<Bullet> bullets;
    
};
