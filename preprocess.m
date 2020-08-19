label_color = [2 0 0];

indx_lower = 1;
indx_upper = 54;

batch_name = "pro_sub";

for i = indx_lower:indx_upper
    filename = "pro_sub" + num2str(i) + ".png"; % have to be double quotes
    anno2label(filename, label_color, "label");
end
