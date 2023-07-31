% (Efficient) Implementation of Laplacian Blob detector 
% -  method: Downsampling the image -

function [ scale_space ] = createLoG_fast( I, n, sigma, k)
    % Creating scale space 
    [h, w] = size(I);
    scale_space = zeros(h,w,n);  
    % Generate the various scales by applying the filter
     tic;
     scale =1;
    for i = 1:n   % levels of processing
        downI = imresize(I, 1/scale);

        hsize = ceil(scale*3)*2+1;    % filter width must be odd number(ref. manual)
        LoGfilter = fspecial('log', hsize, sigma); 
        % scale-normalized Laplacian filter
        LoGfilter = sigma.^2 * LoGfilter;  
        % filter the image 
        filtI = imfilter(downI,LoGfilter,'replicate');
        % keep the squared Laplacian response
        filtI = filtI.^2;  
        up_filtI = imresize(filtI, [h,w], 'bicubuc');
        % Store it at the appropriate level in the scale space 
        scale_space(:, :, i) = up_filtI;
        scale = scale*k;
    end
    disp('(efficient) Scale-space generated.');
    toc;
end
