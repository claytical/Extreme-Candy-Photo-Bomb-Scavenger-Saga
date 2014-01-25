//
//  bullet.cpp
//  snoodyCandyPhotoSaga
//
//  Created by Clay Ewing on 1/24/14.
//
//

#include "bullet.h"

void Bullet::display() {
    ofSetColor(color);
    ofRect(position.x, position.y, width, height);
    if (beingShot) {
        position.y-=speed;
    }
}

void Bullet::create(float x, float y, int w, int h, ofColor c) {
    speed = 3;
    transform = false;
    destroy = false;
    position.set(x, y);
    color = c;
    width = w;
    height = h;
}
