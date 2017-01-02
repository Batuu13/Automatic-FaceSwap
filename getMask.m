function [result,resultMask,centerX,centerY,x1,y1] = getMask( image )
I = im2double(image);

%%
% we are reducing image. This will change to being only for serching not for final image. 
% So we will need to adjust coords accordingly.

I = imadjust(I,[],[],0.5);

coor_Mouth = FindCoordinates(I,'Mouth');
coor_EyeR = FindCoordinates(I,'RightEye');
coor_EyeL = FindCoordinates(I,'LeftEye');

%figure,
%h_im = imshow(I);
%hold on
%for i = 1:size(coor_Eye,1)
%    rectangle('Position',coor_Eye(i,:),'LineWidth',5,'LineStyle','-','EdgeColor','b');
%end

%plot(coor_Mouth(1)+coor_Mouth(3),coor_Mouth(2) + coor_Mouth(4),'rx');
%plot(coor_Mouth(1),coor_Mouth(2) + coor_Mouth(4),'rx');
%plot(coor_EyeR(1)+coor_EyeR(3),coor_EyeR(2),'rx');
%plot(coor_EyeL(1),coor_EyeL(2),'rx');


x1 = coor_EyeL(1);
x2 = coor_EyeR(1)+coor_EyeR(3);
x3 = coor_Mouth(1)+coor_Mouth(3);
x4 = coor_Mouth(1);
y1 = coor_EyeL(2);
y2 = coor_EyeR(2);
y3 = coor_Mouth(2) + coor_Mouth(4);
y4 = coor_Mouth(2) + coor_Mouth(4);

centerX = int32((x1 + x2 + x3 + x4) / 4);
centerY = int32((y1 + y2 + y3 + y4) / 4);

x = [x1 x2 x3 x4 x1];
y = [y1 y2 y3 y4 y1];
bw = poly2mask(x,y,size(I,1),size(I,2));
maskA3=repmat(bw,[1,1,3]);
temp = imdilate(maskA3,ones(2));
ImA= temp.*I;

result(:,:,1) = ImA(y1:y4,x1:x2,1);
result(:,:,2) = ImA(y1:y4,x1:x2,2);
result(:,:,3) = ImA(y1:y4,x1:x2,3);

resultMask(:,:,1) = maskA3(y1:y4,x1:x2,1);
resultMask(:,:,2) = maskA3(y1:y4,x1:x2,2);
resultMask(:,:,3) = maskA3(y1:y4,x1:x2,3);



%plot(x,y,'b','LineWidth',2)
end

