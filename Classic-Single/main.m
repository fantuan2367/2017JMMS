close all
clear;clc
B = 9; % 收费站个数
L = 3; % 进入道路轨道数
plazalength = 101; %收费广场长度
Arrival=1.5; %抵达车辆数的平均值 0.1-light 2-heavy
iterations = 5000; %循坏次数
traffic_light_1=0;
traffic_light_2=0;
traffic_light_3=0;
show_time=0;
KR=100:100:800;%神秘参数
Kr=100;
cars_occupation_max=0.09;%道路最大占有率 o~
green=4;%绿灯时间
red=2;%红灯时间

dt = 0.2; % time step
t_h = 1; % time factor
vmax = 3; % max speed

timecost = [];
influx=zeros(1,iterations);
outflux=zeros(1,iterations);
blank_sum=zeros(1,iterations);%扇入区的空余位置
switch_times=zeros(1,iterations);%扇入区中的换道区域
velocity_variance=zeros(1,iterations);%扇入区的速度方差
velocity_average=zeros(1,iterations);%扇入区中的平均速度
time_average=zeros(1,iterations);%在扇入区中的耗时平均值
in_fan_in=zeros(1,iterations);%进入扇入区车流量
out_car_flow=zeros(1,iterations);%出扇入区车流量
out_cars=zeros(1,iterations);%出扇入区车数量
cars_occupation=zeros(1,iterations);%道路占有率
AVD=zeros(1,8);
red_time=[];
temp_q_k=[];

[plaza, v, time,road_sum,booth_bottom] = create_plaza(B, L, plazalength);%创建地图 road_sum-路块总数
h = show_plaza(plaza, NaN,show_time);
% for k=1:8
%     Kr=KR(k);
for i = 1:iterations
    [plaza, v, influx(i)] = new_cars(Arrival, plaza, v);%生成车
    h = show_plaza(plaza, h,show_time);%刷新图
    if((i~=1)&&out_cars(i-1)>0.5)
        %[plaza,traffic_light_1,traffic_light_2,traffic_light_3] = traffic_light(plaza,traffic_light_1,traffic_light_2,traffic_light_3,green,red);%加交通灯
        red_time=[red_time,red];
    else
        red_time=[red_time,0];
    end
    [plaza, v, time,switch_times(i)] = switch_lanes(plaza, v, time); % 换道
    [plaza, v, time,in_fan_in(i)] = move_forward(plaza, v, time, vmax); %前进
    [plaza, v, time,blank_sum(i),velocity_variance(i),velocity_average(i),time_average(i),out_car_flow(i),out_cars(i)]...
        = clear_boundary(plaza, v, time,booth_bottom,vmax);%消亡抵达的车并结算
    %blank_sum-拥挤程度、空格数;velocity_variance-速度方差;velocity_average-速度均值;time_average时间均值;out_car_flow车流量;out_cars车数量（q(k-1)）
    switch_times(i)=switch_times(i)/(blank_sum(1)-blank_sum(i));%计算平均换道次数
    cars_occupation(i)=(blank_sum(1)-blank_sum(i))/blank_sum(1);%o(k-1)
    q_k=out_cars(i)+Kr*(cars_occupation_max-cars_occupation(i));
    temp_q_k=[temp_q_k,q_k];
    if(traffic_light_1==0)
        q_k=mean(temp_q_k);
        c=2*B/q_k;
        red=ceil(c-2);%绿灯时间固定为2
    end
end
%     AVD(k)=1/(mean(velocity_average));
% end
% figure(4);
% plot(KR,AVD);
h = show_plaza(plaza, h,show_time);
xlabel({strcat('B = ',num2str(B));
    strcat('mean cost time = ', num2str(round(mean(timecost))))})

throughput_rate=out_car_flow./in_fan_in;
%%画平均线
figure(2);
[temp_x,temp_y,flow_avg]=avg_line(cars_occupation,out_car_flow);
plot(temp_x,temp_y,'r');
[flow_min,flow_max]=point_max(temp_x,temp_y);
hold on
[temp_x,temp_y,cars_avg]=avg_line(cars_occupation,out_cars);
plot(temp_x,temp_y,'b');
[cars_min,cars_max]=point_max(temp_x,temp_y);
hold on

%计算安全系数
danger_point=(5*velocity_average).*(25*velocity_variance).*switch_times.*(1/10*cars_occupation);
figure(3);
danger_point=avg_line_continous(danger_point,iterations);
plot(1:iterations,danger_point,'k');
hold on;
velocity_average(1:20)=0;
velocity_average=avg_line_continous(velocity_average,iterations);
plot(1:iterations,velocity_average,'r');
hold on;
velocity_variance=avg_line_continous(velocity_variance,iterations);
plot(1:iterations,velocity_variance,'y');
hold on;
switch_times=avg_line_continous(switch_times,iterations);
plot(1:iterations,switch_times,'g');
hold on;
plot(1:iterations,cars_occupation,'b');
figure(4)
plot(3900:4100,red_time(3900:4100));