%Reading Data
clear all
A = []; %make empty array A to keep data in
%for loop because each segment is kept in different text files :|
for i=1:60
    fnumber = num2str(i);%convert the number to string
        %then depending on what number it is make that number the filename .txt
    if i<10
        fn = strcat('s0',fnumber,'.txt');
    else
        fn = strcat('s',fnumber,'.txt');
    end
    %a01-sitting a02-standing a03-lying on back a04-lying on right side
    filename = fullfile('data','a01','p1',fn);
    fid = fopen(filename,'r');
    datacell = textscan(fid, '%f', 'Delimiter', ',');
    fclose(fid);
    B = cell2mat(datacell); %convert cell format to array format
    A = [A,B]; %everytime you read from a new text file 
end
[m,n] = size(A);
CData = [];
num = m/45;
%get the every 9th set of columns because thats the Chest Data
for j = 1:num
    CData = [CData,A( 45 * (j-1) +1 : (45 * (j-1) +9),:)];
end

Accelerometer = CData(1:3,:);
Gyroscope = CData(1:3,:);
Magnetometer = CData(1:3,:);
