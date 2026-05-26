clc
clear all
close all

dataset = "HCCI";  %dataset options: "HCCI" "miranda" 


colors = {'#FF0000','#E6B800',  '#4A6FA5'};
Markers = ['d', "*", "v"];

Labels = ["\alpha=1", "\alpha=0.9", "\alpha = 0.5"];
Labels1 = ["_1", "_0.9", "_0.5"];

if strcmp(dataset,"miranda")||strcmp(dataset,"mhd")
    mix_prec = "3prec";
else
    mix_prec = "7prec";
end

f = figure('Position', [0, 0, 1500, 500]);
subplot(1,2,1,'Parent',f);
hold on;
for i = 1:3
    file_name = dataset + Labels1(i) + "_" + mix_prec + "_hosvd.mat";
    load(file_name);
    if i == 1
       plot(eps_vec, (err.full)./eps_vec',  'ko--','markersize',8,'linewidth',2.5,'DisplayName', 'Full (HOSVD(\epsilon))');
    end
    p = plot(eps_vec, (err.coreMP.relX)./eps_vec', 'color', colors{i}, 'marker', Markers(i),'markersize',8, 'linewidth',2.5,'Marker', Markers(i),'DisplayName', Labels(i)+" (core only)");
    plot(eps_vec, (err.coreFactorMP.relX)./eps_vec', 'color', colors{i}, 'marker', Markers(i),'markersize',8, 'linewidth',2.5,'LineStyle', ':','Marker', Markers(i), 'DisplayName', Labels(i)+ " (both)");
    
end

set(gca,'FontSize',14)
set(gca, 'XScale', 'log');   % log scale for x-axis
xlabel('Tolerance (\epsilon)', 'FontSize', 16)
ylabel('Error-Tolerance Ratio', 'FontSize', 16)
h=yline(1,'k-','linewidth',2.5);
h.Annotation.LegendInformation.IconDisplayStyle = 'off';

ylim([-0.1 1.1])


if strcmp(dataset,"miranda")
    xlim([0.8e-7, 1.2e-2])
    xticks([1e-7,1e-6,1e-5,1e-4, 1e-3, 1e-2])
else
    xlim([8e-15, 2e-2])
    xticks([1e-14,1e-13,1e-12,1e-11, 1e-10, 1e-9, 1e-8, 1e-7,1e-6,1e-5,1e-4, 1e-3, 1e-2])
end
lgd1 = legend('Location','best','FontSize',12.5); 
box on;
grid on;


subplot(1,2,2,'Parent',f);
hold on;
for i = 1:3
    file_name = dataset + Labels1(i) + "_" + mix_prec + "_hosvd.mat";
    load(file_name);
    p = plot(eps_vec, ratio.Tt.coreMP, 'color', colors{i}, 'marker', Markers(i),'markersize',8,'linewidth',2.5,'Marker', Markers(i),'DisplayName', Labels(i)+" (core only)");
    plot(eps_vec, ratio.Tt.coreFactorMP, 'color', colors{i}, 'marker', Markers(i),'markersize',8, 'linewidth',2.5,'LineStyle', ':', 'Marker', Markers(i),'DisplayName', Labels(i)+ " (both)");
end
set(gca,'FontSize',14)

set(gca, 'XScale', 'log');   % log scale for x-axis
xlabel('Tolerance (\epsilon)', 'FontSize', 16)
ylabel('Compression Improvement Factor','FontSize', 16)

plot(eps_vec,ones(1,length(eps_vec)),'ko--','MarkerSize',8,'linewidth',2.5,'DisplayName','Full (HOSVD(\epsilon))')

lgd = legend('Location','best','FontSize',12.5);

% if strcmp(dataset(1:end-5), 'miranda')
%     lgd = legend('Location','west','FontSize',12.5);
%     lgd.Units = 'normalized';
%     lgd.Position = [0.75 0.5 0 0];
% else
%     lgd = legend('Location','northwest','FontSize',12.5);
% end

yl = ylim;
ylim([min(yl(1),0.95), yl(2)*1.05])
if strcmp(dataset,"miranda")
    xlim([0.8e-7, 1.2e-2])
    xticks([1e-7,1e-6,1e-5,1e-4, 1e-3, 1e-2])
else
    xlim([8e-15, 2e-2])
    xticks([1e-14,1e-13,1e-12,1e-11, 1e-10, 1e-9, 1e-8, 1e-7,1e-6,1e-5,1e-4, 1e-3, 1e-2])
end
box on; 
grid on;


