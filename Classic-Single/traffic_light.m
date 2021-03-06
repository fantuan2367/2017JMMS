function [plaza,traffic_light_1,traffic_light_2,traffic_light_3] = traffic_light(plaza,traffic_light_1,traffic_light_2,traffic_light_3,m,n)
%m为绿灯时间；n为红灯时间
booth_row=ceil(length(plaza)/2);
g=3;%组数
q=2;%每组个数
interval=3;%组内相邻元素间隔
g_interval=2;%组间距
traffic_light=[traffic_light_1,traffic_light_2,traffic_light_3];
for i=1:g
    if((traffic_light(i)<m)&&(traffic_light(i)>=0))%0-m放行
        traffic_light(i)=traffic_light(i)+1;
        for j=1:q
            if(plaza(booth_row+4,2*((i+(j-1)*interval)))~=1)
            plaza(booth_row+4,2*((1+(j-1)*interval+(i-1)*g_interval))+1)=0;
            end
        end
    elseif(traffic_light(i)>=m)%处理边界情况
        traffic_light(i)=-n+1;
        for j=1:q
            if(plaza(booth_row+4,2*((i+(j-1)*interval)))~=1)&&(n~=0)
            plaza(booth_row+4,2*((1+(j-1)*interval+(i-1)*g_interval))+1)=-1;
            end 
        end
    elseif(traffic_light(i)<0)%-2,-1...阻塞
        traffic_light(i)=traffic_light(i)+1;
        for j=1:q
            if(plaza(booth_row+4,2*((i+(j-1)*interval)))~=1)
            plaza(booth_row+4,2*((1+(j-1)*interval+(i-1)*g_interval))+1)=-1;
            end
        end
    end
end
traffic_light_1=traffic_light(1);
traffic_light_2=traffic_light(2);
traffic_light_3=traffic_light(3);%将变化后的红绿灯标志位返回