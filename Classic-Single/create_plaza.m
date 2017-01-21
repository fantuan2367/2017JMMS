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

plaza(1:plazalength,[1,2*B+2]) = -1;%���·�ߣ���ΪB>L��������BΪ��׼
plaza(ceil(plazalength/2)-1,:) = -1;%ȫ����ס
plaza(ceil(plazalength/2),:) = -1;%ȫ����ס
plaza(ceil(plazalength/2)+1,:) = -1;%ȫ����ס
plaza(ceil(plazalength/2)-1,2:2:2*B) =0;%�ڳ�·
plaza(ceil(plazalength/2),2:2:2*B) = -3;%�ڳ��շ�վ
plaza(ceil(plazalength/2)+1,2:2:2*B) =0;%�ڳ�·
%left: angle of width decline for boundaries
toptheta =1.45; %�Ͻ�
bottomtheta = 1.3;%�½�

for col = 2:(2*B+1-L)
    for row = 1:(plazalength-1)/2 - floor(tan(toptheta) * (col-1))
        plaza(row, col) = -1;
    end
    for row = 1:(plazalength-1)/2 - floor(tan(bottomtheta) * (col-1))
        plaza(plazalength+1-row, col) = -1;
    end
end

%right: angle of width decline for boundaries

for col = 2:floor(B/2-L/2) + 1
    for row = 1:(plazalength-1)/2
        plaza(row,B+3-col) = -1;
    end
    for row = 1:(plazalength-1)/2 
        plaza(plazalength+1-row,B+3-col) = -1;
    end
end

%ͳ���õ�·�ĸ���
road_sum=0;
for i=floor(plazalength/2):plazalength
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