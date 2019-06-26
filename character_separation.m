clear all;
clc;

%création de la figure
figure(1);
subplot(2,1,1);

%récupération de l'image
text_img = 1/255*double(rgb2gray(imread('text_image.png')));
text_img = imadjust(text_img);

%affichage de l'image
imshow(text_img);

%sommation de toutes les colonnes pour détecter le zones blanches (valeurs faibles)
text_horz_density = sum(text_img);

%récupérer la valeur min pour en faire un seuil de detection d'espace entre caractères
[minimum_val indice] = max(text_horz_density);

%monter le seuil pour détecter "tous les min" car les espaces sont plus ou moins blancs
minimum_val = minimum_val-10;
minimum_val_vect = minimum_val*ones(1,length(text_horz_density));

%1 quand il y a un caractère, 0 quand il n'y a pas de caractère
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

%cette boucle récpère tous les indices où il y a une transition 
%caractère>>espace et espace>>caract

for i=1 : 1 : length(text_horz_density)
    char_detected =0;
    actual_val = separator_dect(i);
    if(old_val ~= actual_val ) %detection d'un changement de valeur 1>>0 ou 0>>1
        fprintf('transition : %d >> %d \n', old_val, actual_val);
        char_limits = [char_limits i];        
    end
    old_val = actual_val;
    
end

char_limits = char_limits(2:end);
char_limits

%struct pour ranger tous les caractères en vue de les traiter
%char_list = struct;
j=1;
figure;
for i=1: 2 : length(char_limits)
    char_list{j} = text_img(: , char_limits(i):char_limits(i+1));
    subplot(5,2,j)
    imshow(char_list{j})
    j=j+1;
end