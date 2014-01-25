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
    ofSetColor(color);
    ofRect(position.x, position.y, width, height);
}

void Candy::create(float x, float y, int w, int h, ofColor c) {
    position.set(x, y);
    color = c;
    width = w;
    height = h;
    matched = false;
}

