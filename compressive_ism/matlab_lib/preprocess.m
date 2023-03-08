function image = preprocess(image, image_rows, image_cols)
    image_rows = 512;
    image_cols = 512;
    image = imresize(image, [image_rows, image_cols]);
    image = double(im2gray(image));
    image = image./max(max(image)); 
return;