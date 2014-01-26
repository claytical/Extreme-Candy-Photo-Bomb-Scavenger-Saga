//
//  scorepop.h
//  snoodyCandyPhotoSaga
//
//  Created by Clay Ewing on 1/26/14.
//
//

#include "ofMain.h"

class ScorePop {
    
public:
	
    void create(string message, ofPoint pos);
    void destroy();
    bool dead;
    ofColor color;
    ofPoint position;
    string text;
    float duration;
    
    
};
