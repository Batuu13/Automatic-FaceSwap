%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%

target = im2double(imread('a.jpg'));
source = im2double(imread('b.jpg'));
%%



%target = imadjust(target,[],[],0.5); daha iyi face bulma için

tic;
coor_Mouth = FindCoordinates(target,'Mouth');
toc;
tic;
coor_EyeR = FindCoordinates(target,'RightEye');
toc;
tic;
coor_EyeL = FindCoordinates(target,'LeftEye');
toc;
x1 = coor_EyeL(1); % sol göz
x2 = coor_EyeR(1)+coor_EyeR(3); % sağ göz
x3 = coor_Mouth(1)+coor_Mouth(3); % ağız solu
x4 = coor_Mouth(1); % ağız sağı
y1 = coor_EyeL(2); 
y2 = coor_EyeR(2);
y3 = coor_Mouth(2) + coor_Mouth(4);
y4 = coor_Mouth(2) + coor_Mouth(4);
tic;
[ImA,maskA3,centX,centY,cornerX,cornerY] = getMask(source);
figure,
imshow(ImA);
ImA = imresize(ImA,[x2-x1 y4-y1]);
maskA3 = imresize(maskA3,[x2-x1 y4-y1]);
realMask = zeros(size(target));
realImage = zeros(size(target));
%% burada gelen maske ve kesilmiş resmi crop ediyoruz, kesildiği yer ile aynı boyutta oluyorda yanları siyah oluyordu
% ama büyütme için sadece resim olan yerin elimizde olması lazım.
for j=1:(x2-x1)
    for i=1:y4-y1
        realMask(y1+j-1,x1+i-1,1) = maskA3(j,i,1);
        realMask(y1+j -1,x1+i-1,2) = maskA3(j,i,2);
        realMask(y1+j -1,x1+i-1,3) = maskA3(j,i,3);
        
        realImage(y1+j-1,x1+i-1,1) = ImA(j,i,1);
        realImage(y1+j -1,x1+i-1,2) = ImA(j,i,2);
        realImage(y1+j -1,x1+i-1,3) = ImA(j,i,3);
    end
end
%%


toc;

result = realImage.*realMask + target.*(1-realMask);

%%
rateX = size(target,1) / size(source,1);
rateY = size(target,2) / size(source,2);

source = imresize(source,[size(target,1) size(target,2)]);
figure,
imshow(realImage)
% burada gradientleri alırken sorun oluyor source resmi elimizdeki resimle
% aynı oranda değil. boyutları aynı ama bizim elimizdeki surat daha büyük.
% öyle olunca surattan daha büyük yerleri alıyor. çözüm için resmi surat
% farkında büyüttükten kaydetmek lazım.
[Lh Lv] = imgrad(target);
[Gh Gv] = imgrad(source);


X = result;
Fh = Lh;
Fv = Lv;
cornerX = cornerX *rateX;
cornerY = cornerY *rateY;
centX = centX *rateX;
centY = centY *rateY;

w = int32((cornerX - double(centX)) * -2) * 1/ rateX;
h = int32((cornerY - double(centY)) * -2) * 1/ rateY;
LX = int32(cornerX) - 50;
LY = int32(cornerY);
GX = int32(x1) + 50;
GY = int32(y1) + 10;
% sorun burada +50 falan denemek için.


Fh(LY:LY+h,LX:LX+w,:) = Gh(GY:GY+h,GX:GX+w,:);
Fv(LY:LY+h,LX:LX+w,:) = Gv(GY:GY+h,GX:GX+w,:);
figure,
imshow(Fh);
figure,
imshow(Fv);
imwrite(X,'X.png');

tic;
Y = PoissonJacobi(X, Fh, Fv, realMask );
toc
figure,
imshow(Y);
    
imwrite(Y,'Yjc.png');
tic;
%Y = PoissonGaussSeidel( X, Fh, Fv, realMask );
toc
%imwrite(Y,'Ygs.png');
