function labelIDs = pixel_label_ids()
% Return the label IDs corresponding to each class.
% There are only 2 classes: IPH vs. Non-IPH.
% For this project, I've chosen IPH to be [0 0 0] (corresponding to the label color)
% and non-IPH to be [153 50 204] (no particular reason)

labelIDs = { ...

    % "IPH"
    [
    000 000 000; ... % "IPH"
    ]

    % "Non-IPH"
    [
    153 050 204; ... % "Non-IPH"
    ]

    };
end
