function PlotCosts(f,m)
     if(m==2)
        plot(f(:, 1), f(:, 2),'ro','MarkerSize',6);%目标函数值的第一列作为横坐标，第二列作为纵坐标进行画图，ro表示在matlab绘图时只画红色的圆圈，'MarkerSize'表示圆圈的尺寸大小
%         axis([0 1 -0.8 1]);%设置坐标轴的刻度范围.注意：上一行plot显示的图像如果不在这一行设置的坐标刻度内，那么上一行的图像是看不见的
        hold on;%hold on 保留当前坐标区中的绘图，从而使新添加到坐标区中的绘图不会删除现有绘图
        plot11;
%         plotZDT1;
        xlabel('1^{st} Objective'); ylabel('2^{nd} Objective');
        grid on;%grid on 显示 gca 命令返回的当前坐标区或图的主网格线;grid off 删除当前坐标区或图上的所有网格线
        hold off;%hold off 将保留状态设置为 off，从而使新添加到坐标区中的绘图清除现有绘图并重置所有的坐标区属性
        drawnow;%drawnow 更新图窗并处理任何挂起的回调。如果您修改图形对象并且需要在屏幕上立即查看这次更新，请使用该命令。使用 drawnow 在每次循环迭代后将更改显示在屏幕上。
     end
        if(m==3)
         plot3(f(:, 1), f(:, 2),f(:, 3),'ro','MarkerSize',6);
%          axis([0 1 -0.8 1]);
          hold on;
          plot11;
         xlabel('1^{st} Objective'); ylabel('2^{nd} Objective');zlabel('3^{rd} Objective')
          grid on;
        hold off;
         drawnow;
     end
     end