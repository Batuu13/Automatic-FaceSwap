%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%

target = im2double(imread('6t.jpg'));
source = im2double(imread('6s.jpg'));
%%



%target = imadjust(target,[],[],0.2); 

tic;
coor_Mouth = FindCoordinates(target,'Mouth');
toc;
tic;
coor_Eye = FindCoordinates(target,'EyePairBig');
toc;
tic;
toc;
x1 = coor_Eye(1); % sol g�z
x2 = coor_Eye(1)+coor_Eye(3); % sa� g�z
x3 = coor_Mouth(1)+coor_Mouth(3); % a��z solu
x4 = coor_Mouth(1); % a��z sa��
y1 = coor_Eye(2); 
y2 = coor_Eye(2);
y3 = coor_Mouth(2) + coor_Mouth(4);
y4 = coor_Mouth(2) + coor_Mouth(4);

centerX = round((x1 + x2 + x3 + x4) / 4);
centerY = round((y1 + y2 + y3 + y4) / 4);

tic;
width = x2-x1;
height = y4-y1;
[ImA,maskA3,centX,centY,cornerX,cornerY] = getMask(source,width,height,centerX,centerY,size(target));
ImA = imresize(ImA,[size(target,1) size(target,2)]);
maskA3 = imresize(maskA3,[size(target,1) size(target,2)]);




shiftx=int32(centerX-centX);
shifty=int32(centerY-centY);
shiftedIm=circshift(ImA,[shifty,shiftx]);
shiftedMask=circshift(maskA3,[shifty,shiftx]);
%%


toc;

result = shiftedIm.*shiftedMask + target.*(1-shiftedMask);

%%




% burada gradientleri al�rken sorun oluyor source resmi elimizdeki resimle
% ayn� oranda de�il. boyutlar� ayn� ama bizim elimizdeki surat daha b�y�k.
% �yle olunca surattan daha b�y�k yerleri al�yor. ��z�m i�in resmi surat
% fark�nda b�y�tt�kten kaydetmek laz�m.
[Lh, Lv] = imgrad(target);
[Gh, Gv] = imgrad(ImA);


X = result;
Fh = Lh;
Fv = Lv;


w = width;
h = height;
LX = int32(x1);
LY = int32(y1);
isfind = 0;
for i=1:size(ImA,1)
    for j=1:size(ImA,2)
        if(maskA3(i,j,1) == 1)
            GX = j;
            GY = i;
            isfind = 1;
            break
        end
    end
    if (isfind == 1)
    break
    end
end



% sorun burada +50 falan denemek i�in.
x = [x1 x2 x3 x4 x1];
y = [y1 y2 y3 y4 y1];
bw = poly2mask(x,y,size(target,1),size(target,2));
targetMask=repmat(bw,[1,1,3]);


Fh(LY:LY+h,LX:LX+w,:) = Gh(GY:GY+h,GX:GX+w,:);
Fv(LY:LY+h,LX:LX+w,:) = Gv(GY:GY+h,GX:GX+w,:);

imwrite(X,'X.png');

tic;
Y = PoissonJacobi(X, Fh, Fv, shiftedMask );
toc
figure,
imshow(Y);
    
imwrite(Y,'jacobi2y.png');
tic;
Y = PoissonGaussSeidel( X, Fh, Fv, shiftedMask );
toc
imwrite(Y,'gauss2y.png');
