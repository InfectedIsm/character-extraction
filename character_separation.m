clear all;
clc;

%create figure
figure(1);
subplot(2,1,1);

%get the image and normalize pixels between 0 and 1
%Scale : BLACK[0 0.01 0.02 0.03 ... ... ... 0.98 0.99 1]WHITE
text_img = 1/255*double(rgb2gray(imread('text_image.png')));
text_img = imadjust(text_img);

%show image
imshow(text_img);

%each column is summed in order to detect "blank zones" showing spaces between characters
%input : image table, output : vector
text_horz_density = sum(text_img);

%look for the minimum value into the vector, this value will be the threshold saying if a zone is blank or not
%indice is not used here
%we use max function here because the more white there is in a column, the bigger will be the value of the sum
[minimum_val indice] = max(text_horz_density);

%add a small value to the threshold because all the black doesn't have the same summed value, some will be darker
minimum_val = minimum_val-10;
minimum_val_vect = minimum_val*ones(1,length(text_horz_density));

%this vector contain 2 values, 0 and 1, where 0 indicate that a caracter is present in this column, and 1 a blank
separator_dect = (text_horz_density <= minimum_val);


hold on;
plot(separator_dect*150,'r--');

subplot(2,1,2);
plot(separator_dect*150,'r--');
hold on;
plot(text_horz_density);
hold on;
plot(minimum_val_vect);


char_limits = 0;
actual_val = 0;
old_val =0;

%this look detect transition between blank and notblank zones, in order to separate each characters
%trasitions : character>>blank and blank>>character

for i=1 : 1 : length(text_horz_density)
    char_detected =0;
    actual_val = separator_dect(i);
    if(old_val ~= actual_val ) %value chaging 1>>0 or 0>>1
        fprintf('transition : %d >> %d \n', old_val, actual_val);
        char_limits = [char_limits i];        
    end
    old_val = actual_val;
    
end

char_limits = char_limits(2:end);
char_limits

%struct that store all characters separately in order to treat them after
%char_list = struct;
j=1;
figure;
for i=1: 2 : length(char_limits)
    char_list{j} = text_img(: , char_limits(i):char_limits(i+1));
    subplot(5,2,j)
    imshow(char_list{j})
    j=j+1;
end
