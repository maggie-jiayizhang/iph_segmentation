function cmap = color_map()
% Define the colormap used by CamVid dataset.

cmap = [
    000 000 000   % IPH
    153 050 204   % non-IPH
    ];

% Normalize between [0 1].
cmap = cmap ./ 255;
end
