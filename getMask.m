function [result,resultMask,centerX,centerY,x1,y1] = getMask( image ,twidth,theigth,centerx,centery,tsize)
I = im2double(image);

%%
% we are reducing image. This will change to being only for serching not for final image. 
% So we will need to adjust coords accordingly.

%I = imadjust(I,[],[],0.5);

coor_Mouth = FindCoordinates(I,'Mouth');
coor_Eye = FindCoordinates(I,'EyePairBig');




%for i = 1:size(coor_Eye,1)
%    rectangle('Position',coor_Eye(i,:),'LineWidth',5,'LineStyle','-','EdgeColor','b');
%end



x1 = coor_Eye(1);
x2 = coor_Eye(1)+coor_Eye(3);
x3 = coor_Mouth(1)+coor_Mouth(3);
x4 = coor_Mouth(1);
y1 = coor_Eye(2);
y2 = coor_Eye(2);
y3 = coor_Mouth(2) + coor_Mouth(4);
y4 = coor_Mouth(2) + coor_Mouth(4);

rateX =  twidth / (x2-x1);
rateY = theigth / (y4-y1) ;


centerX = round((x1 + x2 + x3 + x4) / 4);
centerY = round((y1 + y2 + y3 + y4) / 4);


figure,
imshow(I);
hold on

plot(x3,y3,'rx');
plot(x4,y4,'rx');
plot(x2,y2,'rx');
plot(x1,y1,'rx');
plot(centerX,centerY,'bo');
hold off

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


maskA3 = imdilate(maskA3,ones(2));
%ImA= temp.*I;


imwrite(I,'uncropped.jpg');
%I = imtranslate(I,[centerX - centerx, centerY - centery],'OutputView','full');
% tsize check its wrong (to divide)

fromY = int32(centerY) - int32(tsize(1)/2);
toY = int32(centerY + int32(tsize(1)/2));

fromX = int32(centerX - int32(tsize(2)/2));
toX = int32(centerX + int32(tsize(2)/2));

if fromY < 1
    fromY = 1;
end
if toY > size(I,1)
    toY = size(I,1);
end
if fromX < 1
    fromX = 1;
end
if toX > size(I,2)
    toX = size(I,2);
end
result(:,:,:) = I(fromY:toY,fromX:toX,:);
resultMask(:,:,:) = maskA3(fromY:toY,fromX:toX,:);
%result(:,:,2) = I(int32(centerY) - int32(tsize(1)/2):int32(centerY + int32(tsize(1)/2)),int32(centerX - int32(tsize(2)/2)):int32(centerX + int32(tsize(2)/2),2));
%result(:,:,3) = I(int32(centerY) - int32(tsize(1)/2):int32(centerY + int32(tsize(1)/2)),int32(centerX - int32(tsize(2)/2)):int32(centerX + int32(tsize(2)/2),3));
imwrite(result,'cropped.jpg');

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

