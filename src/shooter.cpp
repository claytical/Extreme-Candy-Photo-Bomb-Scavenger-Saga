//
//  shooter.cpp
//  snoodyCandyPhotoSaga
//
//  Created by Clay Ewing on 1/24/14.
//
//

#include "shooter.h"

void Shooter::display() {
    for (int i = 0; i < bullets.size(); i++) {
        bullets[i].display();
    }
}

void Shooter::create(float x, float y, int w, int h) {
    position.set(x, y);
    width = w;
    height = h;
    for (int i = 0; i < 5; i++) {
        Bullet tmpBullet;
        tmpBullet.create(x, y, width, height, ofColor(255,255,0));
        bullets.push_back(tmpBullet);
    }
}

void Shooter::reload() {
    bullets.clear();
    for (int i = 0; i < 5; i++) {
        Bullet tmpBullet;
        tmpBullet.create(position.x, position.y, width, height, ofColor(255,255,0));
        bullets.push_back(tmpBullet);
    }
    
}

void Shooter::shoot() {
    if (bullets.size() > 0) {
        bullets[0].beingShot = true;
    }
}
