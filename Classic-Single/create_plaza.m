function [plaza, v, time,road_sum,booth_bottom] = create_plaza(B, L, plazalength)
%
% create_plaza    create the empty plaza matrix( no car ).
%                 1 = car, 0 = empty, -1 = forbid, -3 = empty&booth
%
% USAGE: [plaza, v, time] = create_plaza(B, L, plazalength)
%        B = number booths
%        L = number lanes in highway before and after plaza
%        plazalength = length of the plaza
%
% zhou lvwen: zhou.lv.wen@gmail.com

plaza = zeros(plazalength,2*B+1); %����·�� 1 = car, 0 = empty, -1 = forbid, -3 = empty&booth
v = zeros(plazalength,2*B+2); % velocity of automata (i,j), if it exists
time = zeros(plazalength,2*B+2); % cost time of automata (i,j) if it exists

barrier_length=3;
plaza(1:plazalength,[1,2*B+2]) = -1;%���·�ߣ���ΪB>L��������BΪ��׼
plaza(ceil(plazalength/2)-1,:) = -1;%ȫ����ס
plaza(ceil(plazalength/2),:) = -1;%ȫ����ס
for i=1:barrier_length
    plaza(ceil(plazalength/2)+i,:) = -1;%ȫ����ס
end
plaza(ceil(plazalength/2)-1,2:2:2*B) =0;%�ڳ�·
plaza(ceil(plazalength/2),2:2:2*B) = -3;%�ڳ��շ�վ
for i=1:barrier_length
    plaza(ceil(plazalength/2)+i,2:2:2*B) =0;%�ڳ�·
end

%�����Ž�
toptheta =1.45; %�Ͻ�
bottomtheta = 1.4;%�½�

%���
for col = 2:ceil(B-L/2) + 1
    for row = 1:(plazalength-1)/2 - floor(tan(toptheta) * (col-1))
        plaza(row, col) = -1;
    end
    for row = 1:(plazalength-1)/2 - floor(tan(bottomtheta) * (col-1))
        plaza(plazalength+1-row, col) = -1;
    end
end

fac = ceil(B-L/2)/floor(B-L/2);
%�Ҳ�
toptheta = atan(fac*tan(toptheta));
bottomtheta = atan(fac*tan(bottomtheta));

for col = 2:floor(B-L/2) + 1
    for row = 1:(plazalength-1)/2 - floor(tan(toptheta) * (col-1))
        plaza(row,2*B+3-col) = -1;
    end
    for row = 1:(plazalength-1)/2 - floor(tan(bottomtheta) * (col-1))
        plaza(plazalength+1-row,2*B+3-col) = -1;
    end
end

%ͳ���õ�·�ĸ���
road_sum=0;
for i=ceil(plazalength/2):plazalength
    for j=1:length(plaza(1,:))
        if(plaza(i,j)==0)
            road_sum=road_sum+1;
        end
    end
end
%������������
temp=0;
for i=plazalength:-1:floor(plazalength/2)
    for j=1:length(plaza(1,:))
        if(plaza(i,j)==0)
            temp=temp+1;
        end
    end
    if(temp~=L)
        booth_bottom=i;
        break;
    end
    temp=0;
end