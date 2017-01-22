clear;clc
B = 9; % �շ�վ����
L = 3; % �����·�����
plazalength = 101; %�շѹ㳡����
Arrival=1; %�ִﳵ������ƽ��ֵ 0.1-light 2-heavy
iterations = 3000; %ѭ������
Service = 0.8; % Service rate
traffic_light_1=0;
traffic_light_2=10;
traffic_light_3=20;
show_time=0.01;

dt = 0.2; % time step
t_h = 1; % time factor
vmax = 2; % max speed

timecost = [];
influx=zeros(1,iterations);
outflux=zeros(1,iterations);
blank_sum=zeros(1,iterations);%�������Ŀ���λ��
switch_times=zeros(1,iterations);%�������еĻ�������
velocity_variance=zeros(1,iterations);%���������ٶȷ���
velocity_average=zeros(1,iterations);%�������е�ƽ���ٶ�
time_average=zeros(1,iterations);%���������еĺ�ʱƽ��ֵ
in_fan_in=zeros(1,iterations);%����������������
out_car_flow=zeros(1,iterations);%��������������
out_cars=zeros(1,iterations);%��������������

[plaza, v, time,road_sum,booth_bottom] = create_plaza(B, L, plazalength);%������ͼ road_sum-·������
h = show_plaza(plaza, NaN,show_time);
for i = 1:iterations
    [plaza, v, influx(i)] = new_cars(Arrival, plaza, v);%���ɳ�
    h = show_plaza(plaza, h,show_time);%ˢ��ͼ
    [plaza,traffic_light_1,traffic_light_2,traffic_light_3] = traffic_light(plaza,traffic_light_1,traffic_light_2,traffic_light_3);%�ӽ�ͨ��
    [plaza, v, time,switch_times(i)] = switch_lanes(plaza, v, time); % ����
    [plaza, v, time,in_fan_in(i)] = move_forward(plaza, v, time, vmax); %ǰ��
    [plaza, v, time,blank_sum(i),velocity_variance(i),velocity_average(i),time_average(i),out_car_flow(i),out_cars(i)]...
        = clear_boundary(plaza, v, time,booth_bottom,vmax);%�����ִ�ĳ�������
    %blank_sum-ӵ���̶ȡ��ո���;velocity_variance-�ٶȷ���;velocity_average-�ٶȾ�ֵ
end
h = show_plaza(plaza, h,show_time);
xlabel({strcat('B = ',num2str(B)), ...
strcat('mean cost time = ', num2str(round(mean(timecost))))})

throughput_rate=out_car_flow./in_fan_in;
cars_num_fan_in=road_sum-L*(plazalength-booth_bottom)-blank_sum;
%%��ƽ����
figure(2);
[temp_x,temp_y,flow_avg]=avg_line(cars_num_fan_in,out_car_flow);
plot(temp_x,temp_y,'r');
hold on
[temp_x,temp_y,cars_avg]=avg_line(cars_num_fan_in,out_cars);
plot(temp_x,temp_y,'b');
hold on