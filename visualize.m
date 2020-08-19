function visualize(idx, net, imdsTest, cmap, classes, pxdsTest)
% Visualize the final result with test_image_idx
    I = readimage(imdsTest, idx);
    C = semanticseg(I, net);

    B = labeloverlay(I,C,'Colormap',cmap,'Transparency',0.6);

    expectedResult = readimage(pxdsTest, idx);
    actual = uint8(C);
    expected = uint8(expectedResult);

    figure
    title(['Visualization of final result with test_image', idx])
    subplot(1,3,1);imshow(I);
    title('Raw img');
    subplot(1,3,2);imshow(B);
    label_colorbar(cmap, classes);
    title('Prediction');
    subplot(1,3,3);imshowpair(actual, expected);
    title('Comparison');
end
