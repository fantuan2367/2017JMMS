%%%%%%%%%%%%%%%%%%%%%%%%%%%Classic部分%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [plaza, v, time,road_sum,booth_bottom] = create_plaza(B, L, plazalength)
plazawidth=2*B+3;
plaza = zeros(plazalength,2*(B+1/2)+1); %铺设路面 1 = car, 0 = empty, -1 = forbid, -3 = empty&booth
v = zeros(plazalength,2*(B+1/2)+2); % velocity of automata (i,j), if it exists
time = zeros(plazalength,2*(B+1/2)+2); % cost time of automata (i,j) if it exists

barrier_length=3;
plaza(1:plazalength,[1,plazawidth]) = -1;%标记路边，因为(B+1/2)>L，所以以(B+1/2)为标准
plaza(ceil(plazalength/2)-1,:) = -1;%收费站进口处全部拦住
plaza(ceil(plazalength/2),:) = -1;%全部拦住
for i=1:barrier_length
    plaza(ceil(plazalength/2)+i,:) = -1;%全部拦住收费站出口处
end
plaza(ceil(plazalength/2)-1,3:2:2*(B+1/2)) =0;%挖出路
plaza(ceil(plazalength/2),3:2:2*(B+1/2)) = -3;%挖出收费站
for i=1:barrier_length
    plaza(ceil(plazalength/2)+i,3:2:2*(B+1/2)) =0;%挖出路
end

%上下张角
toptheta =1.45; %上角
bottomtheta = 1.2;%下角

%左侧
for col = 2:ceil((B+1/2)-L/2) + 1
    for row = 1:(plazalength-1)/2 - floor(tan(toptheta) * (col-1))
        plaza(row, col) = -1;
    end
    for row = 1:(plazalength-1)/2 - floor(tan(bottomtheta) * (col-1))
        plaza(plazalength+1-row, col) = -1;
    end
end

fac = ceil((B+1/2)-L/2)/floor((B+1/2)-L/2);
%右侧
toptheta = atan(fac*tan(toptheta));
bottomtheta = atan(fac*tan(bottomtheta));

for col = 2:floor((B+1/2)-L/2) + 1
    for row = 1:(plazalength-1)/2 - floor(tan(toptheta) * (col-1))
        plaza(row,2*(B+1/2)+3-col) = -1;
    end
    for row = 1:(plazalength-1)/2 - floor(tan(bottomtheta) * (col-1))
        plaza(plazalength+1-row,2*(B+1/2)+3-col) = -1;
    end
end

%统计用的路的格数
road_sum=0;
for i=ceil(plazalength/2):plazalength
    for j=1:length(plaza(1,:))
        if(plaza(i,j)==0)
            road_sum=road_sum+1;
        end
    end
end
%计算出扇入界限
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%Sin实现部分%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% function [plaza, v, time,road_sum,booth_bottom] = create_plaza(B, L, plazalength)
% %
% % create_plaza    create the empty plaza matrix( no car ).
% %                 1 = car, 0 = empty, -1 = forbid, -3 = empty&booth
% %
% % USAGE: [plaza, v, time] = create_plaza((B+1/2), L, plazalength)
% %        (B+1/2) = number booths
% %        L = number lanes in highway before and after plaza
% %        plazalength = length of the plaza
% %
% % zhou lvwen: zhou.lv.wen@gmail.com
% plazawidth=2*B+3;
% plaza = zeros(plazalength,plazawidth-1); %铺设路面 1 = car, 0 = empty, -1 = forbid, -3 = empty&booth
% v = zeros(plazalength,plazawidth); %初始化速度矩阵
% time = zeros(plazalength,plazawidth); %初始化时间开销矩阵
% 
% barrier_length=3;
% plaza(1:plazalength,[1,plazawidth]) = -1;%标记路边，因为(B+1/2)>L，所以以(B+1/2)为标准
% plaza(ceil(plazalength/2)-1,:) = -1;%收费站进口处全部拦住
% plaza(ceil(plazalength/2),:) = -1;%全部拦住
% for i=1:barrier_length
%     plaza(ceil(plazalength/2)+i,:) = -1;%全部拦住收费站出口处
% end
% plaza(ceil(plazalength/2)-1,3:2:2*(B+1/2)) =0;%挖出路
% plaza(ceil(plazalength/2),3:2:2*(B+1/2)) = -3;%挖出收费站
% for i=1:barrier_length
%     plaza(ceil(plazalength/2)+i,3:2:2*(B+1/2)) =0;%挖出路
% end
% 
% %上下张角
% toptheta =1.45; %上角
% bottomtheta = 1.4;%下角
% 
% %左侧
% for col = 2:ceil((B+1/2)-L/2) + 1
%     for row = 1:(plazalength-1)/2 - floor(ceil(plazalength/2)*sin((col-1)*pi/20))
%         plaza(row, col) = -1;
%     end
%     for row = 1:(plazalength-1)/2 - floor(ceil(plazalength/2)*sin((col-1)*pi/20))
%         plaza(plazalength+1-row, col) = -1;
%     end
% end
% %右侧
% for col = 2:floor((B+1/2)-L/2) + 1
%     for row = 1:(plazalength-1)/2 - floor(ceil(plazalength/2)*sin((col-1)*pi/20))
%         plaza(row,2*(B+1/2)+3-col) = -1;
%     end
%     for row = 1:(plazalength-1)/2 - floor(ceil(plazalength/2)*sin((col-1)*pi/20))
%         plaza(plazalength+1-row,2*(B+1/2)+3-col) = -1;
%     end
% end
% 
% %统计用的路的格数
% road_sum=0;
% for i=ceil(plazalength/2):plazalength
%     for j=1:length(plaza(1,:))
%         if(plaza(i,j)==0)
%             road_sum=road_sum+1;
%         end
%     end
% end
% %计算出扇入界限
% temp=0;
% for i=plazalength:-1:floor( plazalength/2)
%     for j=1:length(plaza(1,:))
%         if(plaza(i,j)==0)
%             temp=temp+1;
%         end
%     end
%     if(temp~=L)
%         booth_bottom=i;
%         break;
%     end
%     temp=0;
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%