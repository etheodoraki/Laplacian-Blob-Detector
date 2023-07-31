% (Inefficient) Implementation of Laplacian Blob detector 
% -  method: Increasing kernel size -

function [ scale_space ] = createLoG_slow( I, n, sigma, k)
    % Creating scale space 
    [h, w] = size(I);
    scale_space = zeros(h,w,n);  
    % Generate the various scales by applying the filter
     tic;
    for scale = 1:n   % levels of processing
        % Calculate sigma multiplied with k for each scale space
        newSigma = sigma * k^(scale-1);
        hsize = ceil(newSigma*3)*2+1;    % filter width must be odd number(ref. manual)
        LoGfilter = fspecial('log', hsize, newSigma); 
        % scale-normalized Laplacian filter
        LoGfilter = newSigma.^2 * LoGfilter;  
        % filter the image 
        filtI = imfilter(I,LoGfilter,'replicate');
        % keep the squared Laplacian response
        filtI = filtI.^2;  
        % Store it at the appropriate level in the scale space 
        scale_space(:, :, scale) = filtI;
    end
    disp('(inefficient) Scale-space generated.');
    toc;
end
