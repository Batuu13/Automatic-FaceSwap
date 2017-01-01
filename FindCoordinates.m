function [ BB ] = FindCoordinates( I , type)
FDetect = vision.CascadeObjectDetector(type);
BB = step(FDetect,I);
k = 8;
while size(BB,1) ~= 1
    
    FDetect = vision.CascadeObjectDetector(type,'MergeThreshold',k);
    BB = step(FDetect,I);
    if(size(BB,1) == 0)
        k = int8(k /1.5);
    else 
        k = 2 * k;
    end
    
    
end
return

