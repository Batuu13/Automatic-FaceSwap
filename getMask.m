function [result,resultMask,centerX,centerY,x1,y1] = getMask( image ,twidth,theigth,centerx,centery,tsize)
I = im2double(image);

%%
% we are reducing image. This will change to being only for serching not for final image. 
% So we will need to adjust coords accordingly.

I = imadjust(I,[],[],0.5);

coor_Mouth = FindCoordinates(I,'Mouth');
coor_EyeR = FindCoordinates(I,'RightEye');
coor_EyeL = FindCoordinates(I,'LeftEye');



%for i = 1:size(coor_Eye,1)
%    rectangle('Position',coor_Eye(i,:),'LineWidth',5,'LineStyle','-','EdgeColor','b');
%end



x1 = coor_EyeL(1);
x2 = coor_EyeR(1)+coor_EyeR(3);
x3 = coor_Mouth(1)+coor_Mouth(3);
x4 = coor_Mouth(1);
y1 = coor_EyeL(2);
y2 = coor_EyeR(2);
y3 = coor_Mouth(2) + coor_Mouth(4);
y4 = coor_Mouth(2) + coor_Mouth(4);

rateX =  twidth / (x2-x1);
rateY = theigth / (y4-y1) ;


centerX = round((x1 + x2 + x3 + x4) / 4);
centerY = round((y1 + y2 + y3 + y4) / 4);


I = imresize(I, [int32(size(I,1) * rateY) int32(size(I,2) * rateX)]);

x = [x1 x2 x3 x4 x1];
y = [y1 y2 y3 y4 y1];
x = x * rateX;
y = y * rateY;
bw = poly2mask(x,y,size(I,1),size(I,2));
maskA3=repmat(bw,[1,1,3]);

figure,
imshow(double(maskA3))
%maskA3 = imresize(maskA3, [int32(size(maskA3,1) * rateX) int32(size(maskA3,2) * rateY)]);

centerX = int32(centerX * rateX);
centerY = int32(centerY * rateY);

x1 = coor_EyeL(1) * rateX ;
x2 = (coor_EyeR(1)+coor_EyeR(3))* rateX;
x3 = (coor_Mouth(1)+coor_Mouth(3))* rateX;
x4 = coor_Mouth(1)* rateX;
y1 = coor_EyeL(2)* rateY;
y2 = coor_EyeR(2)* rateY;
y3 = (coor_Mouth(2) + coor_Mouth(4))* rateY;
y4 = (coor_Mouth(2) + coor_Mouth(4))* rateY;


maskA3 = imdilate(maskA3,ones(2));
%ImA= temp.*I;

figure,
imshow(I);
hold on

plot(x3,y3,'rx');
plot(x4,y4,'rx');
plot(x2,y2,'rx');
plot(x1,y1,'rx');
plot(centerX,centerY,'bo');
hold off
imwrite(I,'uncropped.jpg');
%I = imtranslate(I,[centerX - centerx, centerY - centery],'OutputView','full');
% tsize check its wrong (to divide)
result(:,:,1) = I(centerY - int32(tsize(1)/2):centerY + int32(tsize(1)/2),centerX - int32(tsize(2)/2):centerX + int32(tsize(2)/2),1);
result(:,:,2) = I(centerY - int32(tsize(1)/2):centerY + int32(tsize(1)/2),centerX - int32(tsize(2)/2):centerX + int32(tsize(2)/2),2);
result(:,:,3) = I(centerY - int32(tsize(1)/2):centerY + int32(tsize(1)/2),centerX - int32(tsize(2)/2):centerX + int32(tsize(2)/2),3);
imwrite(result,'cropped.jpg');
resultMask(:,:,1) = maskA3(centerY - int32(tsize(1)/2):centerY + int32(tsize(1)/2),centerX - int32(tsize(2)/2):centerX + int32(tsize(2)/2),1);
resultMask(:,:,2) = maskA3(centerY - int32(tsize(1)/2):centerY + int32(tsize(1)/2),centerX - int32(tsize(2)/2):centerX + int32(tsize(2)/2),2);
resultMask(:,:,3) = maskA3(centerY - int32(tsize(1)/2):centerY + int32(tsize(1)/2),centerX - int32(tsize(2)/2):centerX + int32(tsize(2)/2),3);

figure,
imshow(result);
hold on

plot(x3,y3,'rx');
plot(x4,y4,'rx');
plot(x2,y2,'rx');
plot(x1,y1,'rx');
plot(centerX,centerY,'bo');

diffX = centerX - centerx;
diffY = centerY - centery;


centerX = tsize(2)/2; 
centerY = tsize(1)/2; 

plot(centerX,centerY,'go');
plot(centerX - diffX,centerY - diffY,'wo');
hold off

%plot(x,y,'b','LineWidth',2)
end

