function [plaza,traffic_light_1,traffic_light_2,traffic_light_3] = traffic_light(plaza,traffic_light_1,traffic_light_2,traffic_light_3,m,n)
%mΪ�̵�ʱ�䣻nΪ���ʱ��
booth_row=ceil(length(plaza)/2);
g=3;%����
q=2;%ÿ�����
interval=3;%��������Ԫ�ؼ��
g_interval=2;%����
traffic_light=[traffic_light_1,traffic_light_2,traffic_light_3];
for i=1:g
    if((traffic_light(i)<m)&&(traffic_light(i)>=0))%0-m����
        traffic_light(i)=traffic_light(i)+1;
        for j=1:q
            if(plaza(booth_row+4,2*((i+(j-1)*interval)))~=1)
            plaza(booth_row+4,2*((1+(j-1)*interval+(i-1)*g_interval))+1)=0;
            end
        end
    elseif(traffic_light(i)>=m)%����߽����
        traffic_light(i)=-n+1;
        for j=1:q
            if(plaza(booth_row+4,2*((i+(j-1)*interval)))~=1)&&(n~=0)
            plaza(booth_row+4,2*((1+(j-1)*interval+(i-1)*g_interval))+1)=-1;
            end 
        end
    elseif(traffic_light(i)<0)%-2,-1...����
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
traffic_light_3=traffic_light(3);%���仯��ĺ��̵Ʊ�־λ����