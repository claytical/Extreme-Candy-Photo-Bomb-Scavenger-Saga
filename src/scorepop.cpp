//
//  scorepop.cpp
//  snoodyCandyPhotoSaga
//
//  Created by Clay Ewing on 1/26/14.
//
//

#include "scorepop.h"

void ScorePop::create(string message, ofPoint pos) {
    color = ofColor(255,255,255);
    text = message;
    position = pos;
    duration = ofGetElapsedTimef() + 1;
    dead = false;
}

void ScorePop::destroy() {
    dead = true;
}
