function mask = anno2label(img_path, label_val, p)
% turns manual annotated data into a labeling mask and writes it to path p.
    img = imread(img_path);
    [~, name, ext] = fileparts(which(img_path));
    [r, c, ch] = size(img);

    mask = img;
    for i = 1:r
        for j = 1:c
            val = reshape(img(i, j, :), [1 3]);
            if val == label_val
                mask(i, j, :) = [0 0 0];
            else
                mask(i, j, :) = [153 50 204];
            end
        end
    end
    pathname = p + '/' + 'L_' + name + ext;
    imwrite(mask, pathname);
end
