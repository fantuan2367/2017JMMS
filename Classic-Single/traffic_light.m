function [plaza,traffic_light_1,traffic_light_2,traffic_light_3] = traffic_light(plaza,traffic_light_1,traffic_light_2,traffic_light_3)
booth_row=ceil(length(plaza)/2);
m=30;%�̵�ʱ��
n=40;%���ʱ��
g=3;%����
q=3;%ÿ�����
interval=3;%��������Ԫ�ؼ��
traffic_light=[traffic_light_1,traffic_light_2,traffic_light_3];
for i=1:g
    if((traffic_light(i)<m)&&(traffic_light(i)>=0))%0-m����
        traffic_light(i)=traffic_light(i)+1;
        for j=1:q
            if(plaza(booth_row+4,2*((i+(j-1)*interval)))~=1)
            plaza(booth_row+4,2*((i+(j-1)*interval)))=0;
            end
        end
    elseif(traffic_light(i)>=m)%����߽����
        traffic_light(i)=-n+1;
        for j=1:q
            if(plaza(booth_row+4,2*((i+(j-1)*interval)))~=1)&&(n~=0)
            plaza(booth_row+4,2*((i+(j-1)*interval)))=-1;
            end
        end
    elseif(traffic_light(i)<0)%-2,-1...����
        traffic_light(i)=traffic_light(i)+1;
        for j=1:q
            if(plaza(booth_row+4,2*((i+(j-1)*interval)))~=1)
            plaza(booth_row+4,2*((i+(j-1)*interval)))=-1;
            end
        end
    end
end
traffic_light_1=traffic_light(1);
traffic_light_2=traffic_light(2);
traffic_light_3=traffic_light(3);%���仯��ĺ��̵Ʊ�־λ����