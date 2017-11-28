%Inclass 14
%Walter Frank Lenoir
%GB comments
1 100 
2a 100 
2b 100

%Work with the image stemcells_dapi.tif in this folder
reader1 = bfGetReader('stemcells_dapi.tif');
iplane = reader1.getIndex(1-1,1-1,1-1)+1;
img = bfGetPlane(reader1,iplane);
% (1) Make a binary mask by thresholding as best you can
imshow(img,[])
mask = img > 350;
imshow(mask,[])

% (2) Try to separate touching objects using watershed. Use two different
% ways to define the basins. (A) With erosion of the mask (B) with a
% distance transform. Which works better in this case?
%a) 
CC = bwconncomp(mask);
stats = regionprops(CC,'Area');
area = [stats.Area];

s = round(1.2*sqrt(mean(area))/pi);
erodemask = imerode(mask,strel('disk',s));
outside = ~imdilate(mask,strel('disk',1));
basin = imcomplement(bwdist(outside));
basin = imimposemin(basin,erodemask|outside);
L = watershed(basin);
imshow(L, [])

%b) 
D = bwdist(~mask);
imshow(D,[])
D = -D;
D(~mask) = -Inf;
L2 = watershed(D);
imshow(L2,[])

%The erode method got rid of a few cells, however its the better method for
%seperating objects with this image. The distance transformation worked
%well, however caused too many breaks in the final product (some cells were
%unnecessarily divided).
