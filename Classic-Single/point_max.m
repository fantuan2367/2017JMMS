function [xmin,xmax] = point_max(temp_x,temp_y)
[ymax,indmax]=max(temp_y);
xmax=temp_x(indmax);
strmax=sprintf('MAX x=%4.2f,y=%4.2f',xmax,ymax);
plot(xmax,ymax,'*r');
text(xmax+0.1,ymax+0.1,strmax);
[ymin,indmin]=min(temp_y);
xmin=temp_x(indmin);
strmin=sprintf('MIN x=%4.2f,y=%4.2f',xmin,ymin);
%plot(xmin,ymin,'*b');
%text(xmin+0.1,ymin-0.1,strmin);
end

