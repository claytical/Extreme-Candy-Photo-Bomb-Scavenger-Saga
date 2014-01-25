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
    void shoot();
    void reload();
    
    ofColor color;
    ofPoint position;
    int width;
    int height;
    vector<Bullet> bullets;
    
};
