function [danger_point] = avg_line_continous(temp,iterations)
power=10;
danger_point(1:power)=temp(1:power);danger_point((iterations-power+1):iterations)=temp((iterations-power+1):iterations);
for i=(power+1):(iterations-power)
    danger_point(i)=mean(temp((i-power):(i+power)));
end
end

