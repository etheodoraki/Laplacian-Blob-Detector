 Aclc;
close all;
clear all;
%% STEP 0: Load input data
% % Get list of the .jpg files in subfolder Data in current folder
srcF         = dir('../Data/*.jpg');
for fileloop = 1 : length(srcF)
    pathI = strcat('../Data/', srcF(fileloop).name);
    srcI  = imread(pathI); 
% convert image to grayscale
    I     = rgb2gray(srcI);
% make double
    I     = im2double(I);
    [h, w] = size(I);
    
% initialize variables    
    n     = 15; %number of levels in scale space
    sigma = 2; %standard deviation of the filter - default is 2( between 1-3)
    k     = 1.19; %sqrt(sqrt(2)) scale multiplier (for overlapping blobs)
%% STEP 1: Generate Laplacian of Gaussian filter &
%  STEP 2: Buid a scale-space 
%          uncomment to use efficient implementation
    scale_space = createLoG_slow(I, n, sigma, k);
    %scale_space = createLoG_fast(I, n, sigma, k);
%% STEP 3: Find the extrema in the scale-space
% Non-Maximum Suppression (NMS):
% Set pixels' values of a maxima pixel to zero, whose values are < the maxima pixel
    nms2D        = [];
    nms3D        = [];
% -> Non-maximum suppression at 2-D slices
%    get the locally max filter response in the 3x3 pixel's neighborhood
    for i = 1:n
        nms2D(:,:,i) = ordfilt2(scale_space(:,:,i),9,ones(3,3));
    end
% -> Non-maximum suppression at 3-D slices
%    get the locally max filter response in the 3x3x3 pixel's neighborhood
   for i = 1:n
        j            = [max(i-1,1) : min(i+1, n)]; 
        nms3D(:,:,i) = (scale_space(:,:,i) == nms2D(:,:,i));  % every location where the max value is the actualy value from that scale
        nms3D(:,:,i) = nms3D(:,:,i) & (nms2D(:,:,i) == max(nms2D(:,:,j),[],3));
   end
%% Threshold
    tH          = 0.008;
    circles     = [];
    for i = 1:n
        radius  = sqrt(2)*sigma*k^(i-1);
        [Y,X]   = ind2sub(size(nms3D),find(nms3D(:,:,i) & (scale_space(:,:,i) > tH)));
        circles = vertcat(circles, [X Y repmat(radius,length(X),1)]);
    end
%% STEP 4: Display the resulting circles 
     figure(fileloop);
     show_all_circles(I, circles(:,1), circles(:,2), circles(:,3), 'r', 0.5);
     hold off;
end