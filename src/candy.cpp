//
//  candy.cpp
//  snoodyCandyPhotoSaga
//
//  Created by Clay Ewing on 1/24/14.
//
//



#include "candy.h"

void Candy::display() {
    ofFill();
//    ofSetColor(color);
    ofSetColor(255, 255, 255);
    image->draw(position, width, height);
   // ofRect(position.x, position.y, width, height);
}

void Candy::create(float x, float y, int w, int h, int t, int st, ofImage * img) {
    image = img;
    type = t;
    subtype = st;
    position.set(x, y);
    width = w;
    height = h;
    matched = false;
}

