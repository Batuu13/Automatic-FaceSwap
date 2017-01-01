
image = im2double(imread('cv_img.jpg'));
I = image;
I = impyramid(I,'reduce');
I = impyramid(I,'reduce');
%%
% we are reducing image. This will change to being only for serching not for final image. 
% So we will need to adjust coords accordingly.

I = imadjust(I,[],[],0.5);

coor_Mouth = FindCoordinates(I,'Mouth');
coor_EyeR = FindCoordinates(I,'RightEye');
coor_EyeL = FindCoordinates(I,'LeftEye');

figure,
h_im = imshow(I);
hold on
%for i = 1:size(coor_Eye,1)
%    rectangle('Position',coor_Eye(i,:),'LineWidth',5,'LineStyle','-','EdgeColor','b');
%end

%plot(coor_Mouth(1)+coor_Mouth(3),coor_Mouth(2) + coor_Mouth(4),'rx');
%plot(coor_Mouth(1),coor_Mouth(2) + coor_Mouth(4),'rx');
%plot(coor_EyeR(1)+coor_EyeR(3),coor_EyeR(2),'rx');
%plot(coor_EyeL(1),coor_EyeL(2),'rx');
title('Face Detection');

x1 = coor_EyeL(1);
x2 = coor_EyeR(1)+coor_EyeR(3);
x3 = coor_Mouth(1)+coor_Mouth(3);
x4 = coor_Mouth(1);
y1 = coor_EyeL(2);
y2 = coor_EyeR(2);
y3 = coor_Mouth(2) + coor_Mouth(4);
y4 = coor_Mouth(2) + coor_Mouth(4);

x = [x1 x2 x3 x4 x1];
y = [y1 y2 y3 y4 y1];
bw = poly2mask(x,y,size(I,1),size(I,2));
maskA3=repmat(bw,[1,1,3]);
temp = imdilate(maskA3,ones(2));
ImA= temp.*I;
figure,
imshow(ImA)
hold on
plot(x,y,'b','LineWidth',2)
hold off